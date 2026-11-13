# Audit visuel UX/UI — VITRINE VIDÉO RC15 (`d42.30-rc15`)

**Phase A de D42.31 + correction IMAGE-FIX — document d'entrée pour la revue
du fondateur.** Aucune modification produit n'a été faite pour produire ce
document.

## Méthodologie (honnête)

- Source : les **captures brutes valides** de la galerie (ÉMULATEUR Android 11 /
  Pixel 5, 1080×2340, caméra et flux **ÉMULÉS**), leurs **dumps d'interface**
  (uiautomator : textes, bornes, états cliquables) archivés pendant les runs,
  et le code source exact de RC15. Les fichiers **vides** (artefact de capture,
  cf. diagnostic ci-dessous) sont conservés dans le dépôt et listés en annexe
  du README — jamais présentés comme captures.
- L'analyse ci-dessous est **structurelle** (textes, bornes, états, cohérence
  inter-écrans et inter-langues) — pas un jugement pixel par pixel.
  **Le juge visuel final est l'œil du fondateur** : c'est précisément l'objet
  de cette revue. Chaque constat indique la capture concernée et le fichier code.
- Gravités : **P0** bloque la vente · **P1** gêne sérieusement · **P2** gêne ·
  **P3** détail de finition.

## Diagnostic des captures (correction IMAGE-FIX)

Le fondateur a signalé trois problèmes de présentation. Diagnostic différentiel
complet, preuves à l'appui :

1. **Vignettes non chargées dans le rendu GitHub** — la Phase A utilisait des
   balises HTML `<a><img src="chemin relatif">`. Correction : vignettes
   Markdown `[![description](URL_raw_épinglée_au_commit)](URL_blob)` — la
   miniature s'affiche dans le rendu GitHub, le clic ouvre l'original.
2. **« Mosaïque » du viseur caméra** — l'artefact provient de la commande
   `screencap` lisant le SurfaceView (PreviewView) sous le rendu logiciel
   swiftshader : bandes uniformes. **Le flux CameraX et l'enregistrement sont
   sains** — preuve : les frames du MP4 exporté (run p1-official 43168986328,
   APK RC15 exacte, sha256 vérifié) sont riches et détaillées, et l'export
   réussit. Correctif : captures **screenrecord** (sortie composée
   SurfaceFlinger réelle) du run `camerafix` 43395637118 (artefact
   14029646676) : `camera_preview`, `camera_rec`, `camera_avant`,
   `camera_arriere`, `camera_refaire`. Les anciennes captures affectées sont
   archivées dans `12_camera/archives-motif-screencap/` et
   `13_prises/archives-motif-screencap/` à titre de diagnostic — aucune n'est
   présentée comme preuve du rendu réel. **Caméra ÉMULÉE**, jamais présentée
   comme capteur physique.
3. **Écrans E7 / E8 / « Vidéo prête ! » : NON CAPTURABLES PAR CONCEPTION
   PRODUIT** — `ExportActivity` — qui héberge l'aperçu E7, l'écran d'export
   E8 **et** l'état « Vidéo prête ! » — active **`FLAG_SECURE`**
   (`ExportActivity.kt` : « Recents bloqués (FLAG_SECURE). Limite assumée :
   caméra physique. »). Conséquences mesurées :
   - `screencap` y renvoie un fichier de **0 octet** — constaté sur 5 runs
     indépendants (v8 base-fr 057-067, v8 base-en 037-049, p1-official 26-30,
     lab p1-debug, lab offline-export, cible 035-036) ;
   - `screenrecord` y renvoie un cadre **noir** — prouvé par le run exportfix
     43412790349 : les captures screenrecord de l'écran d'export sont noires
     (niveau moyen 1/255) tandis que, **au même moment**, la capture du tiroir
     de notifications (UI système, non protégée) est riche (117 Ko) et les
     `screencap` de diagnostic simultanés sont vides — preuve différentielle
     triple que la cause est la protection d'écran, pas le harnais.
   - **Preuves réelles du comportement** : dumps uiautomator (« Export local
     en cours… », « Vidéo prête ! Partage-la avec tes clients. » —
     l'accessibilité n'est pas bloquée par FLAG_SECURE), **MP4 exporté réel**
     (p1-official : export-0.mp4 5 565 078 o, h264 1920×1080, 35,05 s,
     `P1_export_termine` PASS ×3 runs), feuille de partage réellement ouverte
     (`P1_partage` PASS ×3 : Share / export-0.mp4 / Bluetooth / Messaging).
   - **Ce qui reste capturable (et désormais capturé)** : le tiroir de
     notifications pendant l'export (UI système — screenrecord :
     `16_export/exportfix-fr-038_export_notification.png` et
     `16_export/suite-fr-025_export_notification.png`), la **feuille de
     partage** (UI système — `18_partage/suite-fr-026_partage_feuille.png`),
     le **tableau de bord** (`17_historique/suite-fr-027_dashboard.png`,
     `029_dashboard_bas.png`), le **profil** (`19_profil/suite-fr-028_profil_dashboard.png`)
     et le **parrainage** (`04_parrainage/suite-fr-030_dashboard_parrainage.png`)
     — run suite v11d 43465731951, export réel terminé (~29 min de run,
     MP4 5,8 Mo h264+AAC 35 s tiré en preuve, dump « Vidéo prête ! »).
4. **6 captures « dashboard/paywall » du run offline v8 non retenues** — les
   intents shell étaient refusés (Permission Denial — `DashboardActivity`
   `android:exported="false"`) et l'écran réellement capturé n'était pas le
   dashboard. Ces fichiers restent dans le dépôt, listés en annexe du README,
   sans être présentés comme captures.
5. **Pourquoi aucun run galerie n'avait d'export — porte `DENY_INTEGRITY` (RCA
   définitive)** — dans TOUS les runs galerie v6→v11b, l'export n'a **jamais
   démarré** : 0 ligne codec (CCodec/MediaCodec/VideoEncoder) après le tap
   « LANCER L'EXPORT LOCAL » (l'activité codec des logcats provient
   exclusivement de la phase caméra). Les dumps du run suite 43428876674
   capturent le verdict : « Vérification de sécurité échouée. Réinstallez
   l'application officielle. » — `IntegrityGuard.tamperHints()` voit
   `/system/xbin/su`, présent sur l'image système AOSP `default` des
   émulateurs CI (artefact d'image de développement, absent des appareils
   clients de production). La porte `ExportGate` refuse donc tout enqueue.
   Le harnais p1 (`run_official_e2e.sh`, D42.17) prépare un « appareil
   client propre » : bind-mount d'un répertoire vide sur `/system/xbin` —
   le contrôle de **certificat** reste pleinement actif, IntegrityGuard
   n'est ni modifié ni contourné. C'est ce que fait désormais le harnais
   galerie (v11c, commit 47821ea). Une fois la porte passée, l'export réel
   prend ~14 min (p1-official ×3 : MP4 5,5 Mo, 35 s, h264 1920×1080).

Aucune image n'a été fabriquée, retouchée ou substituée à un quelconque moment.

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

### P2-3 · Accessibilité : bouton « Continuer » du brief à bornes nulles
- **Capture** : `20_hors_connexion/offline-fr-022_brief_etape1.png` (dump `_verif_brief.xml` : nœud « Continuer »
  `[0,0][0,0]`, `clickable=false` exposé).
- **Constat** : le bouton Compose expose des bornes dégénérées — les outils
  d'accessibilité (et le harnais) ne le localisent pas. Sans impact visuel
  direct, mais signe d'une sémantique à assainir.
- **Fichier** : `feature-brief/.../GabaritBriefScreen.kt` (bouton d'action).
- **Recommandation** : `Modifier.semantics { }` explicites sur le bouton.

### P3-3 · Écran « Réglages » du dashboard difficile d'accès
- **Preuve** : runs suite v11e→v11i (dumps `_dashboard.xml`) — le bouton
  « Réglages » (OutlinedButton textuel, bas du dashboard,
  `DashboardScreens.kt:61`) n'a jamais été exposé dans un dump uiautomator
  au sommet, et n'a été atteint par le harnais après 5 défilements.
- **Constat** : l'entrée réglages est reléguée très bas dans une longue
  page ; combiné à l'absence de libellé accessible au sommet (aucun
  content-desc), un utilisateur dépendant d'accessibilité ne la trouve pas.
- **Fichier** : `feature-dashboard/.../DashboardScreens.kt`.
- **Recommandation** : bouton icône ⚙ dans l'en-tête avec
  `contentDescription` explicite, ou onglets.

### P3-4 · Paywall : « aucun paiement necessaire » sans accents
- **Capture** : `05_credits/suite-fr-030_paywall.png` (dump `_paywall.xml` :
  « Il vous reste 2 exports offerts : aucun paiement necessaire. »).
- **Fichier** : `feature-billing`/`strings_billing.xml`.
- **Recommandation** : rétablir les accents (« nécessaire »).

### P3-1 · Chaîne sans accents (« Droits non synchronises : mode par defaut prudent. »)
- **Capture** : `17_historique/suite-fr-027_dashboard.png` (en-tête COMPTE du
  tableau de bord, screenrecord du run suite v11d 43465731951). Constat
  également présent dans les dumps des campagnes D42.30 ; l'ancienne référence
  (`base-fr-062_dashboard.png`) était un fichier vide (cf. diagnostic).
- **Fichier** : `feature-dashboard/src/main/res/values/strings_dashboard.xml`
  (`dash_rights_default`).
- **Recommandation** : rétablir les accents (« synchronisés », « par défaut »).

### P3-2 · E7 : l'en-tête peut défiler hors écran sans repère
- **Preuve** : dumps uiautomator des runs (titre « Aperçu de ta vidéo » et
  badge absents du bas de page après défilement — constat structurel) ;
  l'écran E7 étant sous **FLAG_SECURE**, aucune image n'est présentée
  (cf. diagnostic, réserve documentée).
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
  (`12_camera/camerafix-fr-025_camera_preview.png` — screenrecord) —
  conformité lisible.
- **Export en service de premier plan** : notification du canal `vv_export`
  (dumpsys `P1_notif_fgs` PASS ×3), survie à 45 s d'écran éteint
  (`P1_ecran_etaint` PASS ×3), tiroir de notifications capturé pendant
  l'export (`16_export/exportfix-fr-038_export_notification.png`).
- **Protection anti-capture assumée** : `FLAG_SECURE` sur les écrans
  vidéo/export — les contenus du commerçant n'apparaissent ni dans les
  captures d'écran système ni dans les « recents » (choix produit documenté
  dans le code).
- **Hors connexion assumé** : bandeau explicite sur le catalogue, repli local
  honnête (`20_hors_connexion/offline-fr-012_catalogue_haut.png`).
- **Petit écran 720×1520** : parcours complet jusqu'au brief sans débordement
  bloquant (`07_catalogue/petit-fr-*`), idem police 130 %.

## Limites de la capture (honnêteté de la galerie)

1. **Écrans E7 / E8 / « Vidéo prête ! » : aucune image, PAR CONCEPTION** —
   `FLAG_SECURE` (cf. diagnostic n°3). Preuves : dumps uiautomator (texte
   intégral), MP4 exporté réel, results p1 ×3. Ces écrans sont listés en
   **réserve explicite** dans les sections 14/15/16 du README — jamais
   prétendus capturés. Si le fondateur souhaite des captures de ces écrans,
   cela requiert une décision produit (build sans FLAG_SECURE) — hors périmètre
   Phase A.
2. **Fichiers vides conservés (annexe README)** : 27 fichiers de 0 octet des
   campagnes v8/v9/cible (écrans export, dashboard, aperçu) — artefact
   `screencap` documenté ci-dessus. Gaps restants après le run suite v11i : E7 (aperçu) et « Vidéo prête ! »
   (FLAG_SECURE — dumps + MP4 en preuve) + **réglages** (bouton
   `DashboardScreens.kt:61` non atteint après 5 défilements — constat UX).
   Le **paywall est capturé** : `05_credits/suite-fr-030_paywall.png` +
   `031_paywall_bas.png` (screenrecord) — contenu réel : « Choisissez votre
   formule », « Pass 24 h · 500 FCFA », « Pro · 3 000 FCFA / 30 j »,
   « Payer avec Mobile Money » (dump `_paywall.xml`).
3. **Profil offline** : le harnais ne valide pas le gabarit témoignage
   multi-champs (champ non remplissable par automatisation — les mêmes écrans
   existent en base). Limite harnais, PAS produit. Vérification/caméra/E7/
   export non parcourus hors connexion (couverts par base + runs ciblés).
4. **Trois modes audio** : il n'existe **pas de sélecteur de mode audio dans
   l'UI** de RC15 (mode automatique rushs/BGM). Les modes voix/mix/musique
   sont validés par les campagnes p3-modes (28/0/0, 28/0/0, 27/0/0), pas par
   des écrans.
5. **6 captures offline non retenues** (intents refusés, mauvais écran) —
   conservées en annexe, non présentées.
6. **Vitesse d'export** : ~14 min sur l'émulateur CI une fois la porte
   passée (p1 ×3) ; appareil réel (GPU matériel) attendu nettement plus
   rapide. Les attentes de 95/180 min des runs v7-v11b documentaient un
   export qui n'avait jamais démarré (porte), pas une lenteur réelle.

---

*Phase A + IMAGE-FIX — à ce stade, AUCUNE correction produit n'a été appliquée.
La Phase B regroupera les corrections après les observations du fondateur
(lisible en premier : P1-1 et P1-2, puis P2, puis P3). RC15 reste immuable.*
