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
- **17/11 (D42.30-07, commit final du lot)** :
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
