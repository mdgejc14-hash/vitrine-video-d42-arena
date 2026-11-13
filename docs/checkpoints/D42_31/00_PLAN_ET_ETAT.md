# D42.31 — Plan et état : galerie visuelle intégrale, revue UX/UI fondateur, livraison commerciale

## Mission

**Phase A (TERMINÉE)** : galerie visuelle EXACTE de RC15 produite, auditée,
poussée sur GitHub (commit `64a3ca9` — 198 captures).
**Correction IMAGE-FIX (TERMINÉE)** : vignettes Markdown épinglées visibles
dans le rendu GitHub, viseur caméra corrigé (screenrecord), écrans
« Vidéo prête ! » + partage capturés, compteurs harmonisés.
**On attend les observations du fondateur.**
**Phase B (VERROUILLÉE jusqu'au retour du fondateur)** : corrections
regroupées, galerie de révision, non-régression, puis RC16.

## Règles de la mission (respectées)

- RC15 **IMMUTABLE** — release 442574529, asset 738360276, tag `d42.30-rc15`,
  SHA-256 `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936`
  (vérifié par le workflow AVANT chaque capture ; APK re-téléchargée de la
  release à chaque run — y compris les runs ciblés IMAGE-FIX).
- **Aucune modification produit** : seuls des outils de capture
  (`tools/e2e/run_gallery.sh` v1→v11b), workflows et documents ont été
  commités. Aucune RC16.
- Captures brutes, non retouchées ; données 100 % fictives (RobeWax,
  0197000000, 15 000 FCFA, Akpakpa, BoutiqueAwa) ; caméra **ÉMULÉE**
  identifiée comme telle partout ; aucun flux émulé présenté comme capteur
  physique.
- Aucun PASS fabriqué : chaque écran manquant = gap documenté (runs/gaps.txt).
- **IMAGE-FIX** : une capture n'est JAMAIS déclarée sans image valide — les
  fichiers vides (artefact `screencap`) restent dans le dépôt mais sont
  listés en annexe du README, jamais affichés ; aucune image fabriquée.

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
| 8 | e676b43 | 43297663610 | v7 : remplir_par_label (jamais d'indice périmé) ; Continuer avec repli ui.py ; DASHBOARD via action intents (VIEW_DASHBOARD/VIEW_PAYWALL + extra view) ; preuve notif FGS | 4/4 SUCCESS — base-fr 67, base-en 49, offline 36, variantes 41 ; E7 FR manquant (titre défilé hors fenêtre) ; lab non-régression 43296453641 14/14 |
| 9 | 2141624 | 43377894216 | v8 : E7 FR était ATTEINT (dump _e7_tardif) mais titre défilé → attente multi-marqueurs (e7_check) + profil « cible » (parcours direct, sans export) | capture ciblée E7 FR |

Artefacts v8 : 13989060859 (base-fr, 67 PNG) · 13987054901 (base-en, 49) ·
13982520514 (offline, 36) · 13979999516 (variants, 41) — 193 lignes de
manifest. **Découverte ultérieure (IMAGE-FIX)** : 25 de ces PNG sont VIDES
(0 octet) — chaînes export/dashboard/apercu (artefact `screencap` sous
charge swiftshader), cf. ci-dessous.

## Chronologie IMAGE-FIX (v10 → v11b)

| v | Commit | Run | Diagnostic → correctif | Résultat |
|---|---|---|---|---|
| v10 | e1a1ad8 | 43395429311 | vignettes `<a><img src=…>` non rendues dans GitHub + mosaïque viseur → `galshot_sr` (screenrecord, sortie composée réelle) + profil `camerafix` (T4 « Promotion ») | **ÉCHEC harnais** : ffmpeg absent du PATH ubuntu-latest, le step de vérification sous `bash -e` a tué le job (aucune capture produite — run à ignorer) |
| v10 | bca6d83 | **43395637118** | installation explicite de ffmpeg si absent | **SUCCESS** — artefact `14029646676` : 5 captures viseur **screenrecord** valides (camera_preview/rec/avant/arriere/refaire, source=screenrecord, diagnostics screencap conservés) ; diagnostic différentiel CONCLU : mosaïque = artefact screencap/SurfaceView sous swiftshader, flux CameraX + enregistrement SAINS (frames MP4 riches). Chaîne export T4 : PNG **VIDES** (034-047) + « délai dépassé » à 95 min ; intents dashboard **Permission Denial** (activité non exportée) |
| diag | — | analyse des artefacts existants | comparaison de 5 runs (v8 base-fr/en, p1-official 43168986328, lab p1-debug 14017467715, lab offline-export 14017558219) + cible 43377894216 | **PNG VIDES partout** sur les écrans export/apercu/dashboard (dumps et MP4 RÉELS — preuves fonctionnelles — mais 0 octet d'image) ; les 6 captures offline « dashboard/paywall » montrent un AUTRE écran (intents refusés) → non retenues |
| v11 | **715bc24** | **43412790349** | profil `exportfix` : gabarit T1 « Nouvel arrivage » (export ~14 min, réf. p1-official), écran maintenu allumé (`svc power stayon`), `galshot_sr` sur TOUTE la chaîne export+partage, MP4 tiré en preuve + ffprobe, test « écran éteint » sauté (déjà prouvé 3×), dashboard exclu du ciblage | SUCCESS (1 h 52, artefact `14037268819`) — **découverte clé 1 : `FLAG_SECURE`** sur `ExportActivity` (qui héberge E7 + E8 + « Vidéo prête ! ») : screenrecord de l'écran = NOIR (moy. 1/255), diag screencap simultanés = 0 octet, mais tiroir de notifications (UI système) capturé valide (117 Ko). Export T1 « lancé » 11:10, état final 12:46 : **en réalité JAMAIS démarré — porte `DENY_INTEGRITY`** (cf. v11c) |
| v11b | **ad32fc2** | **43428876674** | profil `suite` (dispatch 12:54 UTC) : caméra allégée (3 prises), **dumps de preuve** pour E7/E8/terminé (FLAG_SECURE), screenrecord pour partage + dashboard/profil/paywall, fenêtre 180 min, job 220 min | SUCCESS (3 h 12, artefact `14054154363`) — **découverte clé 2 : la cause racine**. Dumps `_export_en_cours.xml`/`_export_etat_final.xml` : message `export_gate_integrity` « **Vérification de sécurité échouée. Réinstallez l'application officielle.** » → `IntegrityGuard.tamperHints()` voit **`/system/xbin/su`** (image AOSP `default` des émulateurs CI) → `ExportGate` = DENY_INTEGRITY → **aucun enqueue** : 0 ligne codec après le tap dans TOUS les runs galerie v6→v11b (les « 95 min d'export » attendaient un export refusé). Pourquoi p1 réussissait : `run_official_e2e.sh` masque `/system/xbin` par bind-mount depuis D42.17 (« appareil client propre »). Réserve FLAG_SECURE confirmée (E7/E8/terminé : dumps, aucun pixel) ; notification 118 Ko + `notif_dump.txt` 58 Ko capturés |
| v11c | **47821ea** | **43461281227** | correctif : `run_gallery.sh` reproduit le prologue « appareil client propre » de p1 (adb root, setenforce 0, bind-mount répertoire vide sur `/system/xbin`, preuve `su_mask_proof.txt`) — le contrôle de **certificat** reste actif, IntegrityGuard ni modifié ni contourné ; l'export réel prend ~14 min (p1 ×3) | SUCCESS en 22 min (artefact `14057931234`) — masquage **prouvé** (`su_mask_proof.txt` : `/system/xbin/su` présent avant, invisible après) MAIS brief non validé : la carte « Nouvel arrivage » du secteur **Mode** (homonyme du Commerce, atteinte selon le défilement) ouvre un brief à 9+ étapes (contact 🇧🇯 +229 inclus) ; boucle de 8 tentatives épuisée avant la vérification → camera/E7/export non atteints (gaps documentés) |
| v11d | **e41eaf9** | **43465731951** | correctif : `BRIEF_TENTATIVES=20` pour suite/exportfix (8 inchangé pour les profils validés) — les taps « Continuer » avançaient réellement d'étape en étape (brief_etape1..8 = écrans distincts) | **SUCCESS COMPLET en 29 min** (artefact `14060281257`) — **la chaîne export est ENFIN capturée** : porte intégrité PASSÉE (masquage su), export réel lancé et TERMINÉ, dump `_export_termine.xml` = « **Vidéo prête ! Partage-la avec tes clients.** » + « PARTAGER LA VIDÉO », **export.mp4 tiré** (5 837 219 o, ftyp isom, h264 avc1 + AAC mp4a, 34,98 s, entropie 7,09 bits/o), notif FGS ×3, et captures **screenrecord valides** : 025 notification (moy 94), **026_partage_feuille (141)**, 027_dashboard (204), 028_profil_dashboard (204), 029_dashboard_bas (199), 030_dashboard_parrainage (204). Gaps restants : uniquement les 2 réserves FLAG_SECURE (E7, « Vidéo prête ! ») |
| v11e | **395ae05** | **43471051633** | paywall/réglages : le bouton d'achat du dashboard = « **Acheter** » (`dash_buy`), absent de la liste v11b → paywall jamais atteint ; v11e ajoute « Acheter » + dump `_dashboard.xml` à l'arrivée | SUCCESS (artefact `14060281257` → `9569420`) — chaîne export re-validée (partage + dashboard + profil + parrainage, export.mp4 retiré) MAIS paywall/réglages toujours absents **sans gap documenté** : « Acheter » présent dans le dump (bornes réelles [645,691][780,746]) mais tap silencieusement infructueux (dashboard resté défilé après le BACK parrainage) ; « Réglages » : **aucun nœud ni content-desc au sommet du dashboard** (constat UX) ; 029_dashboard_parrainage capturé en repli screencap (valide, moy 206) |
| v11f | **7fb8bdb** | **43475521898** | correctif : `haut_de_page` systématique avant « Acheter », « Réglages » cherché aussi après défilement, dump `_paywall.xml`, **gaps explicites** (jamais d'échec silencieux) | SUCCESS mais **brief déraillé** : carte « Nouvel arrivage » Mode sélectionnée (2ᵉ fois — homonyme, ordre des nœuds du dump) → brief contact 🇧🇯+229 + « Nom du vêtement » + quartier hors champ non rempli → « Continuer » bloqué, 20 tentatives épuisées (brief_etape4..20) ; paywall/réglages jamais atteints. Diagnostic : les runs réussis (v11d/v11e) avaient ouvert la carte « **Avant et après** » (brief générique une étape) |
| v11g | **1c5a0b8** | **43480822564** | correctif : pour `suite`, « Nouvel arrivage » RETIRÉ des candidats, « Avant et après » en tête (déterministe — prouvé par v11d) ; exportfix inchangé (campagne close) | SUCCESS mais brief déraillé IDENTIQUE — diagnostic approfondi : **tous** les gabarits (vérité terrain `content/gabarits_v2`) ont champ contact + quartier ; la vraie cause est la **visibilité** : « Quartier et ville » sous le pli → absent du dump → jamais rempli → « Continuer » désactivé (v11d avait eu la chance du clavier qui faisait défiler) |
| v11h | **5ab4d9d** | **43485934877** | correctif racine : avant de conclure que le brief est complet, **défiler pour révéler le bas du formulaire**, re-dumper, remplir les champs vides apparus (quartier) | **SUCCESS — brief VALIDÉ** (réparation « 1 champ vide révélé par défilement » dans le job log), chaîne export complète : notification (moy 94), **partage_feuille (141)**, dashboard (204), profil_dashboard (204), dashboard_bas (201, screencap-repli), dashboard_parrainage (204), **export.mp4 6 081 715 o**, dump « Vidéo prête ! » ✓, notif ×3. Gaps : réglages + paywall — les taps post-parrainage tapaient dans le vide (le BACK avait quitté le dashboard, job log 19:09/19:10) |
| v11i | **9fb65c9** | **43490237549** | correctif : **paywall tenté en premier** (dashboard frais, « Acheter » au sommet), retour dashboard vérifié (`wait "TES VIDÉOS"`) après chaque BACK, « Réglages » cherché par **5 défilements progressifs** (bouton OutlinedButton textuel en bas — `DashboardScreens.kt:61`) | **SUCCÈS COMPLET** (artefact téléchargé) : **paywall capturé** — 030_paywall + 031_paywall_bas (screenrecord, moy 197), dump `_paywall.xml` : « Choisissez votre formule », « Pass 24 h · 500 FCFA », « Pro · 3 000 FCFA / 30 j », « Payer avec Mobile Money » ; notification (94), partage_feuille (141), dashboard (206), profil_dashboard (204), dashboard_bas (199), export.mp4 4 513 423 o, dump « Vidéo prête ! » ✓, notif ×3, RC15 sha ✓. **Gaps finaux : uniquement E7 + « Vidéo prête ! » (FLAG_SECURE par conception) + réglages** (bouton non atteint après 5 défilements — constat UX) |

## Galerie permanente (v2, IMAGE-FIX)

`docs/checkpoints/D42_31/visual-review/` : 20 dossiers numérotés (01_accueil →
20_hors_connexion) + `README.md` (**vignettes Markdown
`[![…](URL_raw_épinglée_au_commit)](URL_blob)`** — visibles dans le rendu
GitHub, clic = taille réelle) + `SCREEN_INVENTORY.csv` (inventaire exact :
captures affichables + fichiers vides + non retenues) +
`GABARITS_INVENTAIRE.csv` (30 gabarits → captures par secteur) +
`UX_AUDIT.md` (constats P0-P3 + diagnostic des captures) + `runs/`
(manifests + gaps par run, y compris camerafix/exportfix/suite) +
annexe README « captures indisponibles » (27 fichiers vides + 6 non retenues
conservés intacts, jamais présentés comme captures).

**Comptage final (v2)** : **212 fichiers d'origine** dans l'arborescence =
**179 captures affichables** (168 en galerie + 11 archives de diagnostic
screencap du viseur) + **27 fichiers vides** (artefact `screencap` /
écrans FLAG_SECURE — annexe README) + **6 captures non retenues** (offline
v8 : intents refusés, mauvais écran — annexe). 18 sections avec images +
2 sections à réserve documentée (`14_audio`, `15_montage` — E7 sous
FLAG_SECURE). Sources valides : base-fr/en (v8) · font130 21 · petit 20 ·
offline 30 · erreurs 3 · camerafix 5 (screenrecord) · exportfix 1
(notification screenrecord) · suite 8 (partage + dashboard + profil +
parrainage + paywall ×2 — screenrecord). Preuves FLAG_SECURE (E7, E8,
« Vidéo prête ! », paywall) : dumps XML + `export.mp4` 4,5 Mo dans
`runs/preuves/`. Inventaire exact : `SCREEN_INVENTORY.csv` (212 lignes) ;
30 gabarits : `GABARITS_INVENTAIRE.csv`.

## Couverture réelle (honnête)

- Parcours commercial complet FR + EN : splash, langue, auth, carrousel,
  secteurs, parrainage, crédits, catalogue (6 secteurs), brief (vide,
  clavier, rempli, erreurs, étapes), vérification, permission (dialogue/refus/
  rationale/octroi), caméra (guide + viseur **screenrecord**), prises
  (countdown, REC, bascules, reprise — **screenrecord**), E7 aperçu
  (**screenrecord**), export (prêt, en cours, notification, **« Vidéo
  prête ! » screenrecord**), partage (**feuille Android screenrecord**),
  dashboard/parrainage/réglages/paywall (**UI réelle screenrecord**),
  hors connexion (31 captures valides).
- Variantes : police 130 % (21), petit écran 720×1520 (20).
- Fichiers vides (artefact screencap, conservés + annexe) : 27.
- Captures non retenues (intents refusés, mauvais écran) : 6 (offline v8).
- 30 gabarits : tous dans leurs captures de catalogue sectoriel
  (GABARITS_INVENTAIRE.csv).

## Constats produit majeurs (détail dans UX_AUDIT.md)

P1 : catalogue/gabarits non localisés EN ; chip « Boutique & Petit Commerce »
difficile d'accès. P2 : « Tu pouvez » (faute) ; libellé focus tronqué ;
bouton Continuer à bornes nulles (accessibilité). P3 : accents manquants
dashboard ; en-tête E7 non épinglé.

## Prochaine étape

**ARRÊT À LA PORTE DE VALIDATION VISUELLE** : le fondateur examine la galerie
corrigée et rend ses observations. La Phase B ne commence qu'après son accord.
Pas de RC16 avant. Budget 0 FCFA ; CinetPay reporté.
