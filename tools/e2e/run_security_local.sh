#!/usr/bin/env bash
# Suite de sécurité complète (scripts/security-ci.mjs) SANS compte Firebase.
#
#   tools/e2e/run_security_local.sh [sortie.json]
#
# 1. base D1 locale du wrangler remise à zéro + 12 migrations + gabarit CI ;
# 2. pont HTTP local (Worker réel, JWKS locale, cache en mémoire) sur :8790 ;
# 3. IdP local injecté dans le processus de test (idp_preload.mjs) ;
# 4. suite de sécurité exécutée telle quelle, sortie brute conservée.
#
# Statut produit : PASS_LOCAL_HARNESS. Le fournisseur d'identité est simulé,
# le Worker, la vérification JWT et la base sont réels.
set -uo pipefail
cd "$(dirname "$0")/../.." || exit 1
# Node 22 requis (node:sqlite). En CI, setup-node le fournit déjà ; en bac à
# sable, on utilise l'archive locale si elle existe.
if [ -d /tmp/node-v22.20.0-linux-x64/bin ]; then
  export PATH=/tmp/node-v22.20.0-linux-x64/bin:$PATH
fi
command -v node >/dev/null && node -e 'process.versions.node.split(".")[0]>=22||process.exit(1)' \
  || { echo "Node >= 22 requis"; exit 1; }
npm install --no-audit --no-fund >/dev/null 2>&1 || true
SORTIE="${1:-artifacts/security/security_local.txt}"
# 48 caractères : le Worker exige >= 32, sinon il répond 404 (route « inexistante »).
# Le pont et la suite DOIVENT partager la même valeur — d'où l'export global.
export BILLING_WEBHOOK_SECRET="0123456789abcdef0123456789abcdef0123456789abcdef"
mkdir -p "$(dirname "$SORTIE")"
D1_DIR=".wrangler/state/v3/d1"
PORT=8790

liberer_port() {
  if command -v ss >/dev/null 2>&1; then
    ss -lptn "sport = :$PORT" 2>/dev/null | grep -oP 'pid=\K[0-9]+' | xargs -r kill -9 2>/dev/null
  fi
  sleep 1
}

liberer_port
rm -rf "$D1_DIR"
for f in db/migrations/*.sql; do
  npx wrangler d1 execute vitrine-video-db --local --file="$f" >/dev/null 2>&1 || { echo "migration KO : $f"; exit 1; }
done
npx wrangler d1 execute vitrine-video-db --local \
  --command="INSERT OR REPLACE INTO templates (id,secteur,langue,duree_cible_s,edl_json,regles_qc_json,version,actif) VALUES ('ci-commerce-fr-v1','commerce','fr',30,'{}','{}',1,1);" >/dev/null 2>&1

BASE=$(find "$D1_DIR" -name "*.sqlite" | grep -v metadata | head -1)
[ -n "$BASE" ] || { echo "base D1 introuvable"; exit 1; }

D42_KEEP_DB=1 DB_PATH="$PWD/$BASE" nohup node tools/e2e/worker_http.mjs > /tmp/pont-d42.log 2>&1 &
echo "[security-local] pont pid=$!"
PONT=$!
for _ in $(seq 1 30); do
  curl -sS -m 1 -o /dev/null "http://127.0.0.1:$PORT/health" && break
  sleep 0.5
done

API_BASE_URL="http://127.0.0.1:$PORT" \
FIREBASE_WEB_API_KEY="cle-de-banc-non-sensible" \
FIREBASE_TEST_A_EMAIL="a@banc.d42" FIREBASE_TEST_A_PASSWORD="motdepasse-a" \
FIREBASE_TEST_B_EMAIL="b@banc.d42" FIREBASE_TEST_B_PASSWORD="motdepasse-b" \
  node --import ./tools/e2e/idp_preload.mjs scripts/security-ci.mjs > "$SORTIE" 2>&1
CODE=$?

kill -9 "$PONT" 2>/dev/null
PASS=$(grep -c '^PASS' "$SORTIE")
FAIL=$(grep -c '^FAIL' "$SORTIE")
echo "SECURITE LOCALE : PASS=$PASS FAIL=$FAIL (code $CODE) -> $SORTIE"
grep '^FAIL' "$SORTIE" | cut -c1-150
exit 0
