# D42.23 — 09. RÉSULTATS E2E (Phase H/I)

## E2E officiel certifié (réutilisé — code Android inchangé)
- **rc10-audio-v2** (release publique 438084850, APK sha256
  `4e2acf14…`, cert `758077eb…`) : run **42456670342** SUCCESS —
  **PASS=37 FAIL=0 BLOCKED=0** sur l'APK téléchargé DEPUIS la release
  (contrôles sha256 + certificat avant installation).
- Contenu : parcours complet (installation→partage), export FGS écran
  éteint 45 s, MP4 9 140 832 o (h264 1080p + AAC 44,1 kHz, 34,99 s,
  décodage rc=0), non-muette (−53,3 dB moyen / crête −27,3 dB),
  crédits CONFIRMED/solde 2, aucun crash. Artefact 13608501901.
- **Portée exacte (découverte D42.23)** : session SANS compte →
  export + SFX embarqués validés ; la chaîne BGM authentifiée n'est
  PAS couverte (voir 02/06).

## CI du code D42.23 (miroir, gratuit)
- `68a31fb` : android-ci **42465877635 SUCCESS** ; API Security
  **skipped** (cadrage dépôt privé — 42465877627) ; e2e-lab annulé par
  concurrency au profit de `03639c2` (7/9 jobs verts à l'annulation).
- `03639c2` : android-ci **42466646400 SUCCESS** ; e2e-lab
  **42466646463 SUCCESS** (run complet, non annulé — le fix
  preview-d1-migrations n'a rien cassé).
- `cab9370` (checkpoints, doc seul) : poussé au miroir après conclusion
  de l'e2e-lab 03639c2 — runs déclenchés, conclusions à relever au
  prochain point (aucun changement de code attendu).
- Incident : run 42465876563 (workflow invalide, garde dupliquée) —
  corrigé, voir 10.

## APK rc11-production (correctif D23-3 — build local) — FIGÉ
- Construit depuis `d42.23-production` (privé, commit `2cd6991`) :
  tests unitaires feature-export **BUILD SUCCESSFUL** (2m43s, porte
  intégrité) + `:app:assembleRelease` R8 full **BUILD SUCCESSFUL**
  (17m22s, 602 tâches) avec `-PvvApkSha256=758077eb…`, signature
  officielle via `vv-signing/` (gitignoré), clé Firebase RÉELLE.
- **Vérifications effectuées sur l'artefact** :
  - `app-release.apk` — **44 112 105 octets**, sha256
    `b052e7c94137a7f9314d7c016a0b293ce7e41eba92716354c0acbb5ed7c83bb6` ;
  - `apksigner verify` : **Verifies** — schéma **v2** (v1/v3 false),
    certificat **CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou,
    ST=Littoral, C=BJ**, SHA-256 `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`
    (SHA-1 `89fab9b6c2b340d64a493059bc674a06ce0cd8a3`) ; minSdk 24 →
    v2 valide sur tout l'éventail supporté ;
  - clé dex (unzip + strings sur classes*.dex) : UNIQUEMENT
    `AIzaSyCKxf…-Hys` (réelle) — clé factice **ABSENTE** ;
  - `mapping.txt` R8 (81 373 445 o) conservé et publié.
- **Release PRIVÉE `d42.23-rc11` : id 438156110** (tag posé sur
  `2cd6991`, arbre exact du build), assets `app-release.apk` +
  `mapping.txt` + `rc11_checksums.txt` (201 ✓ x3). Branche
  `d42.23-production` poussée au privé jusqu'au merge `3d02c9e`
  (miroir cab9370 intégré, clé réelle conservée).
- Environnement de build noté pour reproduction : Gradle 9.6.0 direct
  (binaire, pas le wrapper), JDK 21 + toolchain JDK 17
  (`org.gradle.java.installations.paths`), `org.gradle.vfs.watch=false`
  (bug snapshots sur overlayfs), Xmx1600m/Metaspace1200m/CCS512m,
  workers 2, swap 6G, NDK 28.2.13676358 + cmake 3.22.1.

## E2E de production complet — plan au déblocage D23-1
1. tag `worker-deploy-3` (privé) → déploiement + smoke renforcé
   (billing/return 200 + version 0.9.1-d42.23) ;
2. dispatch `API Security CI` (privé, ref d42.23-production) ;
3. tag `audio-audit-1` (privé) ;
4. re-certification : re-push du tag `d42.23-rc11` (motif `d42.23-rc*`
   ajouté à release-official-e2e au figéage) → l'e2e-official
   télécharge l'ASSET exact de la release 438156110 et doit donner
   37/37 — c'est l'artefact distribué qui est certifié, pas un rebuild.
