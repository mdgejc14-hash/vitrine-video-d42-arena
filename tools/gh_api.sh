#!/usr/bin/env bash
# Appels API GitHub authentifiés — lecture du jeton par FICHIER uniquement.
#
# PIÈGE CORRIGÉ EN D42.14 : `T=$(cat …) curl …` ne définit PAS la variable pour
# les commandes suivantes — l'affectation ne vaut que pour l'environnement de la
# commande qu'elle préfixe. Résultat : le jeton était vide, ou la variable
# absente du shell, et l'appel partait anonyme (401/403) sans que l'on voie
# pourquoi. Ici l'affectation est une commande À PART ENTIÈRE, puis on vérifie
# qu'elle a réussi AVANT d'appeler l'API. La valeur n'est jamais affichée.
#
# Usage :
#   tools/gh_api.sh GET  repos/OWNER/REPO/actions/runs/42228009767
#   tools/gh_api.sh GET  repos/OWNER/REPO/actions/artifacts/13508945875/zip /tmp/sortie.zip
#
# Codes de sortie : 0 = OK, 3 = fichier de jeton absent, 4 = jeton illisible.
set -uo pipefail

FICHIER_JETON="${D42_GH_TOKEN_FILE:-$HOME/.d42_secrets/gh_token.txt}"

if [ ! -r "$FICHIER_JETON" ]; then
  echo "gh_api: jeton absent ($FICHIER_JETON) — aucune requête authentifiée émise" >&2
  exit 3
fi

# Affectation SEULE, sur sa propre ligne (le point du correctif).
TOKEN=""
TOKEN="$(tr -d '\r\n' < "$FICHIER_JETON")"

if [ -z "${TOKEN:-}" ]; then
  echo "gh_api: fichier de jeton vide — aucune requête émise" >&2
  unset TOKEN
  exit 4
fi

methode="${1:?méthode HTTP}"
chemin="${2:?chemin API}"
sortie="${3:-/dev/stdout}"

code_http="$(
  curl -sS -L -m 60 -X "$methode" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -o "$sortie" -w '%{http_code}' \
    "https://api.github.com/$chemin"
)"
rc=$?
unset TOKEN                       # le jeton ne survit pas à la commande
echo "HTTP $code_http"
exit $rc
