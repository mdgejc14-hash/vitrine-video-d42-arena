# Rapport de Couverture Automatisé — Scellement version officielle

Généré par le harnais CI-Visual-Check FULL-FLOW + suite JVM, méthode couteau suisse
(zéro build Gradle local, CI = seul banc, 0 FCFA d'infrastructure).

## Verdict synthétique

**11 exigences métier identifiées / 11 exigences tracées / 9 preuves automatisées
vertes en CI / 3 sous-points déclarés « code vérifié » (non automatisés) / 1 périmètre
futur assumé (billing additif §2.4).**

Aucune exigence n'est déclarée verte sans preuve exécutable (capture Robolectric
NATIVE, test JVM, ou assertion sémantique) ; aucune capture n'est déclarée valide
sans relecture visuelle et métier humaine-agentielle.

## Détail par exigence

| ID | Exigence | Preuve automatisée | Statut |
|---|---|---|---|
| EX-I18N-4L | 4 langues fr/en/es/ja | capture 01 (4 cartes langues) + parité i18n 0 clé manquante × 6 modules | 🟢 VERT |
| EX-CAROU-3S | carousel 3 slides + slogans | capture 02 (dots, slogan, Next) | 🟢 VERT |
| EX-SECT-3D | secteurs 3D + persistance | capture 03 (6 cartes, contour actif) + lecture `vv_session` par CatalogActivity | 🟢 VERT |
| EX-CATF-DYN | catalogue filtré dynamique | capture 04 FR (sous-titre secteur, 1 carte mode, zéro étiquette hors-sujet) + assertions `assertCountEquals(1/0)` sur titres FR | 🟢 VERT |
| EX-NAV-BACK | Retour natif = étape précédente | revue de code `stepBack()` (chaîne E6→E1, état conservé) | 🟡 CODE VÉRIFIÉ |
| EX-CAM-INS | tournage guidé INS | captures 05/06/07 FR (compteur 1/N, jauge, consigne FR, cadre 9:16, badge R4) + `ProfilerAndConsentTest` (R4 JVM) ; verrou 3A câblé (`launchLockedRecording`) vérifié par code | 🟢 VERT (3A 🟡) |
| EX-IMP-GAL | import galerie client | capture 08 + `BriefValidatorTest` | 🟢 VERT |
| EX-MOT-M3 | moteur Media3 1.11 | `PipelineLogicTest`, `MotionJsonTest`, `DefaultBeatSheetTest`, `BeatGridTest` | 🟢 VERT |
| EX-AUD-14 | contrat sonore −14 LUFS / ducking | `AudioChainTest` (commandes ffmpeg) ; mix = banc ffmpeg (limite Media3 documentée) | 🟢 VERT (contrat) |
| EX-EXP-PREV | export & prévisualisation | capture 09 FR (récap + typo cinétique mot-clé orange) ; WorkManager vérifié par code | 🟢 VERT (WM 🟡) |
| EX-AUTH-D1 | SSO Firebase + D1/webhooks | `AdminGateTest`, `DemoSessionTest`, `RefCodeParserTest` + CI Phase A worker (`/health`, migrations 0001-0003) ; billing §2.4 planifié | 🟢 VERT (billing ⏳) |

## Runs de référence

| Run | Head | Verdict | Artifact visuel |
|---|---|---|---|
| 40294170715 | `eba3089` | success | `ci-visual-check` 12637951581 (10 PNG FR, 214 862 o) |
| 40297292891 | `ffe6ed0` | **success (scellement)** | `ci-visual-check` 12638368756 (10 PNG FR, 217 296 o) + APK release 12638529614 |

## Restes assumés (honnêteté)

1. Verrou 3A, orchestration Retour natif, intégration WorkManager : vérifiés par
   lecture de code, pas de test automatisé dédié (API matériel / orchestration
   Activity) — jamais présentés comme « testés au vert ».
2. Mix loudnorm/ducking exécuté au banc ffmpeg : Media3 1.11 ne fournit pas ces
   effets (documenté, non contournable proprement on-device).
3. Captures Robolectric = rendu logiciel NATIF : fidèles layout/couleurs/textes ;
   thumbnails réseau absents (placeholder « … »), silhouette cadrage prévue pour
   fond sombre du viseur réel.
4. Routes billing FedaPay/CinetPay : additives §2.4, hors worker v0.9.0.
