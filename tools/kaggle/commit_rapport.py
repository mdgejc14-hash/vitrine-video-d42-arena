#!/usr/bin/env python3
"""D42.34 — Met à jour le bloc D:AUDIT du CHECKPOINT (appelé par kaggle-audit.yml).

Usage : commit_rapport.py <sha> <etat> <url_run> <notebook_version>
"""
import re
import subprocess
import sys

sha, etat, url, version = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
heure = subprocess.run(["date", "-u", "+%Y-%m-%d %H:%M UTC"],
                       capture_output=True, text=True).stdout.strip()
apres = {
    "DONE": "APK PRE-SIGN récupérée et vérifiée — re-signature officielle Arena en attente.",
    "EN_COURS": "kernel encore en cours à la fin du run — reprendre le suivi (relancer le workflow : reprise SANS re-push).",
    "ANCIEN_SEUL": "ancienne version terminée, re-push de la version avec build échoué — voir push_result.txt.",
    "SANS_APK": "rapport présent mais APK PRE-SIGN absente (build BLOQUÉ ou échoué — voir logs du kernel dans l'artefact).",
    "SANS_FICHIERS": "sorties sans fichiers attendus — voir artefact.",
    "ERROR": "kernel en erreur — état exact et sorties dans l'artefact.",
}.get(etat, etat)
lignes = [
    "<!--D:AUDIT-->",
    "Dernier audit Kaggle : commit `" + sha + "`, notebook `vitrine-video-d42-34-validation` (" + version + "),",
    "état du pilotage : **" + etat + "** — " + apres,
    "sorties et rapport : " + url + " — `REPORT_KAGGLE_D42_34.md` à la racine du dépôt,",
    "verdicts COMPLET / CASSÉ / NON JUGEABLE PAR LECTURE SEULE avec citations fichiers et lignes.",
    "Mis à jour : " + heure + ".",
    "<!--/D:AUDIT-->",
]
bloc = chr(10).join(lignes)
p = "CHECKPOINT_D42_34_VALIDATION.md"
s = open(p, encoding="utf-8").read()
if "<!--D:AUDIT-->" in s:
    s = re.sub(r"<!--D:AUDIT-->.*?<!--/D:AUDIT-->", bloc, s, flags=re.S)
else:
    s += chr(10) + bloc + chr(10)
open(p, "w", encoding="utf-8").write(s)
print("checkpoint mis à jour (état " + etat + ")")
