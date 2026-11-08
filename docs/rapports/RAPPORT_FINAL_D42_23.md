# RAPPORT FINAL D42.23 — Raccordement production, correctif D23-3, APK rc11

Période : 08/11/2026 (UTC). Point de départ `43de5bc` (clôture D42.22).
Source de vérité : GitHub (privé `mdgejc14-hash/vitrine-video` +
miroir `vitrine-video-d42-arena`). Aucun acquis D42.15-22 recommencé.

## 1. Identification

| Élément | Valeur |
|---|---|
| APK distribution | **rc11** `app-release.apk`, 44 112 105 o |
| sha256 | `b052e7c94137a7f9314d7c016a0b293ce7e41eba92716354c0acbb5ed7c83bb6` |
| Signature | v2, cert `758077eb…e192` (CN=Vitrine Video, O=EPD HOLDING, C=BJ) |
| Clé dex | `AIzaSyCKxf…-Hys` (RÉELLE) — factice absente |
| Release | **PRIVÉE** `d42.23-rc11` id **438156110** (APK + mapping.txt + checksums) |
| Tag | `d42.23-rc11` sur `2cd6991` (arbre exact du build) |
| Branche production | `d42.23-production` @ `3d02c9e` (privé, clé réelle) |

## 2. Découverte critique D23-3 — corrigée et livrée

- **Constat** : l'APK rc10-audio-v2 publié en release publique embarquait
  la clé Firebase **factice** (extraite du dex : `AIzaSyD42LABDUMMYKEY…`).
  La connexion Google aurait échoué au premier test physique — détecté
  AVANT remise au fondateur (règle : le fondateur ne teste qu'après
  qualification complète).
- **Diagnostic d'architecture** : les builds publics (miroir, gratuit)
  n'ont pas accès aux secrets → la clé du dépôt public est factice par
  construction ; l'APK de distribution doit être construit côté privé.
- **Correctif** (cause racine, pas de rustine) :
  1. clé réelle committée dans `d42.23-production` du privé (`2cd6991`) ;
  2. APK reconstruit **localement** + signé officiellement (vv-signing,
     gitignoré) + porte d'intégrité `-PvvApkSha256=758077eb…` ;
  3. **preuve de validité de la clé** par sonde contrastée
     identitytoolkit (email inexistant, zéro écriture) : réelle →
     `INVALID_LOGIN_CREDENTIALS` (valide) ; factice → `API key not
     valid` ;
  4. **vérifications sur l'artefact** : dex = clé réelle seule, cert
     officiel, v2 Verifies, minSdk 24 ;
  5. release **privée uniquement** (décision : pas d'exposition publique
     au-delà de la distribution inévitable) — le miroir garde la clé
     factice pour e2e/lab.
- **Équivalence** : `453e470`→`2cd6991` = worker/workflows/doc/clé
  uniquement → code Android IDENTIQUE à rc10-audio-v2 → l'e2e 37/0
  (run 42456670342) se transpose ; re-certification intégrale
  planifiée au déblocage D23-1.

## 3. Build local — comment et pourquoi

Le privé ne peut pas exécuter d'Actions (D23-1) → build local :
Gradle 9.6.0 (binaire direct, le wrapper échoue au téléchargement),
JDK 21 + toolchain JDK 17, NDK 28.2.13676358 + cmake 3.22.1,
`vfs.watch=false` (bug snapshots overlayfs), mémoire 1600m/1200m/512m,
workers 2, swap 6G. Quatre échecs documentés avant succès (wrapper
réseau ; OOM Metaspace ; cache transforms corrompu + snapshots VFS ;
toolchain 17 manquant) — cause racine et remède de chacun au 09.
Résultat : tests feature-export **SUCCESS** (2m43s), assembleRelease
**SUCCESS** (17m22s, 602 tâches), artefact vérifié ci-dessus.

## 4. CI miroir (gratuite) — verte

- `03639c2` : android-ci **42466646400 SUCCESS**, e2e-lab
  **42466646463 SUCCESS** (run complet ; le fix preview-d1-migrations
  n'a rien cassé — fin des annulations par concurrency).
- `68a31fb` : android-ci SUCCESS, api-security skipped (cadrage privé),
  e2e-lab annulé (supplanté par 03639c2).
- `cab9370` (checkpoints 03-09, doc seul) : poussé APRÈS conclusion de
  l'e2e-lab — runs déclenchés, vert attendu (à relever au prochain
  point).
- Incident résolu : workflow invalide (garde `if:` dupliquée
  preview-d1-migrations, run 42465876563) — corrigé dans 03639c2.

## 5. État production (Phase B — voir 02)

- Worker en ligne = code **D40** (déployé 01/11) : santé OK (D1, 8
  tables), auth Firebase ACTIVE (401), routes audio protégées. Manque
  `?v=N` (20 variations) et SKYPAY → **déploiement D42.23 bloqué par
  D23-1**.
- Version `0.9.1-d42.23` prête dans la branche (marqueur /health +
  smoke deploy renforcé) — prête à déployer par tag `worker-deploy-3`.

## 6. Blocage unique — D23-1 (action fondateur)

Minutes GitHub Actions épuisées pour les dépôts PRIVÉS : tout workflow
du privé meurt en 3-5 s (vérifié en direct) ; backup D1 quotidien en
échec depuis le 04/11 pour cette cause. Le self-hosted est interdit
(périmètre PAT : Administration refusée, 403). **Tout est prêt dans le
privé** : déploiement Worker, API Security (2 comptes), audit audio,
backups. Déblocage = relever la limite de dépenses GitHub (voir
PAQUET_FONDATEUR_D42_23).

## 7. Checkpoints D42_23 (docs/checkpoints/D42_23/)

00 statut exécutif (figé) · 01 audit secrets (16 au privé, 0 miroir) ·
02 état production + découverte e2e audio · 03 D1 (8 tables) ·
04 Firebase/D23-3 (preuves sonde + dex) · 05 B2 audio · 06 variations ·
07 crédits/parrainage/offline · 08 config APK production · 09 e2e +
rc11 FIGÉ · 10 défauts ouverts · 11 verdict/figéage.

## 8. Défauts ouverts (clôture honnête)

Hérités inchangés : D2 (traduction), intros musique, D11 detekt, D3-D6.
Chaîne BGM authentifiée non couverte par l'e2e existant (découverte
D42.22 — audit audio-audit-1 planifié au déblocage). Runs cab9370 à
confirmer. APK rc11 : e2e transposé (équivalence de code), PAS re-çu
sur appareil — re-certification intégrale au déblocage, avant remise
physique au fondateur si elle doit être formelle.

## 9. Conclusion

**Mission D42.23 : LIVRÉE sur son périmètre réalisable.** L'APK de
distribution (rc11, clé réelle, signé officiellement) est en release
privée avec preuves complètes ; le correctif D23-3 corrige la cause
racine (architecture public/privé) ; le miroir est vert. Le reste
(déploiement Worker + audits production) est PRÊT et attend une seule
décision fondateur (D23-1). Le fondateur ne teste rien tant que la
séquence post-déblocage n'est pas exécutée (règle maintenue).
