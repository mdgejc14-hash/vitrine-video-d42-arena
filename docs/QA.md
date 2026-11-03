# VV Remote QA — cahier de transmission et etat de recette

## Variantes de build (rapport audit s6)
| Variante | Role | Contenu QA | Production |
|---|---|---|---|
| qaDeterministic | niveau B : fixture ffmpeg + FixtureFrameSource (MediaExtractor/MediaCodec), horloge injectable | fixtures assets, QaMarker | NON |
| qaRealCamera | niveau C : parcours camera reel instrumente | stubs androidTest | NON |
| releaseCandidate | comportement production audite | aucun | OUI (APK livre) |

Controle hygiene CI : step "Hygiene release" echoue si assets/qa_fixtures, QaMarker,
FixtureFrameSource ou ABI x86 presents dans l'APK releaseCandidate.

## Niveau B — frontiere et limites documentees
`VideoFrameSource` (ins-capture) = frontiere effective ; `CameraXFrameSource`
n'interpose rien (Recorder CameraX reste le chemin reel) ; `FixtureFrameSource`
(qaDeterministic seulement) lit la fixture CI. CE NIVEAU NE PROUVE PAS :
permissions CameraX, vrai Recorder, autofocus, micro, pilotes OEM (niveaux A/C).
Fixture = testsrc2 1280x720 30 fps 4 s + bip 1 kHz, generee par ffmpeg en CI
(jamais commitee), oracle = qa-oracle/fixture_qa.ffprobe.json.

## Credits et transactions (s6)
- Seed : `CreditPolicy.seedDecision` = 3 une fois (ligne Room absente, aucun
  grant serveur/fingerprint connu) ; demo onboarding = seed teste separement.
- Reservation : `atomicDebit` SQL conditionnel (solde > 0) + journal RESERVED.
- Confirmation : worker `Result.Success` -> CONFIRMED.
- Compensation : `Result.Failure` -> atomicCompensate(plafond 3) + COMPENSATED,
  idempotent ; retry = reservation conservee.
- Autorite C06 : `ExportWorker.doWork` refuse toute execution sans journal
  RESERVED (appel direct worker inclus).
- Serveur staging (Worker/D1/B2) : NON provisionne cette session (0 FCFA) :
  scenarios cote serveur = BLOCKED, equivalents locaux = PASS_JVM.

## Scenarios C01-C12 : etat
| ID | Etat | Preuve |
|---|---|---|
| C01 | PASS_JVM | CreditPolicyTest#C01 |
| C02-C04 | PASS_JVM (solde) / BLOCKED_DEVICE (3 MP4 reels) | CreditPolicyTest#C02 |
| C05 | PASS_JVM + hygiene CI / inventaire MediaStore = READY_TO_RUN (DeviceInventoryTest, runner operateur) | CreditPolicyTest#C05 |
| C06 | PASS_CODE (worker autorite) / execution device BLOCKED | doWork check |
| C07 | PASS_JVM (politique) / concurrence DAO = BLOCKED_DEVICE | CreditPolicyTest#C07 |
| C08 | PASS_JVM (politique) / panne reelle = BLOCKED_DEVICE | CreditPolicyTest#C08 |
| C09 | PASS_JVM | MonotonicAnchor + CreditPolicyTest#C09 |
| C10 | PASS_JVM local + PASS_MOCK protocole (reset/install/verify/replay, staging local Node) / execution device READY_TO_RUN (runner operateur) | CreditPolicyTest#C01 + mock-server/PROOF-C10.txt + AuthorityC10Test |
| C11 | PASS_JVM | GuardTest (integrity SHA) |
| C12 | PASS_CI | run CI releaseCandidate + sha256 APK |

## UI/UX (s5)
- coverage-manifest.csv : etats atteignables + statuts ; BLOCKED = non certifie.
- Tarifs : assertions semantiques exactes "500 FCFA", "3 000 FCFA / 30 j",
  "7 500 FCFA / 30 j" + footnote BCEAO 655,957 (PaywallUiCheckTest).
- Couleurs : scan pixel capture non compressee #F95C0F / #022358 (aplat charte).
- 197 maquettes Drive = reference visuelle ; mapping app = lignes du manifeste,
  pas une promesse de 197 captures.

## C15 — Banc self-hosted (staging local, 0 FCFA)
- mock-server/ : Node PUR (zero dependance npm), ports 3200 HTTP (QA locale).
  Roles : auth SSO sans telephone, api (pricing UEMOA miroir de l'enum Plan :
  500/3 000/7 500 FCFA), storage, authority C10 (reset/install/verify + rejet
  du replay + grant de bienvenue unique par empreinte).
  Preuve protocole executee : mock-server/PROOF-C10.txt (sandbox, 31/10/2026).
- Endpoint injectable : -PvvApiBaseUrl (defaut production inchange, zero breaking).
- app/src/androidTest : 5 tests instruments (AuthorityC10Test, WelcomeGrantTest,
  PricingMirrorTest, DeviceInventoryTest, AppLaunchSmokeTest) — compiles en CI
  deterministe (assembleDebugAndroidTest), EXECUTES sur runner self-hosted.
- Workflows : qa-interactive-selfhosted.yml (workflow_dispatch, emulateur KVM
  headless swiftshader ou appareil physique adb WiFi), mock-server.yml (systemd
  vv-mock), cleanup.yml (sur : jamais rm -rf ~/.gradle/caches).
- Runbook operateur : scripts/setup_runner.sh (Ubuntu 22.04, JDK 17, SDK 34,
  AVD pixel_6_pro, runner label android-qa, ufw deny incoming, mock systemd).
- HONNETETE : l'execution device reste READY_TO_RUN tant qu'aucun runner
  self-hosted n'est enregistre (pas de faux PASS ; la file d'attente GitHub
  est l'etat visible). Corrections du doc Agent 2 appliquees (repo reel,
  tarifs officiels, taches Gradle flavors, avdmanager, Appium->UiAutomator natif).

## AUDIT FINAL (31/10/2026) — bugs trouves et corriges en autonomie
1. SSO production casse : AuthActivity ne renvoyait jamais l'ID token Firebase
   => welcome-grant en Bearer vide = 401 = credits bienvenue jamais attribues.
   Corrige : FirebaseAuthGateway renvoie (uid, token), E2 le transmet.
2. Webhook facturation JAMAIS operationnel : INSERT dans `orders` (0001 =
   table des RENDUS, colonnes inexistantes) + subscriptions.started_at NOT NULL
   non fourni + statut prestataire "paid" != "active" attendu par
   recomputeEntitlements (marchand payant = avantages gratuits).
   Corrige : migration additive 0008_billing_orders.sql, started_at/renews_at
   serves, normalisation paid->active. Prouve localement (wrangler + D1) :
   500/3000/7500 -> avantages exacts ; refunded -> canceled ; CI API Security verte.
3. Anti-rejeu webhook : replay signe = 200 duplicate (zero double credit),
   JSON protege (400), champs requis (400), montant hors grille (422).
   5 controles automatises dans security-ci.mjs.
4. Cul-de-sac export : aucun observateur WorkInfo = ecran fige sur
   « export en cours » pour toujours. Corrige : suivi SUCCEEDED/FAILED,
   bouton Partager (FileProvider video/mp4), bouton Voir mon espace.
5. Espace marchand orphelin : Dashboard/Parrainage/Reglages inatteignables.
   Corrige : actions implicites VIEW_PAYWALL (depuis le gate 0 credit, D13)
   et VIEW_DASHBOARD (depuis la fin d'export), graphe modules respecte.
6. Checkout paywall decoratif : le bouton ne faisait que finish(). Corrige :
   ouverture reelle de la page CinetPay (site_id injectable -PvvCinetPaySiteId,
   absent = message honnete).
7. i18n E9/E10/E11/E12 : textes Compose codes en dur en francais. Corrige :
   49 cles x4 langues ; FR identique (tests tarifs inchanges).
8. Repli hors-connexion E2 (D19) : bouton dedie, session locale, x4 langues.

## Bugs 9 et 10 (audit final, keys Firebase) — identite marchande cassee
9. Credits de bienvenue INVISIBLES cote serveur : `welcome-grant` ecrivait
   `signup_fingerprint` dans `merchants` (id = UUID de profil commerce, 0001)
   alors que les routes mobiles passent `users.id` => UPDATE 0 ligne =>
   `/me/entitlements` renvoyait `welcome_credits_left: 0` pendant que le ledger
   `welcome_grants` creditait bien 3. Reproduction reelle : token du projet
   Firebase de production + wrangler/D1 local.
10. Parrainage R8 hors service : `ensureReferralCode` tournait 5 UPDATE a
    0 ligne puis levait `refcode_collision` => `/me/referral` HTTP 500 pour
    tous les comptes ; `/me/referral/claim` ne trouvait jamais de code.
Correctif : migration additive **0009_merchant_identity.sql** (table dediee,
cle = users.id, reprise des donnees eventuelles) + 6 correctifs dans les routes
Phase B uniquement (coffre-fort 0001-0003 et routes Phase A intacts).
Prouve : grant 3 -> entitlements 3 -> 3→2→1→0 strict -> 4e reste 0 ;
referral 200 + code ; D13 empreinte unique ; claims truques/JWT imite = 401 ;
isolation inter-comptes. 7 controles automatises ajoutés a security-ci.mjs.

## Reserves honnetes (non-bloquantes GO, a planifier)
- feature-editor = placeholder vide (E10 edition autonome non developpee ;
  le montage 1,5 s est pilote par le gabarit dans camera/export).
- 280 SFX = catalogue/spec exact dans les 30 gabarits ; banque audio et
  mixage local (ducking, mastering -14 LUFS) = AudioChain specifie et teste,
  execution prevue banc ffmpeg/cloud, PAS dans l'export local actuel.
- Adaptateur webhook CinetPay brut -> format interne signe : a developper
  (route additive) ; la chaine interne est prouvee de bout en bout.
- Avantages des cartes paywall (PaywallMapper) et sous-libelles ReferralGauge
  restent FR (objet pur sans contexte) ; ecrans principaux sont x4.
- C02-C04 (3 MP4 reels), C05-C08 partie device, E10-E12 visuels =
  READY_TO_RUN sur runner self-hosted (C15), jamais masques en PASS.
- URL checkout CinetPay : sandbox -> production (1 ligne apres validation).

## Reproduction
git checkout <sha> && ./gradlew ktlintCheck detekt testDebugUnitTest \
  :app:testReleaseCandidateDebugUnitTest :app:testQaDeterministicDebugUnitTest \
  checkModuleGraph :app:assembleReleaseCandidateRelease

---

## Phase C (31/10/2026) — Audio : BGM distant + banque SFX embarquée

### Livré et prouvé

| Élément | Preuve |
|---|---|
| Structure B2 `audio/bgm/` (30 dossiers + `STRUCTURE.json`) | `ListObjectsV2` → 31 objets ; credentials …009 validés (HTTP 200) |
| Migration `0010_audio_catalog` (30 pistes, seed gabarits × matrice, 0 écart) | D1 local : `SELECT COUNT(*)` → 30 |
| `GET /api/v1/audio/catalog` (auth) | 401 sans jeton ; 200 + 30 pistes + 6 secteurs + BPM/genre/format |
| `GET /api/v1/audio/track/{categorie}` (auth) | sonde réelle uploadée sur B2 → **200** stream `audio/mp4`, `Cache-Control: immutable 30 j`, ETag ; `Range: bytes=0-99` → **206 + Content-Range** ; objet absent → 404 `track_not_uploaded` ; catégorie inconnue/injection chemin → 404 `unknown_track` ; self-heal `statut=EN_LIGNE` vérifié |
| Cache bord sans Authorization | `CF-Cache-Status: HIT` observé en local (miniflare persistant) ; 2ᵉ GET servi en 7 ms |
| Banque SFX **physiquement embarquée** | 9 WAV 48 kHz mono 16 bit, durées exactes du contrat, 574 Ko, manifeste schéma v1.3, régénération bit-à-bit identique ; `SfxBankContractTest` (JVM) |
| Cache définitif téléphone | `BgmStore` (files/bgm, téléchargement unique, temp+rename atomique, vérif Content-Length) ; câblé sur `pickGabarit()` (le gabarit choisi pilote le morceau) ; parseur testé JVM |
| Suite API Security | **49/49 PASS** (worker frais, D1 propre, B2 réel) |

### Bugs trouvés et corrigés pendant la phase C

| # | Bug | Correctif |
|---|---|---|
| **13** | Réponse `Range` servie depuis le cache bord (200 complet au lieu de 206) : le cache ne varie pas selon Range | Requêtes avec `Range` contournent le cache (lecture ET écriture) ; 206 vérifié |
| **14** | `cache.match` non protégé → 500 si la couche cache est indisponible (révélé en local par suppression du répertoire cache à chaud) | try/catch : le cache est un accélérateur, jamais une dépendance |

### Réserves honnêtes (phase C)

1. **30 morceaux réels à téléverser** (cahier des charges non approvisionné — acquisition
   humaine, licence CC0/vérifiée) : procédure `docs/AUDIO_BGM_TELEVERSEMENT.md`.
   Tant que les fichiers sont absents, la route répond 404 `track_not_uploaded`
   et l'app continue sans musique (jamais bloquant).
2. **Banque SFX en attente d'écoute humaine** : `revision_humaine_approuvee=false`
   (le schéma v1.3 exige `true`, qui ne peut être posé que par une oreille).
   Approbation : `python3 scripts/audio/generate_sfx_bank.py --approuver`.
3. Le Worker **déployé** (0.9.0) ne contient pas encore la Phase B/C :
   `npx wrangler deploy` + migrations `--remote` requis (action humaine,
   credentials Cloudflare).

---

## Phase D — Bibliothèque BGM 600 pistes & déploiement production autonome (31/10/2026)

| # | Contrôle | Attendu | Preuve |
|---|---|---|---|
| D1 | Générateur déterministe 600 pistes | 600 MP3, seed crc32(piste_id), RMS≈−16 dBFS, peak≤0,84, fondu 1,5 s | `scripts/audio/generate_bgm_library.py`, manifeste sha256 |
| D2 | Étiquette d'honnêteté | `origine=synthese_procedurale_v1`, `licence=CC0-1.0` (≠ masters humains du LISEZ_MOI) | manifeste + migration 0011 + check CI |
| D3 | Téléversement B2 autonome | 600 objets `audio/bgm/**`, PUT×8 parallèles, sha vérifié pré-PUT | `ingest_bgm.py --upload` + `--sync-check` |
| D4 | Table `bgm_library` | 600 lignes, index categorie/secteur | migration 0011 (locale + distante) |
| D5 | Route bibliothèque | `GET /api/v1/audio/library` 401 sans jeton, 200/total=600/100 par secteur avec jeton | suite sécurité (contrôles dédiés) |
| D6 | Priorité master humain | track = m4a → mp3 titulaire → 1re variation bibliothèque | `routeAudioTrack` + suite |
| D7 | Catalogue `disponible` | true si EN_LIGNE **ou** variation en bibliothèque (JOIN) | `routeAudioCatalog` + check CI |
| D8 | Secrets CI B2 | paire `…009` injectée au worker CI → streaming réel en 200 (branche 404 tolérée hors ligne) | workflow + run |
| D9 | Déploiement production | workflow `deploy-production.yml` (dispatch) : deploy + migrations 0001→0011 + smoke 401/401/401 | run GitHub Actions |
| D10 | Icône application | monochrome adaptive ajouté (`ic_launcher_monochrome` ×5 densités + `<monochrome/>`) ; logo officiel vérifié (couleurs #022358/#F95C0F, safe zone 54 %) | commit icônes + APK CI |

### Repro locale (Phase D)
```bash
python3 scripts/audio/generate_bgm_library.py --out /tmp/bgm_out --manifest /tmp/bgm_lib_manifest.json
python3 scripts/audio/ingest_bgm.py --emit-sql
npx wrangler d1 execute vitrine-video-db --local --file=db/migrations/0011_bgm_library.sql
B2_KEY_ID=… B2_APPLICATION_KEY=… python3 scripts/audio/ingest_bgm.py --upload --sync-check
npx wrangler dev --port 8788   # puis
node scripts/security-ci.mjs --base-url http://127.0.0.1:8788
```
