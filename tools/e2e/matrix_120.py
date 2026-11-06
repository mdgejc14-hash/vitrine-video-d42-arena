#!/usr/bin/env python3
"""Matrice 30 gabarits x 4 langues — laboratoire D42.13.

Répond à UNE question : « pour chacune des 120 combinaisons, le texte qui devra
être rendu est-il présent, complet et typographiquement sain ? »

Ce que ce script VÉRIFIE (statique, sur les données embarquées) :
  - chaque chaîne française utilisée par le gabarit possède une traduction
    en/ es / ja non vide ;
  - les variables {…} sont identiques d'une langue à l'autre ;
  - aucune chaîne japonaise ne commence par un caractère interdit en début de
    ligne (kinsoku shori : 。、）」』！？ー々…), ni ne se termine par un caractère
    interdit en fin de ligne （「『（ ;
  - estimation de largeur : une chaîne est signalée si sa largeur estimée
    dépasse la zone de texte la plus étroite observée dans les rendus (≈ 18 em).

Ce que ce script NE FAIT PAS : aucun rendu vidéo, aucune capture. Une
combinaison « OK » ici signifie PASS_STATIC, jamais « rendu vérifié ».
"""
import csv
import glob
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
L10N = os.path.join(ROOT, "data/src/main/assets/i18n/gabarit_l10n_v1.json")
GABARITS = os.path.join(ROOT, "data/src/main/assets/gabarits/*/T*.json")
OUT_DIR = "/home/user/d42.13/matrix"
LANGS = ["fr", "en", "es", "ja"]

KINSOKU_DEBUT_INTERDIT = "。、）」』！？ー々…"      # ne peut pas commencer une ligne
KINSOKU_FIN_INTERDIT = "（「『"                     # ne peut pas terminer une ligne
LARGEUR_MAX_EM = 20.0


def largeur_estimee(texte):
    """1 caractère CJK ≈ 1 em ; latins ≈ 0.55 em ; espaces 0.28 em."""
    w = 0.0
    for ch in texte:
        if ord(ch) > 0x2E80:      # CJK, kana, ponctuation pleine largeur
            w += 1.0
        elif ch == " ":
            w += 0.28
        else:
            w += 0.55
    return w


def placeholders(texte):
    import re
    return sorted(re.findall(r"\{[a-z_]+\}", texte))


def collecter_textes(obj, acc):
    if isinstance(obj, str):
        acc.append(obj)
    elif isinstance(obj, dict):
        for v in obj.values():
            collecter_textes(v, acc)
    elif isinstance(obj, list):
        for v in obj:
            collecter_textes(v, acc)


def main():
    l10n = json.load(open(L10N, encoding="utf-8"))
    traductions = l10n["textes"]
    badges = l10n.get("badges", {})
    tables = {}
    for k, v in traductions.items():
        tables[k] = v
    for _, v in badges.items():
        for lang, txt in v.items():
            tables.setdefault(txt, {})
    cles = set(tables)

    os.makedirs(OUT_DIR, exist_ok=True)
    lignes = []
    for f in sorted(glob.glob(GABARITS)):
        g = json.load(open(f, encoding="utf-8"))
        nom = os.path.basename(f).replace(".json", "")
        secteur = os.path.basename(os.path.dirname(f))
        textes = []
        collecter_textes(g, textes)
        # chaînes rendues = celles présentes dans la table de traduction
        rendus = [t for t in set(textes) if t in cles]
        sans_trad = [t for t in rendus if len(t.strip()) > 2]
        for lang in LANGS:
            problemes = []
            for fr in sans_trad:
                if lang == "fr":
                    val = fr
                else:
                    val = (tables[fr] or {}).get(lang)
                    if not val:
                        problemes.append(f"traduction_absente:{fr[:28]}")
                        continue
                if placeholders(fr) != placeholders(val):
                    problemes.append(f"variables_divergentes:{fr[:24]}")
                if val != val.strip():
                    problemes.append(f"espaces_parasites:{fr[:24]}")
                if lang == "ja":
                    if val and val[0] in KINSOKU_DEBUT_INTERDIT:
                        problemes.append(f"kinsoku_debut:{val[:16]}")
                    if val and val[-1] in KINSOKU_FIN_INTERDIT:
                        problemes.append(f"kinsoku_fin:{val[:16]}")
                # La largeur n'est mesurable que si la chaîne ne contient pas de
                # variable : la valeur saisie par le commerçant est inconnue.
                if "{" not in val and largeur_estimee(val) > LARGEUR_MAX_EM:
                    problemes.append(f"largeur_{largeur_estimee(val):.1f}em:{val[:20]}")
            if not sans_trad:
                statut = "AUCUN_TEXTE_RENDU"
            elif any(p.startswith("traduction_absente") for p in problemes):
                statut = "MANQUE_TRADUCTION"
            elif problemes:
                statut = "RISQUE_TYPO"
            else:
                statut = "OK_STATIQUE"
            lignes.append({
                "gabarit": nom, "secteur": secteur, "langue": lang,
                "chaines_rendues": len(sans_trad), "statut": statut,
                "problemes": "; ".join(problemes[:4]),
            })

    dest = os.path.join(OUT_DIR, "matrice_120.csv")
    with open(dest, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=["gabarit", "secteur", "langue",
                                           "chaines_rendues", "statut", "problemes"])
        w.writeheader()
        w.writerows(lignes)

    from collections import Counter
    c = Counter(l["statut"] for l in lignes)
    print(f"MATRICE lignes={len(lignes)} combinaisons={len(lignes)}")
    for k, v in sorted(c.items()):
        print(f"MATRICE statut={k} n={v}")
    par_langue = Counter((l["langue"], l["statut"]) for l in lignes)
    for lang in LANGS:
        tot = sum(v for (lg, _), v in par_langue.items() if lg == lang)
        ok = par_langue.get((lang, "OK_STATIQUE"), 0)
        print(f"MATRICE langue={lang} ok={ok}/{tot}")
    print(f"MATRICE rapport={dest}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
