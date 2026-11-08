# D42.22 — 09. QUALIFICATION RELEASE

## Chaîne rc10-audio-v2 (qualification finale, code final)
- Tag `d42.21-build-2` → commit `453e470ddc60180bfe6783e807990fb8450363ba`
- Run `42455957153` (release-official-build) : **SUCCESS** — tests unitaires
  feature-export + assembleRelease R8 avec empreinte officielle injectée.
- Artefact `13608235548` (29 998 845 octets) → re-signature locale
  (keystore officiel, CN=Vitrine Video, O=EPD HOLDING, C=BJ).
- **APK signé : 44 141 502 octets**
  - Certificat SHA-256 : `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`
  - Fichier SHA-256 : `4e2acf14e9276a406369907ebda432cad59c101ddd523cf119985137523f7edb`
- Release GitHub : `rc10-audio-v2` (id 438084850, tag `d42.21-rc-audio-v2`,
  asset `vitrine-release-signed.apk`).
- **Étage 3 (release-official-e2e, run 42456670342) : lancé — résultat à reporter.**

## Chaîne rc10-audio-v1 (preuve audio historique, APK du 003ceca)
- Run 42432251656 : SUCCESS 35/35 ; MP4 9 168 612 octets, AAC + h264,
  34,99 s, décodage rc=0, non-muette (RMS −53,3 dBFS / crête −27,3 dBFS).
- APK : 44 141 502 octets, sha256 `06d320b6…2895d`, même certificat officiel.

## Diff v1 → v2 (app)
9 chaînes de notification traduites (en/es/ja) + mise en forme detekt.
Aucun changement de logique export/audio/sécurité.
