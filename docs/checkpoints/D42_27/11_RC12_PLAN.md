# D42.27-11 — RC12 : build officiel, signature, vérifications, release

Processus hérité D42.17 (3 étages, zéro secret dans le dépôt public) —
règle D42.23-11 : toute modification Android après rc11 (2cd6991) exige un
nouveau build + release rc12 + re-certification e2e complète.

## Conditions d'entrée (toutes obligatoires)

- [ ] android-ci SUCCESS sur le HEAD candidat (run en cours : 42635348927).
- [ ] android-e2e-lab SUCCESS 15/15 jobs, avec EN PARTICULIER :
  - [ ] drafts : S1 pré-remplissage + S2 reprise CAMERA PRISE 2/3 hors
        connexion + rush conservé + S3 fin montage ≥3 rushs + aperçu ;
  - [ ] auth : issue Credential Manager propre (playstore ou défaut) ;
  - [ ] deeplink : code E2E-123 affiché à l'auth + champ pré-rempli.
- [ ] Matrice finale (10) mise à jour avec ces résultats.

## Étages (règle D42.17, inchangée)

1. **Build public sans secret** : `git tag d42.27-build-rc12 && git push
   origin d42.27-build-rc12` → `release-official-build.yml` (tags
   d42.27-build-* acceptés, commit 176e5db) → APK release R8 + mapping.txt
   (artefact `release-build-unsigned`). IntegrityGuard ARMÉ par empreinte
   officielle au build.
2. **Re-signature locale** (poste de confiance, 0 FCFA) :
   - outils : build-tools 37 (apksigner/zipalign) — SDK local
     `/home/user/.cache/androidlab/sdk` (réinstaller si .cache perdu :
     cmdline-tools + `sdkmanager "build-tools;37.0.0"`) ;
   - keystore officiel : `/home/user/vvprod/vv-signing/vitrine.keystore`
     + `signing.properties` (JAMAIS commité, mot de passe jamais affiché
     dans les sorties) ;
   - retrait des signatures v1 résiduelles éventuelles, zipalign,
     `apksigner sign` (v2), puis **`apksigner verify --print-certs` DOIT
     montrer le seul certificat officiel `758077eb…33e192`** (sinon REFUS
     et retour au diagnostic) ;
   - sha256 + taille consignés.
3. **Release + validation CI de l'artefact signé** : release publique sur
   l'arène, tag `d42.27-rc12`, assets APK signé + mapping.txt + checksums
   → `release-official-e2e.yml` (tags d42.27-rc* acceptés) : contrôle
   apksigner (cert == officiel, refus sinon), installation AVD, P1 export
   complet sur l'APK signé, ffprobe du MP4, artefacts de preuve.

## Vérifications finales avant déclaration de livraison

- [ ] Certificat : apksigner verify (local + CI étage 3) == 758077eb…33e192.
- [ ] sha256 APK consigné dans la release ET dans le checkpoint.
- [ ] mapping.txt publié (retraçage R8, règle D42.9).
- [ ] Lien release public + tous les assets accessibles.
- [ ] Runs verts cités par SHA dans la matrice finale.
- [ ] Merge arène → vvprod local (branche production, SANS push privé —
      règle : privé mdgejc14-hash/vitrine-video = LECTURE SEULE).
- [ ] Aucune composition audio modifiée ; aucun secret dans le dépôt.

## Non-configurations volontaires (fondateur)

- SKYPAY : 501 billing_not_configured (seule exception acceptée).
- Auth Google avec compte RÉEL : exige un compte physique fondateur — le
  lab prouve l'API A (Credential Manager) et l'échec propre, pas le
  choix de compte.
