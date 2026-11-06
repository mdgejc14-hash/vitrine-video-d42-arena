#!/usr/bin/env python3
"""Test HORS APPAREIL du ciblage des clics (laboratoire D42.14).

Pourquoi ce test existe : le run 42223776656 a montré un bouton « Continuer »
exposé par Compose dans **1 pixel de haut** ([455,2071][625,2072]) alors que le
bouton réel occupe [44,1978][1036,2072]. `ui.py tap` visait le centre du texte,
c'est-à-dire le **bord bas de la fenêtre** : l'appui ne faisait rien, sans
erreur, et le test concluait « bouton actionné mais écran suivant absent ».

Ce fichier rejoue le ciblage sur des arbres uiautomator **synthétiques** qui
reproduisent les cas réellement observés. Il ne remplace pas un test sur
appareil : il prouve que la correction produit les bonnes coordonnées.

Usage : python3 tools/e2e/test_ciblage.py
"""
import re
import sys
import xml.etree.ElementTree as ET

import ui

ECRAN = (1080, 2340)

# 1) Cas réel du run 42223776656 : bouton pleine largeur, texte dégénéré.
CAS_DEGENERE = """<hierarchy><node class="android.widget.FrameLayout" bounds="[0,0][1080,2340]">
  <node class="android.widget.Button" clickable="true" bounds="[44,1978][1036,2072]">
    <node class="android.widget.TextView" text="Continuer" clickable="false" bounds="[455,2071][625,2072]" />
  </node>
  <node class="android.widget.Button" clickable="true" bounds="[44,600][1036,700]">
    <node class="android.widget.TextView" text="Autres options (facultatif)" bounds="[77,620][700,680]" />
  </node>
</node></hierarchy>"""

# 2) Cas run 42208901429 : texte du bouton exposé à [0,0][0,0], surface nulle part.
CAS_SANS_SURFACE = """<hierarchy><node class="android.widget.FrameLayout" bounds="[0,0][1080,2340]">
  <node class="android.widget.EditText" text="RobeWax" clickable="true" bounds="[44,257][1036,411]" />
  <node class="android.widget.TextView" text="Continuer" clickable="false" bounds="[0,0][0,0]" />
  <node class="android.widget.Button" clickable="true" bounds="[44,1978][1036,2072]" />
  <node class="android.widget.Button" clickable="true" bounds="[44,600][1036,700]" />
</node></hierarchy>"""

# 3) Cas nominal : bornes franches, le centre doit être utilisé tel quel.
CAS_NOMINAL = """<hierarchy><node class="android.widget.FrameLayout" bounds="[0,0][1080,2340]">
  <node class="android.widget.Button" text="Suivant" clickable="true" bounds="[44,2021][1036,2072]" />
</node></hierarchy>"""


def charger(xml):
    root = ET.fromstring(xml)
    ui._PARENT.clear()
    for parent in root.iter("node"):
        for child in parent:
            ui._PARENT[child] = parent
    return list(root.iter("node"))


def node_texte(nodes, texte):
    for n in nodes:
        if n.get("text") == texte:
            return n
    raise AssertionError(f"nœud « {texte} » absent du fixture")


def cas(nom, xml, texte, attendu_mode, attendu_dans, interdit=None):
    nodes = charger(xml)
    n = node_texte(nodes, texte)
    x, y, mode = ui.point_de_clic(nodes, n, *ECRAN)
    problemes = []
    if mode != attendu_mode:
        problemes.append(f"mode={mode} attendu={attendu_mode}")
    if x is None:
        problemes.append("aucun point calculé")
    else:
        x1, y1, x2, y2 = attendu_dans
        if not (x1 <= x <= x2 and y1 <= y <= y2):
            problemes.append(f"point ({x},{y}) hors de la cible {attendu_dans}")
        if interdit and interdit[1] <= y <= interdit[3]:
            problemes.append(f"point ({x},{y}) dans la zone interdite {interdit}")
    etat = "PASS" if not problemes else "FAIL"
    print(f"{etat} {nom} :: ({x},{y}) mode={mode}" + (" | " + " ; ".join(problemes) if problemes else ""))
    return etat == "PASS"


def main():
    ui._FENETRE[0], ui._FENETRE[1] = ECRAN
    resultats = [
        # le bouton réel va de y=1978 à y=2072 : le clic doit tomber à l'intérieur,
        # et surtout PAS sur la dernière ligne (2071) qui touche le bord de l'écran
        cas("texte dégénéré (1 px) -> surface du parent", CAS_DEGENERE, "Continuer",
            "surface", (44, 1978, 1036, 2072), interdit=(0, 2071, 1080, 2072)),
        cas("bornes nulles -> dernier bouton pleine largeur", CAS_SANS_SURFACE, "Continuer",
            "bas_large", (44, 1978, 1036, 2072), interdit=(0, 0, 1080, 0)),
        cas("bornes franches -> centre direct", CAS_NOMINAL, "Suivant",
            "direct", (44, 2021, 1036, 2072)),
    ]
    total, ok = len(resultats), sum(resultats)
    print(f"\nCIBLAGE : {ok}/{total} PASS")
    return 0 if ok == total else 1


if __name__ == "__main__":
    sys.exit(main())
