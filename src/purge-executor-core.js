const FINAL_STATES = new Set(["completed", "blocked"]);
const RESUMABLE_STATES = new Set([
  "planned",
  "retryable_error",
  "revalidating",
  "b2_delete_pending",
  "b2_deleted",
  "db_cleanup_pending",
]);

export class PurgeExecutionError extends Error {
  constructor(code, stage, retryable = true) {
    super(code);
    this.name = "PurgeExecutionError";
    this.code = code;
    this.stage = stage;
    this.retryable = retryable;
  }
}

export function calculatePurgeRetryAt(nowMs, attempt) {
  const firstDelayMs = 15 * 60 * 1000;
  const maximumDelayMs = 6 * 60 * 60 * 1000;
  const multiplier = 2 ** Math.max(0, Math.min(10, Number(attempt) - 1));
  return new Date(nowMs + Math.min(maximumDelayMs, firstDelayMs * multiplier)).toISOString();
}

export async function executePurgeOperation({
  enabled = false,
  operation,
  runId,
  nowMs = Date.now(),
  maxAttempts = 8,
  adapters,
}) {
  if (!enabled) return { status: "skipped", reason: "executor_disabled" };
  if (!operation || !RESUMABLE_STATES.has(operation.status)) {
    return { status: "skipped", reason: "operation_not_resumable" };
  }
  if (!runId || !adapters) throw new Error("purge_executor_configuration_invalid");

  const nowIso = new Date(nowMs).toISOString();
  const expiryMs = Date.parse(operation.expires_at ?? "");
  if (!Number.isFinite(expiryMs)) {
    return { status: "blocked", reason: "operation_expiry_invalid" };
  }
  if (expiryMs > nowMs) {
    return { status: "skipped", reason: "retention_not_expired" };
  }
  if (FINAL_STATES.has(operation.status)) {
    return { status: operation.status, reason: "operation_terminal" };
  }

  const resumeFrom = operation.status;
  const claim = await adapters.claimOperation(operation, nowIso, nowMs);
  if (!claim?.claimed) return { status: "skipped", reason: "claim_not_acquired" };

  const attempt = Number(claim.attempts ?? (Number(operation.attempts ?? 0) + 1));
  const workingOperation = { ...operation, status: resumeFrom, attempts: attempt };
  let stage = "revalidate";

  const setStatus = async (status, details = {}) => {
    await adapters.setOperationStatus(workingOperation, status, {
      nowIso: new Date().toISOString(),
      attempt,
      ...details,
    });
    await adapters.recordEvent({
      runId,
      operationId: operation.operation_id,
      attempt,
      eventType: details.eventType ?? `status_${status}`,
      fromStatus: details.fromStatus ?? "revalidating",
      toStatus: status,
      errorCode: details.errorCode ?? details.errorEventCode ?? null,
      details: details.eventDetails ?? {},
    });
  };

  try {
    const current = await adapters.revalidateOperation(
      workingOperation,
      nowIso,
      resumeFrom,
    );

    if (current?.alreadyCleaned && resumeFrom === "db_cleanup_pending") {
      await setStatus("completed", {
        fromStatus: "db_cleanup_pending",
        dbCleanedAt: nowIso,
        completedAt: nowIso,
        eventType: "operation_completed_after_resume",
        eventDetails: { reason: "database_target_already_absent_after_verified_b2_phase" },
      });
      return { status: "completed", alreadyCleaned: true, attempts: attempt };
    }

    if (!current?.ok) {
      const code = String(current?.code ?? "purge_revalidation_failed").slice(0, 100);
      await setStatus("blocked", {
        fromStatus: "revalidating",
        errorStage: "revalidate",
        errorCode: code,
        errorAt: nowIso,
        nextAttemptAt: null,
        eventType: "operation_blocked",
        errorEventCode: code,
        eventDetails: { reason: code },
      });
      return { status: "blocked", reason: code, attempts: attempt };
    }

    const objects = Array.isArray(current.objects) ? current.objects : [];
    stage = "b2_delete";
    await setStatus("b2_delete_pending", {
      fromStatus: "revalidating",
      errorStage: null,
      errorCode: null,
      errorAt: null,
      nextAttemptAt: null,
      eventType: "b2_phase_started",
      eventDetails: { objectCount: objects.length },
    });

    for (const object of objects) {
      if (!object || typeof object.key !== "string" || !object.key) {
        throw new PurgeExecutionError("b2_object_key_invalid", "b2_delete", false);
      }
      await adapters.deleteObject(object.key);
      const absent = await adapters.isObjectAbsent(object.key);
      if (!absent) {
        throw new PurgeExecutionError("b2_object_still_present", "b2_verify", true);
      }
      await adapters.recordEvent({
        runId,
        operationId: operation.operation_id,
        attempt,
        eventType: "b2_object_absent_confirmed",
        fromStatus: "b2_delete_pending",
        toStatus: "b2_delete_pending",
        errorCode: null,
        details: { fileId: object.file_id ?? null, role: object.role ?? null },
      });
    }

    const b2DoneAt = new Date().toISOString();
    await setStatus("b2_deleted", {
      fromStatus: "b2_delete_pending",
      b2DeletedAt: b2DoneAt,
      eventType: "all_b2_objects_absent_confirmed",
      eventDetails: { objectCount: objects.length },
    });

    stage = "db_cleanup";
    await setStatus("db_cleanup_pending", {
      fromStatus: "b2_deleted",
      eventType: "d1_cleanup_started",
      eventDetails: { scope: operation.scope },
    });

    const cleanup = await adapters.cleanupDatabase(
      { ...workingOperation, status: "db_cleanup_pending" },
      current,
      objects,
      new Date().toISOString(),
    );

    if (!cleanup?.ok) {
      const code = String(cleanup?.code ?? "d1_cleanup_not_confirmed").slice(0, 100);
      throw new PurgeExecutionError(code, "db_cleanup", cleanup?.retryable !== false);
    }

    const completedAt = new Date().toISOString();
    await setStatus("completed", {
      fromStatus: "db_cleanup_pending",
      dbCleanedAt: completedAt,
      completedAt,
      eventType: "operation_completed",
      eventDetails: {
        scope: operation.scope,
        objectsVerifiedAbsent: objects.length,
        databaseTargetRemoved: !cleanup.alreadyCleaned,
        alreadyCleaned: Boolean(cleanup.alreadyCleaned),
      },
    });

    return {
      status: "completed",
      attempts: attempt,
      objectsVerifiedAbsent: objects.length,
      alreadyCleaned: Boolean(cleanup.alreadyCleaned),
    };
  } catch (error) {
    const code = String(error?.code ?? "purge_executor_error").slice(0, 100);
    const errorStage = String(error?.stage ?? stage).slice(0, 80);
    const retryable = error?.retryable !== false;
    const terminal = !retryable || attempt >= maxAttempts;
    const nextAttemptAt = terminal ? null : calculatePurgeRetryAt(Date.now(), attempt);
    const status = terminal ? "blocked" : "retryable_error";

    try {
      await setStatus(status, {
        fromStatus: stage === "db_cleanup" ? "db_cleanup_pending" :
          stage === "revalidate" ? "revalidating" : "b2_delete_pending",
        errorStage,
        errorCode: code,
        errorAt: new Date().toISOString(),
        nextAttemptAt,
        eventType: terminal ? "operation_blocked_after_error" : "operation_retry_scheduled",
        errorEventCode: code,
        eventDetails: { stage: errorStage, retryable, attempt, nextAttemptAt },
      });
    } catch {
      // Keep the original execution error. A later audit can recover from the
      // last durable state if the ledger itself was temporarily unavailable.
    }

    return {
      status,
      errorCode: code,
      stage: errorStage,
      retryable,
      attempts: attempt,
      nextAttemptAt,
    };
  }
}
