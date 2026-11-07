# D42.17 — État (00)

**Ordre final du 07/11/2026 (~09:45 Porto-Novo) : qualification export sur
signature officielle. D42.16 accepté comme référence, rien de refait.**

## 1. Certificat officiel VÉRIFIÉ (procédure §1-2 — FAIT)

- Keystore local `~/keystores/vitrine.keystore` (alias `vitrine`), keytool JDK-11 :
  `SHA256: 75:80:77:EB:13:88:37:6D:8A:C7:97:DB:88:EE:C9:76:B2:7F:7A:55:3D:C0:9D:6D:85:52:9F:BD:0B:33:E1:92`
  = **758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192** —
  correspondance EXACTE avec l'empreinte documentée D42.14/RC6
  (apksigner_verify.txt). DN `CN=Vitrine Video, OU=Mobile, O=EPD HOLDING,
  L=Cotonou, ST=Littoral, C=BJ`, RSA 2048, validité → 2056. Schéma v2.
- Mécanisme de signature officiel en CI : **android-ci.yml** (secrets
  `VV_KEYSTORE_B64` + `VV_STORE_PASSWORD` posés par le fondateur, restauration
  à chaud, keytool → `-PvvApkSha256` → assembleRelease R8 + porte d'intégrité
  ACTIVE, contrôle apksigner). Le keystore n'est JAMAIS dans le dépôt.

## 2. Release corrigée + E2E signé — PRÉPARÉ (commit local c083978, NON poussé)

- `tools/e2e/run_p1.sh` : helpers `app_ls`/`app_cat` — mêmes mesures et preuves
  en debug (run-as) et release (adb root, émulateur AOSP du lab) : comptage
  rushs, 27_rushes.txt, extraction du MP4 exporté (S26 réécrit). Aucune logique
  produit modifiée, IntegrityGuard intact.
- `.github/workflows/android-e2e-lab.yml` : job `android-e2e-release-signed` —
  restauration keystore (secrets), empreinte comparée au certificat officiel
  documenté (refus sinon), `assembleRelease -PvvApkSha256`, contrôle apksigner
  (certificat APK == officiel, clé debug interdite), installation de CET APK
  dans l'AVD, parcours P1 complet → export réel → MP4 → ffprobe + décodage
  intégral → partage. Artefacts : MP4, preuves, APK signé + SHA-256.
- Validations locales : bash -n OK, YAML valide, autotest harnais 9/9, ciblage 3/3.

## 3. Bloqueur de l'exécution autonome — HONNÊTE

**Aucun jeton GitHub actif** : le PAT D42.16 fut supprimé en fin de mission
(conformément au protocole) et l'ordre D42.17 n'en fournit pas. Sans jeton :
pas de push, pas de déclenchement, pas de téléchargement d'artefacts. De plus,
pousser une modification de workflow exige la permission **Workflows** (Contents
seul est rejeté par GitHub).

**Intervention sécurisée demandée** (aucune substitution de clé, conforme à
l'ordre) : PAT fine-grained temporaire sur le miroir uniquement, avec
**Contents RW + Workflows RW + Actions RO** — je pousse alors c083978, UN run
part (push → android-e2e-lab, job release inclus), je le suis jusqu'au terme et
je livre toutes les preuves. Variante sans jeton : le fondateur pousse
c083978 lui-même (bundle/patch fournis dans `D42_17/livraison/`).

## 4. Statut du livrable

L'export n'a PAS été démontré avant 10 h (Porto-Novo) : **NO-GO conditionnel
conservé** — aucune preuve fabriquée. Les 30 PASS D42.16 ne sont pas refaits ;
les 120 combinaisons, backend et sécurité ne sont pas rejoués.

---

## Journal d'exécution option C (07/11, ~09:45 UTC)

- **Commit** `92eb7a9` poussé avec `[skip ci]` (aucun run des 9 jobs verts) :
  workflows `release-official-build.yml` + `release-official-e2e.yml`, retrait
  du job à secrets (voie refusée par le fondateur), checkpoint 01 (évaluation
  A/B/C). Évaluation : A écartée (privé bloqué par facturation, PAT limité au
  miroir), B écartée (sandbox 1,9 Go, R8 OOM probable, et E2E impossible sans
  KVM), **C retenue** (clé hors dépôt, seul l'artefact signé transite).
- **Étage 1** — tag `d42.17-build-1` → 92eb7a9 : AUCUN run (piège : le commit
  porte `[skip ci]`, GitHub saute aussi les tags pointant sur lui). Correctif :
  commit de déclenchement `f7d93a1` (sans skip-ci, poussé via le tag seul) →
  tag `d42.17-build-2` → **run 42359988260 SUCCESS en ~7 min** : APK release
  R8 complet, empreinte officielle injectée, zéro secret, artefact
  `release-build-unsigned` (SHA-256 69be1e22…1bcb0, 43 134 545 o, signé clé
  debug de recette comme attendu sans signing.properties).
- **Étape 2** — re-signature locale (sandbox = poste de confiance) :
  build-tools r34 (apksigner 0.9/Java 11), zipalign OK 4 o, signature
  keystore officiel. **Vérification autoritaire** : `apksigner verify
  --print-certs` → DN CN=Vitrine Video/O=EPD HOLDING, SHA-256
  758077eb…33e192, SHA-1 89fab9b6…, MD5 78fdbd60… — tous conformes D42.14 ;
  Verifies, v2+v3, **1 signataire**. APK final
  `vitrine-video-0.8.0-b0-d42.17-rc1-official.apk`, 43 162 274 o,
  **SHA-256 896240dc7343b9599f3cfc63f9a8684cb52eb05ecd5398458f79f5b2e875683c**.
- **Étape 3** — tag `d42.17-rc1` (f7d93a1) → **run 42360568497
  `release-official-e2e`** : asset téléchargé, **contrôle apksigner en CI
  SUCCESS** (certificat officiel constaté indépendamment), ffprobe + KVM OK,
  parcours P1 sur l'APK officiel EN COURS. Release GitHub 437474823
  (prerelease) : https://github.com/mdgejc14-hash/vitrine-video-d42-arena/releases/tag/d42.17-rc1

## Run 42360568497 — analyse et itération 2

30 PASS (parcours complet sur APK officiel : prises, guide, E7→E8) ;
refus d'export IDENTIQUE. Recroisement décisif : les builds debug n'avaient
pas d'empreinte injectée (porte en mode dev) → leurs refus venaient des
heuristiques ; l'APK officiel a expected == certificat → reste uniquement
tamperHints : **/system/bin/su présent sur l'image AOSP userdebug**.
Itération 2 : -writable-system + retrait de su avant le parcours (preuve
avant/après dans l'artefact), certificat toujours contrôlé. Tag d42.17-rc2.
