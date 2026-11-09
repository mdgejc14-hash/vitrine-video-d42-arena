# D42.28 — Checkpoint 00 : plan, état et journal

Mission : finalisation commerciale intégrale (Firebase, audio, offline,
livraison officielle). Budget 0 FCFA. SKYPAY = seule non-configuration
volontaire. Point de départ : D42.27 close à 8d530b1 (release d42.27-rc12).

## Ordre de la mission (§11) et état

| # | Tâche | État |
|---|---|---|
| 1 | Retrouver le dernier checkpoint GitHub | FAIT — main = 8d530b1, runs 42664670953/42664671112 SUCCESS ; workspace cohérent ; PAT fondateur renouvelé (09/11, stocké chmod 600) |
| 2 | Corriger la configuration Firebase du build | FAIT — d027e2b (voir § P0) |
| 3 | Démontrer la configuration Google/Firebase de production | EN COURS — runs d027e2b en validation ; job auth-officiel-playstore prêt pour la RC13 |
| 4 | Audit audio ciblé + corriger les pistes défectueuses | PRÊT — script + workflow écrits, en attente de commit/push |
| 5 | Corriger les clés titulaires B2 manquantes | PRÊT — intégré au même workflow (ré-ingestion des absentes avec v01 corrigé) |
| 6 | Terminer les deux tests offline PARTIAL | PRÊT — banc A (export offline) + banc B (rejeu idempotent) écrits |
| 7 | Non-régression ciblée | À FAIRE après 4-6 |
| 8 | Construire et signer la nouvelle APK (RC13) | À FAIRE (tags d42.28-build-* / d42.28-rc* déjà acceptés) |
| 9 | Valider l'APK signée | À FAIRE (release-official-e2e inclut le nouveau job auth) |
| 10-11 | Documentation + rapport final + release | À FAIRE |

## P0 — Firebase (défaut prouvé, correctif poussé)

**Preuve du défaut** : analyse binaire des dex de l'APK rc12
(ef85cff7…0655) → 1× `AIzaSyD42LABDUMMYKEY`, **0 clé réelle** →
l'inscription Google de la RC12 était inopérante.

**Correctifs (commit d027e2b)** :
- `release-official-build.yml` : injection
  `ORG_GRADLE_PROJECT_vvFirebaseApiKey` (secret FIREBASE_WEB_API_KEY,
  jamais affiché/committé) + pré-vol + **PORTE post-build** (le dex doit
  contenir la clé réelle, PAS la factice — comparaison binaire).
- `android-ci.yml` + `android-e2e-lab.yml` : même injection pour tous les
  builds de test (identifiant client PUBLIC, APK jamais artefact).
- `release-official-e2e.yml` : tags d42.28-rc* + **job
  auth-officiel-playstore** : banc auth sur l'APK OFFICIELLEMENT SIGNÉE
  (image GMS playstore) — prouve ensemble : clé réelle dans le dex signé,
  certificat officiel 758077eb…33e192, ET l'ouverture du vrai bottom sheet
  Credential Manager (n'arrive QUE si package + SHA-1 officiel + OAuth
  client sont déclarés côté Google/Firebase).

**Mécanisme prouvé antérieurement** : workflow
android-e2e-production-equivalent, run 42482295447 SUCCESS (08/11) —
« propriété = secret (env ORG_GRADLE_PROJECT résolu) », BuildConfig avec
clé réelle, dex vérifié binairement, parcours P0/P1 complets.

**Configuration réelle (fournie fondateur 31/10, gradle.properties)** :
project « vitrine-video » (FirebaseAuthGateway), numéro 609889830251,
web app id 1:609889830251:web:3fbac877b49c108a93782e, OAuth client
609889830251-484f8cs7k48bmegr60stddn2514beht1.apps.googleusercontent.com,
Worker https://vitrine-video-api.mdgejcinfluence.workers.dev.

**Premiers résultats d027e2b** : android-ci 42690012981 SUCCESS ;
e2e-lab 42690012987 en cours — job auth **11/11 avec la clé réelle**
(A1 vrai flux Credential Manager, échec propre, repli, zéro crash).

**Reste à prouver pour la porte P0** : le build release-official (rc13)
avec la porte dex ; le job auth-officiel-playstore sur l'APK signée.
Le choix d'un VRAI compte Google = test physique fondateur (jamais
simulé, jamais déclaré fait).

## P1 — Audio (prêt, en attente de push)

**Audit (artefact 13643105300, 09/11)** : 600/600 EN_LIGNE, sha conformes,
décodables, 0 clipping, RMS -18,7…-14,8 dB (σ 0,81 dB) — MAIS attaque
(premier son @ -40 dB) **min 1,03 s / max 3,18 s sur les 600** → toutes
défectueuses au critère « attaque audible < 0,5 s » (mission §4.C :
correction des 600 autorisée dans ce cas).

**Correctif déterministe** (`scripts/audio/fix_initial_silence.py`,
testé localement sur signal synthétique : attaque 2,3 s → 0,12 s, RMS
préservé à ±0,2 dB, 0 clipping) :
- GET B2 original (contrôle sha manifeste v2) → atrim (attaque - 120 ms)
  + afade 0,4 s → MP3 CBR 128 k 44,1 kHz stéréo ;
- contrôles : attaque < 0,5 s, 0 clipping, décodable, RMS ±1,5 dB,
  durée ≥ 10 s — **garde : SI UNE piste échoue → AUCUN upload** ;
- **nouvelles clés audio/bgm_r2/… (jamais d'écrasement** — originaux
  audio/bgm/… intacts en B2) ;
- **titulaires** : HEAD des 60 clés audio_catalog (seed 0010) →
  ré-ingestion UNIQUEMENT des absentes (54 attendues) avec le v01 corrigé
  (.mp3 + .m4a AAC 128k) — équivalence prouvée par le design même du
  repli worker (« master titulaire prioritaire, sinon repli variation 1 »,
  src/index.js routeAudioTrack) ;
- produit la migration D1 0013_bgm_library_r2.sql (artefact — appliquée
  séparément par deploy-production, acte délibéré).

Workflow `audio-fix-silence.yml` (workflow_dispatch, inputs limit/upload),
secrets B2_KEY_ID/B2_APPLICATION_KEY, ffmpeg via apt, artefact 30 jours.

**Déploiement après validation** : commit 0013 + manifeste r2 →
deploy-production (migrations D1) → re-audit audio (audio-audit.yml
workflow_dispatch full=true) → attente : attaque < 0,5 s sur 600/600,
titulaires 200 sans repli.

## P2 — Offline (prêt, en attente de push)

**Banc A** `tools/e2e/run_offline_export.sh` + job
`android-e2e-offline-export` : réseau ON au départ (langue, démo,
catalogue, sélection gabarit → prefetch BGM), **surveillant** qui coupe
le réseau (svc wifi+data disable, preuve dumpsys horodatée) dès que
files/bgm/*.mp3 existe, puis run_p1.sh complet (brief, tournage, aperçu,
export) SANS Internet. Preuves : export.mp4 + ffprobe + décodage,
journal export_journal (Room), rushs finaux, retour réseau sans crash.
NB : ExportWorker marque CONFIRMÉ localement ; jeton démo jamais envoyé
ni mis en file (BackendSync.postQuotaOrQueue) — aucun double débit
possible par conception.

**Banc B** (security-ci.mjs, harnais worker local node 22) : rejeu du
MÊME eventId sur /api/v1/quota/consume ×3 → attendu { ok:true, dup:true }
(INSERT OR IGNORE quota_ledger, PK event_id) et crédits TOUJOURS 1 —
c'est le comportement du flush d'outbox (replayPendingQuota) après retour
réseau. Chaîne de crédits mise à jour : 3 → 2 → 1 → rejeux ×3 → 1 →
tentatives refusées → 1.

## Règles en vigueur

- Ne rien pousser pendant un run utile (cancel-in-progress e2e-lab).
- 0 FCFA ; aucun secret en commit/log ; originaux audio jamais écrasés ;
  les 600 compositions modifiées UNIQUEMENT sur défaut démontré
  (ici : toutes, preuve citée) ; jamais de PASS sans preuve ; GitHub =
  mémoire durable (ce checkpoint en fait partie).
