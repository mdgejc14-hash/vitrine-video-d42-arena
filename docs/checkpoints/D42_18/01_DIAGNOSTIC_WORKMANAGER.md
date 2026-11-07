# D42.18 — Diagnostic WorkManager : interruptions des exports longs

Référence du défaut : run rc8 (42377890560), artefact `run_42377890560`.
Symptôme : 4 interruptions successives d'ExportWorker à intervalles d'exactement
10 min, chaque relance reprenant l'encodage depuis le début.

## 1. Chronologie observée (rc8, logcat)

| Heure (UTC) | Événement |
|---|---|
| 13:51:36.019 | WM-WorkerWrapper : Starting work for ExportWorker |
| 14:01:36.021 | WM-Processor : WorkerWrapper interrupted — **raison -512** |
| 14:01:36.043 | Work [...] was cancelled |
| 14:01:36.064 | relance immédiate (WorkSpec **c987c10c… inchangé**) |
| 14:11:36.059 | interruption n°2 (raison -512) → relance |
| 14:21:36.108 | interruption n°3 → relance |
| 14:31:36.142 | interruption n°4 → relance (capture logcat close) |

Faits clés :
- le **même WorkSpec** (id `c987c10c…`) est relancé à chaque fois → ce n'est
  pas un nouvel enqueue, c'est le retry automatique de WorkManager ;
- l'intervalle est **exactement 600,000 s** → quota d'exécution du JobScheduler,
  pas une contrainte batterie (batterie 100 %, `RequiresBatteryNotLow` satisfait) ;
- raison **-512 = EINTR/InterruptedException** : arrêt du job imposé par le
  système, pas un échec applicatif ;
- le rythme d'encodage swiftshader est de 8 à 12+ min par tentative selon le
  gabarit (durée vidéo aléatoire au parcours) : un gabarit court passe
  (rc6, ~8 min), un gabarit long **ne peut jamais terminer** dans le quota.

## 2. Cycle de vie d'ExportWorker (lecture du code)

- `ExportWorker` est un **`CoroutineWorker`** (`feature-export/.../ExportWorker.kt`),
  sans `setForeground`/`setForegroundAsync` — la promesse T1 affichée à
  l'utilisateur (`export_t1` : « éteins ton écran, la notification te prévient »)
  n'est donc **pas tenue** : aucun service de premier plan, aucune notification.
- Enqueue : `OneTimeWorkRequestBuilder<ExportWorker>` + contrainte
  `setRequiresBatteryNotLow(true)` + `enqueueUniqueWork("vv-export",
  ExistingWorkPolicy.KEEP)` depuis `ExportActivity.enqueueNow()` (tap utilisateur).
- Exécution : WorkManager 2.12.0 fait tourner le worker dans un **job
  JobScheduler** (non expedited, non foreground) → soumis au quota de runtime
  des jobs d'arrière-plan (~10 min sur API 30+ selon l'état de l'app).
- À l'arrêt système : la coroutine `doWork` est annulée (CancellationException)
  → **aucune branche Succès/Échec du code crédits n'est exécutée** → le journal
  reste `RESERVED` → WorkManager relance le même WorkSpec → `doWork` repart
  de zéro (l'entrée RESERVED est réutilisée, pas de nouveau débit).
- `runAttempt` n'est pas plafonné côté app (pas de `setRunAttemptLimit`), et un
  arrêt système ne compte pas comme un échec applicatif : **boucle sans fin
  tant que le quota est atteint avant la fin de l'encodage**.

## 3. Progression et reprise

- `setProgress(KEY_PROGRESS=100)` n'est appelé **qu'au succès final** : le « % »
  affiché à l'utilisateur reste « — % » pendant tout l'encodage (cosmétique,
  constaté sur les dumps rc6/rc7/rc8).
- media3 Transformer **ne peut pas reprendre un encodage à mi-chemin** : chaque
  tentative ré-encode intégralement (fichier de sortie `export-$attempt.mp4`
  réécrit depuis le début). Il n'existe pas de mécanisme de checkpoint/resume
  dans Transformer 1.11.1 — la reprise partielle n'est PAS une option minimale.
- Conséquence mesurée : à chaque interruption, tout le travail d'encodage déjà
  effectué est perdu (rc8 : ~40 min de CPU pour 0 export complet).

## 4. Crédits — risques de double consommation (examen demandé)

Sémantique du code (`doWork` + `ExportActivity`) :
- **Réservation** : UN seul `atomicDebit` + UNE ligne `RESERVED` par exportId,
  fait dans l'activité AVANT l'enqueue (garde `dejaEnCours` + compensation
  immédiate si l'enqueue est impossible : D41-F14) ;
- **Retry système** (notre cas) : le WorkSpec relancé porte le même
  `KEY_EXPORT_ID` → `doWork` exige une ligne `RESERVED` existante → aucun
  nouveau débit. Preuve rc8 : 5 démarrages du worker, **une seule** ligne
  RESERVED dans `export_journal` (balanceAfter=2) ;
- **Succès** : `CONFIRMED` + consommation serveur idempotente
  (`eventId = exportId`, D40-A3/A7) ;
- **Échec définitif** : `COMPENSATED` idempotent (garde `already`) + bilan
  serveur `ok=false` ;
- **Process tué / app fermée pour toujours** : réconciliation
  `reconcileOrphelines()` à l'ouverture d'ExportActivity — toute ligne RESERVED
  de plus de `ORPHELINE_AGE_MS = 120 s` sans travail WM actif est compensée ;
- **Aucune perte** : RESERVED n'est ni consommé ni perdu ; au pire il est
  temporairement « gelé » jusqu'à la relance du travail ou la réconciliation.

Conclusion crédits : **pas de double consommation possible dans la boucle rc8** ;
le défaut est purement l'incapacité à terminer (perte de temps/CPU/batterie,
pas de perte de crédit).

## 5. Cadre Android : quotas, restrictions, permissions, types FGS

- **Quota JobScheduler** : un job non-foreground d'une app en arrière-plan est
  arrêté au bout de ~10 min de runtime (API 30+ ; comportement constaté = arrêt
  net à 600,000 s même app au premier plan). Un **service de premier plan**
  n'est PAS soumis à ce quota.
- **Android 12+ (API 31+)** : démarrage d'un FGS **depuis l'arrière-plan**
  interdit (`ForegroundServiceStartNotAllowedException`). Notre enqueue vient
  d'un tap utilisateur (app au premier plan) et le worker démarre en pratique
  immédiatement (contrainte batterie presque toujours satisfaite) → le
  `setForeground` initial s'exécute pendant la fenêtre de premier plan.
  Risque résiduel : démarrage différé du worker alors que l'utilisateur a déjà
  fermé l'app → l'appel peut lever ; comportement de repli : l'export continue
  en job classique (statu quo rc8, jamais pire qu'avant).
- **Android 13+ (API 33+)** : `POST_NOTIFICATIONS` est une permission runtime.
  Sans octroi, le FGS **tourne quand même** (la notification n'est simplement
  pas affichée ; l'entrée « appli en cours » reste visible dans le sélecteur).
  Correctif minimal : déclaration manifeste uniquement, sans demande runtime
  (aucune modification d'UI) — documenté comme choix.
- **Android 14+ (API 34+)** : tout FGS doit déclarer un **type** + la permission
  spécifique du type. Type retenu : **`dataSync`** (traitement/export de
  données ; nécessite `FOREGROUND_SERVICE_DATA_SYNC`).
  Alternative rejetée : `mediaProcessing` (API 35+ uniquement — inutilisable
  avec minSdk 24 sans arbre de repli ; ajouté pour ce cas d'usage mais non
  rétrocompatible).
- **Android 15 (API 35+)** : plafond dataSync ≈ 6 h/24 h — très au-delà de tout
  export réel (minutes) ; sans effet.
- **minSdk 24** : canal de notification requis dès API 26+ ;
  `ForegroundInfo(id, notification, type)` disponible dès API 29 — garde
  `Build.VERSION` pour le type et le canal.

## 6. Cause racine et pronostic

**Cause racine** : l'export s'exécute en job JobScheduler d'arrière-plan sans
service de premier plan ; le quota ~10 min du JobScheduler est inférieur au
temps d'encodage d'un gabarit long sur codec lent (émulateur swiftshader,
téléphone modeste), et media3 Transformer ne reprend pas à mi-encodage.

**Pronostic du correctif FGS** : le worker échappe au quota JobScheduler →
l'encodage, même long, termine en UNE tentative → `SUCCEEDED` → l'UI affiche
« Vidéo prête ! » et le bouton Partager (observables qui manquaient en CI).
Sur appareil réel avec codec matériel, le temps d'encodage tombe à quelques
secondes-minutes et le correctif ne fait qu'ajouter la notification promise.

**Ce que le correctif ne fait PAS (choix minimal)** :
- pas de persistance de progression d'encodage (Transformer ne le permet pas ;
  le « % » restera « — % » — cosmétique, hors périmètre) ;
- pas de reprise à mi-encode (idem) ;
- pas de demande runtime POST_NOTIFICATIONS (aucune modif d'UI) ;
- pas de modification de l'enqueue, des contraintes, de la politique de retry,
  du backend, ou du chemin crédits.
