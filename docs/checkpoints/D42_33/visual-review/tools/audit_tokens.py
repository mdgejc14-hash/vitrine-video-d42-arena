#!/usr/bin/env python3
"""Audit de fidélité D42.33 (v2) — vérification programmatique des tokens.

L'environnement d'exécution n'a pas de capacité vision sur les PNG (note du
checkpoint 00) : la conformité chromatique est donc PROUVÉE par analyse de
pixels. Pour chaque capture, on mesure la part des pixels qui collent à un
token officiel de la spec (§3), et on liste les couleurs non-token dominantes
(ΔE Manhattan ≤ 24 par canal = bruit d'anticrénelage tolerated).

Usage : python3 audit_tokens.py [dossier...] (défaut : ../BEFORE ../AFTER)
Sortie : TSV sur stdout — fichier, largeur, hauteur, pct_tokens, top non-tokens.
"""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

# Tokens officiels — spec 05_Spec_design_a_transmettre.md §3.
TOKENS = {
    "OrangeStore": (0xF9, 0x5C, 0x0F),
    "OrangeHi": (0xFF, 0x6E, 0x22),
    "OrangeDeep": (0xD3, 0x49, 0x05),
    "Navy": (0x02, 0x23, 0x58),
    "NavySoft": (0x23, 0x46, 0x7F),
    "Bg": (0xF7, 0xF8, 0xFC),
    "Surface": (0xFF, 0xFF, 0xFF),
    "Line": (0xE2, 0xE8, 0xF0),
    "Muted": (0x6C, 0x7C, 0x99),
    "OrangeVoile": (0xFF, 0xF1, 0xE8),
    "BleuVoile": (0xE9, 0xF0, 0xFF),
    "VertSucces": (0x0E, 0x9F, 0x6E),
    "VertTexte": (0x0B, 0x7A, 0x55),
    "AmbreAlerte": (0xB2, 0x6A, 0x00),
    "RougeBloquant": (0xB4, 0x23, 0x18),
    # État désactivé du CTA (spec §7.1) et piste (§7.8) — tokens dérivés légitimes.
    "CtaDesactive": (0xED, 0xEF, 0xF5),
    "TexteDesactive": (0x9A, 0xA7, 0xBE),
}
TOL = 24  # somme des écarts absolus par canal (anticrénelage)


def plus_proche(px: tuple[int, int, int]) -> str | None:
    for nom, t in TOKENS.items():
        if abs(px[0] - t[0]) + abs(px[1] - t[1]) + abs(px[2] - t[2]) <= TOL:
            return nom
    return None


def auditer(chemin: Path) -> str:
    im = Image.open(chemin).convert("RGB")
    im = im.resize((min(im.width, 360), max(1, round(im.height * min(im.width, 360) / im.width))))
    hist: dict[tuple[int, int, int], int] = {}
    for n, px in im.getcolors(maxcolors=1 << 24) or []:
        hist[px] = n
    total = sum(hist.values()) or 1
    pct = 100.0 * sum(n for px, n in hist.items() if plus_proche(px)) / total
    hors = sorted(((n, px) for px, n in hist.items() if not plus_proche(px)), reverse=True)
    top = " ".join(f"#{r:02X}{g:02X}{b:02X}:{100 * n / total:.1f}%" for n, (r, g, b) in hors[:3])
    return f"{chemin.name}\t{im.width}x{im.height}\t{pct:.1f}\t{top}"


def main() -> None:
    dossiers = [Path(a) for a in sys.argv[1:]] or [Path(__file__).resolve().parent.parent / "AFTER"]
    print("fichier\tlarg_x_haut_resized\tpct_tokens\ttop_non_tokens")
    for d in dossiers:
        for f in sorted(d.rglob("*.png")):
            if "," in f.name:  # doublons v1 exclus de l'audit
                continue
            print(auditer(f))


if __name__ == "__main__":
    main()
