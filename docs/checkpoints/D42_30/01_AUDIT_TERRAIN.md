# D42.30 — Audit terrain (retour fondateur sur RC14, téléphone réel)

Source : retour fondateur du 17/11/2026 après installation de RC14
(vitrine-video-rc14.apk, sha256 a4efd275…f80e78, build 42990176193 = commit 5736355)
sur un smartphone Android physique. Le fondateur a parcouru : accueil, choix de
langue, connexion Google, choix de secteur, parrainage sans code, brief, accès au
tournage.

## Constats fondateur → vérification au code (commit 99b210b ≡ RC14 + sondes)

### 1. Message de récupération des crédits — CONFIRMÉ (produit)
- `welcome_error` (strings_onboarding.xml) : « Ton compte est créé, mais nous n'avons
  pas pu récupérer tes crédits. Ils seront ajoutés dès que la connexion reviendra. »
  — affiché pour TOUT échec de `demarrageServeur` (réseau, 401, 403, 404, 5xx, délai).
- `demarrageServeur()` (OnboardingActivity.kt l.120-144) : `sync.bootstrap()` est
  appelé mais son résultat est IGNORÉ (runCatching + log only). Le welcome-grant est
  ensuite tenté même si le profil n'existe pas serveur → 403/404 → repli « offline »
  → message trompeur (« connexion reviendra ») alors que le serveur a répondu non.
- `WelcomeRepository.requestGrant()` fusionne tous les cas dans GrantState(offline).

### 2. Catalogue peu professionnel — CONFIRMÉ (produit)
- `GabaritLayout()` : cartes textuelles uniformes (nom, méta « 35 s · 9 scenes ·
  3 prises », phrase) — aucune miniature, aucune hiérarchie visuelle.
- `SectorRow` : les 6 secteurs restent affichés en filtres même après le choix
  initial du secteur à l'onboarding.

### 3. WhatsApp obsolète — CONFIRMÉ (produit + contenu)
- `brief_err_phone` : « Format international attendu : +229 97 00 00 00. » —
  format béninois 8 chiffres ABOLI le 30/11/2024 (10 chiffres, préfixe 01).
- Validation : « commence par + et ≥ 8 chiffres » — aucune règle par pays.
- Les **30 gabarits JSON** (content/gabarits_v2/gabarits/**) portent
  « exemple: +229 97 00 00 00 » (30/30 fichiers).

### 4-5. Prix/secousses + clavier — CONFIRMÉ (produit)
- `BriefActivity` déclaré SANS `windowSoftInputMode` → comportement pan par défaut.
- Aucun `imePadding()`/`WindowInsets.ime` dans GabaritBriefScreen.
- Les messages d'erreur de champ sont insérés dynamiquement (hauteur variable) →
  le layout saute à chaque frappe quand une erreur apparaît/disparaît.

### 6. Écran caméra noir — CONFIRMÉ (produit, cause racine certaine)
- `bindCamera()` : `binder.buildUseCases()` crée `Preview.Builder().build()`,
  `binder.bind()` l'attache au lifecycle — mais **`preview.setSurfaceProvider(
  previewView.surfaceProvider)` n'est JAMAIS appelé**, nulle part dans le dépôt.
- Le `PreviewView camera_preview` du layout reste donc SANS flux → noir. Le Preview
  binder ne sert qu'à garder la session CameraX ouverte (piege b/449913903).
- Aucune observation de `PreviewView.streamState` (pas d'état STREAMING distingué).

### 7. Compte à rebours simulé — CONFIRMÉ (produit)
- `PriseViewfinder()` (PriseGuideScreen.kt) : maquette Compose avec cercle central
  « 3 » CODÉ EN DUR + badges « 9:16 · HD » et « COMPTE À REBOURS » décoratifs.
- Aucun compte à rebours réel : `startRecording()` démarre immédiatement au tap.
- Mode générique : `ticker` (Handler 100 ms) fait avancer les scènes du beat sheet
  à l'horloge murale, que l'on filme ou non.

### 8. Tournage sans preuve de capture — CONFIRMÉ (produit)
- Viseur factice (cf. 7) + pas de badge REC lié au recorder + aucun retour
  « prise validée » visible (le compteur PRISE X/Y n'avance qu'après Finalize,
  sans animation ni confirmation explicite à l'écran).

### 9. Confiance générale — découle de 1-8 (design + robustesse).

### Commandes dupliquées (constat complémentaire)
- Layout XML : boutons `camera_flip_button` + `camera_record_button` en bas.
- Overlay Compose : `PriseControls` (Refaire / cercle Tourner / Suivant) dans une
  colonne défilante avec 180 dp de réserve pour échapper à la barre XML.
- L'utilisateur voit donc DEUX ensembles de commandes superposées.

### Périmètre linguistique
- Fondateur : FR + EN uniquement. Actuellement `VitrineLocale.SUPPORTED =
  ["fr","en","es","ja"]`, sélecteur 4 langues, tests e2e es/ja, ressources es/ja.

## Ce qui est préservé (apprécié / certifié)
- Première page d'accueil + carrousel initial (à conserver tels quels).
- Connexion Google : le fondateur a PASSÉ l'écran (Credential Manager OK sur
  téléphone réel — donnée terrain précieuse, cohérente avec auth 10/10 RC13/RC14).
- Toutes les preuves D42.27–D42.29 (voir 00_PLAN_ET_ETAT.md).

## Décisions d'ingénierie
- Caméra : repair minimal vérifiable (setSurfaceProvider) + reconception de l'écran
  de tournage (viseur réel, compte à rebours réel, commandes uniques, états
  STREAMING/indisponible) — les garde-fous certifiés (R4 consentement, verrou 3A,
  garde de stockage, Finalize, slots alignés, brouillon par prise) sont conservés.
- Crédits : enchaînement contrôlé + taxonomie d'erreur, messages actionnables.
- Tests caméra : émulateur = caméra émulée RÉELLE (VirtualScene) ; toute preuve
  exigeant le matériel du fondateur est marquée `BLOCKED_DEVICE_TEST` sans être
  présentée comme physique.
