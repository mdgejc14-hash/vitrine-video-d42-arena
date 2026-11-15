# NEXT_ACTION — D42.34 ordre final (reprise au prochain tour)

Base : 2dfd907 (immuable) → … → fe2ab0d (HEAD). Échéance projet : 18/11/2026.
Date réelle de référence : 15/11/2026 (jamais de date future dans les documents).

## PREMIER GESTE DU PROCHAIN TOUR — LOT 3/3 (9 images)

La limite stricte est de 10 images générées par tour : le lot 2 l'a consommée
ce tour. Au prochain tour, le quota est réinitialisé.

```
cd /home/user/lab23
# 0. réparer le remote (perdu à chaque reset sandbox) :
#    git remote add origin https://x-access-token:$(cat ~/.d42_secrets/gh_pat_fondateur.txt)@github.com/mdgejc14-hash/vitrine-video-d42-arena.git
#    git config user.name d42-agent && git config user.email d42-agent@users.noreply.github.com
#    git checkout -- .   (bits exécutables)
python3 scripts/process_catalog_asset_queue.py next 9    # réserve le lot 3
# → 9 generate_image avec les prompts affichés (shops T2-T5, vetements T1-T5)
#    fichiers /home/user/assets_gen/apercu_<secteur>_T<n>.png
python3 scripts/process_catalog_asset_queue.py integrate shops_small_business_T2 shops_small_business_T3 shops_small_business_T4 shops_small_business_T5 vetements_mode_T1 vetements_mode_T2 vetements_mode_T3 vetements_mode_T4 vetements_mode_T5
python3 scripts/process_catalog_asset_queue.py emit-map
python3 scripts/process_catalog_asset_queue.py verify       # 30/30, 0 doublon
git checkout gradle.properties ; git add -A ; git diff --cached --stat gradle.properties  # DOIT être vide
git commit -m "LOT 3/3 …" && git push origin d42.34-founder-acceptance-fixes
# vérifier les 9 fichiers distants (API contents 200) puis :
python3 scripts/process_catalog_asset_queue.py mark-verified <les 9 ids>
git add … commit … push
```

## PUIS (même tour que le lot 3)

1. Recapture catalogue définitif : étendre D34Lot6 aux 6 secteurs (tests
   Robolectric), remplacer D34-01/02/03, régénérer la galerie.
2. Captures dialogues VR-074→078 + VR-062 si reproductibles (AlertDialog
   dashboard via clics UI ; DialogueChoixPays brief).
3. Régénérer galerie + manifeste : extraire d'abord /tmp/maquettes +
   /tmp/apres33 (raw.githubusercontent + PAT — le clone est blob:none,
   sparse-checkout échoue sur les blobs D31) ; `python3 scripts/galerie_lotf.py`.
4. Mettre à jour 13_RAPPORT_CONFORMITE_VISUELLE.md à la complétude 30/30.

## ÉTAT (15/11 soir)

- Aperçus : **21/30** (batiment T1-T5, coiffure T1-T5, immo T1-T5,
  restaurants T1-T5, shops T1) — 20 VERIFIED file + T1 préexistant.
- Images originales : 31/39 (3 carrousels + 6 secteurs + 21 aperçus + batiment
  T1 ancien → compter 30 aperçus cible).
- Inventaire : 78 états. Galerie : 123 entrées / 118 images. Rapport 13 écrit.
- CI : e8494dc SUCCESS ; runs du jour vérifiés au push (fe2ab0d dernier).

## PIÈGES (tous rencontrés ce tour)

- Remote git + identité perdus à chaque reset sandbox (.git/config non
  persisté) — à réparer AVANT tout push, sinon échec silencieux.
- gradle.properties : JAMAIS committer la valeur locale (1024m) — contrôle
  `git diff --cached --stat gradle.properties` avant chaque push.
- Limite 10 images/tour stricte — 1 lot par tour maximum.
- Builds Robolectric lourds : UN module à la fois (daemon sinon tué, OOM).
- Toolchain : JDK /opt/toolchain/jdk-17.0.21+9, cmdline-tools 15859902,
  platforms;android-37.0, build-tools 37.0.0 ; swap 2G à recréer si reset.
- git archive/sparse-checkout impossibles (clone blob:none) : raw API + PAT.
- WorkManager progress non observable sous Robolectric (VR-051 documenté).
