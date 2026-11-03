# RAPPORT D'AUDIT D41 — Mission « Audit adversarial total + simulation intégrale + validation physique + i18n + conformité »

**Projet** : Vitrine Vidéo INS (Android natif Kotlin/Compose + Cloudflare Worker/D1)
**Dépôt** : `mdgejc14-hash/vitrine-video` — branche d'audit `audit-d41` (base `main` @ `74edd98`, backup `backup/pre-d41`)
**PR** : #2 — https://github.com/mdgejc14-hash/vitrine-video/pull/2
**Date** : 2026-11-02 (fuseau Africa/Lagos)
**Auteur** : Agent d'audit autonome D41 (mode couteau suisse D17, contraintes D18/D21/D36/D40-0.5)
**Findings** : `audit_d41/FINDINGS.md` (F1–F69, v1 + v2) — ce rapport en est la synthèse exécutive et la matrice de validation.

> **Avertissement d'honnêteté (exigence D41 §23)** : ce rapport ne prétend JAMAIS à un système « absolument sans faille ».
> Chaque affirmation est classée par niveau de preuve (section C). Ce qui n'a pas pu être exécuté physiquement
> (rendu MP4 réel, typographie CJK sur écran, biométrie, paiements réels) est déclaré **NON TESTABLE** avec la raison
> exacte, et n'est JAMAIS présenté comme validé.

---

## A. Résumé exécutif

### A.1 Verdict global

| Domaine | Verdict | Détail |
|---|---|---|
| **Chaîne de montage (moteur)** | CORRIGÉE, non-régressée | F58 (mixeur multi-rushs cassé — PREUVÉ sources Media3), F62 (typographie), F55 (décalage rushs), F57/F59/F60 |
| **Autorité serveur** | RENFORCÉE | F10 (checkout/notify CinetPay réels), quota eventId+empreinte, webhook plan dans la grille, F42 bootstrap |
| **Sécurité Android** | 1 P1 corrigée | F63 vol de session par app tierce (AuthActivity exportée + setResult jeton) |
| **Crédits/offline** | CORRIGÉS | F14 double-débit + orphelines, F27/F30 replay, F38 purge/isolation uid, F30b seed honnête |
| **Parcours client A→Z** | BOUTONS MORTS ÉLIMINÉS | F49/F52/F53 (caméra), F5/F6 (dashboard), F34/F64 (liens), F66 (code parrain) |
| **i18n FR/EN/ES/JA** | CHROME 100 %, gabarits ISOLÉS | F8/F33/F44/F67/F68 corrigés + couverture CI ; textes marchands des 30 gabarits = décision éditoriale isolée |
| **Paiements Mobile Money** | ARCHITECTURE PRÊTE DÉMONTRÉE | CinetPay (FCFA/XOF) : checkout serveur, vérification notify, idempotence — 501 honnête sans clés |
| **Conformité/consentements R4** | ENREGISTREMENT SERVEUR | F56 : dialog → POST /consents (scopes visage/mineur), ConsentGate local reste l'autorité du recorder |

**30 findings corrigés à la racine** (jamais de sécurité désactivée, jamais de masquage), **3 isolés/documentés**
(F61 doc≠code sans impact, F65 permissions biométrie sur-déclarées, F69 badge collecté non consommé — décision
produit ambiguë), **9 suites de tests de non-régression ajoutées** (dont fuzz à graine fixée, property-based
10 000 tirages, 120 combinaisons gabarit×langue, faux délégue observant le contrat Media3 réel).

### A.2 Chiffres clés de la mission

- **74 fichiers** touchés, **10 commits** logiques (D17), 0 push sur `main`, 0 déploiement (D40-0.5/D41 §21).
- **69 findings** documentés (F1–F69), dont **5 P0/P1 sécurité ou monétaires** : F42, F58, F62, F63, F10 (+ F14, F41, F53, quota-eventId, quota-fp en P1).
- **Preuve la plus forte** : F58 démontrée par lecture des SOURCES de Media3 1.11.1 (`AudioGraph.java:315/359`) + test de non-régression à faux délégue qui observe les appels réels (`addSource`/`configure`), pas une simulation déclarative.
- **3 CI GitHub Actions** exploitées sur la branche : `android-ci` (ktlint+detekt+tests unitaires+graphe modules+APK+visual), `API Security CI` (wrangler dev + D1 locale + 30+ sondes adversariales), `Phase A safe validation`.
- **CI FINALE VERTE en entier** : `android-ci` run **41427854165** sur le commit **`6f18bc2`** — ktlint ✓ detekt ✓ **tous les tests JVM** (dont les 10 nouvelles suites : 46 tests ins-effects, 120 combinaisons data, 10 000 tirages core-guard, Robolectric ×4 langues) ✓ graphe de modules ✓ **APK debug + APK RELEASE signé officiel R8 full** ✓ contrôle de signature ✓ mapping R8 publié ✓ **Lint cible 36** ✓. `API Security CI` et `Phase A` verts sur le même commit.

---

## B. Méthodes d'audit — matrice « réellement appliquées vs impossibles »

Exigence D41 §11 : ≥ 10 méthodes, avec tableau honnête. Légende : **APPLIQUÉE** (exécutée, preuves conservées) /
**PARTIELLE** (exécutée avec limites déclarées) / **IMPOSSIBLE** (environnement) — jamais transformée en preuve.

| # | Méthode | Statut D41 | Preuve / raison de l'impossibilité |
|---|---|---|---|
| 1 | **SAST** (detekt + ktlint, config durcie D41) | APPLIQUÉE | CI `android-ci` sur chaque push ; 2 violations détectées puis corrigées (LongMethod, CC 15) — le SAST a réellement mordu |
| 2 | **DAST production** (sondes HTTP adversariales) | PARTIELLE | Sondes vertes sur `vitrine-video-api.*.workers.dev` (auth, JWT, CORS, throttling) ; routes billing/consents = 404 attendu PRÉ-DÉPLOIEMENT (aucun deploy autorisé D41 §21) → DAST complet des nouvelles routes = sur CI locale wrangler (méthode 3) |
| 3 | **DAST local** (wrangler dev + D1 + security-ci.mjs) | APPLIQUÉE | CI `API Security CI` verte ×2 : 30+ sondes (400 eventId vide, 403 empreinte non liée, 422 plan hors grille/absent, 501 checkout honnête, notify sans crédit aveugle, 401 anonymes, droits inchangés après attaques) |
| 4 | **SCA / SBOM** | PARTIELLE | Inventaire dépendances (gradle libs.versions.toml + wrangler) ; versions Media3 1.11.1/Compose/Room figées ; pas d'outil de CVE scanning offline en sandbox (pas de réseau vers les bases NVD) → vérification manuelle des versions connues |
| 5 | **STRIDE + arbres d'attaque** | APPLIQUÉE | F63 (Spoofing/Info Disclosure — vol de jeton), quota-fp (Elevation — décrément croisé), AuthActivity deep link, threat model par parcours (section J) |
| 6 | **OWASP MASVS / ASVS / API Top 10** | APPLIQUÉE | MASVS-STORAGE (allowBackup=false ✓ APK), RESILIENCE (libvvguard ×4 ABI ✓, R8 ✓), AUTH (JWT RS256 JWKS ✓) ; API Top 10 : API1 BOLA (isolation uid F38), API2 auth (401 sondés), API4 rate limiting (throttle 300/10 s), API8 sécurité intégrations (webhook HMAC + plan dans grille) |
| 7 | **NIST SSDF** | APPLIQUÉE (mapping) | Pratiques PO/PS/PW/RV mappées sur le pipeline existant (branche protégée de fait, CI, backup, keystore sha256 documenté, secrets hors dépôt) — section N |
| 8 | **Model-based testing** | APPLIQUÉE | Modèles d'états : ExportGate (intégrité→rollback→crédits→ALLOW), caméra (slot→prise→finalisation→skip), CreditPolicy (seed/débit/compensation/réservation) — tests exhaustifs des transitions |
| 9 | **Property-based testing** | APPLIQUÉE | `CreditPolicyPropertyTest` : 10 000 tirages/invariant, graine 987654321 (reproductible) — masse monétaire conservée, seed borné 0..3, refus ≤ 0 débité, compensation idempotente, exportAllowed ⟺ solde>0 ∧ réservation, priorités de refus |
| 10 | **Fuzzing** | APPLIQUÉE | `MotionJsonFuzzTest` (400 mutations graine 424242 + tronçatures), `GabaritFuzzTest` (100 mutations × 8 gabarits réels, graine 20261102) — contrat : SEULES JSONException/IllegalArgumentException/NumberFormatException tolérées, tout autre type = crash de rendu (F18/F57) |
| 11 | **Mutation testing** | IMPOSSIBLE en sandbox | Gradle lourd interdit (D18) ; PR jetable dédiée (phase L) = plan documenté, non exécutée à ce jour — ne jamais compter comme faite |
| 12 | **Fault injection / chaos** | PARTIELLE | Injection réseau : offline (WelcomeRepository repli cache/seed), 5xx vs 4xx (purge F38), rollback horloge (clockRollbackDenies), fichier manquant (input manquant → compensation), Finalize échoué (F53) ; pas de chaos infra réel (pas d'accès prod autorisé) |
| 13 | **Contract testing** | APPLIQUÉE | Contrats extraits des SOURCES (AudioMixer.java, BitmapOverlay/TextureOverlay.java, AudioGraph.java) + contrat serveur réel relu AVANT chaque client (F56 sendConsents, F10 checkout/notify, /me/bootstrap, /me/referral) ; faux délégue = consommateur du contrat |
| 14 | **Visual regression** | PARTIELLE | `DashboardL10nCheckTest` Robolectric NATIVE ×4 langues avec captures PNG (build/visual-check/l10n-*.png) + PaywallUiCheckTest existant ; rendu CJK PHYSIQUE sur appareil = NON TESTABLE (pas d'émulateur/KVM en sandbox) |
| 15 | **Perf / Macrobenchmark** | IMPOSSIBLE | Nécessite appareil physique/émulateur (profil R) ; budget temps de composition ≤ 1,5 s/plan validé statiquement (120 combinaisons), latence B2 documentée |
| 16 | **Combinatoire / valeurs limites** | APPLIQUÉE | 30 gabarits × 4 langues = 120 combinaisons construites ET vérifiées (plans ≤ 1,5 s, timecodes, SFX dans fenêtre +500 ms, ducking ∈ [-30, 0]) ; limites : crédits 0/1/3, eventId "", empreintes 15/16 caractères, montants hors grille |
| 17 | **Inspection binaire (APK CI)** | APPLIQUÉE | APK run 41330211303 : sha256, manifest dump (exported, allowBackup=false, target 36), assets 30 gabarits + 9 SFX, libvvguard ×4 ABI, R8 mapping, polices (aucune embarquée → CJK = Noto système) |
| 18 | **Analyse audio réelle (FFprobe/ebur128)** | APPLIQUÉE (D39/D40) | 600 pistes B2 mesurées LUFS ≈ -16 ; mixage BGM -20 dB/SFX -25 dB vérifié dans le CODE (MixPlan) + contrat ducking testé (F58/F59) ; rendu audio d'un export PHYSIQUE = NON TESTABLE sandbox |

**Bilan : 12 méthodes APPLIQUÉES, 4 PARTIELLES, 2 IMPOSSIBLES** (mutation testing, Macrobenchmark) — conformément
à l'exigence « ≥ 10 méthodes réellement appliquées ».

---

## C. Hiérarchie des preuves (5 niveaux, exigence D41 §6)

| Niveau | Définition | Exemples D41 |
|---|---|---|
| **1 — Preuve physique/exécution réelle** | Artefact mesuré d'un système qui a réellement tourné | CI GitHub Actions (compilation, tests JVM exécutés, APK signé debug produit, wrangler dev + D1 réelle sondée), APK inspecté (sha256, aapt dump), pistes audio B2 mesurées FFprobe |
| **2 — Sources faisant autorité** | Code tiers/de référence lu directement | Media3 1.11.1 `AudioGraph.java:315/359` (F58), `TextOverlay.java`/`BitmapOverlay.java` (F62), docs CinetPay officielles (F10), wrangler/D1 schémas migrations 0001–0012 |
| **3 — Tests automatisés exécutés** | Assertions passées dans la CI | 9 nouvelles suites (mixeur, slots, typographie, fuzz ×2, 120 combinaisons, propriétés crédits, i18n couverture, Robolectric ×4 langues) + suites existantes |
| **4 — Analyse statique / revue de code** | Lecture contradictoire du code du dépôt | F1–F69 (chaque finding cite fichier:ligne), revue chaîne complète UI→backend pour chaque bouton (section H) |
| **5 — Simulation / inférence documentée** | Raisonnement sur comportement NON exécuté | Parcours client simulés sur maquette d'états (section G) — TOUJOURS marqués « simulation », jamais promus en preuve physique |

**Règle appliquée sans exception** : une simulation (niveau 5) n'est JAMAIS présentée comme une validation physique
(niveau 1). Les cases « VALIDÉ PHYSIQUEMENT » de la matrice (section O) ne contiennent que du niveau 1–3.

---

## D. État des lieux initial (Phase 1) et analyse contradictoire (Phase 2)

### D.1 Périmètre réel vérifié (le code = source de vérité)

- **Android** : 11 modules Gradle (app, core-model, core-guard, core-designsystem, data, ins-effects, feature-onboarding/-dashboard/-brief/-catalog/-camera/-export). Chaîne vérifiée : `OnboardingActivity` → `AuthActivity` → `CatalogActivity` → `GabaritBriefScreen` → `CameraGuideActivity` (3 prises) → `ExportActivity`/`ExportWorker` → `DashboardActivity` (paywall/parrainage/réglages).
- **Serveur** : Worker unique `src/index.js` (≈ 5 900 lignes) + D1 (migrations `0001`–`0012`, coffre-fort : 0001–0003 JAMAIS touchées, D16) ; `wrangler.jsonc` ; routes `/api/v1/*` (auth, me/bootstrap, me/referral + claim, welcome-grant, quota/consume, consents, billing/checkout + notify + return, webhook interne HMAC, pricing).
- **Assets** : 30 gabarits JSON (6 secteurs × T1–T5), 9 SFX, 600 pistes BGM B2 (LUFS ≈ -16 mesurées D39), libvvguard ×4 ABI.
- **Infra** : GitHub Actions ×3 workflows ; Cloudflare (compte, D1 prod `0dacf519-…`, Workers Builds = statut INCONNU documenté) ; Firebase Auth (projet `vitrine-video` vérifié par JWT iss/aud) ; B2 `vitrine-video-media` (api005).

### D.2 Ce que l'analyse contradictoire a cassé (extraits, niveau de preuve 2/4)

1. **F58 — le mixeur audio était cassé en multi-rushs, PREUVÉ par les sources Media3** : `AudioGraph.java` (media3-transformer 1.11.1, l.315 `addSource`/l.359 `removeSource`) montre que le Transformer appelle ces méthodes PAR ITEM de séquence. L'ancien `BgmSfxAudioMixer` ré-enregistrait musique+SFX à chaque `addSource` → dès la 3e prise : BGM/SFX DOUBLÉS (+6 dB, repères rejoués en rafale) ; dès la 2e prise : `voiceSourceId` pointait une source retirée → ducking MORT. Impact direct : la promesse produit « musique -20 dB sous la voix » était FAUSSE sur tout montage ≥ 2 prises — le cas nominal du produit (3 prises, D23).
2. **F62 — la typographie cinétique ne pouvait pas fonctionner** : `TextOverlay` Media3 = taille FIXE 100 px et largeur de layout = largeur du texte (aucun wrap) → débord garanti ; et `keywords.contains(mot)` comparait des tokens blancs à des VALEURS multi-mots (« 5000 FCFA ») → le surlignage orange, argument de vente central, ne s'appliquait JAMAIS.
3. **F63 — vol de session trivial** : `AuthActivity exported=true` + `setResult(firebase_token)` → n'importe quelle app installée récupérait le jeton Firebase du compte (vérifié dans le manifest de l'APK CI, niveau 1).
4. **F42 — bootstrap jamais appelé** : sans ligne `users`, TOUTES les routes `/me/*` répondaient 404 `profile_notinitialized` — le serveur était correct, le client ne l'amorçait jamais.
5. **F10 — paiement « sandbox » inventé** : le client construisait une URL vers un hôte inexistant (NXDOMAIN démontré) ; l'API réelle CinetPay exige la clé SECRÈTE côté serveur (docs officielles relues). L'architecture est désormais PRÊTE (checkout/notify/return) — il ne manque que les clés, et le 501 honnête le dit.
6. **quota/consume — collision PK globale** : `eventId` vide accepté → le 2e appelant avec `""` était ignoré en silence (consommation jamais comptée) ; et `source=welcome` acceptait une empreinte ARBITRAIRE → décrément des crédits d'un AUTRE appareil.

---

## E. Serveur — autorité, idempotence, isolation (exigence D41 §14)

### E.1 Principes vérifiés/imposés

| Principe | État D41 | Preuve |
|---|---|---|
| Quotas/crédits/parrainage JAMAIS décidés côté client | IMPOSÉ | Le client ne fait que MIRROR (Room) ; le serveur est appelé au démarrage (bootstrap), au flush et aux portes ; `ExportGate` local n'autorise que sur données déjà servies ou seed honnête (F30b, documenté comme limite offline) |
| Idempotence | VÉRIFIÉE + DURCIE | `quota_ledger.event_id` PK (eventId désormais REQUIS, 400 si vide) ; `applyPaidOrder` point unique (statut ≠ pending → duplicate ; rejeu notify → 200 ignored) ; webhook ref idempotente ; claim UNIQUE(referred_id) ; welcome-grant anti multi-appareils/comptes |
| Isolation comptes | VÉRIFIÉE + DURCIE | JWT RS256 (JWKS, iss/aud `vitrine-video`) sur toutes les routes /me ; F38 : file locale purgée/isolée par uid (les entrées d'un autre compte ne sont jamais rejouées) ; quota welcome : empreinte vérifiée contre `merchant_identity.signup_fingerprint` (403) |
| Anti auto-parrainage / doubles attributions | VÉRIFIÉ (sain pré-existant) | Même appareil refusé, même uid refusé, UNIQUE(referred_id), paliers R8 de 5 idempotents (`reward_granted`) — re-vérifié par sondes CI |
| Paiements : montant/marchand FIGÉS au checkout | IMPOSÉ | La commande pending porte marchand+montant ; notify re-vérifie via `/v2/payment/check` et réconcilie ; plan DÉRIVÉ du montant (grille injective 500/3000/7500) ; montant ≠ commande → 422 |
| Webhook interne | DURCI | HMAC + plan OBLIGATOIREMENT dans la grille (avant : plan absent/inconnu → abonnement hors contrat) |
| Throttling | VÉRIFIÉ | 300 req/10 s/IP best-effort (sondé) ; bot-fight CF actif (UA custom requis — documenté) |
| CORS | VÉRIFIÉ | Origines contrôlées (sondes CI) ; `GET /billing/return` = page HTML no-store (aucun secret côté navigateur) |

### E.2 Sondes DAST exécutées (niveau 1 — CI verte ×2 sur `API Security CI`)

Production (avant correctifs, routes déployées) : `/health`, auth sonde (JWT iss/aud ✓), 401 anonymes ✓, throttle ✓.
CI wrangler+D1 locale (après correctifs) : bootstrap anonyme 401 ; quota eventId vide **400** ; quota empreinte non liée **403 + droits inchangés** ; webhook plan inconnu **422** ; webhook plan absent **422** ; checkout sans clés **501 honnête** ; checkout anonyme **401** ; notify corps invalide **400/501** ; consents anonyme **401** ; rejeu notify **200 ignored sans double crédit**.

### E.3 Limites serveurs documentées (honnêteté)

- **Aucun déploiement exécuté pendant D41** (règle D40-0.5 / D41 §21) : les nouvelles routes (`/billing/*`, `/consents`, `/me/bootstrap` côté client) renvoient **404 en production jusqu'au prochain deploy autorisé**. Les sondes DAST prod billing/consents = 404 ATTENDU (fingerprints `d41-probe-*`), la validation réelle s'est faite sur wrangler+D1 locale en CI.
- Workers Builds Cloudflare : statut INCONNU (jeton API client invalide en sandbox) — à vérifier avant merge : si un build auto existe sur toutes branches, `audit-d41` ne déclenche QUE le worker preview, jamais la prod (deploy = workflow_dispatch uniquement).
- Throttle best-effort (mémoire worker) : contournable par rotation d'IP — limite acceptée (coût 0 FCFA, D21), documentée.

---

## F. Sécurité Android + STRIDE (exigence D41 §17)

### F.1 Menaces traitées (arbres d'attaque simplifiés)

| Menace STRIDE | Scénario concret D41 | Traitement |
|---|---|---|
| **Spoofing** | App tierce lance `AuthActivity` et reçoit le jeton Firebase (F63) | `exported=false` ; deep link routé par MainActivity (seule exportée) ; sonde manifest APK |
| **Tampering** | Room/prefs modifiables (root) pour gonfler crédits offline | `ExportGate` : DENY_INTEGRITY si journal incohérent, DENY_ROLLBACK si horloge reculée ; le débit/récompense RÉEL ne se fait QUE serveur (quota ledger) ; libvvguard (NativeGuard ×4 ABI) + R8 |
| **Répudiation** | Export réussi nié / crédit débité sans trace | Journal d'export Room (RESERVED→CONSUMED/COMPENSATED) + télémétrie outbox (`export_fallback_script`, échecs) + ledger serveur |
| **Information Disclosure** | Écran visible pendant verrouillage ; noms de filleuls inventés/capturés ; jetons dans les logs | FLAG_SECURE (vérifié D40) ; F8/F33 historique ANONYMISÉ serveur ; secrets jamais loggés (règle D40-9.4) ; allowBackup=false (APK, niveau 1) |
| **Denial of Service** | Stockage saturé par rushs/exports jamais purgés (F50/F51) ; codec qui tourne après annulation (F24b) | Purge > 24 h au lancement + manuelle ; `invokeOnCancellation → transformer.cancel()` ; fichiers dans filesDir (quota visible utilisateur) |
| **Elevation of Privilege** | Client compromis décrémente les crédits d'un AUTRE appareil (quota-fp) ; plan d'abonnement hors grille via webhook signé (F-webhook-plan) | Empreinte vérifiée contre `merchant_identity` (403) ; plan obligatoirement dans `PLAN_GRID` (422) |

### F.2 Durcissements build vérifiés (niveau 1, APK CI)

R8/ProGuard actif (mapping archivé), `libvvguard.so` ×4 ABI, `allowBackup=false`, target 36, minSdk conforme,
aucune clé secrète dans l'APK (grep binaire), obfuscation moteur (D36) conservée. Keystore : sha256 `8aef33ca…6f0d`
(documenté D40, hors dépôt).

### F.3 Résidus acceptés (jamais « zéro faille »)

- F65 : `USE_BIOMETRIC`/`USE_FINGERPRINT` déclarées sans code consommateur (hygiène store, P4 — retrait à valider avec le listing).
- Bot-fight CF : les sondes nécessitent un UA custom — un attaquant informé passe cette couche (défense en profondeur : le JWT reste l'autorité).
- appId Firebase = appId WEB dans FirebaseOptions (F40) : comportement réel NON TESTABLE sans appareil ; SSO Google = prérequis externe (client OAuth Android + SHA-1 dans la console).

---

## G. Simulation intégrale du parcours client A→Z (Phase 4)

> **Marquage honnête (D41 §6)** : cette section est une SIMULATION (niveau 5) exécutée sur la chaîne réelle du code
> (chaque étape cite le fichier qui la porte) et sur les modèles d'états testés en CI (niveau 3). Aucun de ces
> parcours n'a été exécuté sur un appareil physique — déclaré NON TESTABLE physiquement en sandbox (pas d'émulateur/KVM).

### G.1 Les 33 étapes du parcours nominal (12 profils croisés)

| # | Étape | Porteur dans le code | Verdict D41 |
|---|---|---|---|
| 1 | Première ouverture (splash/onboarding) | OnboardingActivity.onCreate | ✓ jamais bloquant (D19) |
| 2 | Choix secteur (6 secteurs) | OnboardingScreens + Sector.entries | ✓ persisté prefs |
| 3 | **Hors-ligne à la 1re ouverture** | WelcomeRepository.requestGrant → seed honnête 3 crédits (F30b) | ✓ CORRIGÉ — cohérent avec la porte d'export offline |
| 4 | Connexion 1-tap Firebase (sans téléphone, D13) | AuthActivity | ✓ ; SSO Google = prérequis externe console (F40) |
| 5 | **Deep link parrain /r/CODE** | MainActivity → extra ref_code → AuthActivity (F63/F34) | ✓ CORRIGÉ — routé, AuthActivity plus exportée |
| 6 | Saisie manuelle code parrain | ReferralCodeScreen + RefCodeParser (F66) | ✓ CORRIGÉ — validation MOTIF-123, erreur visible ×4 |
| 7 | Bootstrap profil serveur | BackendSync.bootstrap (F42) | ✓ CORRIGÉ — appelé au sign-in ET onboarding |
| 8 | Claim parrain (serveur = autorité) | BackendSync.claimReferral + file rejouable (F27) | ✓ anti auto-parrainage/double attribution vérifié serveur |
| 9 | Welcome grant (3 ou 5 crédits si parrainé) | OnboardingActivity.demarrageServeur : claim PUIS grant (F41) | ✓ CORRIGÉ — ordre serveur respecté |
| 10 | Catalogue des 30 gabarits | CatalogActivity + GabaritRepository (F48 re-seed versionCode) | ✓ ; bandeau d'indisponibilité traduit (F44) |
| 11 | Sélection gabarit T1–T5 × 6 secteurs | CatalogScreen → BriefActivity | ✓ 30/30 présents (APK, niveau 1) |
| 12 | Brief E5 (champs réels du gabarit) | GabaritBriefScreen + BriefValidator (F67/F68) | ✓ CORRIGÉ — validation et libellés ×4 |
| 13 | Badge engagement (stock/places/qualité) | collecte E5 | ⚠ F69 ISOLÉ — collecté, jamais consommé par les gabarits (décision produit) |
| 14 | Consentements R4 (visage/mineur) | CameraGuideActivity dialog → sendConsents (F56) | ✓ CORRIGÉ — enregistrés serveur, ConsentGate autorité locale du recorder |
| 15 | Permission caméra | rationale + dialog réglages (F52) | ✓ CORRIGÉ — plus de bouton mort |
| 16 | Guide 3 prises (marchand : 2–4 prises, D23) | CameraGuideActivity slots indexés (F55) | ✓ CORRIGÉ — prise sautée = slot "" |
| 17 | Enregistrement prise N | VideoCapture + Finalize événementiel (F53) | ✓ CORRIGÉ — échec = fichier supprimé + message + reste sur la prise |
| 18 | Skip prise intermédiaire | skipPrise → slot vide | ✓ comblé au montage par RushSlots.resolve |
| 19 | Skip DERNIÈRE prise sans aucune prise | RESULT_CANCELED honnête (F49) | ✓ CORRIGÉ — plus d'écran muet |
| 20 | Rushs persistants | filesDir/rushes (F50) + purge > 24 h (F51) | ✓ CORRIGÉ |
| 21 | Transmission au montage | finishWithPrises → extra client_rushs padé | ✓ slots alignés |
| 21b | **Échec export** | compensation immédiate du crédit réservé + bouton rendu | ✓ CORRIGÉ (F14) |
| 22 | Gate d'export (intégrité→rollback→crédits) | ExportGate + CreditPolicy (propriétés 10 000 tirages) | ✓ priorités testées |
| 23 | Réservation crédit + anti double-tap | ExportActivity gateInFlight + bouton désactivé (F14) | ✓ CORRIGÉ |
| 24 | Beat sheet (30 gabarits × valeurs brief) | GabaritBeatSheet.build (120 combinaisons CI) | ✓ plans ≤ 1,5 s, SFX fenêtre, ducking contrat |
| 25 | Fallback script si beat sheet invalide | parseSheet + télémétrie export_fallback_script (F57) | ✓ CORRIGÉ — plus silencieux |
| 26 | Composition multi-rushs | MotionComposition + RushSlots.resolve (F55/F62) | ✓ CORRIGÉ — creux comblés voisin |
| 27 | Mixage audio (BGM duckée, 9 SFX) | BgmSfxAudioMixer (F58/F59/F60) | ✓ CORRIGÉ — musique/SFX uniques, ducking vivant, fades |
| 28 | Typographie + surlignage mots-clés | KineticTypography BitmapOverlay (F62) | ✓ CORRIGÉ — wrap, contour, CJK, orange sur tokens |
| 29 | Rendu Transformer + annulation | ExportWorker runExport + invokeOnCancellation (F24b) | ✓ CORRIGÉ |
| 30 | Vérification durée ±500 ms | ExportVerifier + expectedDurationMs (beat sheet = vérité) | ✓ replis en cascade documentés |
| 31 | Dashboard : crédits/jauge réels | miroir Room + serveurs (F1/F2) | ✓ CORRIGÉ |
| 32 | Paywall à épuisement (D13) | PaywallMapper + checkout serveur (F10) | ✓ CORRIGÉ — 501 honnête sans clés |
| 33 | Réglages (langue/secteur/accords/espace) + déconnexion | SettingsScreen (F5/F6) | ✓ CORRIGÉ — 4 boutons vivants, signOut réel |

### G.2 Parcours interrompus et adversariaux (12 profils)

| Profil / scénario | Comportement vérifié (code + tests) |
|---|---|
| **P1 Coupure réseau pendant onboarding** | seed 3 crédits honnête, claim/grant en file rejouable (flushPending), pas d'écran bloquant |
| **P2 Coupure pendant export** | WorkManager : échec → compensation crédit ; réservations orphelines > 120 s purgées au démarrage (reconcileOrphelines) |
| **P3 Kill app pendant prise 2/3** | rush 1 dans filesDir persiste ; au retour, le guide repart (pas de reprise automatique — honnête) ; purge > 24 h |
| **P4 Réinstallation** | allowBackup=false (APK niveau 1) + données serveur : le welcome-grant est ANTI multi-appareils/comptes → PAS de récupération artificielle de crédits (exigence D41 §13 respectée — vérifiée serveur, pas seulement client) |
| **P5 Changement d'appareil (même compte)** | empreinte différente → welcome-grant refusé (serveur) ; quota/consume source=welcome vérifie l'empreinte liée (403 sinon) |
| **P6 Horloge reculée** | clockRollbackDenies → DENY_ROLLBACK (porte) + compensation si débit déjà passé |
| **P7 Room/prefs modifiés (root)** | DENY_INTEGRITY (journal incohérent) ; le crédit RÉEL ne vit que serveur |
| **P8 Double-tap bouton export** | gateInFlight + bouton désactivé (F14) |
| **P9 Stockage plein pendant prise** | Finalize erreur → fichier supprimé, message ×4, utilisateur reste sur la prise (F53) |
| **P10 Code parrain invalide/inexistant** | refus client visible (F66) + refus serveur (anti auto/double) ; jamais de crédit fantôme |
| **P11 Paiement abandonné/échoué** | commande reste pending (aucun crédit) ; notify non ACCEPTED → failed + 200 ignored ; return = page HTML (pas de cul-de-sac) |
| **P12 Webhook rejeu/montant falsifié** | idempotence ref/statut + re-vérification /v2/payment/check + montant ≠ commande → 422 |

### G.3 Hors-ligne : utilisable MAIS non exploitable (exigence D41 §15)

- **Utilisable** : prise(s) caméra, montage fallback script, export si le journal local intègre montre un solde > 0 (seed 3 honnête F30b), dashboard en miroir Room.
- **Non exploitable** : tout octroi RÉEL (grant, paliers parrainage, achat, consommation définitive) passe par le serveur idempotent ; rollback horloge et intégrité refusent l'export ; la file de sync est isolée par uid et purgée des non-retryables (F38) ; le rejeu ne peut ni doubler un claim (UNIQUE), ni un grant (anti-appareil), ni une récompense (reward_granted).

---

## H. Audit boutonnerie — objectif zéro bouton mort (exigence D41 §12)

Méthode : revue exhaustive UI→callback→effet visible (niveau 4), croisée avec les tests Robolectric existants
(PaywallUiCheckTest, DashboardL10nCheckTest). Tableau condensé des écrans à boutons ; le détail finding-par-finding
est dans FINDINGS.md.

| Écran | Bouton/interaction | Callback | Résultat visible | Verdict |
|---|---|---|---|---|
| Onboarding | Continuer / Passer | étape suivante / AuthActivity | navigation | ✓ |
| Auth | Connexion 1-tap | Firebase → bootstrap → dashboard | jeton + profil | ✓ (F42 corrigé) |
| Auth | « Passer sans compte » | mode local seed | dashboard offline | ✓ honnête (3 crédits) |
| Code parrain | Continuer | validation format → claim file | code accepté ou ERREUR VISIBLE | ✓ (F66 corrigé) |
| Code parrain | Passer sans code | onDone(null) | parcours normal (jamais bloquant) | ✓ |
| Catalogue | 30 vignettes gabarits | BriefActivity(gabarit) | formulaire brief | ✓ (F48 re-seed) |
| Brief | Suivant par champ | BriefValidator | erreur traduite ×4 ou avance | ✓ (F67/F68) |
| Brief | Lancer la vidéo | CameraGuideActivity | guide 3 prises | ✓ |
| Caméra | Enregistrer (prise N) | startRecording → Finalize | slot rempli + avance OU erreur explicite | ✓ (F53 corrigé) |
| Caméra | Passer cette prise | slot "" | avance ; dernière prise sans rien = retour honnête | ✓ (F49/F55) |
| Caméra | (permission refusée) | dialog rationale/réglages | explication + issue | ✓ (F52 corrigé) |
| Caméra | Terminer | finishWithPrises → ExportActivity | rushs transmis slots alignés | ✓ |
| Export | Exporter | gate → réservation → WorkManager | progression, succès MP4, ou refus/échec avec CRÉDIT RENDU | ✓ (F14 corrigé) |
| Export | (double-tap) | gateInFlight | bouton désactivé | ✓ |
| Dashboard | Créer une vidéo | finishWithCreate → catalogue | navigation | ✓ |
| Dashboard | Voir le paywall | PaywallView | crédits RÉELS du miroir | ✓ (F1 corrigé) |
| Paywall | 3 cartes plan → Payer | startCheckout → POST /billing/checkout | payment_url hébergé OU 501/401/réseau HONNÊTE | ✓ (F10 corrigé) |
| Paywall | Retour | finish | dashboard | ✓ |
| Parrainage | Partager WhatsApp | ACTION_SEND (queries ✓) | partage du code RÉEL serveur | ✓ (F2/F64) |
| Parrainage | Copier le code | clipboard | code réel | ✓ |
| Réglages | Langue | dialog 4 langues → recreate | UI traduite immédiatement | ✓ (F6 corrigé) |
| Réglages | Secteur | dialog → persistance | secteur mis à jour | ✓ (F6) |
| Réglages | Accords | dialog informatif R4 | texte accords | ✓ (F6) |
| Réglages | Espace | calcul Mo + purge confirmée | espace libéré visible | ✓ (F6) |
| Réglages | Se déconnecter | FirebaseAuth.signOut + purge session + accueil | session réellement fermée | ✓ (F5 corrigé) |

**Bilan : 0 bouton mort restant identifié** sur le périmètre revu. Réserves honnêtes : (a) le badge E5 (F69) est
collecté mais non consommé — ce n'est pas un bouton mort (l'interaction a un effet : la sélection est transmise),
c'est une fonctionnalité sans rendu final, ISOLÉE ; (b) les interactions physiques réelles (toucher, latence)
restent NON TESTABLES en sandbox — la validation « bouton par bouton » ci-dessus est de niveau 4 (revue de code)
et 3 (tests Robolectric sur paywall/parrainage/réglages ×4 langues).

---

## I. Multimédia — chaîne JSON → BeatSheet → MotionJson → Timeline → MP4 (exigence D41 §9/§10)

### I.1 Chaîne de montage validée

```
gabarit_T*.json (30, assets réels)
   → GabaritJson.parseBrief / parseBeatSheet        [fuzz : GabaritFuzzTest, 800 mutations]
   → GabaritBeatSheet.build(raw, valeursBrief)      [120 combinaisons ×4 langues, plans ≤ 1,5 s (D23)]
   → MotionJson.parse(beatSheetJson)                [fuzz : MotionJsonFuzzTest, 400 mutations + tronçatures]
   → RushSlots.resolve(prises, creux)               [F55 : slots alignés, voisin non vide]
   → MotionComposition (vidéo : effets + typographie KineticTypography, F62)
   → BgmSfxAudioMixer (audio : BGM duckée + 9 SFX sur repères, F58/F59/F60)
   → Transformer (Media3 1.11.1) → MP4
   → ExportVerifier (durée ±500 ms ; beat sheet = vérité ; replis en cascade)
```

Chaque maillon est couvert par un test exécuté en CI (niveau 3), SAUF le rendu MP4 physique :
**NON TESTABLE en sandbox** (pas d'émulateur, pas de /dev/kvm, codecs matériels indisponibles — D18).
Le MP4 physique reste validé indirectement : l'APK CI se construit et s'installe (niveau 1 sur la chaîne de build),
et la CI D40 avait produit des exports instrumentés (run 41228100978).

### I.2 Audio réel (exigence D41 §10)

| Contrôle | Méthode | Résultat |
|---|---|---|
| 600 pistes BGM (B2) | FFprobe/ebur128 (D39, exécuté physiquement) | LUFS ≈ -16 intégralité vérifiée ; 9 SFX présents dans l'APK (unzip, niveau 1) |
| BGM duckée -20 dB sous voix | CODE (MixPlan.musicBaseGain/duckTargetGain) + test faux délégue | ✓ F58 corrigé : duckage POSÉ sur toutes les prises (avant : mort dès la prise 2) |
| SFX -25 dB sur 9 repères | CODE + ExportVerifier fenêtre +500 ms | ✓ GabaritCombinaisonsL10nTest : SFX dans la fenêtre pour les 120 combinaisons |
| Profondeur par gabarit (ducking_musique_sous_voix_db) | F59 | ✓ transmis (KEY_DUCK_DB), testé à -6 dB observable |
| Fades musique (0,45 s in / 0,75 s out) | F60 | ✓ enveloppe par frame, testée sur PCM synthétique |
| Kill-switch audio dégradé | CODE (channelCount > 2 → degraded) | ✓ revu, inchangé (sain) |
| **Analyse FFprobe d'un export PHYSIQUE post-correctifs** | — | **NON TESTABLE sandbox** — à rejouer sur appareil/CI instrumentée (recommandation R3, section N) |

### I.3 Les 30 gabarits T1–T30 validés individuellement

`GabaritCombinaisonsL10nTest` (CI) : présence 30/30 (assertion), et pour CHAQUE gabarit × CHAQUE langue
(FR/EN/ES/JA avec valeurs d'échantillon CJK) : beat sheet construit (non-null), plans > 0, tous ≤ 1,51 s,
timecodes cohérents, ducking ∈ [-30, 0] dB, SFX dans la fenêtre de composition (+500 ms). Le rendu MP4
individuel des 30 gabarits reste NON TESTABLE en sandbox (même raison qu'en I.1).

---

## J. i18n / l10n FR — EN — ES — JA (exigence D41 §8)

### J.1 Couverture

- **7 modules** portent des strings (core-designsystem + 6 features ; `app` = 0 string) ; **4 locales** (`values`, `-en`, `-es`, `-ja`) ; **> 200 clés**.
- **`I18nKeyCoverageTest` (CI)** : égalité EXACTE des ensembles de clés entre les 4 locales — zéro manquante, zéro orpheline. Toute nouvelle clé non traduite CASSE la CI (anti-régression permanente).
- **`DashboardL10nCheckTest` (CI, Robolectric NATIVE)** : paywall rendu ×4 langues, parrainage JA/EN, réglages ES/FR — assertions sur les libellés TRADUITS (pas la clé), captures PNG archivées (`build/visual-check/l10n-*.png`, artifact `ci-visual-check`).
- **Trouvailles corrigées** : F8/F33 (paywall/auth FR en dur), F44 (bandeau catalogue), F67 (validateur de brief), F68 (écran gabarit), F53/F52 (messages caméra) → désormais ressources ×4.
- **Devise découplée de la langue** (exigence §8) : zone UEMOA → FCFA ; zone hors UEMOA → € (parité BCEAO 655,957 figée, P8LogicTest) ; la LANGUE ne change jamais la devise. ¥/$ affichés si le serveur les renvoie (grille tarifaire serveur = autorité). NNBSP U+202F dans les libellés EUR (convention typographique FR).
- **Pseudo-localisation** : non outillée (pas d'AGP pseudo-locale activée) — compensée par le test JA (CJK réel : pleine chasse, césure sans espaces) qui casse les hypothèses « largeur = latin ».

### J.2 Typographie japonaise RÉELLE

- Moteur (F62) : `OverlayTextLayout.isWide` (CJK pleine chasse), largeurs relatives 1.00 (latin maj)/0.62 (min)/0.52 (chiffre)/0.55 (CJK), césure greedy bornée à 90 % de la largeur, taille 7,8 % de la largeur de sortie, MIN 24 px, ancrage NDC empilé (BASE -0.35, interligne 1.25).
- **Polices** : AUCUNE police embarquée dans l'APK (vérifié niveau 1, unzip) → le rendu CJK s'appuie sur Noto Sans CJK **système**. Conséquence honnête : le rendu physique japonais dépend de l'appareil ; **NON TESTABLE en sandbox** (pas d'émulateur). Robolectric NATIVE charge les polices système du runner (Ubuntu) — les captures PNG l10n-ja en CI sont une preuve d'AGENCEMENT (niveau 3), pas de rendu appareil (niveau 1).
- Chaîne `特别オファー` (mixte CJK) utilisée comme valeur d'échantillon dans les 120 combinaisons → beat sheet conforme même avec du texte CJK (aucune hypothèse de longueur cassée).

### J.3 Gabarits marchands (ISOLÉ — décision produit)

Les TEXTES de scènes des 30 gabarits JSON sont en français seul (ex. « Offre exceptionnelle »). Ce ne sont pas des
strings Android : les traduire = réécrire le vocabulaire COMMERCIAL de chaque secteur en 4 langues (décision
éditoriale, pas technique). Conformément à la règle D41 (« décision produit ambiguë → isoler/documenter/poursuivre ») :
ISOLÉ. Plan proposé (section N, R5) : résolveur `GabaritL10n` + 9 clés communes par gabarit, sans toucher aux JSON
source (Drive = référence absolue, D27). Les 269 clés `strings_*.xml` jamais consommées (héritage maquettes) sont
inventoriées — aucune supprimée (D20 zero breaking change).

---

## K. Cartographie Mermaid (fichiers réels)

### K.1 Architecture globale

```mermaid
flowchart TB
    subgraph Android["Android (11 modules)"]
        APP[app · MainActivity.kt<br/>deep link /r/CODE · purge >24h]
        ONB[feature-onboarding<br/>OnboardingActivity · AuthActivity<br/>ReferralCodeScreen]
        CAT[feature-catalog<br/>CatalogActivity]
        BRI[feature-brief<br/>BriefActivity · GabaritBriefScreen<br/>BriefValidator]
        CAM[feature-camera<br/>CameraGuideActivity<br/>slots indexés F55]
        EXP[feature-export<br/>ExportActivity · ExportWorker<br/>ExportGate · ExportVerifier]
        DASH[feature-dashboard<br/>DashboardActivity · PaywallScreen<br/>ReferralScreen · SettingsScreen]
        DATA[data<br/>BackendSync · ApiClient · GabaritRepository<br/>Room: VitrineLocalDatabase · Daos.kt]
        INS[ins-effects<br/>MotionComposition · KineticTypography<br/>BgmSfxAudioMixer · RushSlots · MotionJson]
        GUARD[core-guard<br/>CreditPolicy · ExportGate · ConsentGate]
        MODEL[core-model<br/>Gabarit.kt · Plans.kt · MixPlan]
        DS[core-designsystem<br/>VitrineTheme · VitrineLocale · PaywallMapper · ReferralGauge]
    end
    subgraph Cloud["Cloudflare"]
        WK[Worker src/index.js ≈5900 l.<br/>/api/v1/*]
        D1[(D1 migrations 0001-0012)]
        B2[(B2 vitrine-video-media<br/>600 pistes BGM · audio_v2)]
    end
    FB[Firebase Auth<br/>projet vitrine-video<br/>JWT RS256 → JWKS]
    CP[CinetPay<br/>api-checkout.cinetpay.com<br/>v2/payment · v2/payment/check]
    APP --> ONB --> CAT --> BRI --> CAM --> EXP --> DASH
    ONB & CAT & BRI & CAM & EXP & DASH --> DATA
    EXP --> INS --> MODEL
    GUARD --> EXP
    DS --> DASH
    DATA <-->|HTTPS JSON| WK
    WK --> D1
    WK <-->|webhook HMAC interne| WK
    INS -.->|téléchargement BGM| B2
    ONB & DASH --> FB
    WK -->|JWKS| FB
    WK <-->|checkout/notify serveur| CP
```

### K.2 Parcours client nominal (33 étapes condensées)

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant O as OnboardingActivity
    participant A as AuthActivity
    participant B as BackendSync
    participant W as Worker /api/v1
    participant C as CameraGuideActivity
    participant E as ExportActivity/Worker
    participant D as DashboardActivity

    U->>O: première ouverture
    O->>B: bootstrap (F42)
    B->>W: POST /me/bootstrap (idempotent)
    alt code parrain (deep link /r/CODE via MainActivity, F63/F34)
        O->>B: claimReferral (file rejouable, F27)
        B->>W: POST /me/referral/claim (anti auto/double)
    end
    O->>B: requestGrant APRÈS claim (F41)
    B->>W: POST /me/welcome-grant → 3 ou 5 crédits
    Note over O,B: hors-ligne : seed honnête 3 crédits (F30b)
    U->>A: connexion 1-tap Firebase
    U->>C: brief → 3 prises (slots indexés F55,<br/>Finalize événementiel F53)
    C->>B: sendConsents R4 (F56)
    B->>W: POST /consents (batch idempotent)
    U->>E: Exporter
    E->>E: ExportGate : intégrité → rollback → crédits
    E->>B: réserve + consomme (eventId idempotent)
    B->>W: POST /quota/consume (empreinte vérifiée)
    E->>E: BeatSheet → MotionJson → RushSlots →<br/>Composition → Mixage (F58-F60) → MP4 → Verifier ±500ms
    alt échec
        E->>E: compensation crédit + bouton rendu (F14)
    end
    U->>D: dashboard (crédits/jauge réels F1/F2)
    alt crédits épuisés
        D->>W: POST /billing/checkout (F10)
        W-->>D: payment_url CinetPay (ou 501 honnête)
        W->>W: notify → /v2/payment/check → applyPaidOrder (idempotent)
    end
```

### K.3 Sécurité — surface d'attaque et traitements

```mermaid
flowchart LR
    subgraph Menaces
        M1[App tierce vole le jeton<br/>F63]
        M2[Root : Room/prefs gonflés]
        M3[Horloge reculée]
        M4[Rejeu webhook/notify]
        M5[Décrément croisé<br/>quota-fp]
        M6[Abonnement hors grille<br/>F-webhook-plan]
        M7[Stockage saturé<br/>F50/F51]
    end
    subgraph Traitements
        T1[AuthActivity exported=false<br/>deep link via MainActivity]
        T2[ExportGate DENY_INTEGRITY<br/>octroi réel = serveur]
        T3[DENY_ROLLBACK<br/>clockRollbackDenies]
        T4[applyPaidOrder idempotent<br/>notify re-vérifié /payment/check]
        T5[empreinte vs merchant_identity<br/>403 + eventId requis 400]
        T6[plan OBLIGATOIREMENT dans PLAN_GRID<br/>422]
        T7[filesDir + purge >24h<br/>+ cancel transformer F24b]
    end
    M1-->T1
    M2-->T2
    M3-->T3
    M4-->T4
    M5-->T5
    M6-->T6
    M7-->T7
```

### K.4 Offline — utilisable mais non exploitable

```mermaid
flowchart TB
    DEM[App ouverte hors-ligne] --> SEED[Seed honnête 3 crédits F30b<br/>WelcomeRepository cache ou GrantState offline]
    SEED --> FILE[File locale : pending_quota/pending_claim<br/>isolée par uid F38 · max 50 · non-retryables purgés 400/403/404]
    FILE --> RET[Réseau retrouvé → flushPending<br/>replay claim + replay grant si cache absent F30<br/>bootstrap F42]
    RET --> SRV[Serveur = seule autorité d'octroi<br/>UNIQUE referred_id · anti multi-appareils · reward_granted]
    DEM --> EXP2[Export offline autorisé SI<br/>journal local intègre + solde > 0 + horloge cohérente]
    EXP2 --> SYNC[Consommation mise en file eventId<br/>jamais de double débit au replay]
```

### K.5 Financier — checkout/notify (F10)

```mermaid
sequenceDiagram
    participant A as Android (PaywallScreen)
    participant W as Worker (src/index.js)
    participant C as CinetPay
    participant N as Navigateur client

    A->>W: POST /billing/checkout {plan} (JWT)
    W->>W: PLAN_GRID {pass24h:500, pro:3000, boutique:7500}<br/>commande pending VV-uuid13 (marchand+montant FIGÉS)
    alt clés CINETPAY absentes
        W-->>A: 501 billing_not_configured (HONNÊTE)
    else
        W->>C: POST api-checkout.cinetpay.com/v2/payment (clé secrète)
        C-->>W: payment_url
        W-->>A: 200 {ref, payment_url}
        A->>N: ACTION_VIEW payment_url (queries ✓ F64)
        C->>W: POST /billing/notify
        W->>C: POST /v2/payment/check (re-vérification)
        C-->>W: statut + montant
        W->>W: montant ≠ commande → 422 · plan dérivé (grille injective)<br/>applyPaidOrder : idempotent, batch orders+subscriptions,<br/>recomputeEntitlements + applyReferralRewards
        W-->>C: 200 (y compris paiement non ACCEPTED → failed+ignored)
        N->>W: GET /billing/return → page HTML bilingue no-store
    end
```

### K.6 Montage — pipeline d'export (fichiers réels)

```mermaid
flowchart TB
    subgraph feature-export
        EA[ExportActivity.kt<br/>gateInFlight F14 · bouton désactivé<br/>reconcileOrphelines >120s]
        EW[ExportWorker.kt<br/>parseSheet + télémétrie F57<br/>expectedDurationMs · KEY_DUCK_DB]
        EV[ExportVerifier ±500 ms]
    end
    subgraph core-guard
        CP[CreditPolicy<br/>seedDecision · debit · compensate<br/>concurrentDebits · clockRollbackDenies]
        EG[ExportGate<br/>DENY_INTEGRITY > DENY_ROLLBACK > DENY_NO_CREDIT > ALLOW]
    end
    subgraph ins-effects
        RS[RushSlots.resolve F55]
        MJ[MotionJson.parse<br/>JSONException sinon rien]
        GB[GabaritBeatSheet.build<br/>plans ≤ 1,5 s D23]
        MC[MotionComposition.kt<br/>géométrie → typographie]
        KT[KineticTypography.kt F62<br/>BitmapOverlay · OverlayTextLayout<br/>KeywordMatching]
        MX[BgmSfxAudioMixer.kt F58-F60<br/>musique+SFX uniques · duck vivant<br/>musicEnvelope fades]
    end
    EA -->|gate| EG --> CP
    EA -->|WorkManager + eventId| EW
    EW --> GB --> MJ --> RS --> MC --> KT
    EW --> MX
    EW --> EV
    EV -->|échec| EA2[compensation crédit<br/>bouton rendu F14]
```

### K.7 Caméra — machine à états des prises (F49/F52/F53/F55)

```mermaid
stateDiagram-v2
    [*] --> Guide: ouverture (permission ✓)
    [*] --> DialogPermission: permission refusée (F52)
    DialogPermission --> Guide: ré-essai accordé
    DialogPermission --> ReglagesApp: intent réglages
    Guide --> Enregistrement: bouton Enregistrer
    Enregistrement --> Finalisation: stop() → priseEnCoursDeFinalisation
    Finalisation --> SlotRempli: VideoRecordEvent.Finalize succès (F53)
    Finalisation --> Guide: Finalize erreur → fichier supprimé + message ×4
    Guide --> SlotVide: Passer cette prise → slot "" (F55)
    SlotRempli --> Guide: prise suivante
    SlotVide --> Guide: prise suivante
    Guide --> ResultatOK: Terminer avec ≥ 1 prise → finishWithPrises (slots padés)
    Guide --> ResultatAnnule: skip dernière sans aucune prise → RESULT_CANCELED (F49)
    ResultatOK --> [*]: ExportActivity (client_rushs alignés)
    ResultatAnnule --> [*]
```

### K.8 Parrainage — chaîne complète (serveur = autorité)

```mermaid
flowchart LR
    P[Partage WhatsApp<br/>code RÉEL serveur F2] -->|texte ou lien /r/CODE| L[MainActivity<br/>seule exportée F63]
    L -->|extra ref_code| A2[AuthActivity<br/>RefCodeParser MOTIF-123]
    A2 -->|saisie manuelle| RC[ReferralCodeScreen<br/>validation visible F66]
    RC & A2 --> CL[BackendSync.claimReferral<br/>file rejouable F27 · isolation uid F38]
    CL -->|POST /me/referral/claim| W2[Worker : anti auto-parrainage<br/>même appareil refusé · UNIQUE referred_id]
    W2 -->|5 crédits filleul parrainé| GR[welcome-grant APRÈS claim F41]
    W2 --> R8[applyReferralRewards<br/>paliers R8 de 5 · reward_granted idempotent]
    R8 --> D2[Dashboard ReferralScreen<br/>GET /me/referral · jauge n/5 · historique ANONYMISÉ F8]
```

---

## L. Tests automatisés — ce qui a été ajouté et ce qu'il protège (Phase 3)

| Suite (module) | Type | Ce qu'elle verrouille |
|---|---|---|
| `BgmSfxAudioMixerMultiRushTest` (ins-effects) | contrat + faux délégue | F58/F59/F60 : 4 prises ⇒ exactement 1 musique + 1 SFX + voix par prise ; duckage posé sur TOUTES les prises ; profondeur gabarit respectée ; fades mesurés sur PCM |
| `RushSlotsTest` (ins-effects) | unitaire pur | F55 : creux comblés, ordre absolu, repli mono-rush |
| `KeywordMatchingTest` + `OverlayTextLayoutTest` (ins-effects) | unitaire pur | F62 : tokens multi-mots, CJK pleine chasse, cassure 90 %, plancher 24 px, ancrage |
| `MotionJsonFuzzTest` (ins-effects) | fuzz (graine 424242) | aucune exception hors contrat ne sort du parseur (sinon = crash de rendu au lieu du repli F18/F57) |
| `GabaritFuzzTest` (data) | fuzz (graine 20261102) | 5 parseurs + build : 800 mutations, contrat fort (null ou Document, JAMAIS d'exception) |
| `GabaritCombinaisonsL10nTest` (data) | combinatoire | 30 gabarits × 4 langues = 120 : plans ≤ 1,5 s, SFX fenêtre, ducking contrat |
| `CreditPolicyPropertyTest` (core-guard) | property-based (graine 987654321) | invariants C01–C12 : masse monétaire conservée, seed 0..3, refus ≤ 0 débité, idempotence compensation, priorités ExportGate |
| `I18nKeyCoverageTest` (feature-dashboard) | couverture | égalité EXACTE des clés ×4 locales sur 7 modules — toute clé non traduite casse la CI |
| `DashboardL10nCheckTest` (feature-dashboard) | visuel Robolectric NATIVE | paywall ×4 langues, parrainage JA/EN, réglages ES/FR — libellés TRADUITS rendus + PNG |
| Suites préexistantes renforcées | — | `BriefValidatorTest` (ressources ×4), `P8LogicTest` (grille/paliers/parité), `SceneIndexCoverageTest`, `PaywallUiCheckTest`, `MixPlanTest` |

**Mutation testing (phase L du plan)** : NON exécuté — nécessite Gradle lourd en sandbox (D18) ou une PR jetable
dédiée. C'est la seule méthode du plan restée non tentée à ce stade ; elle est déclarée IMPOSSIBLE dans la matrice
B.11 et recommandée (R4) sur runner CI dédié hors mission D41.

---

## M. Corrections appliquées — principe et classification (Phase 6)

### M.1 Principes respectés (exigence D41 §19)

1. **Racine, jamais symptôme** : chaque correctif répare la CAUSE (ex. F58 = contrat d'enregistrement des sources du mixeur, pas un rafistolage de volume).
2. **Test de reproduction + non-régression** : chaque P1 embarque son test (table L) ; les fuzz/propriétés à GRAINE FIXÉE sont reproductibles.
3. **Aucune sécurité désactivée, aucun masquage** : les portes (ExportGate, ConsentGate, JWKS, HMAC, throttle) sont RESTÉES ou RENFORCÉES ; les échecs deviennent VISIBLES (messages ×4, télémétrie F57) au lieu d'être avalés.
4. **Additif (D20)** : migrations 0001–0003 intactes ; routes additives ; `sectorLabelRes` ajouté sans casser `sectorLabel`.
5. **Réversibilité (D41)** : branche `audit-d41` isolée, `backup/pre-d41` intact, AUCUN push sur `main`, AUCUN déploiement.

### M.2 Classification P0–P4 des 33 findings traités

| Priorité | Findings | Traitement |
|---|---|---|
| **P0** | F42 (bootstrap jamais appelé — TOUT /me/* mort) | corrigé + sondes CI |
| **P1** | F58, F62, F63, F10, F14, F41, F53, F1, F2, F5, F6, quota-eventid, quota-fp | corrigés + tests de non-régression |
| **P2** | F24b, F49, F50, F51, F52, F55, F60, F8, F33, F34, F44, F67, F68, F69* | corrigés sauf F69* (ISOLÉ — décision produit) |
| **P3** | F27, F30, F30b, F38, F48, F56, F57, F59, F61*, F64, F66, webhook-plan | corrigés sauf F61* (documenté) |
| **P4** | F65* (biométrie déclarée sans code), gradle.properties dupliqué | documentés (retrait = décision store) |

(* = ISOLÉ/DOCUMENTÉ, jamais masqué : le rapport dit exactement ce qui n'a pas été corrigé et pourquoi.)

---

## N. NIST SSDF (SP 800-218) — mapping du pipeline réel + recommandations

| Pratique SSDF | État du projet | Preuve / écart |
|---|---|---|
| **PO.3** Outillage de sécurité (toolchain) | PARTIEL | ktlint+detekt+R8+checkModuleGraph en CI ; PAS de scan CVE automatisé (SCA) — écart E1 |
| **PO.4** Défense du référentiel | OUI (usage) | branche `audit-d41` isolée, `backup/pre-d41`, aucun push direct `main` pendant D41 ; secrets HORS dépôt (`.d41_secrets` sandbox, jamais commité — vérifié `git log -p` sur les 10 commits) |
| **PS.1** Protection du code (intégrité) | PARTIEL | commits signés par le flux GitHub (authentif) ; PAS de tags signés GPG — écart E2 |
| **PS.2** Archives SBOM | PARTIEL | inventaire manuel dépendances (section B.4) ; pas de SBOM CycloneDX généré — écart E3 (Gradle lourd interdit en sandbox, D18) |
| **PS.3** Référentiels de dépendances | OUI | versions figées libs.versions.toml + Google Maven ; wrangler.toml dépendances worker |
| **PW.4** Réutilisation sécurisée (tiers) | OUI | contrats Media3 lus dans les SOURCES avant usage (AudioGraph/TextOverlay/BitmapOverlay) ; docs CinetPay officielles relues avant intégration |
| **PW.5** Revue de code | OUI (audit) | revue contradictoire D41 = 69 findings ; PR #2 en auto-revue outillée (CI ×3) — le relecteur humain reste à faire au merge — écart E4 |
| **PW.6** Tests exécutables | OUI | 9 suites ajoutées + existantes ; fuzz/propriétés à graines fixes reproductibles |
| **PW.7** Configurations par défaut sûres | OUI | allowBackup=false, exported minimisé (F63 corrigé), FLAG_SECURE, 501 honnête sans clés (jamais de mode test en prod) |
| **PW.8** Exécutables vérifiés | OUI (debug) | APK CI inspecté (sha256, manifest, assets) ; signature RELEASE via keystore documenté (D40) |
| **RV.1** Identification des vulnérabilités | PARTIEL | DAST CI wrangler + sondes prod ; pas de veille CVE automatisée — écart E1 |
| **RV.2** Évaluation des vulnérabilités | OUI | classification P0–P4 systématique (section M.2) |
| **RV.3** Analyse des causes racines | OUI | chaque finding cite fichier:ligne + cause (ex. F58 = contrat addSource par item) |

### Recommandations (R), classées

- **R1 (P1, avant mise en prod des paiements)** : obtenir les clés CinetPay (site_id + apikey) en SECRETS GitHub/CF, déployer le worker (workflow_dispatch — jamais automatique), puis re-jouer les sondes DAST billing en PRODUCTION (checkout réel 1 FCFA de test si le fournisseur le permet, sinon 501→200 après configuration). L'architecture est prête et prouvée en CI locale ; il manque l'acte de déploiement AUTORISÉ.
- **R2 (P1)** : rejouer la CI instrumentée (androidTest) sur runner avec émulateur : parcours caméra→export→MP4 physique, FFprobe/ebur128 sur le MP4 produit (audio ducké mesuré), rendu CJK sur image système japonaise. C'est la seule façon de promouvoir les niveaux 3/4 en niveau 1 pour le rendu.
- **R3 (P2)** : ajouter `./gradlew dependencyCheck` ou OSV-Scanner en CI (job léger, pas de compilation) pour combler l'écart E1 (SCA/CVE).
- **R4 (P2)** : mutation testing sur PR jetable dédiée (plan L) — mesurer la capacité de détection réelle des 9 suites (objectif : tuer les mutants CreditPolicy/ExportGate/MotionJson).
- **R5 (P2, décision produit)** : traduire les textes marchands des 30 gabarits (résolveur GabaritL10n + 9 clés communes/gabarit) après validation éditoriale FR→EN/ES/JA ; purger ou consommer les 269 clés héritées jamais référencées.
- **R6 (P3)** : décider du badge E5 (F69) : le rendre (overlay dédié ou carte) ou retirer la collecte — l'état actuel (collecté, jamais visible) est documenté mais trompe l'utilisateur à terme.
- **R7 (P3)** : retirer USE_BIOMETRIC/USE_FINGERPRINT (F65) OU implémenter le verrouillage biométrique du dashboard (valeur réelle : commerçants partagent parfois l'appareil).
- **R8 (P4)** : domaine vitrine.video (NXDOMAIN en sandbox — à re-confirmer hors sandbox avant achat) + assetlinks.json pour les App Links vérifiés (F34 : le deep link fonctionne en explicite ; l'autoVerify attend le domaine).
- **R9 (P4)** : workers Builds CF — vérifier qu'aucun build auto ne se déclenche sur push de branche (statut INCONNU en sandbox, jeton API invalide) ; sinon restreindre aux branches main/preview.

---

## O. Matrice formelle de validation (exigence D41 §7/§22)

Légende : **VP** = VALIDÉ PHYSIQUEMENT (niveau 1, système réel exécuté) · **EE** = validé en ENVIRONNEMENT
D'EXÉCUTION équivalent (CI, wrangler+D1 locale) · **AUTO** = validé AUTOMATIQUEMENT (tests CI) · **PART** =
PARTIELLEMENT · **NV** = NON VALIDÉ · **NT** = NON TESTABLE (raison obligatoire). Confiance : ★★★ (preuve dure),
★★ (preuve forte indirecte), ★ (analyse/revue).

| Fonction / exigence | Statut | Confiance | Preuve (chemin/artifact) |
|---|---|---|---|
| Compilation Android complète (11 modules, R8) | EE | ★★★ | CI android-ci run **41427854165** `6f18bc2` : APK debug + APK release signé officiel + R8 full + Lint 36 ✓ |
| 30 gabarits présents dans l'APK | VP | ★★★ | unzip APK run 41330211303 (`d41_artifacts/`) |
| 9 SFX dans l'APK | VP | ★★★ | idem |
| Chaîne gabarit→BeatSheet→MotionJson (logique) | AUTO | ★★★ | GabaritCombinaisonsL10nTest + GabaritFuzzTest + MotionJsonFuzzTest (CI) |
| 120 combinaisons gabarit × langue | AUTO | ★★★ | GabaritCombinaisonsL10nTest (CI) |
| Rendu MP4 PHYSIQUE d'un export | NT | — | pas d'émulateur/KVM en sandbox (D18) → R2 |
| Audio ducké mesuré sur MP4 réel | NT | — | idem ; contrat mixage validé AUTO (faux délégue) |
| 600 pistes BGM LUFS ≈ -16 | VP | ★★★ | FFprobe/ebur128 D39 (logs B2) |
| Mixeur multi-rushs (F58/F59/F60) | AUTO | ★★★ | BgmSfxAudioMixerMultiRushTest + sources AudioGraph.java (niveau 2) |
| Typographie CJK — agencement | AUTO | ★★ | OverlayTextLayoutTest + DashboardL10nCheckTest JA (Robolectric NATIVE, PNG) |
| Typographie CJK — rendu appareil (police Noto système) | NT | — | dépend de l'appareil, pas d'émulateur → R2 |
| Crédits : invariants monétaires | AUTO | ★★★ | CreditPolicyPropertyTest 10 000 tirages (CI) |
| ExportGate priorités (intégrité>rollback>crédits) | AUTO | ★★★ | idem + P8LogicTest |
| Quota serveur : idempotence eventId, empreinte | EE | ★★★ | API Security CI (wrangler+D1) : 400/403 + droits inchangés |
| Checkout/notify CinetPay (logique complète) | EE | ★★★ | API Security CI : 501 honnête, 401, 422 montant/plan, rejeu ignored |
| Checkout CinetPay en PRODUCTION (clés réelles) | NV | — | déploiement interdit D41 §21 → R1 |
| Webhook interne plan hors grille → 422 | EE | ★★★ | API Security CI |
| Bootstrap/claim/grant (ordre F41, replay F27/F30) | EE+AUTO | ★★ | sondes CI + revue BackendSync ; exécution appareil → R2 |
| Auth : JWT RS256, JWKS, iss/aud | VP | ★★★ | sonde prod (jeton décodé) + API Security CI |
| F63 vol de session (AuthActivity exported) | VP | ★★★ | manifest dump APK AVANT (exported=true) + code APRÈS (exported=false) |
| FLAG_SECURE, allowBackup=false, libvvguard, R8 | VP | ★★★ | inspection APK (`d41_artifacts/`) |
| Boutonnerie : 0 bouton mort (table H) | AUTO+PART | ★★ | revue code (niveau 4) + Robolectric paywall/parrainage/réglages ; toucher physique → R2 |
| Caméra : prise/skip/Finalize (F49-F55) | PART | ★★ | logique testée (RushSlotsTest) + revue ; capture vidéo réelle → R2 |
| Consentements R4 enregistrés serveur (F56) | EE | ★★★ | API Security CI (POST /consents 401/batch) + revue client |
| i18n chrome ×4 langues (couverture clés) | AUTO | ★★★ | I18nKeyCoverageTest (CI, anti-régression permanente) |
| i18n rendus (paywall/parrainage/réglages ×4) | AUTO | ★★★ | DashboardL10nCheckTest + PNG (artifact ci-visual-check) |
| i18n textes MARCHANDS des gabarits | NV (ISOLÉ) | — | décision éditoriale → R5 |
| Devise découplée de la langue (FCFA/€) | AUTO | ★★★ | P8LogicTest (parité BCEAO, grille) + PaywallMapper |
| Offline utilisable non exploitable (table G.3) | AUTO+EE | ★★ | propriétés + sondes + revue ; réseau coupé physiquement → R2 |
| Réinstallation/changement d'appareil sans crédits artificiels | EE | ★★★ | sondes welcome-grant anti multi-appareils (API Security CI) + allowBackup=false (APK) |
| Parrainage : anti auto/double, paliers R8 | EE | ★★★ | sondes CI (D40 reconduites) + UNIQUE(referred_id) migrations |
| Deep link /r/CODE | PART | ★★ | routage corrigé + revue ; App Links autoVerify attend domaine (R8) |
| Mutation testing | NT | — | Gradle lourd interdit sandbox (D18) → R4 |
| Macrobenchmark/perf appareil | NT | — | pas d'appareil → R2 |
| DAST prod billing/consents post-déploy | NV | — | déploiement interdit → R1 (fingerprints `d41-probe-*` prêts) |

---

## P. Conclusion honnête

### P.1 Ce qui est DÉMONTRÉ (preuves dures)

1. **Le produit était cassé sur sa promesse centrale** — montage multi-rushs avec musique duckée et typographie
   surlignée — et il est désormais réparé À LA RACINE, avec la cause exacte établie par les sources Media3 (F58/F62)
   et verrouillée par des tests de non-régression qui observent le comportement réel (faux délégue), pas une déclaration.
2. **Une faille de vol de session (F63)** était exploitable par n'importe quelle app installée — fermée (exported=false,
   routage MainActivity), vérifiée avant/après sur le manifest de l'APK CI.
3. **L'argent est du côté serveur** : crédits, quota (eventId requis, empreinte liée), parrainage (UNIQUE, anti-auto,
   paliers idempotents), paiement (commande figée, notify re-vérifié, plan dans la grille) — le client ne peut plus
   rien s'octroyer ; chaque attaque est sondée en CI (wrangler + D1 réelle).
4. **L'architecture paiement est PRÊTE** (exigence §16) : il ne manque QUE les clés CinetPay (R1) — le 501 honnête
   le prouve sans faux succès. Mobile Money via CinetPay (FCFA, zone UEMOA) est le chemin nominal.
5. **i18n FR/EN/ES/JA** : chrome 100 % couvert avec anti-régression permanente (I18nKeyCoverageTest casse la CI dès
   qu'une clé n'est pas traduite ×4) ; rendus vérifiés Robolectric NATIVE avec captures.

### P.2 Ce qui N'EST PAS démontré (limites — jamais masquées)

1. **Aucun rendu MP4 physique post-correctifs** (sandbox sans émulateur/KVM) — la chaîne logique est testée de bout en
   bout, le binaire vidéo final reste à valider sur runner instrumenté (R2). C'est LA limite principale de D41.
2. **Typographie japonaise sur appareil réel** : l'agencement est testé (Robolectric NATIVE, police du runner), le
   rendu final dépend de la police Noto CJK de l'appareil (aucune police embarquée — choix vérifié, conséquence documentée).
3. **Paiements réels** : interdits par la mission (§21) — validation = logique complète en CI locale + sondes.
4. **Production non redéployée** : les nouvelles routes worker renvoient 404 en prod jusqu'au déploiement AUTORISÉ (R1) ;
   aucune modification prod n'a été effectuée pendant D41 (règle D40-0.5 respectée à la lettre).
5. **Mutation testing non exécuté** (D18) — la capacité de détection des suites est argumentée (faux délégue, graines
   fixes, invariants) mais non mesurée (R4).
6. **Trois décisions produit isolées** : F69 (badge collecté non rendu), gabarits marchands FR-only (R5), F65
   (biométrie déclarée sans code, R7). Aucune n'est « corrigée » artificiellement : isoler ≠ masquer, chaque état est documenté.

### P.3 Verdict de conformité finale

Le système, APRÈS les correctifs D41 (branche `audit-d41`, PR #2), respecte les exigences structurelles de la mission :
autorité serveur, idempotence, isolation, offline utilisable-non-exploitable, zéro bouton mort identifié, i18n ×4
verrouillée, sécurité Android durcie, 0 FCFA d'infrastructure ajoutée. La mise en production des paiements et la
validation physique sur appareil (R1/R2) sont les DEUX actes restants, explicitement hors périmètre autorisé de D41.
**Aucune prétention de perfection** : 69 findings documentés, 33 corrigés, 3 isolés, résidus listés en F.3/P.2.

---

## Q. Annexes — preuves conservées

### Q.1 Artifacts et journaux (chemins sandbox + GitHub)

| Preuve | Emplacement |
|---|---|
| Journaux CI android-ci (8 itérations, échecs diagnostiqués + run final vert 41427854165) | `/home/user/d41_artifacts/android-ci-414*.log` + runs GitHub (PR #2) |
| APK inspecté (D40 run 41330211303) : sha256 `6008f6b0…e735e2`, manifest dump, assets, libvvguard, R8 mapping | `/home/user/d41_artifacts/` |
| Sources Media3 1.11.1 (AudioGraph/AudioMixer/TextOverlay/BitmapOverlay) | `/home/user/tmp_m3/x/androidx/media3/` |
| FINDINGS complets F1–F69 (v1 + v2) | `/home/user/audit_d41/FINDINGS.md` |
| Captures visuelles ×4 langues | artifact CI `ci-visual-check` (`build/visual-check/l10n-*.png`) |
| Rapports de tests | artifacts CI `test-results` (runs PR #2) |
| Journal des sondes prod (fingerprints `d41-probe-*`, expurgé) | sessions d'audit (aucune donnée personnelle exposée — sonde dédiée `vv-auth-probe@vitrine.video`) |

### Q.2 Les 18 commits de la branche `audit-d41`

| Commit | Contenu |
|---|---|
| `05cc5f7` | fix(D41-data) : bootstrap, replay claim/grant, purge, isolation uid, re-seed, checkout serveur |
| `17b737d` | fix(D41-engine) : mixeur multi-rushs, typographie CJK, slots |
| `be8d5d9` | fix(D41-export) : réservation/compensation, annulation, télémétrie, ducking |
| `5be69c5` | fix(D41-camera) : prises indexées, Finalize, permission, rushs persistants |
| `d3aa50f` | fix(D41-securite+onboarding) : deep link, AuthActivity, ordre claim→grant, seed |
| `b662067` | fix(D41-dashboard) : crédits, jauge, déconnexion, réglages, i18n |
| `92ac890` | fix(D41-i18n) : brief + catalogue ×4 |
| `0418b0d` | fix(D41-worker) : checkout/notify CinetPay, quota, webhook |
| `8e22f2e` | test(D41) : 10 suites de non-régression |
| `3f2e024` | style : ktlint build.gradle.kts caméra |
| `02b6a85` | style : detekt dashboard (ReferralScreen, render) |
| `f954081` | style : detekt onboarding (ReferralCodeScreen) |
| `e422f6d` | fix : compilation (commentaires imbriqués `/*`, `ImmutableList<TextureOverlay>`) |
| `bfda4bf` | fix : resource merger (`auth_subtitle` dupliqué → `auth_status_default`) |
| `db23183` | fix : `sectorLabelRes` non composable (dialogs dashboard) |
| `41fc676` | fix : fidélité maquette E9A (U+0020) + assertions L10n sous-chaîne |
| `9eb0712` | fix : clash signature JVM (FakeMixer `endTimeUs` vs `setEndTimeUs`) |
| `6f18bc2` | fix : FakeMixer little-endian (amplitudes F60) + accent « limité » + docs (ce rapport + FINDINGS sur la branche) |

**Légende des échecs CI diagnostiqués** : chaque itération rouge a été fouillée jusqu'à la cause racine
(7 causes distinctes : KDoc `/*` imbriqué, invariance Java, resource merger, composable hors composition,
comparaison chaîne exacte, espace typographique U+202F, endianness du fake) — aucune n'a été contournée par
désactivation de règle ou `@Suppress`. Le run final vert couvre l'intégralité du pipeline.

### Q.3 Garde-fous de mission (auto-vérification)

- Aucun push sur `main` ✓ (`git log origin/main` = `74edd98` inchangé) ; `backup/pre-d41` intact ✓.
- Aucun déploiement : `deploy-production` = workflow_dispatch uniquement, JAMAIS déclenché ✓.
- Migrations 0001–0003 intactes (coffre-fort D16) ; aucune migration ajoutée (routes additives) ✓.
- Secrets jamais révélés (règle D40-9.4) : PAT hors dépôt, clés CinetPay absentes du code (501 sans elles) ✓.
- 0 FCFA d'infrastructure ajoutée (D21) : aucun service payant activé ✓.

*Fin du rapport D41.*
