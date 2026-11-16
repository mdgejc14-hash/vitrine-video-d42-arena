# CHECKPOINT D42.34 — DOSSIER TECHNIQUE 20 GABARITS (4 SECTEURS)

**Statut : TERMINÉ ET LIVRÉ** — 17/11/2026.
**Source analysée : commit `85655e3`** (branche `d42.34-founder-acceptance-fixes`, miroir). Lecture seule stricte : aucun code/JSON/template/composition audio/ressource modifié sur ce dépôt.

## Livraison (dépôt PRIVÉ `mdgejc14-hash/vitrine-video`)

- Branche dédiée : **`founder-four-sector-template-specs`** @ **`c8b6297342463ff66d41b004ace5cbde0f870df4`** (branche orpheline, 3 fichiers, zéro secret).
- Chemin : `deliveries/D42.34/four-sector-specifications/`
  — `VITRINE_VIDEO_D42_34_4_SECTEURS_20_GABARITS.zip` (611 133 octets)
  — `ZIP_SHA256.txt` — `README_DOSSIER.md` (3 497 octets).
- SHA-256 du ZIP : `d13447d79ab7fd362b5f80e84c07c4a13b2578d581c2e5f8a779b0ecd5c2db55`.
- Vérifications distantes TOUTES PASS : branche API 200 @ c8b6297 ; ZIP raw HTTP 200 / 611 133 octets / SHA exact / `cmp` octet/octet IDENTIQUE / `unzip -t` sans erreur ; README et ZIP_SHA256.txt HTTP 200 ; `main` (`5710befd…`) et `founder-delivery-d42-34` (`b85c193…`) inchangées avant/après.

## Comptes exacts des 7 phases (toutes franchies)

1. **Inventaire 4 secteurs** — assets = 6 secteurs ; 4 cibles (`restaurants_maquis`, `coiffure_beaute`, `vetements_mode`, `shops_small_business`) × T1–T5 = **20/20 gabarits présents** ; 20/20 aperçus `drawable-nodpi/apercu_*.webp` localisés (aucun 5e secteur).
2. **Extraction 20 JSON** — 20/20 extraits et copiés octet/octet (`DONNEES_SOURCE.json`) ; comparaison assets vs `content/gabarits_v2/` : **19/20 identiques octet/octet**, 1 divergence documentée sans modification (`restaurants_maquis/T1`, scènes 12-13 : `{nom_offre}`/`CONTACTEZ-NOUS` embarqué vs « À RETENIR »/« À DÉCOUVRIR » en autoring) ; chargement réel retracé : `GabaritRepository.kt` seed les ASSETS (canoniques) → Room.
3. **Analyse 20 montages** — 20/20 chronologies complètes (|Temps|Scène|Source|Montage|Texte|Audio|) ; moteur retracé (`GabaritBeatSheet.kt` l. citées) : subdivision 1,5 s, in-points séquentiels + repli cyclique, cartes générées (`decoupage_prises` `carte:*`), matrices zoom/transitions, badge E5, substitution `{prix}` groupé/`{pourcentage}` calculé, SFX débuts de scène, ducking −14 dB. **Distinction prises↔scènes tenue partout** (3 prises → 13–17 scènes selon gabarit).
4. **Parcours + textes** — 7 écrans par gabarit (catalogue→E4→E4b→E6→E7→E8→partage) avec chaînes réelles ; **141 clés UI** extraites FR/EN des 15 fichiers `values*/strings*.xml` → `MATRICE_TEXTES_AFFICHES.csv` = **2 740 lignes** ; textes dynamiques des 20 JSON listés verbatim.
5. **Matrices tests** — `MATRICE_TESTS_COMPLETE.csv` = **560 lignes (20 × 28)** : **389 COMPLET · 171 NON PROUVÉ · 0 CASSÉ** ; seuls parcours e2e bout-en-bout prouvés : `shops_small_business_T1` (bancs P1/camerap/offline-export du lab 43904729372) ; 19 autres gabarits : 9 lignes NON PROUVÉ chacun (parcours UI dédié non exécuté), 19 lignes COMPLET via tests itérant les 30 gabarits (kernel v3.5 : 383 JVM/0 échec).
6. **Génération ZIP** — 147 fichiers (7 racine + 20 × 7), 611 133 octets, INDEX_GABARITS.html hors-ligne (liens relatifs), CSV intégrés, intégrité `unzip -t` OK.
7. **Vérification ZIP distant** — PASS (voir « Livraison » ci-dessus).

## Reproduction locale

Générateur conservé : `~/gen_dossier.py` (workspace Arena) ; sortie locale : `~/dossier_build/VITRINE_VIDEO_D42_34_4_SECTEURS_20_GABARITS/` (147 fichiers).

**Prochaine reprise éventuelle : néant — mission livrée.** En cas de demande de mise à jour : régénérer depuis le SHA voulu via `gen_dossier.py`, re-zipper, re-vérifier SHA+cmp, pousser sur la même branche dédiée (jamais main).
