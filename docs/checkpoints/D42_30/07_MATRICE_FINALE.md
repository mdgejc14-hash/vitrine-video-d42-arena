# D42.30 — 07_MATRICE_FINALE

Matrice de validation produit sur **02eff63**, revalidée sur **0abebc9**
(= 137c972 + harnais D42.30-17/-18 ; **le code APP est inchangé depuis b279bca**
(fix export D42.30-14 ; chaîne
46fe2a4 → 4ee2b4b → b279bca → 39189c4 → 818d8d6 → 02eff63 → 137c972 → 95449cf → 6ef3273 → 0abebc9, seule la suite harnais évolue). Tous les bancs = émulateur API 30
Pixel 5 swiftshader, APK debug du commit, sauf mention contraire. Aucun PASS
fabriqué : chaque ligne pointe le run/artefact GitHub qui la prouve.

## P0 — Caméra réelle (défauts fondateur 6/7/8)

| Test | Verdict | Preuve |
|---|---|---|
| STREAMING capteur (flux réel dans le viseur) | PASS ×8 | camerap 62/0/0 — marqueur VV_E2E « PREVIEW STREAMING : le flux caméra est actif (frames réelles) » (logcat e2e-p1 du lab 43193984605 : artefact 13932824643, 09:56:02 ; artefacts antérieurs ex. 13894710199) |
| Compte à rebours 3-2-1 VRAI puis enregistrement | PASS ×8 | marqueurs « compte à rebours » ×6 → « startRecording : ENREGISTREMENT ACTIF » ×2 (logcat 43193984605) |
| Jamais 2 enregistrements simultanés | PASS ×8 | garde onRecord « enregistrement=true » refusé |
| Finalize + fichier rush complet | PASS ×8 | « Finalize : hasError=false taille=…octets » ×2 par run ; rushs MP4 réels 787 554 / 747 527 / 760 139 o (B04_rushs_finaux.txt, artefact 13934217930) |
| Suppression fichier incomplet si échec | codé+couvert | CameraGuideActivity l.494 (chemin d'échec défensif) |
| Bascules AVANT/ARRIÈRE, Refaire slot seul, reprise, conservation | PASS ×8 | camerap 62/0/0 ; bascules prouvées par fichiers (flip_avant=1, bind_avant=1, flip_arriere=1) |
| Zéro crash caméra | PASS ×8 | camerap 62/0/0 (aucun FATAL du processus app, crash_a/b/c.txt vides) |
| **Résilience du harnais caméra (D42.30-18)** | **RÉSOLU** | épisode 43182516945 : 45/3/12 — remplissage whatsapp À L'AVEUGLE (tel=0 aux preuves CPA/CPB) + détection d'erreur greppant les dumps des phases PRÉCÉDENTES (CPC tel=1 à sa preuve mais FAIL sans même tenter Continuer) ; **app innocente** (elle refusait à juste titre les numéros vides/amputés). Correctif harnais-only 0abebc9 : portage saisir_et_verifier + contrôle d'intégrité final + détection rescopée par phase. Revalidation 43193984605 : **62/0/0**, le correctif s'est DÉCLENCHÉ ×2 en vol (« saisie non confirmée, champ #1 — re-saisie » 09:52:52 et 10:16:09) : le défaut a été intercepté et réparé, pas évité par chance |
| **Caméra CAPTEUR PHYSIQUE (téléphone fondateur)** | **BLOCKED_DEVICE_TEST** | exige un appareil réel ; seuls le STREAMING capteur, le countdown au doigt et le MP4 capteur y sont prouvables |

## P1 — Produit

| Domaine | Verdict | Preuve |
|---|---|---|
| Catalogue 30 gabarits / 6 secteurs | PASS | gabarits-audit SUCCESS (structure, brief, séquences, durées) |
| Brief : prix stable, clavier, erreurs à hauteur réservée | PASS | p1 35/0/0 + offline-export 35/0/0 (P1_brief*, P1_prise*) |
| WhatsApp international (BJ 01 10 chiffres, sélecteur pays, E.164) | PASS | P1_brief_valide avec 0197000000 ; libphonenumber 8.13.50 validé JVM |
| Écran vérification (ReadyCheck responsive) | PASS | p1 P1_brief_valide → « Avant de commencer » |
| Parcours complet 25+ étapes | **PASS 35/0/0** | lab 43182516945 (95449cf) job android-e2e-p1 (131061699172) : FIN P1 35/0/0 — brief valide + invalides refusés + caméra + 2 prises + rushs + export « Vidéo prête ! » + MP4 5 312 086 o + partage + notif FGS + écran éteint + zéro crash ; labs antérieurs 43142014528/43148343691/43160964840 ; APK signée 36/0/0 (43168986328) |
| Export local abouti, « Vidéo prête ! », partage | **PASS (1re fois)** | P1_export_termine + P1_partage PASS — fix D42.30-14 |
| Export HORS CONNEXION avec musique | **PASS** | OFFX_mp4_decode_offline : RMS -17.609050 dB > -28 |
| Journal d'export / crédits | **PASS** | OFFX_journal_export : CONFIRMED, solde 2 |
| Crédits/backend idempotents | PASS | backend-http + security-local SUCCESS (contrat requireUser, welcome-grant, 404/403/503) |
| FR/EN uniquement (es/ja retirés du parcours actif) | **PASS ×4** | S03b_es_ja_absents (lab 43129951436 android-e2e : base/font130/rot90 + petit écran) ; asset l10n purgé 9 716→4 948 o ; dialog dashboard FR/EN |
| Langues EN (parcours anglais) | PASS | android-e2e-langues (en) SUCCESS |
| Brouillons inter-sessions, auth, deeplink, offline | PASS | jobs SUCCESS lab 43142014528 |
| 3 modes audio (musique/voix/mix × fr/en) | **PASS 6/6 à 0 FAIL** | p3-modes 43161021108 (02eff63) : voix fr/en 28/0/0, mix fr/en 28/0/0, musique fr/en 27/0/0 — musique établie (D42-BGM + RMS global -17,6 dB), mix prouvé au delta (+5 dB vs voix seule), voix pass-through (intro quasi muette) |

## Stabilité

| Contrôle | Verdict | Preuve |
|---|---|---|
| Aucun crash app (parcours complet ×2 bancs) | PASS | P1_aucun_crash (filtre processus app, D42.30-11) |
| Écran éteint 45 s : export poursuivi | PASS | P1_ecran_etaint |
| Notification FGS canal vv_export | PASS | P1_notif_fgs |

## Correction produit de la mission (RCA artefacts)

**D42.30-14 — export mort si prise sautée** : `rushesAudioPresente()` sondait
le tableau BRUT de `client_rushes` (contient des slots vides « » quand une
prise est sautée — gabarit 3 prises, 2 tournées) → `setDataSource("")` lève →
repli conservateur « voix présente » → base silencieuse D42-21 désactivée →
export sans piste audio → audioVerdict=ECHEC → 3 tentatives rejetées →
FAILURE (journal COMPENSATED, ~35 min perdues, crédit compensé, AUCUNE vidéo
livrée). Fix : sonder `RushSlots.resolve()` (rushs réels = ce que la
composition utilise). Validé : p1 35/0/0 + OFFX 41/0 (b279bca).

## Reste à livrer

1. p3-modes vert (3 modes audio).
2. RC15 : tag `d42.30-build-rc15` (build signée cert officiel + R8 mapping +
   SHA-256) puis `d42.30-rc15` (E2E sur l'APK exacte + release GitHub).
3. Captures FR/EN (artefacts p1 FR + langues-en).
4. Caméra capteur physique : `BLOCKED_DEVICE_TEST` au scellage si le
   fondateur n'est pas disponible (test humain d'acceptation finale).
