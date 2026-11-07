# D42.18 — Décision d'architecture : ExportWorker en premier plan

## Décision

Promouvoir `ExportWorker` en travail de premier plan **`dataSync`** via
`setForeground(ForegroundInfo)` en tête de `doWork()`. **Un seul composant
modifié** (ExportWorker) + déclarations manifeste + chaînes/icône de
notification. Rien d'autre ne bouge.

## Pourquoi cette option

1. **C'est la promesse produit existante** : la chaîne `export_t1` affichée à
   l'utilisateur (« éteins ton écran, la notification te prévient ») suppose
   déjà un FGS. Le correctif ne crée pas une fonctionnalité, il livre celle
   qui est annoncée.
2. **Action directe sur la cause racine** : le quota ~10 min du JobScheduler
   ne s'applique pas à un service de premier plan → l'encodage long termine
   en une seule tentative (défaut rc8 : 4 interruptions / 40 min / 0 complet).
3. **Minimal et standard** : API WorkManager stable (2.12.0), motif documenté
   Android pour les traitements longs initiés par l'utilisateur.
4. **Aucun risque crédits** : le chemin crédits (RESERVED/CONFIRMED/
   COMPENSATED/réconciliation) n'est pas touché ; le FGS ne fait que supprimer
   les interruptions qui empêchaient d'atteindre CONFIRMED.

## Variantes écartées

| Variante | Pourquoi écartée |
|---|---|
| `mediaProcessing` FGS type (API 35+) | Non rétrocompatible (minSdk 24) ; imposerait un arbre de types par niveau d'API — pas minimal. `dataSync` est valide de API 29 à 36+. |
| Expedited work (`setExpedited`) | Les travaux expedited **ne peuvent pas** passer au premier plan sur API 31+ ; quota expedited limité par jour ; ne résout pas un encodage de 10+ min. |
| Reprise/checkpoint d'encodage | media3 Transformer 1.11.1 ne le supporte pas ; ré-implémentation du muxer = chantier majeur, hors minimal. |
| Plafonner `runAttemptLimit` pour échouer vite | Transformerait la boucle en échec définitif (compensation crédit) SANS produire la vidéo — l'utilisateur perdrait l'export au lieu de le gagner. |
| Persistance de progression (% UI) | Cosmétique ; exigerait brancher `Transformer.onProgress` → setProgress + observer UI = 2ᵉ composant modifié. Refusé (règle : un composant à la fois). |
| Demande runtime `POST_NOTIFICATIONS` | Modification d'UI du parcours d'export ; sans octroi le FGS tourne quand même (Android 13+ n'affiche juste pas la notification). À considérer plus tard, séparément. |
| Émulateur CI en API 34 | Masquerait le défaut sans le corriger (rejeté dès D42.17, confirmé). |

## Implémentation (résumé)

`ExportWorker.kt` (seul fichier de code modifié) :
- en tête de `doWork()`, **après** la validation du journal (RESERVED) et
  **avant** `doWorkInner()` : `runCatching { setForeground(createForegroundInfo()) }`
  — en cas d'échec (démarrage FGS depuis l'arrière-plan interdit, Android 12+),
  dégradation silencieuse : l'export continue en job classique (statu quo
  antérieur, jamais pire) ;
- `createForegroundInfo()` : `ForegroundInfo(NOTIF_ID, notification,
  ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)` sur API 29+, forme simple
  en-dessous ; notification `ongoing`, canal `vv_export` créé à la demande ;
- arrêt automatique du FGS par WorkManager à la fin/réussite/annulation du
  worker (rien à gérer).

`feature-export/src/main/AndroidManifest.xml` :
- `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC` (API 34+),
  `POST_NOTIFICATIONS` (API 33+) ;
- override fusionné du service WorkManager :
  `<service android:name="androidx.work.impl.foreground.SystemForegroundService"
  android:foregroundServiceType="dataSync" tools:node="merge" />`.

Ressources : `ic_stat_export.xml` (vecteur), chaînes
`export_notif_channel_name`, `export_notif_title`, `export_notif_text`.

## Risques et mitigations

| Risque | Évaluation |
|---|---|
| `ForegroundServiceStartNotAllowedException` (API 31+, départ en arrière-plan) | Attrapé par `runCatching` → repli en comportement antérieur. Cas nominal (tap → worker immédiat) : app au premier plan. |
| Notification non affichée (POST_NOTIFICATIONS refusé, API 33+) | Le FGS tourne quand même ; l'utilisateur voit l'entrée « appli en cours ». Accepté (documenté). |
| Plafond dataSync 6 h (API 35+) | Un export réel dure des minutes ; marge ×30 minimum. |
| Comportement CI inchangé sur émulateur lent | C'est le but : l'encodage n'est PLUS interrompu à 10 min → il termine (rc6 l'a prouvé en ~8 min une fois le quota hors jeu). |
| Régression crédits | Aucune modification du chemin crédits ; tests existants + journal à surveiller au run de qualification (une seule ligne RESERVED → CONFIRMED). |

## Tests de non-régression ajoutés

`ExportForegroundInfoTest` (Robolectric, même style que `ExportVisualCheckTest`) :
1. `canal_cree_idempotent` — créer deux fois le canal ne lève pas et ne
   duplique pas ;
2. `foreground_info_type_data_sync` — sur API 29+ le `ForegroundInfo` porte
   `FOREGROUND_SERVICE_TYPE_DATA_SYNC` et l'identifiant de notification attendu ;
3. `notification_contenu` — titre/texte du canal et de la notification issus
   des ressources, `ongoing`, petite icône présente.

Un test d'exécution complète du FGS n'est pas faisable en unitaire (WorkManager
runtime) : couvert par le run de qualification CI (E2E existant) — l'absence
d'interruption à 10 min et l'arrivée à « Vidéo prête ! » en seront la preuve.

## Critère de succès du correctif (run de qualification à venir)

Sur émulateur API 30 (swiftshader, gabarit long si possible) :
- zéro « WorkerWrapper interrupted (raison -512) » pendant l'export ;
- `P1_export_termine` PASS (« Vidéo prête ! » affiché) ;
- `P1_partage` PASS (bouton visible, tap, sélecteur Android) ;
- journal : 1 ligne RESERVED → CONFIRMED, aucune double consommation ;
- les 30 PASS existants inchangés (aucune régression du parcours).
