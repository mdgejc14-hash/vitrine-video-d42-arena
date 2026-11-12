# D42.30 — 08_RC_FINALE

**RC15 = release GitHub 442574529 (tag `d42.30-rc15`, prerelease), commit
137c972.** CinetPay volontairement reporté. Budget : 0 FCFA.

## Empreintes de livraison

| Artefact | Taille | SHA-256 |
|---|---|---|
| **vitrine-video-rc15.apk** (asset 738360276, signée cert officiel) | 44 470 123 o | `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936` |
| APK non signée (sortie CI `assembleRelease` R8) | 44 397 306 o | `110789cfde00471a37add457fee4f5c9aacffd8db35dfa763ffbd67f49804f4a` |
| mapping R8 | 83 068 643 o | `cebff1663fd23cf64147f0fe325dea7c52ff289c72941f5ea7a0145e27d6dc9b` |
| Certificat de signature | — | `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192` (SHA-1 `89fab9b6…cd8a3`, identique RC12/RC13/RC14 — continuité OAuth Google) |

Chaîne de production : tag `d42.30-build-rc15` (137c972) → **release-official-build
43167390743 SUCCESS** (tests unitaires feature-export 0 échec, APK R8, porte
dex : 1× clé Firebase réelle / 0× factice) → signature locale zipalign +
apksigner (keystore officiel, jamais committé, `vv-signing/` gitignoré) →
release 442574529 + asset → **release-official-e2e 43168986328 SUCCESS** sur
l'APK signée exacte.

## Validation sur l'APK signée exacte (release-official-e2e 43168986328)

- **e2e-official : PASS=36 FAIL=0 BLOCKED=0** (recompté ; P1 35/0/0 + partâge)
  — parcours commercial complet sur l'APK de livraison : catalogue → brief →
  caméra → 2 prises (guide terminé, aperçu atteint) → export **abouti** →
  MP4 extrait → partage, notification FGS, écran éteint 45 s, zéro crash.
- **auth-officiel-playstore : 10/10** — vrai flux Credential Manager,
  annulation propre, repli intact, resoumission, aucun crash.
- **Porte apksigner : PASS** — « l'APK porte le certificat officiel »
  (758077eb…33e192).
- **Porte dex : PASS** — clé Firebase réelle présente, factice absente.

## Qualification complète du commit 137c972 (= 02eff63 + docs)

| Banc | Verdict | Preuve (runs GitHub) |
|---|---|---|
| android-ci | SUCCESS | 43167388352 (137c972), 43160964884 (02eff63), 43154617344 (818d8d6) |
| android-e2e-lab | 14/14 jobs | 43167388350 (137c972, lab final — voir ligne p1 ci-dessous) |
| Caméra (camerap) | **62 PASS / 0 FAIL / 0 BLOCKED** ×6 runs | labs 43082333578, 43100433919, 43115322040, 43129951436, 43142014528, 43167388350 |
| Parcours complet (p1) | **35/0/0** sur 02eff63/b279bca | labs 43142014528, 43148343691, 43160964840 |
| Export hors connexion + OFFX | **35/0/0 + OFFLINE_EXPORT 41/0** | lab 43142014528 (b279bca) : RMS musique -17,609 dB, journal CONFIRMED, solde 2 |
| 3 modes audio × fr/en | **6/6 cellules à 0 FAIL** | p3-modes 43161021108 (02eff63) : voix 28/0×2, mix 28/0×2, musique 27/0×2 |
| FR/EN uniquement | **S03b_es_ja_absents PASS ×4** | lab 43129951436 android-e2e (base/font130/rot90 + petit écran) |
| Langues EN | SUCCESS | job android-e2e-langues (en) |
| Auth, brouillons, deeplink, offline, backend-http, security, selftest, gabarits-audit | SUCCESS | jobs des labs ci-dessus |

**Lab final 43167388350 (137c972) : 14/14 jobs SUCCESS côté GitHub, MAIS le
journal fonctionnel du job android-e2e-p1 (131012346489) donne 21 PASS /
6 FAIL / 7 BLOCKED — le parcours complet n'est PAS validé sur ce run.**
RCA (artefact 13925839270) : le whatsapp tapé « 0197000000 » (vérifié au dump
de saisie) est devenu « 019700000 » (9 chiffres) au remplissage suivant —
course IME/perte de focus sur un runner fortement ralenti (job de 113 min vs
~35). **L'app a CORRECTEMENT refusé le numéro invalide** (« Ce numéro n'est
pas valide pour le pays choisi ») : formulaire, clavier, bouton et validateur
sont sains ; le défaut est le REMPLISSAGE AUTOMATISÉ (volatilité de frappe
sans contrôle final). Les 6 FAIL = brief_valide + 5 cascades (pas de caméra →
pas de rushs → pas d'export). Correctif **D42.30-17 (harnais uniquement)** :
contrôle d'intégrité final avant Continuer — si l'app AFFICHE une erreur de
champ, le champ fautif est re-saisi (2 essais). Aucun changement produit :
**l'APK RC15 reste exacte** (le code app de 137c972 est inchangé) ; la
preuve de livraison sur l'APK signée reste release-official-e2e 43168986328
(36/0/0). Revalidation : lab sur le commit du correctif (p1 + offline-export
embarquent run_p1.sh).

## Défauts terrain RC14 → correctifs D42.30 (aucun défaut sans correction ou preuve)

| # | Défaut constaté (fondateur, RC14) | Correction | Preuve |
|---|---|---|---|
| 6 | Écran caméra NOIR malgré permission | `setSurfaceProvider` branché (67f6421) — le PreviewView reçoit le flux | marqueur VV_E2E « PREVIEW STREAMING : le flux caméra est actif (frames réelles) » dans chaque run camerap (×6) — **capteur physique : voir § test humain** |
| 7 | Compte à rebours simulé | countdown 3-2-1 VRAI (démarrage de l'enregistrement APRÈS le décompte), annulable | marqueurs « compte à rebours : 3/2/1 » → « startRecording : ENREGISTREMENT ACTIF » ; camerap 62/0/0 ×6 |
| 8 | Rien ne prouve que les scènes sont filmées | état STREAMING, badge REC lié au recorder, Finalize avec taille de fichier, slots réels | « Finalize : hasError=false taille=… » ×2/run ; rushs MP4 extraits (734 339 / 729 812 / 677 523 o…) ; p1 P1_rushs_fichiers + P1_mp4_extrait PASS |
| — | (découvert en qualification D42.30-14) **export mort si prise sautée** | sonde audio sur les rushs RÉELS (`RushSlots.resolve`) au lieu du tableau brut à slots vides | p1 35/0/0 + OFFX 41/0 sur b279bca (P1_export_termine PASS, journal CONFIRMED) |
| 1 | Message « récupération des crédits » après inscription | enchaînement bootstrap→claim→grant contrôlé, taxonomie d'erreur welcome (réseau/401/403/404/5xx/profil) | backend-http + security-local SUCCESS ; OFFX solde crédits juste (2) ; codé dd5ca28 |
| 3 | WhatsApp : validation et exemple obsolètes (+229 97…) | libphonenumber 8.13.50, sélecteur de pays (BJ défaut), collage E.164, migration des 30 gabarits vers « 01 » 10 chiffres (10a12e1, versionCode 2) | P1_brief_valide PASS avec 0197000000 (p1 35/0/0 ×3 labs + APK signée) ; validation JVM libphonenumber (BJ/FR) |
| 4 | Prix : secousses pendant la saisie | ChampPrix brut-à-la-frappe, suffixe FCFA, emplacement d'erreur RÉSERVÉ (plus de saut de layout) | p1 P1_brief* PASS ×3 ; saisie harnais vérifiée (D42.30-13) |
| 5 | Mauvaise gestion clavier / éléments hors écran | adjustResize, imePadding, header repliable < 340dp | petit-ecran SUCCESS (run_p0 pixel5 base/font130/rot90) ; S03b ×4 |
| 2 | Catalogue pas assez professionnel | VignetteCatalogue (vignettes sectorielles DESSINÉES, durée/scènes/prises), « Changer de secteur » discret | gabarits-audit SUCCESS (30 gabarits/6 secteurs) ; p1 P1_catalogue + P1_gabarit_visible PASS |
| 9 | Présentation générale < confiance commerciale | écrans vérification redessinés (ReadyCheck responsive), parcours 25+ étapes uniforme | p1 35/0/0 (parcours complet) + 36/0/0 sur l'APK signée |
| — | Périmètre linguistique | FR/EN uniquement, es/ja retirés du parcours actif | S03b_es_ja_absents ×4 ; asset l10n purgé (9 716→4 948 o) ; archives content/archive_i18n/ |

## Tests humains restants (distincts du laboratoire)

Le laboratoire prouve le produit sur **caméra ÉMULÉE** (flux CameraX réel,
fichier MP4 réel, mais capteur synthétique). Restent au fondateur, sur son
téléphone :

1. **Capteur physique** : viseur vivant (STREAMING du vrai capteur), compte à
   rebours au doigt, MP4 filmé par le capteur — `BLOCKED_DEVICE_TEST` si non
   exécuté au scellage (aucune confusion émulé/physique dans les verdicts).
2. **Acceptation finale** : parcours commercial de bout en bout sur l'APK
   RC15 (installe `vitrine-video-rc15.apk`, empreinte ci-dessus), ressenti
   général (défaut 9).
3. Comportement export sur matériel réel (codecs matériels — l'émulateur
   swiftshader encode en ~12 min/tentative, un téléphone réel est
   attendu bien plus rapide).

## Journal GitOps de la mission (chaîne poussée)

99b210b (RC14+) → …→ 5082856 → 67f6421 (P0 caméra) → 8c9f514 → 09d3e74 →
0de99a6 → 05ca482 → 401ce39 (D42.30-11) → 46fe2a4 (D42.30-12 es/ja) →
4ee2b4b (D42.30-13 harnais saisie) → b279bca (**D42.30-14 fix export**) →
39189c4 (journal) → 818d8d6 (D42.30-15 p3) → 02eff63 (D42.30-16) →
**137c972 (état final, tagué d42.30-build-rc15 + d42.30-rc15)**.

Tags : `D42_29`, `d42.29-build-rc14`, `d42.29-rc14`, `d42.30-build-rc15`,
`d42.30-rc15`. Releases : RC14 = 441446648, **RC15 = 442574529**.
