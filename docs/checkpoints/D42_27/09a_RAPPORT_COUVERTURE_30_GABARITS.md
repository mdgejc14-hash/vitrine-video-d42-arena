# D42.27-09a — RAPPORT DE COUVERTURE DES 30 GABARITS (§5, audit H)

**Source** : `tools/e2e/audit_gabarits.py` exécuté sur le lot régénéré
(D42.27-06, manifeste 119/119 conforme) — **818 contrôles PASS, 0 FAIL,
0 WARN**. Détail par gabarit : `artefacts/couverture_30_gabarits.csv`
(30 lignes : contrôles pass/fail/warn par gabarit).

## 1. Périmètre par gabarit (identique pour les 30)

Chaque gabarit est audité sur les familles de contrôles suivantes (toutes
PASS pour les 30 × 5 formats × 6 secteurs) :

| Famille | Contrôles |
|---|---|
| Identité | `identite` (id/secteur/format/fichier), `secteur_libelle`, `nom_format_affiche` |
| Contenu métier | `copywriting`, `notes_adaptation`, `montage_signature`, `etalonnage`, `style_visuel`, `signature_montage`, `axes_signature`, `interface_commercant` |
| Formulaire | `formulaire_ui` (champs, types, contrat), `champs_uniques` |
| Structure de montage | `nombre_scenes` (déclaré = réel), `ordre_sequences` (1..N séquentiel), `structure_montage` (étapes horodatées temps_s/action), `duree_coherente` (déclarée = somme des scènes) |
| Format | `ratio` 9:16 |
| Catalogue | `catalogue/<secteur>` (T1..T5 complets), `catalogue/completude` (30/30) |
| Intégrité du lot | `manifeste/integrite` (119 entrées conformes — PASS depuis D42.27-06, WARN avant) |

## 2. Synthèse chiffrée

- 30/30 gabarits audités, 6 secteurs × 5 formats (T1–T5).
- 818 contrôles au total, 0 FAIL, 0 WARN/BLOCKED (avant D42.27-06 :
  817 PASS + 1 WARN manifeste).
- Le contrôle croisé audio : chaque gabarit a 20 variations musicales
  (voir 09b).

## 3. Historique des corrections incluses dans l'état audité

- 170ad89 : 8 accroches T2 raccourcies (immo_auto, shops_small_business) —
  120/120 OK_STATIQUE, valideurs 0 anomalie (la divergence manifeste
  correspondante est désormais reflétée par le manifeste régénéré).
- D42.27-06 : manifeste SHA régénéré (119/119) — l'audit intégrité repasse
  PASS sans toucher aux contenus.

**Conclusion H** : couverture intégrale des 30 gabarits, toutes familles de
contrôles PASS, preuve reproductible (`audit_gabarits.py` + CSV joint).
