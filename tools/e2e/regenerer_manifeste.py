#!/usr/bin/env python3
"""D42.27-06 — Régénération du MANIFEST_SHA256.txt du lot gabarits V2.0.

AUTORISATION FONDATEUR (message D42.27) : « régénération du manifeste
gabarits AUTORISÉE — sans détruire les références existantes ».

Ce script ne SUPPRIME NI NE MODIFIE AUCUN fichier de contenu : il ne fait
que CONSTATER les empreintes SHA-256 réelles des fichiers présents et
réécrire le manifeste d'intégrité (liste « sha256  chemin » relative au
dossier du lot). Les écarts réparés le 09/11/2026 (constat AVANT) :
  - 30 entrées pointant vers des fichiers supprimés AVANT D42.27
    (profils_style/ et autres, retirés lors de consolidations antérieures) ;
  - 4 empreintes modifiées par le commit VALIDÉ 170ad89
    « fix(gabarits): 8 accroches T2 raccourcies » (120/120 OK_STATIQUE,
    valideurs 0 anomalie) : gabarits/ + fiches_style_v2_0/ × immo_auto,
    shops_small_business ;
  - 1 fichier absent du manifeste : INTEGRATION_REPO.md.

Idempotent : relancer ne change rien (ordre de parcours déterministe :
chemins triés). Le manifeste s'exclut lui-même.

Usage : python3 tools/e2e/regenerer_manifeste.py [--verifier]
  --verifier : ne réécrit rien, sortie 1 si le manifeste actuel diverge.
"""
import hashlib
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent.parent / "content" / "gabarits_v2"
MANIFESTE = RACINE / "MANIFEST_SHA256.txt"


def empreintes() -> list[tuple[str, str]]:
    fichiers = [
        p for p in RACINE.rglob("*")
        if p.is_file() and p != MANIFESTE
    ]
    fichiers.sort(key=lambda p: p.relative_to(RACINE).as_posix())
    return [
        (hashlib.sha256(p.read_bytes()).hexdigest(),
         p.relative_to(RACINE).as_posix())
        for p in fichiers
    ]


def verifier() -> int:
    paires = empreintes()
    actuel = MANIFESTE.read_text(encoding="utf-8") if MANIFESTE.is_file() else ""
    attendu = "".join(f"{s}  {r}\n" for s, r in paires)
    if actuel == attendu:
        print(f"OK : manifeste conforme ({len(paires)} entrées, toutes vérifiées)")
        return 0
    print(f"DIVERGENCE : manifeste != réalité du lot ({len(paires)} fichiers réels)")
    return 1


def regenerer() -> int:
    if not RACINE.is_dir():
        print(f"ERREUR : lot introuvable ({RACINE})")
        return 2
    paires = empreintes()
    corps = "".join(f"{s}  {r}\n" for s, r in paires)
    avant = MANIFESTE.read_text(encoding="utf-8") if MANIFESTE.is_file() else ""
    MANIFESTE.write_text(corps, encoding="utf-8")
    etat = "inchangé (déjà conforme)" if avant == corps else "RÉGÉNÉRÉ"
    print(f"Manifeste {etat} : {len(paires)} entrées -> {MANIFESTE}")
    # Contrôle immédiat : chaque ligne relue doit matcher le fichier.
    import re
    ok = 0
    for l in corps.splitlines():
        m = re.match(r"^([0-9a-f]{64})  (.+)$", l)
        assert m, l
        reel = hashlib.sha256((RACINE / m.group(2)).read_bytes()).hexdigest()
        assert reel == m.group(1), m.group(2)
        ok += 1
    print(f"Auto-contrôle : {ok}/{len(paires)} empreintes re vérifiées OK")
    return 0


if __name__ == "__main__":
    sys.exit(verifier() if "--verifier" in sys.argv else regenerer())
