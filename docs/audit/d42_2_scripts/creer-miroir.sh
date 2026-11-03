#!/usr/bin/env bash
# =============================================================================
# D42.2 — CRÉATION DU MIROIR PUBLIC TEMPORAIRE
#
#   bash creer-miroir.sh <clone-source> <commit> <compte-ou-orga> <nom-miroir>
#
# Exemple :
#   bash creer-miroir.sh ~/work/vv-d42 cf26af5 mdgejc14-hash vitrine-video-d42-arena
#
# Principe :
#   1. extrait un SNAPSHOT de l'arbre au commit donné (aucun historique) ;
#   2. retire les fichiers interdits (secrets, binaires, caches) ;
#   3. exécute le contrôle de confidentialité — ABANDONNE s'il échoue ;
#   4. écrit MANIFESTE_MIROIR.md (dépôt source, commit, arbre, empreintes) ;
#   5. initialise un dépôt NEUF (historique aplati) et pousse.
#
# Le dépôt privé reste la référence canonique : le miroir n'est qu'un outil.
# =============================================================================
set -euo pipefail

SOURCE="${1:?clone source requis}"
COMMIT="${2:?commit requis}"
COMPTE="${3:?compte ou organisation requis}"
NOM="${4:?nom du miroir requis}"

ICI="$(cd "$(dirname "$0")" && pwd)"
TRAVAIL="$(mktemp -d)"
SNAPSHOT="${TRAVAIL}/${NOM}"
TOKEN="${GITHUB_TOKEN:-}"

[ -n "${TOKEN}" ] || { echo "GITHUB_TOKEN absent de l'environnement"; exit 2; }
[ -d "${SOURCE}/.git" ] || { echo "${SOURCE} n'est pas un dépôt git"; exit 2; }

echo "== 1. empreinte de l'arbre source =="
ARBRE=$(git -C "${SOURCE}" rev-parse "${COMMIT}^{tree}")
echo "commit=${COMMIT}"
echo "arbre =${ARBRE}"
git -C "${SOURCE}" log -1 --format='date=%cI auteur=%an' "${COMMIT}"

echo "== 2. extraction du snapshot (sans historique) =="
mkdir -p "${SNAPSHOT}"
git -C "${SOURCE}" archive "${COMMIT}" | tar -x -C "${SNAPSHOT}"

echo "== 3. retrait des fichiers interdits =="
# Secrets et configurations locales
find "${SNAPSHOT}" -type f \( \
  -name "*.keystore" -o -name "*.jks" -o -name "*.p12" -o -name "*.pfx" \
  -o -name "*.pem" -o -name "*.key" -o -name ".env" -o -name ".env.*" \
  -o -name ".dev.vars" -o -name ".netrc" -o -name ".git-credentials" \
  -o -name "local.properties" -o -name "google-services.json" \
  -o -name ".b2_keys.json" -o -name "b2_keys.json" \
  \) -delete 2>/dev/null || true
# Médias lourds et artefacts : interdits dans Git (artefacts Actions à la place)
find "${SNAPSHOT}" -type f \( -name "*.mp4" -o -name "*.apk" -o -name "*.zip" \
  -o -name "*.aab" \) -size +200k -delete 2>/dev/null || true
# Caches de build éventuellement versionnés par erreur
rm -rf "${SNAPSHOT}/build" "${SNAPSHOT}/.gradle" "${SNAPSHOT}/.idea" 2>/dev/null || true

echo "== 4. contrôle de confidentialité =="
if ! bash "${ICI}/scan-exposition.sh" "${SNAPSHOT}"; then
  echo "ABANDON : le contrôle de confidentialité a échoué."
  echo "Snapshot conservé pour inspection : ${SNAPSHOT}"
  exit 1
fi

echo "== 5. manifeste du miroir =="
{
  echo "# Manifeste du miroir public — ${NOM}"
  echo ""
  echo "| Élément | Valeur |"
  echo "|---|---|"
  echo "| Dépôt source (canonique) | ${COMPTE}/vitrine-video (privé) |"
  echo "| Branche source | audit-d41 |"
  echo "| Commit source | \`${COMMIT}\` |"
  echo "| Arbre source | \`${ARBRE}\` |"
  echo "| Date de création | $(date -u +%Y-%m-%dT%H:%M:%SZ) |"
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
  echo ""
  echo "> Ce fichier permet de comparer le miroir au snapshot source et de"
  echo "> détecter toute différence inattendue. Le dépôt privé reste la"
  echo "> référence : toute correction validée ici doit être transférée."
} > "${SNAPSHOT}/MANIFESTE_MIROIR.md"

NB_FICHIERS=$(find "${SNAPSHOT}" -type f -not -name "MANIFESTE_MIROIR.md" | wc -l)
echo "fichiers : ${NB_FICHIERS}"

echo "== 6. dépôt neuf (historique aplati) =="
cd "${SNAPSHOT}"
git init -q -b main
git -c user.name="D42 mirror" -c user.email="d42@vitrine.invalid" \
    add -A
git -c user.name="D42 mirror" -c user.email="d42@vitrine.invalid" \
    commit -q -m "Snapshot D42 du commit ${COMMIT} (arbre ${ARBRE})

Miroir public temporaire d'ingénierie pour la validation D42.
Aucun historique repris : snapshot plat et contrôlé.
Le dépôt privé ${COMPTE}/vitrine-video reste la référence canonique."

echo "== 7. création du dépôt distant =="
CODE=$(curl -s -o "${TRAVAIL}/creation.json" -w "%{http_code}" \
  -X POST "https://api.github.com/user/repos" \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d "{\"name\":\"${NOM}\",\"private\":false,\"has_issues\":false,\
\"has_wiki\":false,\"has_projects\":false,\"description\":\
\"Miroir public TEMPORAIRE D42 - validation du moteur de rendu Vitrine Video\"}")
if [ "${CODE}" != "201" ]; then
  echo "création du dépôt : HTTP ${CODE}"
  head -c 400 "${TRAVAIL}/creation.json"
  exit 1
fi

echo "== 8. push =="
git remote add origin "https://x-access-token:${TOKEN}@github.com/${COMPTE}/${NOM}.git"
git push -q -u origin main
MIROIR_SHA=$(git rev-parse HEAD)
echo "commit du miroir : ${MIROIR_SHA}"
echo "arbre du miroir  : $(git rev-parse HEAD^{tree})"

echo ""
echo "MIROIR PRÊT : https://github.com/${COMPTE}/${NOM}"
echo "correspondance : source ${COMMIT} (arbre ${ARBRE}) -> miroir ${MIROIR_SHA}"
echo "snapshot local : ${SNAPSHOT}"
