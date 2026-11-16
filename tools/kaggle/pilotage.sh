#!/bin/bash
# D42.34 — Pilotage du kernel Kaggle par GitHub Actions (contrôleur, pas runner aveugle).
# Usage : pilotage.sh <attente_max_secondes> <pushdir>
# Exigences fondateur :
#   - envoyer le notebook UNE seule fois (jamais de notebooks concurrents) ;
#   - si le kernel est déjà en cours : reprendre le suivi SANS re-push ;
#   - vérifier l'existence et la version réelle du kernel après push
#     (jamais déduire le succès du seul code de sortie) ;
#   - en cas d'erreur : fournir l'erreur exacte, ne jamais simuler un succès ;
#   - vérifier la présence des fichiers attendus avant de déclarer terminé.
# Sorties ($GITHUB_OUTPUT) : etat=DONE|EN_COURS|ANCIEN_SEUL|SANS_APK|SANS_FICHIERS|ERROR
set -uo pipefail

SLUG="$KAGGLE_USERNAME/vitrine-video-d42-34-validation"
ATTENTE_MAX="${1:-16200}"
PUSHDIR="${2:-pushdir}"
DEBUT=$(date +%s)

sonde() { kaggle kernels status "$SLUG" 2>&1 | tail -1; }
en_cours() {
  case "$1" in
    *running*|*RUNNING*|*queued*|*QUEUED*|*acknowledged*|*ACKNOWLEDGED*|*Acknowledged*) return 0 ;;
    *) return 1 ;;
  esac
}

recuperer_sorties() {
  mkdir -p kaggle-output
  kaggle kernels output "$SLUG" -p kaggle-output/ 2>&1 | tail -3 || true
  echo "── sorties récupérées ──"
  ls -la kaggle-output/ 2>/dev/null || true
}

# ── 1. Envoyer une seule fois, si et seulement si nécessaire ──
ETAT=$(sonde) || ETAT="inaccessible"
echo "état initial du kernel : $ETAT"
PUSHE=0
if en_cours "$ETAT"; then
  echo "REPRISE : le kernel est déjà en cours — AUCUN re-push (aucun notebook concurrent)."
else
  echo "push de la version courante (SHA ${SHA_NOTEBOOK:-?})…"
  if ! kaggle kernels push -p "$PUSHDIR" 2>&1 | tee push_result.txt; then
    echo "::error title=Push échoué::Erreur Kaggle exacte ci-dessus (ex. « New kernels must have a title specified » si le title manque)."
    exit 3
  fi
  PUSHE=1
  # VÉRIFICATION RÉELLE après push — jamais le seul code de sortie :
  sleep 25
  VERIF=$(sonde) || VERIF="inaccessible"
  echo "état après push : $VERIF"
  if ! en_cours "$VERIF"; then
    echo "::error title=Push non confirmé::le kernel n'est PAS en cours après le push (état : $VERIF)."
    exit 3
  fi
  # metadata réel du kernel (titre / identifiant / slug préservés) :
  mkdir -p kmeta && rm -f kmeta/kernel-metadata.json
  if kaggle kernels pull "$SLUG" -m -p kmeta >/dev/null 2>&1 && [ -f kmeta/kernel-metadata.json ]; then
    echo "metadata réel confirmé (id/title du kernel) :"
    python3 - << 'PYM'
import json
d = json.load(open("kmeta/kernel-metadata.json"))
print("  id    =", d.get("id"))
print("  title =", d.get("title"))
print("  slug  =", d.get("slug", "(implicite via id)"))
PYM
  else
    echo "::warning::metadata du kernel non récupérable (kernels pull -m) — poursuite, vérification d'état déjà faite."
  fi
fi

# ── 2. Suivi du statut et des journaux ──
REPOUSSE=0
while [ $(( $(date +%s) - DEBUT )) -lt "$ATTENTE_MAX" ]; do
  ETAT=$(sonde) || ETAT="inaccessible"
  case "$ETAT" in
    *COMPLETE*|*complete*)
      echo "kernel TERMINÉ — récupération des sorties…"
      recuperer_sorties
      if [ -f kaggle-output/vitrine-video-d42-34-PRE-SIGN.apk ]; then
        echo "✓ APK PRE-SIGN présente — fichiers attendus confirmés."
        echo "etat=DONE" >> "$GITHUB_OUTPUT"
        exit 0
      fi
      if [ -f kaggle-output/REPORT_KAGGLE_D42_34.md ]; then
        if [ "$REPOUSSE" = "0" ]; then
          echo "Version ANCIENNE terminée (rapport sans APK PRE-SIGN) — envoi de la version courante (avec build)…"
          if kaggle kernels push -p "$PUSHDIR" 2>&1 | tee -a push_result.txt; then
            REPOUSSE=1
            PUSHE=1
            sleep 25
            VERIF=$(sonde) || VERIF="inaccessible"
            if en_cours "$VERIF"; then
              echo "nouvelle version confirmée en cours (état : $VERIF) — poursuite du suivi."
              continue
            fi
            echo "::error::re-push non confirmé (état : $VERIF)."
            echo "etat=ANCIEN_SEUL" >> "$GITHUB_OUTPUT"
            exit 4
          else
            echo "::error::re-push échoué — erreur exacte ci-dessus."
            echo "etat=ANCIEN_SEUL" >> "$GITHUB_OUTPUT"
            exit 4
          fi
        fi
        echo "::error::rapport présent MAIS APK PRE-SIGN absente (version courante) — voir logs du kernel dans l'artefact."
        echo "etat=SANS_APK" >> "$GITHUB_OUTPUT"
        exit 5
      fi
      echo "::error::sorties sans aucun fichier attendu (ni rapport ni APK)."
      echo "etat=SANS_FICHIERS" >> "$GITHUB_OUTPUT"
      exit 6
      ;;
    *ERROR*|*error*|*CANCEL*|*cancel*)
      echo "::error title=Kernel en erreur::état exact : $ETAT"
      recuperer_sorties
      echo "etat=ERROR" >> "$GITHUB_OUTPUT"
      exit 7
      ;;
  esac
  sleep 90
done

echo "DÉLAI d'attente atteint — le kernel CONTINUE sur Kaggle (aucune interruption)."
echo "Relancer le workflow pour reprendre le suivi : la reprise se fait SANS re-push."
echo "etat=EN_COURS" >> "$GITHUB_OUTPUT"
exit 0
