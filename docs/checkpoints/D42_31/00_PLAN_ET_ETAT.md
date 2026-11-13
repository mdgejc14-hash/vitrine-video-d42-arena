# D42.31 — Plan et état : galerie visuelle intégrale, revue UX/UI fondateur, livraison commerciale

## Mission

**Phase A (TERMINÉE)** : galerie visuelle EXACTE de RC15 produite, auditée,
poussée sur GitHub — le fondateur peut désormais examiner l'application écran
par écran sans APK. **On attend ses observations.**
**Phase B (VERROUILLÉE jusqu'au retour du fondateur)** : corrections
regroupées, galerie de révision, non-régression, puis RC16.

## Règles de la mission (respectées)

- RC15 **IMMUTABLE** — release 442574529, asset 738360276, tag `d42.30-rc15`,
  SHA-256 `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936`
  (vérifié par le workflow AVANT chaque capture ; APK re-téléchargée de la
  release à chaque run).
- **Aucune modification produit en Phase A** : seuls des outils de capture
  (`tools/e2e/run_gallery.sh` v1→v9), workflows et documents ont été commités.
- Captures brutes, non retouchées ; données 100 % fictives (RobeWax,
  0197000000, 15 000 FCFA, Akpakba, BoutiqueAwa) ; caméra **ÉMULÉE**
  identifiée comme telle partout.
- Aucun PASS fabriqué : chaque écran manquant = gap documenté (runs/gaps.txt).
- FR/EN uniquement ; budget 0 FCFA ; CinetPay reporté ; GitOps intégral.

## Chronologie complète Phase A (v1 → v9)

| v | Commit | Run | Diagnostic du run précédent → correctifs | Résultat |
|---|---|---|---|---|
| 1 | c910663 | 43225168935 | (initial : harnais v1 écrit) | annulé au timeout global 150 min (2 jobs séquentiels, variantes en parcours complet, attente export 95 min sans export lancé) ; artefacts partiels récupérés |
| 2 | a6d2458 | 43252461478 | v1 : tap du bouton Google déraillait le parcours (feuille système) ; libellés de champs FR-only en EN ; gabarit tapé après les scrolls ; 4 jobs parallèles | 4/4 SUCCESS — FR base déraillé (BACK de secours), EN bloqué au catalogue, offline jusqu'au brief, variantes OK |
| 3 | 6f8df31 | 43257462315 | v2 : taps par visibilité ; cartes EN réellement en FR (défaut i18n) ; BACK de secours interdit | 4/4 SUCCESS — EN jusqu'à la permission caméra puis brief rouvert (refus → brouillon) |
| 4 | 4f3ab61 | (combiné au run v3) | v3 : après refus de permission, re-validation nécessaire (Continuer → vérification → OK) | (v4 poussée pendant le run v3) |
| 5 | e3c2a06 | 43263211628 | v3/v4 : émulateur lancé SANS caméra (« Caméra indisponible ») → `-camera-back emulated` ; chips secteurs = bloc multi-lignes (toggle inline D42.30) ; sélection gabarit une-passe ; captures « brief » du petit mal étiquetées → GABARIT_OK gate | 4/4 SUCCESS — base-fr 53 captures (secteurs 1-5, brief, vérification, permission complète, caméra), EN/offline camera OK mais boutons = TEXTES |
| 6 | 322d6ef | 43267368915 | v5 : contrôles caméra = boutons texte (« VERROUILLER ET ENREGISTRER », « CHANGER DE CAMÉRA », « REFAIRE », « SUIVANT ») ; chips à 44 % de hauteur ; motif « Un » tapait le titre | 4/4 SUCCESS — base-fr 61, base-en 41 (E7 atteint en EN, export lancé partout), petit réparé ; export > 25 min |
| 7 | 42187f6 | 43276442451 | v6 : export = 75-95 min (mesures p1 D42.28/30) → fenêtre 95 min + jobs 165 min ; brief MULTI-ÉTAPES ; capture E7 tardive | 4/4 SUCCESS — base-en 44 (export 95 min honnête, état final capturé) ; offline : « Continuer » à bornes dégénérées [0,0][0,0] + numéro dans le champ prix (indices périmés) |
| 8 | e676b43 | 43297663610 | v7 : remplir_par_label (jamais d'indice périmé) ; Continuer avec repli ui.py ; DASHBOARD via action intents (VIEW_DASHBOARD/VIEW_PAYWALL + extra view) ; preuve notif FGS | 4/4 SUCCESS — base-fr 67, base-en 49, offline 36 (dashboard/parrainage/réglages/paywall capturés partout), variantes 41 ; E7 FR manquant (titre défilé hors fenêtre) ; lab non-régression 43296453641 14/14 |
| 9 | 2141624 | 43377894216 | v8 : E7 FR était ATTEINT (dump _e7_tardif) mais titre défilé → attente multi-marqueurs (e7_check) + profil « cible » (parcours direct, sans export) | capture ciblée E7 FR |

Artefacts v8 : 13989060859 (base-fr, 67 PNG) · 13987054901 (base-en, 49) ·
13982520514 (offline, 36) · 13979999516 (variants, 41) — 193 captures brutes.

## Galerie permanente

`docs/checkpoints/D42_31/visual-review/` : 20 dossiers numérotés (01_accueil →
20_hors_connexion) + `README.md` (galerie cliquable, vignettes + taille
réelle) + `SCREEN_INVENTORY.csv` (193 lignes) + `GABARITS_INVENTAIRE.csv`
(30 gabarits → captures par secteur) + `UX_AUDIT.md` (constats P0-P3 avec
captures et fichiers code) + `runs/` (manifests + gaps par run).

## Couverture réelle (honnête)

- Parcours commercial complet FR + EN : splash, langue, auth, carrousel,
  secteurs, parrainage, crédits, catalogue (6 secteurs : Commerce initial +
  Mode/Coiffure/Restauration/BTP/Immo-Auto par itérations), brief (vide,
  clavier, rempli, erreurs, étapes), vérification, permission (dialogue/refus/
  rationale/octroi), caméra (guide, viseur, countdown, REC, arrêt, bascules,
  refaire, scène 2), E7 aperçu (EN v8 + FR cible v9), export (prêt, en cours,
  notification, écran éteint, état final), dashboard/parrainage/réglages/
  paywall (intents), hors connexion (36 captures).
- Variantes : police 130 % (21), petit écran 720×1520 (20).
- **Non capturés (documentés)** : feuille de partage Android + « Vidéo
  prête ! » (export > 95 min sur swiftshader — à vérifier sur appareil réel) ;
  profil offline : vérification/camera/E7/export (limite harnais sur le
  gabarit témoignage multi-champs — écrans couverts par base).
- 30 gabarits : tous dans leurs captures de catalogue sectoriel
  (GABARITS_INVENTAIRE.csv) ; titres dump-vérifiés : « Promotion » (T4) et
  « Un client raconte » (T5).

## Constats produit majeurs (détail dans UX_AUDIT.md)

P1 : catalogue/gabarits non localisés EN ; chip « Boutique & Petit Commerce »
difficile d'accès. P2 : « Tu pouvez » (faute) ; libellé focus tronqué ;
bouton Continuer à bornes nulles (accessibilité). P3 : accents manquants
dashboard ; en-tête E7 non épinglé.

## Prochaine étape

**ARRÊT À LA PORTE DE VALIDATION VISUELLE** : le fondateur examine la galerie
et rend ses observations (écran accepté/à corriger, texte, bouton, couleur,
gabarit). La Phase B ne commence qu'après son accord. Pas de RC16 avant.
