# Audit visuel UX/UI — VITRINE VIDÉO RC15 (`d42.30-rc15`)

**Phase A de D42.31 — document d'entrée pour la revue du fondateur.**
Aucune modification produit n'a été faite pour produire ce document.

## Méthodologie (honnête)

- Source : les **193 captures brutes** de la galerie (ÉMULATEUR Android 11 / Pixel 5,
  1080×2340, caméra et flux **ÉMULÉS**), leurs **dumps d'interface** (uiautomator :
  textes, bornes, états cliquables) archivés pendant les runs, et le code source
  exact de RC15.
- L'analyse ci-dessous est **structurelle** (textes, bornes, états, cohérence
  inter-écrans et inter-langues) — pas un jugement pixel par pixel.
  **Le juge visuel final est l'œil du fondateur** : c'est précisément l'objet de
  cette revue. Chaque constat indique la capture concernée et le fichier code.
- Gravités : **P0** bloque la vente · **P1** gêne sérieusement · **P2** gêne ·
  **P3** détail de finition.

---

## Constats produit (constatés sur les captures/dumps, à corriger en Phase B)

### P1-1 · Le catalogue et les gabarits ne sont PAS localisés en anglais
- **Captures** (dont erreur, run v6 — APK RC15 sha256 identique vérifié par le workflow) : `07_catalogue/base-en-012_catalogue_haut.png`,
  `07_catalogue/base-en-013_catalogue_scroll1.png`,
  `09_brief/base-en-017_brief_vide.png` (dumps `_cat_prec.xml`, `_saisie_*.xml`).
- **Constat** : en mode EN, la *chrome* de l'app est en anglais, mais les cartes
  universelles du catalogue et tout le contenu des gabarits restent en français :
  « Le client parle avec ses mots. », « Un client raconte », « 33 s · 17 scenes ·
  2 **prises** », champs du brief « Le prix », « Monnaie \* », « Quartier et
  ville \* », aides « Écris le vrai prix. La monnaie FCFA est choisie par
  défaut. ».
- **Fichiers** : `feature-catalog/.../CatalogScreen.kt` (libellés des cartes),
  `content/gabarits_v2/gabarits/*/*.json` (`champs_saisie[].label`/`aide_simple`
  FR uniquement), `feature-brief` (rendu des champs).
- **Recommandation** : extraire les libellés/aides des 30 gabarits vers des
  ressources `values-en` (clé par gabarit+champ), et localiser les textes des
  cartes (bénéfice, durée/scènes/prises).

### P1-2 · Sélecteur de secteur : « Boutique & Petit Commerce » difficile d'accès
- **Captures** : `06_secteurs/base-fr-017_secteur_change_1.png` à
  `06_secteurs/base-fr-037_secteur_change_6.png` (dumps `secteur_iter6.xml`).
- **Constat** : les filtres de secteur se déplient en un bloc multi-lignes où la
  dernière puce (« 🛒 Boutique & Petit Commerce ») sort de la zone de rendu
  initiale ; le harnais lui-même n'a jamais réussi à l'atteindre en 3 runs
  (swipes horizontaux infructueux). Un commerçant qui veut revenir au secteur
  Commerce après en avoir essayé un autre peut ne pas trouver la puce.
- **Fichier** : `feature-catalog/.../CatalogScreen.kt` (`SectorRow`).
- **Recommandation** : grille verticale repliable (2 colonnes, retour à la ligne
  garanti) ou feuille plein écran ; garantir que les 6 secteurs + « Tous les
  métiers » sont visibles sans geste horizontal.

### P2-1 · Faute de conjugaison dans l'aide du gabarit témoignage
- **Capture** : `20_hors_connexion/offline-fr-022_brief_etape1.png` (dump
  `_verif_brief.xml` : « Écris ses vrais mots. **Tu pouvez** laisser vide. »).
- **Fichier** : `content/gabarits_v2/gabarits/*/T5_temoignage_client.json`
  (`aide_simple` du champ facultatif).
- **Recommandation** : « Tu **peux** laisser vide. » — vérifier toutes les
  `aide_simple` des 30 gabarits (relecture FR puis EN lors de la localisation).

### P2-2 · Libellé de focus du catalogue trompeur + tronqué
- **Captures** : `08_gabarits/base-fr-018_catalogue_secteur1.png`,
  `08_gabarits/base-fr-034_catalogue_secteur5.png` (dump `secteur_iter6.xml`).
- **Constat** : la ligne de focus affiche « **Gabarits adaptés à votre
  commerce** : 🚗🏠 Vente de Voitures & M » — (a) le mot « commerce » est
  générique mais se confond avec le secteur « Boutique & Petit Commerce » ;
  (b) le libellé du secteur est **coupé** (ellipse à « & M ») sans retour à la
  ligne.
- **Fichier** : `feature-catalog/.../CatalogScreen.kt` (`catalog_sector_focus`,
  `strings_catalog.xml`).
- **Recommandation** : « Modèles pour : 🚗🏠 Vente de Voitures & Maisons » avec
  retour à la ligne (2 lignes autorisées).

### P2-3 · Acccessibilité : bouton « Continuer » du brief à bornes nulles
- **Capture** : `20_hors_connexion/offline-fr-022_brief_etape1.png` (dump `_verif_brief.xml` : nœud « Continuer »
  `[0,0][0,0]`, `clickable=false` exposé).
- **Constat** : le bouton Compose expose des bornes dégénérées — les outils
  d'accessibilité (et le harnais) ne le localisent pas. Sans impact visuel
  direct, mais signe d'une sémantique à assainir.
- **Fichier** : `feature-brief/.../GabaritBriefScreen.kt` (bouton d'action).
- **Recommandation** : `Modifier.semantics { }` explicites sur le bouton.

### P3-1 · Chaîne sans accents (« Droits non synchronises : mode par defaut prudent. »)
- **Capture** : `17_historique/base-fr-062_dashboard.png` (en-tête COMPTE du
  dashboard).
- **Fichier** : `feature-dashboard/src/main/res/values/strings_dashboard.xml`
  (`dash_rights_default`).
- **Recommandation** : rétablir les accents (« synchronisés », « par défaut »).

### P3-2 · E7 : l'en-tête peut défiler hors écran sans repère
- **Captures** : `15_montage/base-en-037_apercu.png` (+ captures ciblées FR).
- **Constat** : le titre « Aperçu de ta vidéo » et le badge défilent avec le
  contenu ; en bas de page, l'utilisateur perd le contexte d'écran.
- **Fichier** : `feature-export/.../VideoPreviewScreen.kt`.
- **Recommandation** : en-tête épinglé (comme la barre d'action du sélecteur de
  secteur, qui est un bon exemple).

---

## Points positifs constatés (à préserver)

- **Barre d'action épinglée** du sélecteur secteur (bouton 56 dp, toujours
  visible — y compris police 130 % : `06_secteurs/font130-fr-008_secteurs.png`).
- **États d'erreur clairs et pédagogiques** : numéro invalide (9 chiffres) et
  prix non numérique expliqués en langage commerçant
  (`10_formulaires/base-fr-041_brief_erreur_whatsapp.png`).
- **Porte R4 (consentement)** visible en continu pendant le tournage :
  « Visages détectés : 0 · porte R4 : cadre libre »
  (`12_camera/.../camera_preview*.png`) — conformité lisible.
- **Export en service de premier plan** : notification « Export en cours… »,
  survie à l'écran éteint (`16_export/base-fr-059_export_notification.png`,
  `16_export/base-fr-060_export_apres_ecran_etaint.png`).
- **Hors connexion assumé** : bandeau explicite sur le catalogue, repli local
  honnête (`20_hors_connexion/offline-fr-012_catalogue_haut.png`).
- **Petit écran 720×1520** : parcours complet jusqu'au brief sans débordement
  bloquant (`07_catalogue/petit-fr-*`), idem police 130 %.

## Limites de la capture (honnêteté de la galerie)

1. **Feuille de partage Android + état « Vidéo prête ! »** : non capturés —
   l'export sur l'émulateur (rendu logiciel swiftshader 1080p, BGM + voix)
   dépasse 95 minutes. Processus vivant et silencieux (D42-TRACE beatsheet,
   JIT actif) : lent, pas bloqué. **À vérifier sur appareil réel** (GPU réel :
   quelques minutes attendues).
2. **Profil offline** : le harnais ne valide pas le gabarit témoignage
   multi-champs (champ non remplissable par automatisation — les mêmes écrans
   existent en base). Limite harnais, PAS produit.
3. **Trois modes audio** : il n'existe **pas de sélecteur de mode audio dans
   l'UI** de RC15 (mode automatique rushs/BGM — cf. `14_audio/`). Les modes
   voix/mix/musique sont validés par les campagnes p3-modes (28/0/0, 28/0/0,
   27/0/0), pas par des écrans.

---

*Phase A — à ce stade, AUCUNE correction n'a été appliquée. La Phase B
regroupera les corrections après les observations du fondateur (lisible en
premier : P1-1 et P1-2, puis P2, puis P3). RC15 reste immuable.*
