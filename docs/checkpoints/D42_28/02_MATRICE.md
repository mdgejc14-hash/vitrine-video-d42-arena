# D42.28 — Matrice finale de validation

Statuts : PASS / PARTIAL / FAIL / BLOCKED / NOT RUN. Environnements : **lab** (émulateur
CI, APK debug), **prod** (services de production : Worker, D1, B2, Firebase), **physique**
(test fondateur, jamais simulé). Légende : ⏳ en cours. (Fichier recréé après restauration
du workspace — contenu identique aux commits D42.28-08/09, complété au fil de l'eau.)

## P0 — Firebase réel dans toute la chaîne de build

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | SHA-256 | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|---------|--------|---------|
| P0-1 | Le défaut RC12 est démontré avant correction | Analyse binaire dex : 1× `AIzaSyD42LABDUMMYKEY`, 0× clé réelle dans l'APK rc12 | — (analyse locale) | — | RC12 inapte à l'inscription Google | docs/checkpoints D42.28/00 | ef85cff7…0655 (apk rc12) | PASS | — |
| P0-2 | Injection de la clé réelle dans TOUT build officiel, sans jamais la committer | `ORG_GRADLE_PROJECT_vvFirebaseApiKey` (secret) + pré-vol + PORTE dex post-build (réelle présente, factice absente) | d027e2b | release-official-build (42706902169, tag d42.28-build-rc13) | Build RC13 SUCCESS, porte PASS : 1× réelle / 0× factice (classes.dex 9 462 208 o) | release-build-unsigned + logs job | be85fd9f…61e2c6 (apk non signée) | PASS | — |
| P0-3 | Même injection pour tous les builds de test (CI + lab) | android-ci + android-e2e-lab injectent la clé ; APK jamais artefact | d027e2b | android-ci 42690012981 (d027e2b) ; e2e-lab 42690012987 + 42695850837 | SUCCESS 41 jobs (d027e2b) puis 16/16 (0e9e84f) ; auth lab 11/11 avec clé réelle (A1 vrai flux Credential Manager) | artefacts e2e-lab | — | PASS | — |
| P0-4 | Banc auth sur l'APK OFFICIELLEMENT SIGNÉE avec image GMS playstore | Job auth-officiel-playstore : download asset, apksigner gate (758077eb…33e192), contrôle dex (1× réelle/0× factice), émulateur api 30 target playstore, run_auth.sh | d027e2b | release-official-e2e (42708544509, tag d42.28-rc13) | **10/10 PASS** : A1 vrai flux Credential Manager déclenché, A2 annulation propre + repli intact, A3 resoumission, A4 parcours continue, A5 vivante/sans crash | artefact auth-officiel | 4e8dd943…fdbc4 | PASS | — |
| P0-5 | Vrai compte Google = test physique fondateur | — | — | — | Réservé au fondateur (jamais simulé, jamais déclaré fait) | — | — | NOT RUN | Par choix ; aucun identifiant Google de test possédé |

## P1 — Audio : correction du silence initial + clés titulaires

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | SHA-256 | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|---------|--------|---------|
| P1-1 | Défaut démontré avant correction | Audit 600/600 : attaque 1,03–3,18 s (toutes > 1 s) | — | audio-audit (13643105300, 09/11) | rapport.json 600 mesures | artefact audit | — | PASS | — |
| P1-2 | Correction déterministe, originaux JAMAIS écrasés | fix_initial_silence.py : atrim(attaque−120 ms)+afade 0,4 s+mp3 128k 44,1 st ; garde anti-déploiement partiel ; NOUVELLES clés audio/bgm_r2/** | 0e9e84f | audio-fix-silence (42695901102, upload=false) | 600/600 corrigées conformes : attaque→0,00 s, ΔRMS ≤0,35 dB, 0 clipping, 600/600 décodables | audio-r2 (rapport/manifeste/SQL/journal) | manifeste : sha par piste (déterminisme 2 runs prouvé) | PASS | — |
| P1-3 | Upload B2 | 600 pistes r2 + ré-ingestion des titulaires absentes (30 m4a AAC + 30 mp3) | 0e9e84f | audio-fix-silence (42697768061, upload=true) | upload B2 600/600 + 30+30 titulaires ; originaux audio/bgm/** intacts (listing 691 clés) | audio-r2 | — | PASS | — |
| P1-4 | Migration D1 0013 (bgm_library → clés r2) | 600 INSERT OR REPLACE, statut EN_LIGNE, preuve_sha256 d42.28-fix-initial-silence | 7aefe65 | deploy-production (42702350485) | Migrations 0001→0013 appliquées (wrangler) ; worker redéployé ; smoke PASS | logs deploy | — | PASS | — |
| P1-5 | Re-audit post-déploiement : attaque <0,5 s sur 600/600, titulaires servies sans repli | audio-audit full | 7aefe65 | **42728213996 (10/11 00:26) : 26 PASS / 0 FAIL** | attaque max **0,00 s** (600/600), silence bord 0/0, sha 600/600 conformes, titulaire sans ?v → **206 audio/mpeg** (servie, plus de repli), 0/60 titulaires absentes, RMS moyen −17,6 dB, 0 clipping, σ RMS 0,81 dB | artefact audio-audit-full | — | PASS | 1er run 42702694932 FAIL = incident cap B2 (P1-6), requalifié |
| P1-6 | Incident : plafond téléchargements compte B2 | Diagnostic HEAD/GET 403 AccessDenied « Class B cap exceeded » ; LISTINGS OK (691 anciens + 600 r2 présents) | 195d813 | b2-diagnostic (42705741236, 195d813) | Bucket INTACT — cap de compte épuisé par les ~1200 GET des runs de correction ; reset quotidien 00:00 UTC | logs diagnostic | — | PASS (diagnostic) | Option fondateur : relever le cap (Caps & Alerts, 0 FCFA) |

## P2 — Offline

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | SHA-256 | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|---------|--------|---------|
| P2-1 | Export complet hors connexion (BGM pré-téléchargé puis réseau coupé) | run_offline_export.sh + job android-e2e-offline-export ; surveillant coupe svc wifi+data dès files/bgm/*.mp3 | 0e9e84f + cb12a4f + a1565d2+ (instrumentation D42.28-13) | 42695850837 : 40/2 (sh -c/adb) ; 42728504073 : 40/2 — **export offline réussi 2 fois** (CONFIRMED, solde 2, rushs, retour réseau, zéro crash ; D42-VERIF « gain solo » + hasAudioTrack=true dans le logcat) MAIS (a) sonde de surveillance jamais déclenchée (cause en cours d'instrumen­tation : double sonde run-as+root, trace surveillant.log, diagnostic post-run) et (b) verdict decode faussé par 162 warnings DTS de rushs émulés (0 vraie erreur) — critère corrigé (erreurs réelles uniquement) | e2e-offline-export ×2 | — | PARTIAL | Re-run avec banc instrumenté : la preuve de la COUPURE reste à établir |
| P2-2 | Idempotence du consume (jamais de double débit au rejeu outbox) | security-ci.mjs : re-POST même eventId ×3 | 0e9e84f | e2e-lab security-local (42695850837) | security_ci.txt **69 PASS/0 FAIL** : solde avant=1, dup:true ×3, crédits TOUJOURS 1, tentatives refusées sans décrément | security-local (security_ci.txt) | — | PASS | — |
| P2-3 | Preuves architecture offline (code) | ExportWorker CONFIRMED local ; jeton démo jamais envoyé/queue ; BgmStore cache+historique | (existant D42.21-23) | — | Lu et cité au checkpoint 00 | — | — | PASS | — |

## P3 — Parcours commercial × langues × modes audio

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | SHA-256 | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|---------|--------|---------|
| P3-1 | Banc 4 langues × 3 modes audio (parcours complet + export + preuves acoustiques) | run_audio_modes.sh (musique/voix/mix) + workflow android-e2e-p3-modes (3 jobs × 4 langues) | c7c3338 | ⏳ (déclenchement après reset cap B2 — chaque cellule télécharge 1 BGM) | ⏳ | e2e-p3-{musique,voix,mix} | — | NOT RUN | — |
| P3-2 | Parole jamais obligatoire | Mode musique seule = rushs muets (émulateur) ; aucun blocage sans voix | c7c3338 | (couvert par P3-1 mode musique × 4 langues) | ⏳ | idem | — | NOT RUN | — |
| P3-3 | Preuve localisation jusqu'à l'export | Libellés extraits des values*/strings*.xml ; brief FR par design (gabarits non localisés — documenté) | c7c3338 | (couvert par P3-1) | ⏳ | idem | — | NOT RUN | Constat d'architecture à documenter |

## Livraison

| # | Exigence | Fonctionnalité | Commit | Workflow (run) | Résultat | Artefact | SHA-256 | Statut | Réserve |
|---|----------|----------------|--------|----------------|----------|----------|---------|--------|---------|
| L-1 | RC13 construite, signée, non destructive (RC12 conservée) | release-official-build (porte dex) + re-signature locale cert officiel + release privée d42.28-rc13 | d027e2b (workflows) ; tag d42.28-build-rc13 | build 42706902169 SUCCESS ; release 439701454 | APK signée 44 166 078 o, cert 758077eb…33e192, SHA-1 89fab9b6…cd8a3 | vitrine-video-rc13.apk (asset release) | 4e8dd943f2fd97358b3a6df0c08d2ed4ab1615446b3e7f2edd8dcdd4289fdbc4 | PASS | — |
| L-2 | Validation e2e officielle RC13 | release-official-e2e : e2e-official + auth-officiel-playstore | d027e2b | 42708544509 SUCCESS | e2e-official **37 PASS/0 FAIL** (parcours complet : brief, prises, export 7 861 674 o, FGS, écran éteint, partage, zéro crash) ; auth-officiel **10/10** | artefacts des 2 jobs | 4e8dd943…fdbc4 | PASS | Export de CE run sans musique (cap B2 dépassé pendant le run → prefetch en repli) — l'audio en production revalidé par P1-5/P3 |
| L-3 | Non-régression ciblée post-changements | e2e-lab complet (16 jobs) | — | 42728504073 (6b72a03) : 15/16 — seul auth-local FAIL (compteur 12 migrations codé dur, corrigé a1565d2) ; 42732930889 (a1565d2) : **14/16, les 2 échecs = infrastructure** (« could not connect to TCP port 5554 » : émulateur non démarré sur android-e2e-offline et langues-ja, zéro E2E_RESULT émis) — auth-local PASS (13 migrations), offline-export SUCCESS ; run abf3b5e en cours pour le verdict final | artefacts e2e-lab | — | PARTIAL | 2 jobs flaky infra à revalider (run en cours) |
| L-4 | Matrice finale + checkpoint + rapport | docs/checkpoints/D42_28 + matrice + rapport | — | — | Ce document + 00_PLAN_ET_ETAT.md | — | — | PARTIAL | Complété en fin de mission |

## Consommation CI (indicatif)

- Runs du 09/11 : android-ci ×4, e2e-lab (2 complets + 2 annulés), audio-fix ×2,
  audio-audit ×1, b2-diagnostic ×3, deploy ×1, release-build ×1, release-e2e ×1.
- Cap B2 (compte, pas CI) : épuisé à ~21:10 UTC par ~1200 GET (correction audio) —
  reset 00:00 UTC (10/11).

## Incident de reprise (10/11 00:23 UTC)

Le bac à sable a été restauré à un état antérieur (D42.27-11d, 8d530b1) : `.git/config`
(exclu des snapshots) et les commits locaux NON poussés (D42.28-07/08/09 : mises à jour
du checkpoint 00 + matrice) ont été perdus. **Aucune perte de fond** : tout le code, les
workflows, la migration 0013 et le checkpoint de base étaient poussés (195d813) ;
remote rétabli, `reset --hard origin/main`, checkpoint et matrice recréés à l'identique.
