#!/usr/bin/env bash
# =============================================================================
# D42.2 — CRÉATION DU MIROIR PUBLIC TEMPORAIRE
#
#   bash creer-miroir.sh <clone-source> <commit> <compte> <nom-miroir> [--dry-run]
#
# Exemple :
#   bash creer-miroir.sh ~/work/vv-d42 13eb3c6 mdgejc14-hash vitrine-video-d42-arena
#
# Principe :
#   1. extrait un SNAPSHOT de l'arbre au commit donné (AUCUN historique) ;
#   2. retire les fichiers interdits, neutralise les identifiants connus ;
#   3. écarte les workflows de production (aucun déploiement depuis le miroir) ;
#   4. exécute le contrôle de confidentialité — ABANDONNE s'il échoue ;
#   5. écrit MANIFESTE_MIROIR.md (source, commit, arbre, empreintes) ;
#   6. initialise un dépôt NEUF (historique aplati) et pousse.
#
# --dry-run : s'arrête après le contrôle, sans créer ni pousser de dépôt.
#
# Le dépôt privé reste la référence canonique : le miroir n'est qu'un outil.
# =============================================================================
set -euo pipefail

SOURCE="${1:?clone source requis}"
COMMIT="${2:?commit requis}"
COMPTE="${3:?compte ou organisation requis}"
NOM="${4:?nom du miroir requis}"
MODE="${5:-}"
TOKEN="${GITHUB_TOKEN:-}"

ICI="$(cd "$(dirname "$0")" && pwd)"
TRAVAIL="$(mktemp -d)"
SNAPSHOT="${TRAVAIL}/${NOM}"

if [ "${MODE}" != "--dry-run" ]; then
  [ -n "${TOKEN}" ] || { echo "GITHUB_TOKEN absent de l'environnement"; exit 2; }
fi
[ -d "${SOURCE}/.git" ] || { echo "${SOURCE} n'est pas un dépôt git"; exit 2; }

echo "== 1. empreinte de l'arbre source =="
ARBRE=$(git -C "${SOURCE}" rev-parse "${COMMIT}^{tree}")
echo "commit = ${COMMIT}"
echo "arbre  = ${ARBRE}"

echo "== 2. extraction du snapshot (sans historique) =="
mkdir -p "${SNAPSHOT}"
git -C "${SOURCE}" archive "${COMMIT}" | tar -x -C "${SNAPSHOT}"

echo "== 3. retrait des fichiers interdits =="
find "${SNAPSHOT}" -type f \( \
  -name "*.keystore" -o -name "*.jks" -o -name "*.p12" -o -name "*.pfx" \
  -o -name "*.pem" -o -name "*.key" -o -name ".env" -o -name ".env.*" \
  -o -name ".dev.vars" -o -name ".netrc" -o -name ".git-credentials" \
  -o -name "local.properties" -o -name "google-services.json" \
  -o -name ".b2_keys.json" -o -name "b2_keys.json" \
  \) -delete 2>/dev/null || true
# Uploads de test du serveur local : aucun intérêt public, 512 octets de bruit.
rm -rf "${SNAPSHOT}/mock-server/data/uploads" 2>/dev/null || true
rm -rf "${SNAPSHOT}/build" "${SNAPSHOT}/.gradle" "${SNAPSHOT}/.idea" 2>/dev/null || true

echo "== 4. workflows de production écartés =="
for wf in deploy-production.yml backup-d1-to-b2.yml preview-d1-migrations.yml; do
  if [ -f "${SNAPSHOT}/.github/workflows/${wf}" ]; then
    rm -f "${SNAPSHOT}/.github/workflows/${wf}"
    echo "  retiré : ${wf} (aucune publication, aucun déploiement depuis le miroir)"
  fi
done

echo "== 5. neutralisation des identifiants connus =="
# Clé Firebase : présente dans l'arbre privé ET dans son historique. Elle est
# remplacée par le jeton de repli déjà prévu par le build
# (feature-onboarding/build.gradle.kts : orNull ?: "REMPLACE_PAR_API_KEY").
if [ -f "${SNAPSHOT}/gradle.properties" ]; then
  sed -i -E 's|^vvFirebaseApiKey=.*$|vvFirebaseApiKey=REMPLACE_PAR_API_KEY|' \
    "${SNAPSHOT}/gradle.properties"
  echo "  gradle.properties : vvFirebaseApiKey neutralisée"
fi
if [ -f "${SNAPSHOT}/scripts/audio/probes_audio_v2.py" ]; then
  sed -i -E 's|^FIREBASE_KEY = .*$|FIREBASE_KEY = "REMPLACE_PAR_API_KEY"|' \
    "${SNAPSHOT}/scripts/audio/probes_audio_v2.py"
  echo "  probes_audio_v2.py : FIREBASE_KEY neutralisée"
fi
# Identifiants de bases D1 (prod et preview) : des identifiants, pas des
# secrets, mais inutiles au miroir — aucun déploiement n'y est possible.
if [ -f "${SNAPSHOT}/wrangler.jsonc" ]; then
  sed -i -E 's|"database_id": "[0-9a-f-]{36}"|"database_id": "00000000-0000-0000-0000-000000000000"|g' \
    "${SNAPSHOT}/wrangler.jsonc"
  echo "  wrangler.jsonc : database_id neutralisés"
fi

echo "== 6. contrôle de confidentialité =="
if ! bash "${ICI}/scan-exposition.sh" "${SNAPSHOT}"; then
  echo ""
  echo "ABANDON : le contrôle de confidentialité a échoué."
  echo "Snapshot conservé pour inspection : ${SNAPSHOT}"
  exit 1
fi

echo "== 7. manifeste du miroir =="
{
  echo "# Manifeste du miroir public — ${NOM}"
  echo ""
  echo "> Miroir d'ingénierie TEMPORAIRE. La référence canonique reste le"
  echo "> dépôt privé \`${COMPTE}/vitrine-video\`."
  echo ""
  echo "| Élément | Valeur |"
  echo "|---|---|"
  echo "| Dépôt source (canonique) | ${COMPTE}/vitrine-video (privé) |"
  echo "| Branche source | d42.2 |"
  echo "| Commit source | \`${COMMIT}\` |"
  echo "| Arbre source | \`${ARBRE}\` |"
  echo "| Date de création | $(date -u +%Y-%m-%dT%H:%M:%SZ) |"
  echo ""
  echo "## Retraits et neutralisations"
  echo ""
  for wf in deploy-production.yml backup-d1-to-b2.yml preview-d1-migrations.yml; do
    echo "- workflow de production écarté : \`${wf}\`"
  done
  echo "- \`gradle.properties\` : \`vvFirebaseApiKey\` remplacée par le jeton de repli"
  echo "- \`scripts/audio/probes_audio_v2.py\` : \`FIREBASE_KEY\` neutralisée"
  echo "- \`wrangler.jsonc\` : \`database_id\` remplacés par des zéros"
  echo "- \`mock-server/data/uploads\` : retiré"
  echo ""
  echo "## Fichiers copiés et empreintes"
  echo ""
  echo "| fichier | octets | sha256 |"
  echo "|---|---|---|"
  ( cd "${SNAPSHOT}" && find . -type f -not -path "./.git/*" | sort | \
      while read -r f; do
        printf "| %s | %s | %s |\n" "${f#./}" "$(stat -c%s "$f")" \
               "$(sha256sum "$f" | cut -d' ' -f1)"
      done )
} > "${SNAPSHOT}/MANIFESTE_MIROIR.md"

NB=$(find "${SNAPSHOT}" -type f | wc -l)
echo "fichiers : ${NB}"

if [ "${MODE}" = "--dry-run" ]; then
  echo ""
  echo "DRY-RUN terminé. Aucun dépôt créé. Snapshot : ${SNAPSHOT}"
  exit 0
fi

echo "== 8. dépôt neuf (historique aplati) =="
cd "${SNAPSHOT}"
git init -q -b main
git -c user.name="D42 mirror" -c user.email="d42@vitrine.invalid" add -A
git -c user.name="D42 mirror" -c user.email="d42@vitrine.invalid" commit -q \
  -m "Snapshot D42 du commit ${COMMIT} (arbre ${ARBRE})

Miroir public TEMPORAIRE d'ingenierie pour la validation D42.
Aucun historique repris : snapshot plat et controle.
Aucun workflow de deploiement. Aucun secret.
Le depot prive ${COMPTE}/vitrine-video reste la reference canonique."

echo "== 9. création du dépôt distant =="
CODE=$(curl -s -o "${TRAVAIL}/creation.json" -w "%{http_code}" \
  -X POST "https://api.github.com/user/repos" \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d "{\"name\":\"${NOM}\",\"private\":false,\"has_issues\":false,\"has_wiki\":false,\"has_projects\":false,\"description\":\"Miroir public TEMPORAIRE D42 - validation du moteur de rendu\"}")
if [ "${CODE}" != "201" ]; then
  echo "création du dépôt : HTTP ${CODE}"
  head -c 400 "${TRAVAIL}/creation.json"
  exit 1
fi

echo "== 10. push =="
AUTH="http.extraheader=Authorization: Basic $(printf 'x-access-token:%s' "${TOKEN}" | base64 -w0)"
git remote add origin "https://github.com/${COMPTE}/${NOM}.git"
git -c "${AUTH}" push -q -u origin main
echo ""
echo "MIROIR PRÊT : https://github.com/${COMPTE}/${NOM}"
echo "source ${COMMIT} (arbre ${ARBRE}) -> miroir $(git rev-parse HEAD)"
echo "correspondance à reporter dans docs/audit/D42_RESUME_STATE.md"
