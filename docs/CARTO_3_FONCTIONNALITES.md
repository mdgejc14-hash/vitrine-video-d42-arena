# CARTOGRAPHIE 3 — Inventaire Exhaustif des Fonctionnalités Métier

Légende : ✅ livré · 🎯 cible de ce cycle · ⏳ planifié.
Chaque moteur = module du dépôt + contrat testé. Rien n'est déclaré livré sans
test JVM/Robolectric vert ou preuve de code (TRACEABILITY_MATRIX.md).

## 1. Vue d'ensemble des 6 moteurs

```
+--------------------------- APPLICATION ---------------------------+
|                                                                    |
|  [M1] MOTEUR CAMERA INS          [M2] MOTEUR MONTAGE Media3        |
|   CameraX 3A lock                 WordClock (horloge voix)         |
|   ML Kit gate R4 visages          BeatGrid + DefaultBeatSheet      |
|   DeviceProfiler/EncoderProbe     MotionComposition (z(t), cuts)   |
|   🎯 guide 2-4 prises             KineticTypography orange         |
|             |                              ^                       |
|             | rushs mp4                    | plans->rushIndex      |
|             v                              |                       |
|  [M3] MOTEUR AUDIO AudioChain    [M4] MOTEUR CATALOGUE B2          |
|   highpass/lowpass/comp            manifest JSON injectable        |
|   loudnorm -14 LUFS / -1 dBTP      cache offline + canary          |
|   ducking sidechain voix           SkinDisplayName commercial      |
|             |                                                      |
|             v                                                      |
|  [M5] MOTEUR PERSISTANCE & SECURITE                                |
|   session/langue/secteur locaux    Firebase Auth JWKS              |
|   🎯 AES-256 coffres locaux        ⏳ Play Integrity (admin/billing)|
|             |                                                      |
|             v                                                      |
|  [M6] MOTEUR EXPORT & SYNCHRO (WorkManager)                        |
|   export local unique KEEP         sync silencieuse ⏳             |
|   crédits check léger              notification rendu              |
+--------------------------------------------------------------------+
```

## 2. Inventaire détaillé par moteur

### M1 — Caméra INS & verrous (`ins-capture`, `feature-camera`)
| Fonction | Contrat | Preuve | Statut |
|---|---|---|---|
| Verrou 3A (AE/AWB) avant prise | mesure centrée puis lock, auto-cancel 3 s | code `lockThreeA` câblé `launchLockedRecording` | ✅ (code) |
| Gate R4 visages | tout visage sans consentement = modale BLOQUANTE | `ConsentGate` + `ProfilerAndConsentTest` | ✅ |
| Stabilisation conditionnelle | active SEULEMENT si supportée HAL | `applyStabilizationIfSupported` | ✅ |
| Classe appareil | DeviceProfiler → bitrate/qualité adaptés | `CaptureSpecTest` | ✅ |
| Guide tournage | 🎯 2–4 prises nommées (Vue/Détail/Prix/Situation), 1 tap chacune | overlay actuel = 26 plans → ❌ rejeté, 🎯 simplifié | 🎯 |

### M2 — Montage Media3 1.11 (`ins-effects`, `feature-export`)
| Fonction | Contrat | Preuve | Statut |
|---|---|---|---|
| Horloge voix WordClock | mots pondérés = bornes de plans | `BeatGridTest`, `DefaultBeatSheetTest` | ✅ |
| Découpage 1,5 s (moyenne ≤ 1,5 s, max 3 s) | plans side MOTEUR, jamais côté marchand | tests bounds/durées | ✅ |
| Mapping plans → prises | `rushIndex` : plan i → prise i mod nPrises | champ existant, 🎯 câblage 2–4 prises | 🎯 |
| Zooms z(t) & recadrage 9:16 | MatrixTransformation NDC, z alterné | `PipelineLogicTest` | ✅ |
| Transitions | cycle cut/swipe/flash/glitch horodaté | `MotionJsonTest` | ✅ |
| Kinetic Typography orange | mot-clé coloré FF5500, contour noir | TextOverlay statique Media3 | ✅ |

### M3 — AudioChain (`ins-effects`, banc ffmpeg)
| Fonction | Contrat | Preuve | Statut |
|---|---|---|---|
| Cible master | loudnorm I=-14 LUFS, TP=-1,0 dBTP | `AudioChainTest` | ✅ |
| Ducking | sidechaincompress voix→musique (seuils mesurés) | `AudioChainTest` | ✅ |
| Chaîne voix | highpass 85, lowpass 15 000, comp -18/3:1, vol 1,06 | `AudioChainTest` | ✅ |
| Honnêteté | mix exécuté banc ffmpeg (Media3 1.11 sans effets audio) | documenté AUDIT_TECHNIQUE | ✅ assumé |

### M4 — Catalogue B2 injectable (`feature-catalog`, Workers/R2)
| Fonction | Contrat | Preuve | Statut |
|---|---|---|---|
| 180 gabarits sans recompiler | manifest JSON serveur + canary | `CatalogManifestParserTest`, `EdlParserTest` | ✅ |
| Cache offline | repli complet + bannière discrète | `CatalogRepository` | ✅ |
| Filtrage secteur | continuité onboarding→catalogue | capture 04 + assertions sémantiques | ✅ |
| Naming commercial | zéro code technique visible | `SkinDisplayName` + captures | ✅ |

### M5 — Persistance & Sécurité (`core-*`, `feature-onboarding`, worker)
| Fonction | Contrat | Preuve | Statut |
|---|---|---|---|
| Session/langue/secteur | locaux, restaurés au boot | `vv_session` + tests session | ✅ |
| Auth SSO | Firebase JWKS vérifié côté worker, sans téléphone | `AdminGateTest`, Phase A | ✅ |
| Coffres AES-256 | EncryptedSharedPreferences/Tink pour session+brouillons | à intégrer | ⏳ 🎯 prochain chantier |
| Play Integrity API | attestation device pour routes admin/billing | à intégrer | ⏳ |
| Consentements R4 archivés | horodatage local + preuve export | 🎯 avec AES-256 | 🎯 |

### M6 — Export & Synchro (`feature-export`, WorkManager, Workers)
| Fonction | Contrat | Preuve | Statut |
|---|---|---|---|
| Export local | work unique KEEP, contraintes batterie | `ExportWorker` | ✅ |
| Preview dynamisée | 🎯 lecture auto du rendu + partage 1 tap | panneau statique actuel | 🎯 |
| Sync silencieuse gabarits | periodic 12 h charging+idle, silent | à intégrer | ⏳ |
| Crédits | 1 requête légère à l'export, grace 24 h, paywall à épuisement | logique D13, routes §2.4 | 🎯/⏳ |

## 3. Règle d'or transverse

**Le marchand manipule des objets métier (produit, prix, offre, prises) ;
le moteur manipule des objets techniques (plans, bornes, rushIndex, LUFS).**
Aucun objet technique ne doit jamais apparaître dans une UI marchand —
c'est exactement la fuite (26 scènes) que cette cartographie referme.
