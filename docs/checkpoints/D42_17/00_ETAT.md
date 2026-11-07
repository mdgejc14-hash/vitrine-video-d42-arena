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
