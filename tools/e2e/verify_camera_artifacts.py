#!/usr/bin/env python3
"""D42.32 (§5, v4) — VÉRIFICATION DES PREUVES DU DIAGNOSTIC CAMÉRA.

Contexte (RCA) : android-emulator-runner exécute le script du job LIGNE PAR
LIGNE via `/usr/bin/sh -c` — un heredoc Python multi-lignes y est interprété
comme des commandes shell (`import: not found`, run 43578603832). Ce
vérificateur est donc un FICHIER du dépôt, invoqué en UNE seule ligne :

    python3 tools/e2e/verify_camera_artifacts.py artifacts/camera-diagnostic

Contrôles (le job ÉCHOUE si une preuve obligatoire manque — compile ≠ terminé) :
  1. deux rapports JSON (performance + compatible), chacun ≥ 500 o, JSON valide ;
  2. les QUATRE sources par rapport : image_analysis, preview_view,
     video_capture, mp4_decode ;
  3. `appareil.emulateur = true` (identification honnête émulateur/physique) ;
  4. PNG de preuve : analysis-*, preview-*, mp4-*-frame-* ;
  5. MP4 réels copiés : video-<mode>.mp4 ≥ 100 000 o (v4 : VideoCapture ~2 s) ;
  6. métriques minimales : frames ImageAnalysis ≥ 10, VideoCapture > 0 octet,
     frames MP4 décodées ≥ 1.

Sortie : lignes « CAMERA OK … » / « ::error::… » + « CAMERA-DIAGNOSTIC BILAN ».
Exit 0 si tout est présent, exit 1 sinon.
"""
import glob
import json
import os
import sys

SOURCES = ("image_analysis", "preview_view", "video_capture", "mp4_decode")


def erreur(msg: str) -> None:
    print(f"::error::{msg}")


def main(dossier: str) -> int:
    rapports = sorted(glob.glob(os.path.join(dossier, "rapport-*.json")))
    if len(rapports) < 2:
        erreur(f"rapports JSON manquants ({len(rapports)} < 2) — récupération en échec")
        return 1

    for attendu in ("performance", "compatible"):
        if not any(f"rapport-{attendu}.json" in r for r in rapports):
            erreur(f"rapport-{attendu}.json absent")
            return 1

    pngs = {
        "analysis": sorted(glob.glob(os.path.join(dossier, "analysis-*.png"))),
        "preview": sorted(glob.glob(os.path.join(dossier, "preview-*.png"))),
        "mp4": sorted(glob.glob(os.path.join(dossier, "mp4-*-frame-*.png"))),
    }
    for famille, liste in pngs.items():
        if not liste:
            erreur(f"aucun PNG de preuve {famille}-* récupéré")
            return 1

    mp4s = sorted(glob.glob(os.path.join(dossier, "video-*.mp4")))
    if len(mp4s) < 2:
        erreur(f"MP4 de diagnostic manquants ({len(mp4s)} < 2 — v4 exige video-performance.mp4 et video-compatible.mp4)")
        return 1
    for m in mp4s:
        taille = os.path.getsize(m)
        if taille < 100_000:
            erreur(f"{os.path.basename(m)} trop petit ({taille} o < 100 000) — vidéo tronquée")
            return 1

    for r in rapports:
        taille = os.path.getsize(r)
        if taille < 500:
            erreur(f"{os.path.basename(r)} trop petit ({taille} o) — rapport tronqué")
            return 1
        try:
            with open(r, encoding="utf-8") as fh:
                d = json.load(fh)
        except (OSError, ValueError) as e:
            erreur(f"{os.path.basename(r)} illisible : {e}")
            return 1
        src = d.get("sources", {})
        for s in SOURCES:
            if s not in src:
                erreur(f"{os.path.basename(r)} : source {s} absente")
                return 1
        if not d.get("appareil", {}).get("emulateur"):
            erreur(f"{os.path.basename(r)} : emulateur=true absent (identification honnête exigée)")
            return 1
        ia = src["image_analysis"]
        if int(ia.get("frames", 0)) < 10:
            erreur(f"{os.path.basename(r)} : frames ImageAnalysis insuffisantes ({ia.get('frames')})")
            return 1
        if int(src["video_capture"].get("octets", 0)) <= 0:
            erreur(f"{os.path.basename(r)} : fichier VideoCapture vide")
            return 1
        if int(src["mp4_decode"].get("frames_decodees", 0)) < 1:
            erreur(f"{os.path.basename(r)} : aucune frame MP4 décodée")
            return 1
        print(f"CAMERA OK {os.path.basename(r)} : {taille} o, 4 sources, emulateur=true")

    total_png = sum(len(v) for v in pngs.values())
    print(f"CAMERA-DIAGNOSTIC BILAN : {len(rapports)} rapports, {total_png} PNG "
          f"({len(pngs['analysis'])} analysis, {len(pngs['preview'])} preview, {len(pngs['mp4'])} mp4), "
          f"{len(mp4s)} MP4 réels — preuves complètes")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: verify_camera_artifacts.py <dossier camera-diagnostic>")
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
