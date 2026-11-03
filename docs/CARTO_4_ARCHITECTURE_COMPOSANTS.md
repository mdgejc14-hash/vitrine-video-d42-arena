# CARTOGRAPHIE 4 — Architecture & Composants Vitrine Vidéo v1 (vue 360°)

Légende des statuts : ✅ **Code prêt** (testé/vert CI) · 🔧 **En cours** (codé,
transformation ou câblage restant) · ⏳ **À intégrer** (décidé, non codé).
Chaque statut cite sa preuve (fichier, test, run). Aucune déclaration sans preuve.

---

## DIMENSION 1 — UX/UI & Parcours Utilisateur (le squelette visuel)

| Composant | Techno | Statut | Preuve / reste à brancher |
|---|---|---|---|
| Splash + logo + thèmes palette | SplashScreen API, adaptive icons, Material3 `VitrineTheme` (#FF5500/#0A192F…) | ✅ | mipmaps, `themes.xml`, captures 03/10 |
| Écran langue (4 locales) | Compose `LanguageScreen` + `VitrineLocale` | ✅ | capture 01 ; parité i18n 0 manque |
| SSO Google 1-tap (sans téléphone) | Credential Manager + `FirebaseAuthGateway` (init manuelle, sans google-services.json) | ✅ | `GoogleSsoClient`, `AdminGateTest` |
| Tuto carousel 3 slides | Compose HorizontalPager | ✅ (🔧 cible : skippable 1 tap, 1re fois seulement) | capture 02 |
| Grille 6 secteurs 3D + persistance | `SectorCard3D` neumorphique, `vv_session` | ✅ | capture 03 |
| Catalogue filtré par secteur | `CatalogScreen` initialSector + colonne ≤12 / grille lazy + naming commercial | ✅ | capture 04 + assertions sémantiques FR |
| **Grille 6 secteurs × 5 formats** | manifest v2 (30 gabarits) | ⏳ | structure décidée (VISION §3) ; mécanisme de filtre déjà prêt |
| Brief dynamique **3 variables + WhatsApp** | `BriefScreen` Compose | 🔧 | écran existe (script/durée/objectif) → transformer en Nom/Prix/Offre ; numéro WhatsApp = champ ⏳ (CTA WhatsApp déjà dans contrat EDL `hasWhatsAppCta`) |
| **Prompteur local** (script voix défilant) | Compose overlay | ⏳ | décidé (VISION §5) : téléprompter du script auto-généré pendant l'enregistrement voix |
| Guidage Caméra INS | `GuidedShootingOverlay` (cadre 9:16, jauge, badge R4, consignes FR) | 🔧 | overlay prêt ; remplacer 26 plans par ShootingProtocol 2–4 prises (VISION §5.1) |
| Prévisualisation & export | `ExportPreviewPanel` (typo cinétique + récap) + WorkManager | 🔧 | panneau prêt ; **lecteur vidéo du rendu (PlayerView) = ⏳** |
| Dashboard partage/historique | `DashboardActivity` (chooser partage) | ✅ | manifest déclaré, tests P8 |
| Retour natif = étape précédente | `MainActivity.stepBack` wizard | ✅ | `NAVIGATION_GRAPH.md`, zéro éjection |

**Réponse Q1 — flux UI 100 % opérationnels aujourd'hui :** langue → SSO → tuto →
secteur → catalogue filtré → brief (saisie+validation) → caméra guidée (overlay+3A+R4)
→ enqueue export → notification ; retours natifs complets ; parcours hors-ligne
validable (cache catalogue). Non opérationnels : prompteur, lecteur de rendu,
brief 3 variables (anciens champs présents), grille 30 gabarits.

---

## DIMENSION 2 — Core Engine & Traitement Moteur (l'ingénierie de montage)

| Composant | Techno | Statut | Preuve / reste à brancher |
|---|---|---|---|
| Pipeline rendu on-device | Media3 1.11.1 `InsExportPipeline` : ordre imposé INS (LUT 333 SMPTE 170M + verrou teinte) → effets métier → H.264 bitrate/classe ; 8 bits (T5) | ✅ | code + `PipelineLogicTest` |
| Découpe multi-prises en segments dynamiques | `MotionComposition` : ClippingConfiguration par rush, EditedMediaItemSequence | ✅ (🔧 mapping plans→prises via `rushIndex` = ⏳ câblage) | champ `BeatSheetPlan.rushIndex` présent |
| Zooms z(t) & transitions | MatrixTransformation NDC, TimestampWrapper, cycle cut/swipe/flash/glitch | ✅ | `MotionJsonTest` |
| Typographie cinétique orange #FF5500 | TextOverlay SpannableString, mot-clé coloré | ✅ | captures 09 ; palette Color.kt |
| Horloge voix (calage texte/voix) | `WordClock` pondérée + `BeatGrid` + `DefaultBeatSheet` (≤1,5 s/plan) | ✅ | `DefaultBeatSheetTest`, `BeatGridTest` |
| **Silero VAD** | — | ⏳/❌ assumé | ABSENT par décision : calage = WordClock (zéro ASR, offline, 0 FCFA, toutes langues) ; VAD on-device = poids + dépendance contraires au contrat local-first |
| AudioChain (nettoyage + mix −14 LUFS) | générateur commandes ffmpeg : highpass 85, lowpass 15 k, comp, ducking sidechain, loudnorm I=−14/TP=−1,0 | ✅ contrat+générateur (`AudioChainTest`) ; 🔧 exécution | **non appelée par l'app aujourd'hui** : Media3 1.11 sans effets audio → mix au banc ffmpeg ; branchement export (banc serveur léger ou pistes pré-mixées) = décision d'assemblage final |
| Caméra INS : 9:16 forcé, 30 fps, stabilisation | CameraX : SessionConfig 30 FPS déterministe (pas de VFR), stabilisation SEULEMENT si supportée HAL, cible 9:16 | ✅ | `InsCameraBinder`, `DeviceClass` (« 30 FPS strict ») |
| Verrous & éthique | lockThreeA AE/AWB câblé avant prise ; gate R4 ML Kit 100 % on-device | ✅ | `launchLockedRecording`, `ProfilerAndConsentTest` |
| Adaptation appareil | DeviceProfiler/EncoderProbe → classes bitrate/effets (anti-surchauffe) | ✅ | `CaptureSpecTest` |
| Optique INS | shaders `ins_smartlock.frag`, `ins_grain.frag` | ✅ | assets ins-effects |

**Réponse Q2 — état exact du moteur 0 FCFA :** rendu vidéo **100 % local et prêt**
(INS → effets → H.264, WorkManager écran éteint) ; chaîne audio = contrat et
générateur prêts et testés, **exécution restant à brancher** au point d'export
(le device ne peut pas porter ffmpeg ; options : banc serveur minimal par lot,
ou musique/pré-mix CC0 déjà duckés — décision à trancher à l'assemblage).

---

## DIMENSION 3 — Data Matrix & Gabarits (le cerveau éditorial)

| Composant | Techno | Statut | Preuve / reste à brancher |
|---|---|---|---|
| Gabarits JSON embarqués | `assets/templates/demo/F001…F005.json` (EDL complet : scènes, durées bornées, **cta whatsapp**, sector_category) | ✅ | 5 fichiers présents |
| Parseur & contrat éditorial | `EdlParser` (version 1.2.0, enum secteurs, CTA, durées) + `CatalogManifestParser` | ✅ | `EdlParserTest`, `CatalogManifestParserTest` |
| Manifeste serveur + cache offline | `CatalogRepository` HttpURLConnection + cache disque, `templates/[canary/]manifest.json` | ✅ | code + bannière `catalog_offline` |
| **Matrice 30 manifestes `gabarits/{secteur}/{format}.json` + `socle_universel.json`** | extension du pattern demo (5 archétypes × 6 secteurs + socle = ADN 4 actes) | ⏳ | spécifié VISION §3–4 ; validateur de conformité au socle = ⏳ |
| Injection dans le moteur (chaîne exacte) | manifest → CatalogRepository → EdlParser → `MotionJson.BeatSheet` → `DefaultBeatSheet`/WordClock → `MotionComposition` → `InsExportPipeline` | ✅ | chaîne vérifiée fichier par fichier |
| Multilingue Zéro-ASR | ressources Android ×4 (fr/en/es/ja) + `VitrineLocale` ; voix = voix réelle (jamais ASR/TTS) | ✅ | parité auditée 0 manque |
| **Bibliothèque audio Afrobeats/Amapiano + SFX** | assets ou R2, licences CC0/CC-BY | ⏳ | absent du repo ; ducking sidechain déjà prêt à l'accueillir |

**Réponse Q3 — comment la matrice est lue par le moteur :** le JSON ne contient
que de l'éditorial (scènes, durées, CTA, vocabulaire) ; le moteur le transforme
en beat sheet horodaté (WordClock) puis en séquences Media3 clippées ; aucun code
n'est recompilé pour ajouter un gabarit (injection B2/R2 conservée).

---

## DIMENSION 4 — Infrastructure Backend, Paiement & Local-First

| Composant | Techno | Statut | Preuve / reste à brancher |
|---|---|---|---|
| **Base locale Room/SQLite** | `VitrineLocalDatabase` v1 : TemplateVersionDao, **EntitlementsDao**, TelemetryDao, ReferralDao | ✅ | module `data` ; droits/versions/parrainage offline |
| Projets en cours (brouillons) | fichiers cacheDir (choix léger) | ✅ (⏳ option Room si édition lourde) | brief/rushs locaux |
| Workers + D1 + R2 | `src/index.js` + `wrangler.jsonc` (repo présent) ; D1 prod `0dacf519…`/preview `5b9060b1…`, migrations 0001–0003, cron 0 3 * * *, `/health`, JWKS Firebase ; R2 vignettes lecture seule | ✅ Phase A | commit `4439cf6`, docs Phase A |
| Firebase Auth | init manuelle FirebaseOptions, SSO, AdminGate emails | ✅ | `SSO_RELEASE.md` |
| **Grille tarifaire & checkout client** | `core-model/billing/Plans.kt` : PASS_24H 500 F / PRO 3 000 F / BOUTIQUE 7 500 F (validée 23/10/2026) ; `BillingCheckout` CinetPay sandbox hébergé + réf idempotente | ✅ modèle+checkout sandbox | aucun secret côté client |
| Routes serveur paiement | checkout FedaPay, webhooks HMAC idempotents, crédit D1 | ⏳ additives §2.4 | spec `CONNECTEURS_BACKEND.md` |
| Paywall à épuisement | gate export = entitlements Room + grace JWT 24 h | 🔧 | logique D13 décidée, UI ⏳ |

**Réponse Q4 — articulation paiement vs rendu local :** le paiement vit dans
**deux couches fines** (modèle client `core-model/billing` + routes worker
additives) et **ne touche jamais le moteur de rendu** : l'export local fonctionne
offline ; le gate ne lit que les droits en Room (grace 24 h), jamais le réseau au
moment du rendu. Endpoints déjà câblés : `/health`, `/api/v1/templates/*`,
`/api/v1/users/me` (+crédits) ; **webhooks paiement : aucun câblé aujourd'hui**
(⏳, idempotence + re-vérification serveur spécifiées).

---

## Synthèse des statuts & ordre de fusion finale

| Dimension | ✅ Code prêt | 🔧 En cours | ⏳ À intégrer |
|---|---|---|---|
| 1 UX/UI | 8 | 3 (tuto skip, shooting 2–4 prises, preview player) | 3 (grille 30, brief 3 vars+WhatsApp, prompteur) |
| 2 Moteur | 8 | 2 (mapping rushIndex, branchement mix audio) | 0 (Silero écarté par décision) |
| 3 Data | 5 | 0 | 2 (matrice 30+socle, bibliothèque audio CC0) |
| 4 Infra | 6 | 1 (paywall UI) | 1 (routes/webhooks paiement) |

**Ordre de fusion recommandé (micro-commits, CI = banc) :**
1. ShootingProtocol 2–4 prises + brief 3 variables + prompteur (Dimension 1) ;
2. câblage `rushIndex` plans→prises (Dimension 2) ;
3. manifeste v2 30 gabarits + `socle_universel.json` + validateur (Dimension 3) ;
4. branchement mix audio à l'export (banc ou pré-mix CC0) + bibliothèque (2+3) ;
5. routes/webhooks paiement + paywall à épuisement (Dimension 4) ;
6. lecteur de rendu + preview auto + partage 1 tap (Dimension 1, fermeture parcours).
