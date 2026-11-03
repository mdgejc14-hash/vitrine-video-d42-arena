import test from 'node:test';
import assert from 'node:assert/strict';
import {
  calculatePurgeRetryAt,
  executePurgeOperation,
} from '../src/purge-executor-core.js';

const baseOperation = (overrides = {}) => ({
  operation_id: 'purge-v1:order:test:terminal_72h:2026-10-20T00:00:00.000Z',
  scope: 'order',
  target_id: 'test-order',
  order_id: 'test-order',
  rule: 'terminal_72h',
  expires_at: '2026-10-20T00:00:00.000Z',
  status: 'planned',
  attempts: 0,
  ...overrides,
});

function fakeAdapters(overrides = {}) {
  const calls = [];
  return {
    calls,
    claimOperation: async (operation, nowIso) => {
      calls.push(['claim', operation.operation_id, nowIso]);
      return { claimed: true, attempts: Number(operation.attempts ?? 0) + 1 };
    },
    revalidateOperation: async () => ({
      ok: true,
      objects: [
        { key: 'test-only/order/audio.ogg', file_id: 'file-a', role: 'audio' },
      ],
    }),
    deleteObject: async (key) => calls.push(['delete', key]),
    isObjectAbsent: async (key) => {
      calls.push(['head', key]);
      return true;
    },
    cleanupDatabase: async () => {
      calls.push(['cleanup']);
      return { ok: true };
    },
    setOperationStatus: async (operation, status, details) => {
      calls.push(['status', status, details]);
    },
    recordEvent: async (event) => calls.push(['event', event.eventType]),
    ...overrides,
  };
}

test('executor disabled: no database or storage adapter is called', async () => {
  const adapters = fakeAdapters();
  const result = await executePurgeOperation({
    enabled: false,
    operation: baseOperation(),
    runId: 'run-test',
    adapters,
  });
  assert.deepEqual(result, { status: 'skipped', reason: 'executor_disabled' });
  assert.deepEqual(adapters.calls, []);
});

test('successful executor verifies object absence before database cleanup', async () => {
  const adapters = fakeAdapters();
  const result = await executePurgeOperation({
    enabled: true,
    operation: baseOperation(),
    runId: 'run-test',
    nowMs: Date.parse('2026-10-22T00:00:00.000Z'),
    adapters,
  });
  assert.equal(result.status, 'completed');
  assert.ok(adapters.calls.findIndex((c) => c[0] === 'head') < adapters.calls.findIndex((c) => c[0] === 'cleanup'));
  assert.ok(adapters.calls.some((c) => c[0] === 'status' && c[1] === 'completed'));
});

test('B2 deletion failure schedules retry and never cleans up D1', async () => {
  const adapters = fakeAdapters({
    deleteObject: async () => {
      throw Object.assign(new Error('redacted'), {
        code: 'b2_delete_http_503', stage: 'b2_delete', retryable: true,
      });
    },
  });
  const result = await executePurgeOperation({
    enabled: true,
    operation: baseOperation(),
    runId: 'run-test',
    nowMs: Date.parse('2026-10-22T00:00:00.000Z'),
    adapters,
  });
  assert.equal(result.status, 'retryable_error');
  assert.equal(result.errorCode, 'b2_delete_http_503');
  assert.equal(adapters.calls.some((c) => c[0] === 'cleanup'), false);
  assert.ok(result.nextAttemptAt);
});

test('failed revalidation blocks operation without deleting B2 or cleaning D1', async () => {
  const adapters = fakeAdapters({
    revalidateOperation: async () => ({ ok: false, code: 'order_status_changed' }),
  });
  const result = await executePurgeOperation({
    enabled: true,
    operation: baseOperation(),
    runId: 'run-test',
    nowMs: Date.parse('2026-10-22T00:00:00.000Z'),
    adapters,
  });
  assert.equal(result.status, 'blocked');
  assert.equal(adapters.calls.some((c) => c[0] === 'delete'), false);
  assert.equal(adapters.calls.some((c) => c[0] === 'cleanup'), false);
});

test('resume after database cleanup already happened does not delete again', async () => {
  const adapters = fakeAdapters({
    revalidateOperation: async (_operation, _now, resumeFrom) => {
      assert.equal(resumeFrom, 'db_cleanup_pending');
      return { ok: true, alreadyCleaned: true, objects: [] };
    },
  });
  const result = await executePurgeOperation({
    enabled: true,
    operation: baseOperation({ status: 'db_cleanup_pending' }),
    runId: 'run-test',
    nowMs: Date.parse('2026-10-22T00:00:00.000Z'),
    adapters,
  });
  assert.equal(result.status, 'completed');
  assert.equal(result.alreadyCleaned, true);
  assert.equal(adapters.calls.some((c) => c[0] === 'delete'), false);
  assert.equal(adapters.calls.some((c) => c[0] === 'cleanup'), false);
});

test('retry delay grows exponentially and is capped at six hours', () => {
  const now = Date.parse('2026-10-22T00:00:00.000Z');
  assert.equal(calculatePurgeRetryAt(now, 1), new Date(now + 15 * 60 * 1000).toISOString());
  assert.equal(calculatePurgeRetryAt(now, 2), new Date(now + 30 * 60 * 1000).toISOString());
  assert.equal(calculatePurgeRetryAt(now, 8), new Date(now + 6 * 60 * 60 * 1000).toISOString());
});

test('D1 cleanup failure keeps operation retryable after B2 absence is verified', async () => {
  const adapters = fakeAdapters({
    cleanupDatabase: async () => {
      adapters.calls.push(['cleanup']);
      throw Object.assign(new Error('redacted'), {
        code: 'd1_temporary_failure', stage: 'db_cleanup', retryable: true,
      });
    },
  });
  const result = await executePurgeOperation({
    enabled: true,
    operation: baseOperation(),
    runId: 'run-test',
    nowMs: Date.parse('2026-10-22T00:00:00.000Z'),
    adapters,
  });
  assert.equal(result.status, 'retryable_error');
  assert.equal(result.errorCode, 'd1_temporary_failure');
  assert.equal(adapters.calls.some((c) => c[0] === 'head'), true);
  assert.equal(adapters.calls.some((c) => c[0] === 'cleanup'), true);
  assert.ok(result.nextAttemptAt);
});

test('retry after D1 failure repeats idempotent B2 verification then completes', async () => {
  let cleanupCount = 0;
  let deleteCount = 0;
  const adapters = fakeAdapters({
    deleteObject: async (key) => {
      deleteCount += 1;
      adapters.calls.push(['delete', key]);
    },
    cleanupDatabase: async () => {
      cleanupCount += 1;
      adapters.calls.push(['cleanup', cleanupCount]);
      if (cleanupCount === 1) {
        throw Object.assign(new Error('redacted'), {
          code: 'd1_temporary_failure', stage: 'db_cleanup', retryable: true,
        });
      }
      return { ok: true };
    },
  });

  const first = await executePurgeOperation({
    enabled: true,
    operation: baseOperation(),
    runId: 'run-first',
    nowMs: Date.parse('2026-10-22T00:00:00.000Z'),
    adapters,
  });
  assert.equal(first.status, 'retryable_error');

  const second = await executePurgeOperation({
    enabled: true,
    operation: baseOperation({ status: 'retryable_error', attempts: 1 }),
    runId: 'run-second',
    nowMs: Date.parse(first.nextAttemptAt) + 1000,
    adapters,
  });

  assert.equal(second.status, 'completed');
  assert.equal(deleteCount, 2, 'B2 delete is safely repeated during resume');
  assert.equal(cleanupCount, 2, 'D1 cleanup is retried');
});
