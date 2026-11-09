# D42.27-11 — RC12 : journal d'exécution

(Plan : 11_RC12_PLAN.md. Processus 3 étages hérité D42.17.)

## Conditions d'entrée — TOUTES RÉUNIES

- android-ci 42647493287 : **SUCCESS** (83da04e).
- android-e2e-lab 42647493665 : **SUCCESS 15/15** (83da04e) —
  drafts 36/36 (42641946124 même code app : reprise CAMÉRA PRISE 2/3
  hors connexion, rush conservé, montage terminé, retour réseau),
  auth 11/11, deeplink 7/7 (AKWABA-100 : code affiché + champ
  pré-rempli), camerap, p1, offline, langues ×3, gabarits, backend,
  security, harness.
- Matrice finale (10) à jour : 1.9/1.10/1.11/4.2/6.2 PASS documentés.

## Étage 1/3 — build CI sans secret : SUCCESS

- Tag `d42.27-build-rc12` → 83da04e (SHA exact validé par les runs).
- Run release-official-build **42652646514 SUCCESS** : tests unitaires
  feature-export (P1 export) verts, APK release R8 complet, empreinte
  officielle PUBLIQUE injectée (IntegrityGuard armé), zéro secret.
- Artefact `release-build-unsigned` : app-release.apk
  SHA-256 7b6652015850276defd22f1d094cfa68e24002f5f26b2b6fb9cfde4bd96ea955,
  + mapping.txt (SHA-256 0a43e08081f356c2ade7cbe9d771b57bfbcc9a4b4c2835f4c725f72f09197f84).

## Étage 2/3 — re-signature locale (poste de confiance) : FAITE

- Outils : build-tools 37.0.0 (zipalign, apksigner), keystore officiel
  `~/vvprod/vv-signing/vitrine.keystore` (jamais commité, mots de passe
  jamais affichés).
- Aucune signature v1 JAR à retirer (APK release propre).
- zipalign -f -p 4, puis `apksigner sign` v2+v3 (v1 désactivée).
- **Vérification autoritaire `apksigner verify --print-certs`** :
  - DN : CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou,
    ST=Littoral, C=BJ — conforme D42.14 ;
  - **SHA-256 : 758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192** (attendu ✓) ;
  - SHA-1 89fab9b6…, MD5 78fdbd60… (conformes D42.17) ;
  - Verifies OK, v2+v3, 1 signataire.
- APK final `vitrine-video-0.8.0-b0-d42.27-rc12-official.apk`
  (versionName 0.8.0-b0) : 44 124 921 octets,
  **SHA-256 ef85cff7924a5d80785e2c35fe5e52d1d42f890ac61a27d46e75c188111a0655**.

## Étage 3/3 — release + validation CI de l'APK signée : EN COURS

- Release GitHub **439393689** (publiée, prerelease) :
  https://github.com/mdgejc14-hash/vitrine-video-d42-arena/releases/tag/d42.27-rc12
  — assets : APK officiel signé + mapping.txt + checksums.txt.
- Run 42654929203 : FAILURE — déclenché avant la fin de l'upload des
  assets (la création d'une release publiée crée le tag → le workflow
  part immédiatement). **Leçon A : publier un DRAFT avec assets déjà
  en place (la publication crée le tag ensuite).**
- Run 42655178977 : FAILURE — re-push du tag après suppression : la
  suppression du tag repasse la release en DRAFT → releases/tags/ 404
  pour tout le run. **Leçon B : ne jamais supprimer le tag d'une
  release publiée ; republier un draft APRÈS re-push du tag fonctionne
  (la boucle d'attente de 10 min couvre ce cas).**
- Run 42658418318 : FAILURE — release.apk = 688 octets = checksums.txt :
  l'API liste les assets par ordre ALPHABÉTIQUE, a[0] n'était l'APK
  qu'en D42.17 par accident de nommage. **Fix 11b (ea0edde) :
  sélection du premier asset .apk.**
- Tag d42.27-rc12 : recâblé sur ea0edde — diff 83da04e..ea0edde =
  1 fichier workflow + 2 fichiers docs, **code app strictement
  identique au build validé** (APK inchangée ef85cff7…0655, build
  d42.27-build-rc12 = 83da04e inchangé).
- **Run 42658920860** (workflow corrigé) : **COMPLETED SUCCESS — 41 PASS /
  0 FAIL** :
  - certificat APK constaté EN CI :
    758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192 ✓ ;
  - installation (versionName 0.8.0-b0), langue, auth (repli), carrousel,
    activité, parrainage, catalogue, gabarit ;
  - brief : vide refusé, invalide refusé (prix « abc »), valide accepté,
    retour arrière sans crash ;
  - caméra émulée : prises filmées, guide terminé (3 rushs non vides),
    aperçu E7, export E8 lancé, notification FGS ;
  - **export poursuivi après 45 s d'écran éteint** ;
  - **« Vidéo prête ! », export-0.mp4 7 536 097 octets, feuille de
    partage Android, AUCUN FATAL EXCEPTION** ;
  - ffprobe : h264 + aac, duration 34,99 s.
- Runs de contrôle du commit ea0edde (code app identique) :
  android-ci 42658870561 SUCCESS, android-e2e-lab 42658870536 SUCCESS 15/15.

## Verdict

**RC12 LIVRÉE avec preuves.** APK officielle
`vitrine-video-0.8.0-b0-d42.27-rc12-official.apk` (SHA-256
ef85cff7924a5d80785e2c35fe5e52d1d42f890ac61a27d46e75c188111a0655,
certificat EPD HOLDING 758077eb…33e192) :

- build : d42.27-build-rc12 → 83da04e (run 42652646514 SUCCESS) ;
- re-signature locale : verify --print-certs conforme (étage 2) ;
- validation CI de l'APK signée : run 42658920860 SUCCESS 41/41 (étage 3) ;
- release : https://github.com/mdgejc14-hash/vitrine-video-d42-arena/releases/tag/d42.27-rc12
  (APK + mapping.txt + checksums.txt).

Conditions d'entrée toutes réunies et citées ; aucune modification du
code app après le build validé (diff 83da04e..ea0edde = workflow + docs
uniquement). Règles respectées : 0 FCFA, aucune composition audio
modifiée, aucun secret exposé, aucun PASS sans preuve.
