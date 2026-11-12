# D42.30 — 07_MATRICE_FINALE

Matrice de validation produit sur **02eff63** (= b279bca + harnais ; le code APP
est celui de b279bca (fix export D42.30-14 ; chaîne
46fe2a4 → 4ee2b4b → b279bca → 39189c4 docs). Tous les bancs = émulateur API 30
Pixel 5 swiftshader, APK debug du commit, sauf mention contraire. Aucun PASS
fabriqué : chaque ligne pointe le run/artefact GitHub qui la prouve.

## P0 — Caméra réelle (défauts fondateur 6/7/8)

| Test | Verdict | Preuve |
|---|---|---|
| STREAMING capteur (flux réel dans le viseur) | PASS ×5 | camerap 62/0/0 — marqueur VV_E2E « PREVIEW STREAMING : le flux caméra est actif (frames réelles) » (artefacts e2e-camerap, ex. 13894710199) |
| Compte à rebours 3-2-1 VRAI puis enregistrement | PASS ×5 | marqueurs « compte à rebours : 3/2/1 » → « startRecording : ENREGISTREMENT ACTIF » |
| Jamais 2 enregistrements simultanés | PASS ×5 | garde onRecord « enregistrement=true » refusé |
| Finalize + fichier rush complet | PASS ×5 | « Finalize : hasError=false taille=…octets » ×2 par run |
| Suppression fichier incomplet si échec | codé+couvert | CameraGuideActivity l.494 (chemin d'échec défensif) |
| Bascules AVANT/ARRIÈRE, Refaire slot seul, reprise, conservation | PASS ×5 | camerap 62/0/0 |
| Zéro crash caméra | PASS ×5 | camerap 62/0/0 (aucun FATAL du processus app) |
| **Caméra CAPTEUR PHYSIQUE (téléphone fondateur)** | **BLOCKED_DEVICE_TEST** | exige un appareil réel ; seuls le STREAMING capteur, le countdown au doigt et le MP4 capteur y sont prouvables |

## P1 — Produit

| Domaine | Verdict | Preuve |
|---|---|---|
| Catalogue 30 gabarits / 6 secteurs | PASS | gabarits-audit SUCCESS (structure, brief, séquences, durées) |
| Brief : prix stable, clavier, erreurs à hauteur réservée | PASS | p1 35/0/0 + offline-export 35/0/0 (P1_brief*, P1_prise*) |
| WhatsApp international (BJ 01 10 chiffres, sélecteur pays, E.164) | PASS | P1_brief_valide avec 0197000000 ; libphonenumber 8.13.50 validé JVM |
| Écran vérification (ReadyCheck responsive) | PASS | p1 P1_brief_valide → « Avant de commencer » |
| Parcours complet 25+ étapes | **PASS 35/0/0** | lab 43142014528 job android-e2e-p1 (log FIN P1) |
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
