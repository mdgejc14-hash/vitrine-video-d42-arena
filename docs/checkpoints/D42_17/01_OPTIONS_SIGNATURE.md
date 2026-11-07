# D42.17 — Options de signature officielle (évaluation demandée par le fondateur)

Contraintes fondateur : aucun secret de signature sur le miroir public ; aucune
extraction de clé ; aucune clé privée publiée ; IntegrityGuard jamais modifié ;
aucune substitution de clé. Objectif inchangé (APK A5/H12/H13, certificat
officiel vérifié, IntegrityGuard actif, AVD, export réel, MP4, ffprobe, décodage,
crédits, partage).

## Option A — Build et signature dans l'environnement privé de confiance

- **Prérequis** : accès au dépôt privé (le PAT actuel est strictement limité au
  miroir public, sur ordre fondateur) ET Actions du dépôt privé opérationnelles.
- **Constat** : les Actions du dépôt privé sont bloquées par facturation depuis
  D42.16 (« recent account payments have failed or your spending limit needs to
  be increased ») — le fondateur a interdit toute relance et toute demande de
  paiement. Les secrets VV_KEYSTORE_B64 / VV_STORE_PASSWORD y existent, mais le
  runner privé ne peut pas démarrer.
- **Opérations nécessaires** : résolution de la facturation par le fondateur +
  extension du périmètre du PAT — les deux hors de mon autorité.
- **Risques** : aucun exécutable de mon côté ; dépend entièrement d'actions
  fondateur contraires aux instructions en vigueur. **Écarté.**

## Option B — Machine de build locale de confiance (SDK + Gradle + keystore)

- **Prérequis** : JDK 17 (~190 Mo), SDK Android (cmdline-tools + platform +
  build-tools, ~700 Mo), dépendances Gradle/Maven (~1,5 Go), sur la sandbox
  2 vCPU / 1,9 Go de RAM. Keystore déjà présent localement (`~/keystores/`).
- **Constat** : R8 full sur une application multi-modules Compose avec < 2 Go
  de tas : probabilité élevée d'OOM (OutOfMemoryError) ; même en cas de succès,
  l'E2E resterait impossible localement (pas de KVM) — l'APK signé devrait de
  toute façon transiter par le miroir public pour la validation AVD.
- **Opérations** : installation complète de la chaîne + build + signature +
  transfert de l'artefact vers CI — tout le poids du build pour un résultat
  incertain, sans avantage sur l'option C.
- **Risques** : échec mémoire très probable, durée 30-90 min, gaspillage.
  **Écarté (documenté comme voie de repli).**

## Option C — Signature sécurisée : la clé reste hors du dépôt public, seul
l'artefact signé est transmis — **RETENUE**

Chaîne en trois étages (la clé officielle ne quitte JAMAIS la sandbox de
l'agent ; le dépôt public ne voit QUE l'artefact signé et l'empreinte publique
déjà documentée en D42.14) :

1. **Build CI sans secret** (workflow `release-official-build.yml`, déclenché
   par tag `d42.17-build-*`) : `assembleRelease -PvvApkSha256=758077eb…`
   (empreinte PUBLIQUE, documentée) → APK R8 complet, porte d'intégrité ACTIVE,
   signé de la clé debug de recette (comportement Gradle sans signing.properties
   — aucune donnée secrète impliquée). Artefact `release-build-unsigned`.
2. **Re-signature locale** (sandbox de l'agent = poste de confiance) : retrait
   des signatures v1, contrôle zipalign, `apksigner sign` avec le keystore
   officiel `~/keystores/vitrine.keystore`, puis `apksigner verify --print-certs`
   **doit** montrer le seul certificat officiel `758077eb…33e192` (sinon refus),
   SHA-256 de l'APK consigné.
3. **Validation CI de l'artefact signé** (workflow `release-official-e2e.yml`,
   déclenché par la publication d'une release taguée `d42.17-rc*`) :
   téléchargement de l'asset, **contrôle apksigner (certificat == officiel,
   refus sinon)**, installation dans l'AVD (Pixel 5 / API 30 / AOSP, adb root),
   parcours P1 complet → export réel → MP4 → ffprobe + décodage intégral →
   crédits (pull de la base locale + mono-déclenchement prouvé) → partage.
   Artefacts : MP4, ffprobe, decode, dumps, logs, base de crédits.

- **Prérequis** : build-tools (apksigner/zipalign, ~57 Mo) téléchargés localement
  (aucun SDK complet requis) ; PAT actuel (Contents RW pour les releases,
  Workflows RW pour les fichiers, Actions RO pour les artefacts) — vérifiés.
- **Opérations** : push des workflows avec `[skip ci]` (aucun des 9 jobs verts
  n'est relancé), tag de build, re-signature locale, publication de la release
  avec l'asset signé, suivi du run E2E, livraison des preuves.
- **Risques** : (i) re-signature au-dessus d'une signature debug — neutralisée
  par le retrait v1 préalable + `apksigner verify` final (preuve autoritaire) ;
  (ii) UI minifiée R8 pilotée par libellés — les libellés sont des ressources
  conservées par R8, risque faible-modéré, le run tranche avec preuves ;
  (iii) l'asset de release est publiquement téléchargeable — inhérent à la
  définition même de l'option C (« seul l'artefact signé est transmis »),
  l'APK ne contient aucun matériel de clé ; (iv) déclencheurs par tags —
  sémantique GitHub vérifiée (push de tag ≠ push de branche : android-e2e-lab
  ne se déclenche pas ; les workflows tag-lus au commit tagué).
- **IntegrityGuard** : jamais modifié, jamais contourné — ACTIVÉ par
  l'injection de l'empreinte officielle au build, puis **satisfait** par la
  signature officielle réelle.

## Décision

Option C exécutée (autorisation fondateur : « la poursuite de la qualification
est autorisée, pas l'exposition de la clé »). Options A et B documentées ci-
dessus. En cas d'échec de C : NO-GO conditionnel conservé + documentation
précise du blocage, conformément à l'ordre.

## Journal d'exécution

- Tag `d42.17-build-1` → 92eb7a9 : AUCUN run — le commit porte `[skip ci]`,
  GitHub saute également les workflows déclenchés par un tag pointant sur lui.
- Correctif : commit de déclenchement sans skip-ci, poussé par le tag seul
  (la branche `d42.13-lab` ne bouge pas : les 9 jobs verts ne sont pas
  relancés). Tag : `d42.17-build-2`.
