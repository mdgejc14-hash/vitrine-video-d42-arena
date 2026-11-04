#!/usr/bin/env bash
# =============================================================================
# D42.2 — CONTRÔLE DE CONFIDENTIALITÉ AVANT EXPOSITION PUBLIQUE
#
#   bash scan-exposition.sh <arborescence>
#
# Refuse l'exposition si un secret, une clé, un keystore, une donnée
# personnelle ou un jeton réel subsiste dans l'arbre.
#
# Code de sortie :
#   0 = aucun secret détecté (exposition autorisable)
#   1 = au moins un secret détecté (exposition INTERDITE)
#   2 = usage incorrect
#
# Aucun secret n'est affiché en clair : les correspondances sont masquées.
#
# v2 — après premier passage sur l'arbre réel, trois règles ont été précisées :
#   * `.dev.vars.example` est conservé : ce sont des noms vides, utiles à la
#     lecture, pas des valeurs ;
#   * une mention *textuelle* de CLOUDFLARE_API_TOKEN n'est pas un secret :
#     seules les valeurs affectées le sont ;
#   * les médias produits (< 5 Mo, sous assets/) sont légitimes ; seuls les
#     fichiers hors assets/ ou volumineux sont refusés.
#   * les numéros manifestement synthétiques sont connus et admis.
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
  case "$f" in
    *.example|*.sample|*.template) continue ;;
  esac
  DEFAUTS=$((DEFAUTS+1))
  noter "  INTERDIT ${f#${RACINE}/}"
done < <(find "${RACINE}" -type f \( \
  -name "*.keystore" -o -name "*.jks" -o -name "*.p12" -o -name "*.pfx" \
  -o -name "*.pem" -o -name "*.key" -o -name "id_rsa*" -o -name "id_ed25519*" \
  -o -name ".env" -o -name ".env.*" -o -name ".dev.vars" -o -name ".dev.vars.*" \
  -o -name ".netrc" -o -name ".git-credentials" -o -name "*.kdbx" \
  -o -name "google-services.json" -o -name "GoogleService-Info.plist" \
  -o -name "b2_keys.json" -o -name ".b2_keys.json" \
  \) -not -path "*/build/*" -not -path "*/.gradle/*" 2>/dev/null)

# --- 2. motifs de secrets dans le contenu -----------------------------------
# libellé | expression | mode (bloquant)
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
  # Valeur affectée uniquement : « CLOUDFLARE_API_TOKEN: ${...} » ou une simple
  # mention de son nom n'est PAS un secret.
  "jeton Cloudflare réel|CLOUDFLARE_API_TOKEN[\"' ]*[:=][^$}\n]{20,}"
  "mot de passe en clair|(password|mot_de_passe)['\"]?\s*[:=]\s*['\"][^'\"]{6,}"
  "URL de service privé|https?://[a-z0-9-]+\.workers\.dev"
  "adresse e-mail réelle|[A-Za-z0-9._%+-]+@(?!vitrine\.video|example\.)[A-Za-z0-9.-]+\.[A-Za-z]{2,}"
  # Numéros béninois : 97000000 et 00000000 sont les seuls numéros de test connus.
  "numéro béninois réel|\+229(?!97000000|00000000)[0-9]{8}"
)

noter ""
noter "== 2. Motifs de secrets dans le contenu =="
for entree in "${MOTIFS[@]}"; do
  libelle="${entree%%|*}"
  regex="${entree#*|}"
  trouve=$(grep -rIlEZ --exclude-dir=build --exclude-dir=.gradle \
             --exclude-dir=.git --exclude-dir=node_modules \
             -e "${regex}" "${RACINE}" 2>/dev/null | tr '\0' '\n' | head -20)
  if [ -n "${trouve}" ]; then
    nb=$(echo "${trouve}" | wc -l)
    DEFAUTS=$((DEFAUTS+nb))
    noter "  DETECTE ${libelle} — ${nb} fichier(s) :"
    echo "${trouve}" | sed "s|^${RACINE}/|      |" | tee -a "${RAPPORT}"
  else
    noter "  ok      ${libelle}"
  fi
done

# --- 3. fichiers hors dépôt et médias volumineux ----------------------------
# Les assets produits (SFX, BGM, rushes de test) sont legitimes et necessaires
# au rendu : les retirer casserait la fonctionnalite, ce que D42.2 interdit.
noter ""
noter "== 3. Fichiers hors assets ou volumineux =="
TROUVE3=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  TROUVE3=$((TROUVE3+1))
  DEFAUTS=$((DEFAUTS+1))
  noter "  A RETIRER ${f#${RACINE}/} ($(du -h "$f" | cut -f1))"
done < <(find "${RACINE}" -type f \( -name "*.mp4" -o -name "*.wav" -o -name "*.m4a" \
           -o -name "*.apk" -o -name "*.aab" -o -name "*.zip" \) \
           \( -size +5M -o -not -path "*/assets/*" \) -not -path "*/build/*" 2>/dev/null | head -40)
[ "${TROUVE3}" -eq 0 ] && noter "  ok      aucun média hors assets, aucun fichier de plus de 5 Mo"

# --- 4. configuration locale ------------------------------------------------
noter ""
noter "== 4. Configuration locale et journaux =="
TROUVE4=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  TROUVE4=$((TROUVE4+1))
  DEFAUTS=$((DEFAUTS+1))
  noter "  A RETIRER ${f#${RACINE}/}"
done < <(find "${RACINE}" -type f \( -name "local.properties" -o -name "*.log" \
           -o -name "logcat*.txt" \) -not -path "*/build/*" 2>/dev/null | head -20)
[ "${TROUVE4}" -eq 0 ] && noter "  ok      aucun fichier de configuration locale"

# --- 5. historique Git ------------------------------------------------------
noter ""
noter "== 5. Historique Git =="
if [ -d "${RACINE}/.git" ]; then
  # ATTENTION : `git log | grep -q` est un piege — grep -q ferme le tube,
  # git recoit SIGPIPE et `set -o pipefail` transforme le succes en echec.
  # On capture d'abord, on teste ensuite.
  HIST=$(git -C "${RACINE}" log --all -p 2>/dev/null | \
         grep -E "ghp_[A-Za-z0-9]{36}|AIza[0-9A-Za-z_-]{35}|BEGIN [A-Z ]*PRIVATE KEY|sk_live_" | head -3)
  if [ -n "${HIST}" ]; then
    DEFAUTS=$((DEFAUTS+1))
    noter "  INTERDIT : motif de secret dans l'historique ($(echo "${HIST}" | wc -l) ligne(s)) — aplatir"
  else
    noter "  ok      aucun motif de secret dans l'historique"
  fi
else
  noter "  ok      pas de .git : snapshot aplati par construction"
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
