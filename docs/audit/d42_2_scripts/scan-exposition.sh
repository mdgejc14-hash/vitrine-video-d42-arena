#!/usr/bin/env bash
# =============================================================================
# D42.2 — CONTRÔLE DE CONFIDENTIALITÉ AVANT EXPOSITION PUBLIQUE
#
#   bash scan-exposition.sh <arborescence>
#
# Refuse l'exposition si un secret, une clé, un keystore, une donnée
# personnelle ou une URL de service privé subsiste dans l'arbre.
#
# Code de sortie :
#   0 = aucun secret détecté (exposition autorisable)
#   1 = au moins un secret détecté (exposition INTERDITE)
#   2 = usage incorrect
#
# Aucun secret n'est affiché en clair : les correspondances sont masquées.
# =============================================================================
set -uo pipefail

RACINE="${1:?usage: scan-exposition.sh <arborescence>}"
[ -d "${RACINE}" ] || { echo "arborescence absente : ${RACINE}"; exit 2; }

RAPPORT="${RACINE}/../D42_EXPOSURE_SCAN.txt"
: > "${RAPPORT}"
DEFAUTS=0

noter() { echo "$1" | tee -a "${RAPPORT}"; }

# --- 1. fichiers interdits par leur nom -------------------------------------
noter "== 1. Fichiers interdits par leur nom =="
while IFS= read -r f; do
  [ -z "$f" ] && continue
  DEFAUTS=$((DEFAUTS+1))
  noter "  INTERDIT ${f}"
done < <(find "${RACINE}" -type f \( \
  -name "*.keystore" -o -name "*.jks" -o -name "*.p12" -o -name "*.pfx" \
  -o -name "*.pem" -o -name "*.key" -o -name "id_rsa*" -o -name "id_ed25519*" \
  -o -name ".env" -o -name ".env.*" -o -name ".dev.vars" -o -name ".dev.vars.*" \
  -o -name ".netrc" -o -name ".git-credentials" -o -name "*.kdbx" \
  -o -name "google-services.json" -o -name "GoogleService-Info.plist" \
  -o -name "b2_keys.json" -o -name ".b2_keys.json" -o -name "*secret*.json" \
  \) -not -path "*/build/*" -not -path "*/.gradle/*" 2>/dev/null)

# --- 2. motifs de secrets dans le contenu -----------------------------------
# Chaque motif : libellé | expression régulière étendue
MOTIFS=(
  "PAT GitHub (ghp_)|ghp_[A-Za-z0-9]{36}"
  "PAT GitHub (github_pat_)|github_pat_[A-Za-z0-9_]{60,}"
  "jeton OAuth|gho_[A-Za-z0-9]{36}"
  "clé Google API|AIza[0-9A-Za-z_-]{35}"
  "clé AWS|AKIA[0-9A-Z]{16}"
  "clé privée PEM|-----BEGIN [A-Z ]*PRIVATE KEY-----"
  "clé Stripe (live)|sk_live_[0-9A-Za-z]{20,}"
  "clé Stripe (test)|sk_test_[0-9A-Za-z]{20,}"
  "clé CinetPay|cinetpay[_\":= ]+[A-Za-z0-9_-]{16,}"
  "clé FedaPay|fedapay[_\":= ]+[A-Za-z0-9_-]{16,}"
  "clé application B2|applicationKey[^,}]{0,8}[\"'][A-Za-z0-9]{20,}"
  "identifiant Cloudflare|CLOUDFLARE_API_TOKEN|CF_API_TOKEN"
  "mot de passe en clair|(password|mot_de_passe)['\"]?\s*[:=]\s*['\"][^'\"]{6,}"
  "URL de service privé|https?://[a-z0-9-]+\.workers\.dev"
  "adresse e-mail réelle|[A-Za-z0-9._%+-]+@(?!vitrine\.video|example\.)[A-Za-z0-9.-]+\.[A-Za-z]{2,}"
  "numéro béninois réel|\+229[0-9]{8}"
)

noter ""
noter "== 2. Motifs de secrets dans le contenu =="
for entree in "${MOTIFS[@]}"; do
  libelle="${entree%%|*}"
  regex="${entree#*|}"
  # Fichiers texte uniquement (pas de binaire), hors build et artefacts.
  trouve=$(grep -rIlEZ --exclude-dir=build --exclude-dir=.gradle \
             --exclude-dir=.git --exclude-dir=node_modules \
             -e "${regex}" "${RACINE}" 2>/dev/null | tr '\0' '\n' | head -20)
  if [ -n "${trouve}" ]; then
    nb=$(echo "${trouve}" | wc -l)
    DEFAUTS=$((DEFAUTS+nb))
    noter "  DETECTE ${libelle} — ${nb} fichier(s) :"
    echo "${trouve}" | sed 's/^/      /' | tee -a "${RAPPORT}"
  else
    noter "  ok      ${libelle}"
  fi
done

# --- 3. fichiers de configuration locaux ------------------------------------
noter ""
noter "== 3. Configurations locales et caches =="
while IFS= read -r f; do
  [ -z "$f" ] && continue
  DEFAUTS=$((DEFAUTS+1))
  noter "  A RETIRER ${f}"
done < <(find "${RACINE}" -type f \( \
  -name "local.properties" -o -name "*.log" -o -name "logcat*.txt" \
  -o -name "*.mp4" -o -name "*.wav" -o -name "*.m4a" -o -name "*.apk" \
  -o -name "*.zip" -o -name "*.jks.enc" \
  \) -not -path "*/build/*" 2>/dev/null | head -50)

# --- 4. historique Git -------------------------------------------------------
noter ""
noter "== 4. Historique Git =="
if [ -d "${RACINE}/.git" ]; then
  if grep -rIlE "ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35}|BEGIN [A-Z ]*PRIVATE KEY" \
       "${RACINE}/.git" 2>/dev/null | head -5 | grep -q .; then
    DEFAUTS=$((DEFAULTS+1))
    noter "  INTERDIT : un secret figure dans l'historique — aplatir l'historique"
  else
    noter "  ok      aucun motif de secret dans les objets Git"
  fi
else
  noter "  note    pas de .git : snapshot aplati par construction"
fi

# --- verdict ----------------------------------------------------------------
noter ""
if [ "${DEFAUTS}" -eq 0 ]; then
  noter "VERDICT : AUCUN SECRET DETECTE — exposition autorisable"
  exit 0
else
  noter "VERDICT : ${DEFAUTS} ANOMALIE(S) — EXPOSITION INTERDITE"
  noter "Corriger, puis relancer ce script avant toute publication."
  exit 1
fi
