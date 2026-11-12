# D42.30 — Plan et état d'exécution

**Mission** : correction terrain (RC14 testée sur vrai téléphone par le fondateur) —
caméra réelle, crédits/backend, reconception UX/UI catalogue-brief-vérification,
numéros WhatsApp internationaux, périmètre FR/EN, puis RC15 signée et qualifiée.
**Budget strict : 0 FCFA.** CinetPay reste volontairement non intégré.

## État de départ (reprise GitHub du 17/11/2026)

- `origin/main` = **99b210b** (D42.29-11, scellage D42.29) — récupéré après reset
  sandbox (erreur 663, procédure éprouvée : re-add origin + fetch + reset --hard,
  contenus vérifiés).
- Checkpoint D42.29 : tag `D42_29` → 99b210b. Matrice D42.29 : 15 PASS.
- **RC14 = 5736355** (tags d42.29-build-rc14 / d42.29-rc14, build 42990176193,
  release 441446648, APK signée sha256 a4efd275…f80e78, cert 758077eb…33e192).
- Après RC14 : a6519b5/b522290/67b5cd8/99b210b = harnais + sonde D42-SYNC (4 lignes
  de log BackendSync) + docs. **Aucun changement produit**, la RC14 testée par le
  fondateur est fidèle au code audité ci-dessous.
- CI au départ : android-ci 43005793126 SUCCESS, android-e2e-lab 43005792936 SUCCESS
  (99b210b). Backup D1→B2 43001921063 SUCCESS.

## Acquis D42.27–D42.29 à préserver (ne pas re-tester sans impact)

Firebase + Credential Manager (10/10 RC13, 10/10 RC14), parrainage 7/7, brouillons
inter-sessions 36/36, audio 600/600, 3 modes audio 12/12, offline OFFX 3/3 (HTTP 200),
sécurité/idempotence 69/0, sauvegardes/restaurations, gabarits, intégrité RC14 +
certificat. Ces preuves sont réouvertes UNIQUEMENT si un commit D42.30 touche leur
fonctionnement (analyse d'impact systématique avant non-régression).

## Défauts terrain constatés par le fondateur (RC14, téléphone réel)

1. Message « récupération des crédits » après inscription.
2. Catalogue de gabarits pas assez professionnel.
3. Formulaire WhatsApp : validation et exemple obsolètes (+229 97…).
4. Prix : secousses pendant la saisie (clavier).
5. Mauvaise gestion clavier / éléments hors écran.
6. Écran caméra NOIR malgré permission accordée.
7. Compte à rebours et indications de scène simulés.
8. Tournage : rien ne prouve que les scènes sont réellement filmées.
9. Présentation générale < confiance commerciale.
+ Périmètre linguistique réduit à **FR/EN** (ES/JA retirés). Carrousel initial conservé.

## Diagnostic établi (audit code, commit 99b210b = RC14 + sondes)

| # | Constat terrain | Cause racine (constatée au code) | Fichier(s) |
|---|-----------------|----------------------------------|------------|
| 6 | Écran caméra noir | `bindCamera()` attache le `Preview` à CameraX mais **`setSurfaceProvider` n'est JAMAIS appelé** — le PreviewView `camera_preview` ne reçoit aucun flux. Le `Preview` binder ne sert qu'au piège b/449913903 | `CameraGuideActivity.kt` (bindCamera), `InsCameraBinder.kt` (buildUseCases) |
| 7 | Compte à rebours simulé | `PriseViewfinder()` = maquette Compose avec un cercle **« 3 » statique codé en dur** ; le compte à rebours n'existe pas — l'enregistrement démarre immédiatement au tap. Les indications de scène du mode générique avancent par horloge murale (`ticker`), pas par prise réelle | `PriseGuideScreen.kt`, `CameraGuideActivity.kt` |
| 8 | Rien ne prouve le film | viseur factice + pas d'état STREAMING + pas de badge REC lié au recorder + `GuidedShootingOverlay` décoratif | idem |
| — | Commandes dupliquées | barre XML (flip + record) **ET** contrôles Compose (Refaire/Tourner/Suivant) superposés | layout + PriseGuideScreen |
| 1 | Crédits « récupération » | `welcome_error` = « Ils seront ajoutés dès que la connexion reviendra » affiché pour TOUT échec ; résultat de `bootstrap()` ignoré (`.onFailure` log only) → welcome-grant tenté sur profil inexistant ; taxonomie d'erreur inexistante (tout → null/offline) | `OnboardingActivity.kt` (demarrageServeur), `WelcomeRepository.kt`, `strings_onboarding.xml` |
| 2 | Catalogue peu pro | `GabaritLayout()` = cartes 100 % textuelles uniformes (titre + méta + phrase), pas de miniature, `SectorRow` = 6 filtres toujours affichés | `CatalogScreen.kt` |
| 3 | WhatsApp obsolète | `brief_err_phone` = « +229 97 00 00 00 » (format 8 chiffres d'avant le 30/11/2024) ; validation naïve « + puis ≥ 8 chiffres » ; **les 30 gabarits JSON** portent l'exemple obsolète | `GabaritBriefScreen.kt` (fieldError), `strings_brief.xml`, `content/gabarits_v2/**` |
| 4/5 | Prix/secousses + clavier | `BriefActivity` sans `windowSoftInputMode` (pan par défaut) ; pas d'`imePadding`/insets ; messages d'erreur insérés dynamiquement = sauts de layout | `feature-brief/AndroidManifest.xml`, `GabaritBriefScreen.kt` |
| — | Badge VÉRIFICATION coupé | `ReadyHeader` : Row SpaceBetween sans poids ni repli — le badge chevauche le titre sur petit écran ; `ReadyConfirmBox` ressemble à une case à cocher active sans l'être ; bouton final sous un long scroll | `ReadyCheckScreen.kt` |
| — | ES/JA actifs | `VitrineLocale.SUPPORTED = fr,en,es,ja` + sélecteur 4 langues + tests e2e es/ja + valeurs-es/ja | `VitrineLocale.kt`, harness, ressources |

## Plan d'exécution (ordre par dépendance)

- **Étape 1 (P0-A)** — Caméra réelle : `setSurfaceProvider`, état STREAMING,
  viseur = PreviewView réel (fini la maquette), compte à rebours 3-2-1 VRAI
  (recorder démarré après), badge REC, commandes unifiées, garde-fous conservés
  (R4, 3A, stockage, Finalize, slots, brouillons). → `02_CAMÉRA_RÉELLE.md`
- **Étape 2 (P0-B)** — Crédits : enchaînement bootstrap→claim→grant contrôlé,
  taxonomie d'erreur (réseau/401/403/404/5xx/délai/profil), messages justes. → `05_BACKEND_CREDITS.md`
- **Étape 3 (P1-E)** — WhatsApp : libphonenumber, sélecteur de pays (BJ défaut),
  collage E.164, formatage, migration des 30 gabarits + version contenu + invalidation
  Room. → `04_FORMULAIRES_ET_NUMÉROS.md`
- **Étape 4 (P1-D)** — Prix + clavier : adjustResize, imePadding, curseur stable,
  erreurs à hauteur réservée. → `04_FORMULAIRES_ET_NUMÉROS.md`
- **Étape 5 (P1-F)** — Écrans vérification : header responsive, confirmation
  non factice, boutons visibles. → `03_UX_UI.md`
- **Étape 6 (P1-C)** — Catalogue : cartes visuelles (miniatures, bénéfice, durée,
  scènes, prises), secteur affiché + « Changer de secteur » discret. → `03_UX_UI.md`
- **Étape 7 (P1-G)** — FR/EN uniquement : VitrineLocale, sélecteur, tests, matrices. → `06_LANGUES_FR_EN.md`
- **Étape 8 (P2)** — Parcours complet 25 étapes sur émulateur (caméra émulée RÉELLE),
  non-régression ciblée, RC15 : version, build, signature, E2E APK signée, release. → `07/08`
- Scellage : matrice finale, rapport, release GitHub. Chaque étape = commit(s) poussé(s).

## Journal d'exécution

- **17/11 (reprise)** : reset sandbox récupéré (663) ; état GitHub vérifié (99b210b,
  CI verts, aucun run en cours) ; audit terrain complet établi (tableau ci-dessus,
  causes racines constatées au code sur le commit RC14) ; checkpoint D42.30 créé.
- **17/11 (D42.30-01)** : checkpoint 5be204b poussé (audit 9 défauts, ce plan).
- **17/11 (D42.30-02 = dd5ca28)** : P0 caméra (setSurfaceProvider/STREAMING,
  countdown réel, commandes uniques, badge REC) + P0 crédits (enchaînement
  contrôlé bootstrap→claim→grant, taxonomie welcome) codés et poussés —
  **sans compile locale (impossible : JDK 11 seul, pas de SDK)** → android-ci
  43025089617 ÉCHEC : detekt onCreate 98/80 + complexité 18/15 ; AAPT
  materialButtonOutlinedStyle ×3 (attr Material absent du module).
  Leçon consignée : CI est le compilateur du sandbox.
- **17/11 (D42.30-03 = 10a12e1)** : correctifs CI (onCreate scindé 98→~20 lignes
  en 7 fonctions privées ; styles XML locaux) + P1-E WhatsApp international
  complet (libphonenumber 8.13.50, TelephoneField/TelephoneValidator, migration
  60 JSON +229 01…, versionCode 2 → re-seed Room F48) + P1-D prix
  (adjustResize, imePadding, ChampPrix brut-à-la-frappe, erreur à hauteur
  réservée) + P1-F ReadyCheck (header repliable < 340dp, bandeau neutre,
  imePadding). android-ci 43026595710 ÉCHEC sur 3 points : (a) detekt
  TelephoneField 137/80 + 19/15 ; (b) values-en/strings_brief.xml :
  brief_err_phone EN DOUBLÉ (ancienne ligne non supprimée) ; (c)
  I18nKeyCoverageTest : les 7 nouvelles clés brief_phone_* n'existaient qu'en
  FR/EN (ES/JA retirés du périmètre mais dossiers encore présents).
  POSITIF : feature-camera detekt + AAPT PASSÉS (correctifs caméra validés) ;
  data:compileDebugKotlin PASSÉ.
- **17/11 (D42.30-04, en cours)** : (1) doublon brief_err_phone EN supprimé ;
  (2) TelephoneField refactoré (137→66 lignes, 5 composants privés) ;
  (3) BriefFieldInput 85→58 (extraction ChampTexteSimple + ZoneErreurEtAide) ;
  (4) P1-C catalogue : VignetteCatalogue.kt (vignettes sectorielles DESSINÉES —
  viseur caméra, pastille lecture, pellicule = nombre réel de scènes, badge
  durée, icônes métier par secteur, palette 6 secteurs ; zéro dépendance,
  marche hors-ligne) branchée dans GabaritLayout + repli SkinCard (fini le
  « … » gris) + « Changer de secteur » discret (filtres repliés si secteur
  déjà choisi) ; (5) P1-G FR/EN : VitrineLocale.SUPPORTED=[fr,en] + purge des
  choix es/ja hérités, sélecteur 2 cartes, dialog dashboard 2 langues,
  GabaritL10n.LANGUES restreintes, 16 dossiers values-es/values-ja ARCHIVÉS
  dans content/archive_i18n/ (plus aucune locale fantôme), matrices de rendu
  virtual-render-validation [fr,en], harnais run_langue.sh/run_audio_modes.sh
  restreints, tests convertis (l'AnglaisEstReellementDeLanglais,
  leRenduAnglais…, 60 combinaisons, I18nKeyCoverage 2 langues,
  ProductionRenderInstrumentedTest fr/en) ; échantillon téléphone de test
  passé au format BJ 10 chiffres (+2290197000000). 02_CAMÉRA_RÉELLE.md REMPLI.
  Vérifications harnars faites : « Tourner » toléré (|| true, CAM_REC réel
  présent, CAM_STOP conservé), signatures PriseGuideScreen/GuidedShootingOverlay
  conformes, clés FR=EN sur les 7 modules (10/10 par module).
- **17/11 (D42.30-05/06)** : fix compile TelephoneValidator
  (String.lowercase(Locale) — `lowercase(langue)` refusé, e: 72:87) puis
  **OOM :app:packageDebug → heap Gradle 1280m → 2048m** (tout le reste était
  vert). Récupération sandbox intermédiaire (snapshot .git antérieur à D42.30,
  arbre D42.28) : remote re-add + fetch + vérif que l'arbre local ne portait
  rien d'unique + reset --hard origin/main = 5082856 — aucune perte.
- **17/11 (5082856 : PREMIER VERT COMPLET android-ci)** : ktlint + detekt +
  tests JVM (I18nKeyCoverage 2 langues, GabaritL10nTest EN, 60 combinaisons,
  TelephoneValidator) + compile tous modules + packaging APK → SUCCESS.
  **e2e-lab 5082856 : 12 jobs SUCCESS** — suite principale (run_p0 base/
  font130/rot90, petit écran), auth 10/10, offline, deeplink, security,
  gabarits, backend-http, harness-selftest, **langues (en)**, et surtout
  **camerap : 59 PASS / 0 FAIL / 3 BLOCKED** (permissions refusées propres,
  bascule avant/retour prouvée, prise AVANT enregistrée — 0→1 rush, app
  vivante, zéro crash). Les 3 BLOCKED = `wait --text "Filme ta prise" --exact`
  : le titre HUD était devenu « Filme ta prise · PRISE 1/3 » (suffixe) →
  détection impossible, navigation réelle OK. langues (es)/(ja) FAILURE
  attendues : matrices workflow non restreintes au moment du push.
- **17/11 (e2e-lab 5082856 complet : 13 SUCCESS / 2 FAIL attendus / 1 annulé)** :
  auth, camerap (59 PASS/0 FAIL/3 BLOCKED), suite principale, offline-export,
  drafts, langues (en), offline, deeplink, security, gabarits, backend-http,
  harness-selftest SUCCESS. langues es/ja FAIL attendus (matrices, corrigées).
  **p1 ANNULÉ à 90 min (timeout job) — analyse complète de l'artefact** :
  (a) `P1_brief_valide` FAIL : bouton « Continuer » écrasé à **1 px de haut**
  (dump 22b : bounds [455,2071][625,2072]) — **adjustResize + imePadding =
  INSET APPLIQUÉ DEUX FOIS** (fenêtre redimensionnée PUIS padding clavier) →
  tap sans effet, navigation jamais faite (dump 23 == dump 22b) ;
  (b) `P1_brief_invalide_refuse` BLOCKED « champ Prix introuvable » : au
  re-listage après retour arrière, le Prix est sous le pli (slots d'erreur
  +20dp/champ + champ pays → brief plus haut) ; le remplissage valide l'a
  bien rempli (5/5 champs) — seule la détection du test invalide a raté ;
  (c) tout le reste en cascade (camera/prises/rushs/export) = conséquence de
  (a). **Correctifs** : adjustResize SUPPRIMÉ du manifest (imePadding seul —
  pattern Compose avec decorFits=true ; leçon consignée : JAMAIS les deux) ;
  run_p1.sh fait défiler + relister si Prix absent du listage.
  **Vérification JVM libphonenumber (jar Maven Central 8.13.50)** :
  +2290197000000/016…/012… VALIDES, +33612345678 VALIDE FR, et
  **+22997000000 (ancien 8 chiffres) reste VALIDE** (transition ARCEP dans
  les métadonnées Google) → le p1 en cours passait le brief malgré l'ancien
  numéro ; exemple contextuel BJ = **+229 01 95 12 34 56** (nouveau format).
  Harnais migrés vers +2290197000000 (7 occurrences, 4 scripts) pour que les
  PREUVES montrent le format actuel.
- **17/11 (67f6421 : android-ci SUCCESS ; lab en cours → diagnostic FINAL du bouton)** :
  camerap SUCCESS (job) mais **CPA/CPB_brief_valide FAIL** (4 taps Continuer
  sans effet) — analyse de l'artefact : la théorie « double inset » était
  INCOMPLÈTE. Vérité terrain (dump CPA_brief_bas) : fenêtre 1080×2072, le
  bouton Continuer clippé au bord bas ([44,2032][1036,2072] = 40 px visibles,
  TEXTE à [455,2071][625,2072] = **1 px de haut**, dans la zone de gestes
  système) — MÊME position qu'en 5082856 : le scroll s'arrête quand le texte
  devient partiellement visible (1 px suffit au détecteur) et le tap atterrit
  au bord absolu de l'écran → avalé. Cause profonde : le bouton était DANS le
  scroll, en dernier élément — sa position de fin de défilement dépend du
  contenu ; +120 px de contenu (slots d'erreur + champ pays) ont déplacé le
  point d'arrêt du harnais dans la zone mortelle.
  **Fix produit (défaut fondateur n°5 « boutons hors écran »)** : bouton
  Continuer **ÉPINGLÉ hors du scroll** (pied fixe : navigationBarsPadding +
  imePadding, formulaire défile en weight(1f) SOUS le bouton) — TOUJOURS
  visible sans défiler. Même correction pour « OK, je commence »
  (ReadyCheckScreen). Extraction PiedContinuer (fun 84→78 lignes).
  Leçon consignée : (1) jamais de CTA dans la zone de défilement en fin de
  liste ; (2) la théorie doit être validée par le dump AVANT le fix.
- **17/11 (lab 8c9f514 : android-ci SUCCESS, 13 jobs verts, camerap 45 PASS /
  3 FAIL / 12 BLOCKED — RCA FINALE D42.30-09, le brief élucidé)** :
  Run 43065939431. Le fix « bouton épinglé » (8c9f514) n'a PAS fait passer
  brief_valide : `CPA/CPB/CPC_brief_valide` FAIL identiques. Analyse croisée
  camerap vs drafts (artefacts 13878098720 / 13876408574) — **le drafts, sur
  le MÊME APK, remplit le champ whatsapp ET valide le brief avec le bouton
  Continuer** (S2_brief_valide PASS) : l'app n'est PAS en cause.
  Vérité terrain :
  - dumps : les 4 champs visibles remplis (RobeWax, 15 000, FCFA, Akpakpa) ;
    `verif_contenu.xml` affiche « **Ce numéro n'est pas valide pour le pays
    choisi** » → le champ whatsapp contient une valeur INVALIDE ;
  - bouton Continuer [44,2059][1036,2072] « 13 px » + texte [0,0][0,0] :
    GÉOMÉTRIE IDENTIQUE dans le drafts qui PASSE → artefact uiautomator, le
    tap fonctionne ; `clickable/enabled` non fiables sur boutons Compose ;
  - JVM (libphonenumber 8.13.50 testée en local) : `+2290197000000`,
    `0197000000`, `01 97 00 00 00`, `2290197000000` (indicatif collé) tous
    VALIDE → la validation app est saine.
  **Chaîne causale du FAIL** : le harnais camerap exigeait « +229 » dans le
  dump — or le champ affiche la forme NATIONALE « 01 97 00 00 00 » et le prix
  est reformaté « 15 000 » → preuve JAMAIS satisfaite → re-remplissages en
  boucle → `remplir_champ` n'efface que 8 caractères (DEL×8 < 14) →
  **concaténation invalide** dans le champ → `invalid=true` → bouton Continuer
  DÉSACTIVÉ (comportement correct de l'app) → 4 taps sans effet → FAIL.
  (Le « + » isolé peut aussi se perdre à la 1re frappe d'une session vierge —
  consigné depuis D42.26-18f.)
  **Corrections (D42.30-09)** :
  - harnais (4 bancs : camerap, p1, drafts, audio_modes) : whatsapp tapé en
    forme NATIONALE `0197000000` (celle du hint, insensible à la perte du
    « + ») ; DEL×24 (effacement complet) ; preuves sur dump NORMALISÉ
    (espaces ôtées : « 0197000000 » couvre national ET E.164, « 15000 »
    couvre « 15 000 ») ; diagnostic différencié — si un dump porte
    « n'est pas valide », le FAIL nomme le champ (Continuer correctement
    désactivé) au lieu de « 4 essais sans effet » (avec remontée exprès du
    formulaire pour capter le message hors écran).
  - app : `TelephoneValidator.versE164` tolère l'indicatif collé SANS « + »
    (« 2290197000000 » → +2290197000000 ; essai direct prioritaire, re-essai
    sans indicatif seulement après échec — un fixe « 2290… » n'est pas
    dénaturé). Nouveau test JVM `TelephoneValidatorTest` (7 cas : national
    10 chiffres, collage international, indicatif collé, ancien format 8
    chiffres, invalides, exemple généré, France).
  Leçon : comparer un banc qui ÉCHOUE avec un banc qui PASSE sur le même APK
  isole le défaut en une étape — ici le défaut était dans le HARNAIS, pas
  dans l'app ; le message d'erreur affiché à l'écran était la preuve depuis
  le premier dump.
- **17/11 (D42.30-14 VALIDÉ : lab 43142014528 sur b279bca — 14 jobs SUCCESS
  en ~40 min, TOUT PASS)** : android-ci SUCCESS ; camerap **62/0/0 (5e
  consécutive)** ; **p1 35/0/0** — P1_export_termine PASS (« Vidéo prête ! »)
  + P1_partage PASS, PREMIÈRE FOIS ; **offline-export 35/0/0 +
  OFFLINE_EXPORT 41/0** — OFFX_mp4_decode_offline PASS « MP4 exporté HORS
  CONNEXION avec musique (RMS -17.609050 dB > -28) », OFFX_journal_export
  PASS « CONFIRMED, solde 2 ». Le fix produit (sonde sur rushs réels) est
  VALIDÉ : l'export aboutit, avec audio, hors connexion, journal et crédits
  justes. Les correctifs harnais D42.30-13 (saisie vérifiée + Monnaie
  FCFA) sont validés par la même occasion (brief_valide PASS dans les DEUX
  bancs). Non-régression audio déclenchée : p3-modes (musique voix mix) —
  le fix touche le chemin audio du Worker.
- **17/11 (D42.30-16 VALIDÉ : p3-modes 43161021108 sur 02eff63 — 6/6 cellules
  à 0 FAIL)** : voix fr/en 28/0/0, mix fr/en 28/0/0, musique fr/en 27/0/0 ;
  P3_prise_2_en PASS (libellés EN couverts), P3_mode_mix PASS (delta +5 dB vs
  voix seule : la musique duckée apporte son énergie, preuve physique du mix).
  **ÉTAT : toutes les validations D42.30 sont VERTES** — android-ci SUCCESS,
  lab 14/14 (camerap 62/0/0 ×6, p1 35/0/0, offline-export 35/0/0 + OFFX 41/0,
  S03b_es_ja_absents ×4, drafts/auth/deeplink/langues-en/offline/backend/
  security/selftest/gabarits-audit), p3-modes 6/6. → RC15.
- **17/11 (D42.30-15 = p3-modes analysé : 5 correctifs harnais, app INNOCENTE)** :
  p3-modes 43148299573 (b279bca) : jobs SUCCESS mais verdicts internes —
  voix 26/2, mix 25/3, musique fr 13/4/7 (cascade) + en 24/3. RCA (artefacts
  13915245374/13915250319/13914680734 + mesures ffmpeg locales) :
  - **P3_mp4_decode FAIL ×6 = filtre incohérent** : ffmpeg émet « non
    monotonically increasing dts » (BÉNIN, déjà filtré par le banc OFFX
    l.161-174) mais le p3 comptait TOUT stderr. Aligné sur OFFX.
  - **P3_mode_musique/mix « intro quasi muette » = attente contraire au
    produit** : le mixeur applique un fade-in (contrat AudioChain D41 F60) ;
    mesuré sur le MP4 musique : t=0 -54 dB, t=2 -26 dB, t=5 -17,6 dB,
    GLOBAL -17,6 dB (= exactement le PASS OFFX). La musique EST là. Le
    standard p3 devient OFFX : RMS global > -28 + preuve STRUCTURELLE
    « D42-BGM : décodage BGM » au logcat. Intro conservée en diagnostic.
  - **P3_prise_2 rc=4 ×6 = même attente obsolète que P1** (aperçu après la
    dernière prise d'un gabarit 2 prises) — port du fix D42.30-11.
  - **P3_brief_valide FAIL (musique fr) = même corruption de saisie que
    D42.30-13** — port de saisir_et_verifier (Monnaie FCFA déjà en place).
  - Côté APP, tout est sain : export voix/musique hasAudioTrack=true,
    VERIFIE_PARTIELLEMENT, attempt 0 SUCCESS, base silencieuse D42.21
    correctement déclenchée par le fix D42.30-14.
- **17/11 (D42.30-14 = bug produit EXPORT trouvé par RCA des artefacts, FIX
  app poussé)** : lab 43129951436 (46fe2a4) 14 jobs SUCCESS — camerap 62/0/0
  (4e preuve), **S03b_es_ja_absents PASS ×4 (retrait es/ja PROUVÉ)**, p1
  33/1/1, offline-export 33/1/1 + OFFX 37/3 (brief_valide PASSé cette fois —
  la corruption de saisie D42.30-13 est bien intermittente). Restaient
  P1_export_termine + OFFX_journal_export (COMPENSATED) +
  OFFX_mp4_decode_offline (SANS musique). **RCA (logcat artefact p1 +
  draft Room)** : D42-VERIF essai 0/1/2 → `hasAudioTrack=false,
  audioVerdict=ECHEC` — les 3 tentatives produisaient des MP4 COMPLETS
  (35 s, bitrate OK, nonBlackFrames=3) mais SANS piste audio, rejetés par
  le vérificateur → FAILURE 23:43, journal COMPENSATED, ~35 min perdues.
  Chaîne : gabarit T1 « Nouvel arrivage » = 3 prises, parcours = 2 prises →
  `client_rushes` contient un slot VIDE "" ; `rushesAudioPresente()` sondait
  le tableau BRUT → `setDataSource("")` lève → repli conservateur « voix
  présente » → base silencieuse D42-21 désactivée → Transformer sans graphe
  audio → piste absente → ECHEC. **Impact utilisateur réel : merchant qui
  saute une prise = export mort (crédit compensé, aucune vidéo).**
  **Fix (ExportWorker.rushesAudioPresente)** : sonder `RushSlots.resolve()`
  — les rushs RÉELS, même alignement que la composition. Avec le fix :
  base silencieuse préparée → SFX/BGM mixés → piste audio → export
  CONFIRMED (~12 min/tentative, fenêtre 95 min large).
- **17/11 (D42.30-11 VALIDÉ : lab 43115322040 sur 401ce39, 14 jobs SUCCESS)** :
  camerap 62/0/0 (3e preuve) ; **p1 PASS=33 FAIL=1 BLOCKED=1** — P1_prise_2 ✔,
  P1_aucun_crash ✔, P1_brief_invalide ✔ (les 3 correctifs D42.30-11 font
  leurs preuves) ; P1_export_termine ✗ (fenêtre 75 min) + P1_partage en
  cascade. **offline-export régresse : P1_brief_valide ✗ → 7 BLOCKED en
  cascade** — RCA artefacts (draft Room + dumps) :
  - **P1_export_termine est un FAUX échec de fenêtre** : l'export A ABOUTI —
    export-0.mp4 5 084 798 octets, h264 1920×1080, 35,04 s (ffprobe),
    P1_mp4_extrait PASS. L'export avec BGM dure ≥75 min sur swiftshader
    (run SANS aucune collision UiAutomation cette fois). Fenêtre 75 → 95 min.
  - **P1_brief_valide ✗ = saisie harnais corrompue** : le draft final (base
    Room de l'artefact) montre `devise:""` (le FCFA par défaut a été EFFACÉ)
    et `whatsapp:"019700000"` (un chiffre perdu) — les DEL×24 de
    remplir_champ sur un tap décalé (géométrie clavier/adjustResize) et/ou
    une frappe `input text` incomplète. Le harnais ne vérifiait JAMAIS le
    contenu saisi (listing vide/rempli only). L'app est saine (p1 : même
    parcours, brief_valide PASS, Monnaie=FCFA).
  - **Correctifs D42.30-13 (harnais)** : `valeur_pour` Monnaie → « FCFA »
    (remplir au lieu de supposer le préremplissage) ; `saisir_et_verifier()`
    = remplir puis VÉRIFIER la valeur dans le dump (comparaison sans
    espaces : « 15000 » affiché « 15 000 »), retry avec coordonnées
    fraîches si absente ; fenêtre export 95 min ; timeouts p1/offline-export
    135 min.
  - Leçon : un FAIL harnais peut être une SAISIE harnais corrompue —
    vérifier le draft (source de vérité de l'app) avant d'accuser l'écran.
- **17/11 (D42.30-12 = ca0ed30, local — push après le lab 401ce39)** :
  retrait es/ja du parcours actif FERMÉ : run_p0.sh S03 attendait encore
  日本語 (FAIL ×5 au lab 09d3e74 — exigence retirée) → S03b_es_ja_absents
  prouve désormais l'ABSENCE des cartes es/ja ; asset l10n actif purgé
  (9 716 → 4 948 o, EN 53/53) + version 4 langues archivée dans
  content/archive_i18n/. Journal + 06_LANGUES_FR_EN.md à jour.
- **17/11 (lab 05ca482, runs 43100433919 + artefacts : android-ci SUCCESS,
  camerap 62/0/0 REPRODUCTIBLE, RCA des « échecs » p1/offline-export — 4
  défauts HARNAIS/INFRA, ZÉRO défaut app)** :
  Verdicts offline-export (job SUCCESS car `true` final) : PASS=30 FAIL=3
  BLOCKED=2 — P1_prise_2 FAIL, P1_export_termine FAIL (75 min),
  P1_aucun_crash FAIL (FATAL). Job p1 : cancelled (timeout 90 min), même
  profil. **L'app est INNOCENTE, preuves à l'appui :**
  - marqueurs VV_E2E (artefact e2e-p1 13896963032) : `PREVIEW STREAMING`
    (frames réelles), compte à rebours 3-2-1, verrou 3A, **prise 1 ET prise 2
    enregistrées + Finalize hasError=false ×2** (772 930 et 750 186 octets),
    guide terminé proprement (onActivity req=14 result=-1) → l'aperçu.
  - le « FATAL EXCEPTION » (crash.log artefact 13896818708) = crash du
    processus **`uiautomator dump` lui-même** (« UiAutomationService already
    registered », PIDs 2530/2588/2628/…) — PAS de video.vitrine.app.
  **Chaînes causales :**
  1. *offline-export aveuglé* : le surveillant du wrapper faisait
     `uiautomator dump` toutes les 3 s EN PARALLÈLE des dumps du parcours →
     collisions « already registered » → des dumps du parcours crashe(en)t →
     fausses détections (prise_2 « ratée » alors que le rush est finalisé),
     attente d'export qui ne voit jamais la fin, crash.log pollué.
  2. *p1 coupé avant le verdict* : l'export avec BGM est ~3x plus lent sur
     swiftshader (>75 min) et le timeout job était à 90 min (4 cancellations
     consécutives : 5082856, 8c9f514, 09d3e74, 05ca482 — le « hang »
     mystérieux était l'export en cours).
  3. *P1_prise_2 « FAIL »* : le gabarit T4/T5 du secteur mode a **2 prises**
     — après la DERNIÈRE prise l'app va légitimement à l'aperçu ; le harnais
     exigeait le retour au guidage.
  4. *P1_brief_invalide BLOCKED « champ Prix introuvable »* : la boucle de
     secours listait via `$UI fields` (lignes « E2E FIELD ») que le grep
     `^E2E CHAMP` ne peut pas matcher.
  **Corrections (D42.30-11, harnais uniquement — l'app n'est pas touchée) :**
  surveillant du wrapper → détection du brief par `dumpsys activity top`
  (BriefActivity au sommet, ZÉRO UiAutomation) ; timeout p1 90 → 120 min ;
  la fonction `prise()` accepte l'aperçu comme issue valide après la
  dernière prise ; crash compté uniquement pour `Process: video.vitrine.app` ;
  `$UI fields` → `$UI champs` dans la boucle de secours du prix.
  Leçon : avant d'accuser un parcours, lire les marqueurs de l'APP (VV_E2E)
  et le buffer crash AVEC le nom du processus — un FATAL n'est pas
  nécessairement celui qu'on croit.
- **17/11 (lab 09d3e74, run 43082333578 : CAMERAP 62 PASS / 0 FAIL / 0 BLOCKED
  — la cascade caméra est LIBÉRÉE)** : le fix harnais D42.30-09 fait passer
  brief_valide ×3 → guide ×3 → refus permission (F52 jusque dans les réglages
  système) → prise1 avec PREUVE FICHIER (3 rush MP4 réels, ~700 Ko chacun) →
  Refaire (slot courant seul, prises intactes) → reprise → guide terminé →
  conservation → bascules AVANT/ARRIÈRE (re-bind prouvé par logs) → prise
  depuis la caméra avant → zéro crash (artefact 13888175723, détail au
  checkpoint 02). android-ci 43082333344 FAILURE : « : » illégal dans un nom
  de test JVM (TelephoneValidatorTest l.70) → fix 0de99a6 prêt, poussé à la
  fin du lab. Restent p1/offline-export (en cours au moment de l'écriture).
- **17/11 (fin du lab 8c9f514, run 43065939431 : completed/cancelled)** :
  13 jobs SUCCESS (e2e, langues en, deeplink, offline, auth, drafts,
  camerap-job, **offline-export SUCCESS — preuve export hors-ligne**,
  backend-http, security, selftest, gabarits-audit, auth-local) ;
  p1 CANCELLED au timeout 90 min (bloqué au brief — cause harnais ci-dessus).
- **17/11 (D42.30-08, poussé)** :
  (1) **machine à états tournage** : trou comblé dans la fenêtre verrouillage
  3A (le job du décompte se terminait AVANT lockThreeA → écran PRÊT → un
  re-tap pouvait déclencher un 2e startRecording pendant que le 1er tournait).
  `launchLockedRecording()` devient suspend DANS le job du décompte → le 2e
  tap annule pendant décompte OU verrouillage ; CancellationException RELANCÉE
  (runCatching l'avalait) ; `start()` blindé try/catch (échec = fichier
  supprimé + sortie propre) ; updateStatus : état « lancement » couvre les
  deux fenêtres. (2) **titre HUD séparé** : « Filme ta prise » redevient un
  nœud EXACT (+ badge « PRISE 1/3 » séparé) → fix camerap 3 BLOCKED et
  compatibilité run_audio_modes. (3) **matrices FR/EN** : android-e2e-lab
  langue [en] (FR couvert par la suite principale), run_p3_matrix fr/en,
  intitulés p3-modes, commentaires virtual-render 60 rendus.
