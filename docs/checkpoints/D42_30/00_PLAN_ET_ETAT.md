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
