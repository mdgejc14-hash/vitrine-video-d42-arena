# PROCHAINE ACTION — D42.34

**Lot 1 TERMINÉ (corrections catalogue appliquées, tests verts)** — en cours
de commit/push. Si interruption : vérifier `git log` distant ; si le commit
Lot 1 est présent, passer directement au **Lot 2**.

**Lot 2 — import des rushs dans le parcours gabarit** (CR-2, P0 ④) :

1. Auditer `GabaritBriefScreen` / `GabaritBriefActivity` : branchement du
   picker `OpenMultipleDocuments()` (existe dans BriefActivity/BriefScreen
   générique, absent du parcours gabarit), contrat slots `prises[]`
   (`photo_acceptee` 81/81 : 1 prise = 1 média), URI persistantes
   (`takePersistableUriPermission`), brouillon, transmission
   MainActivity→ExportActivity→ExportWorker.
2. Audit 30 gabarits : requis / facultatif / non (témoignages en priorité) —
   colonnes dédiées dans `02_MATRICE_GABARITS_30.csv`.
3. Écrire `03_BRIEF_IMPORT_RUSHS.md` (cause racine démontrée AVANT correction).
4. Corrections + tests + captures, commit + push + CI.

Rappel RAM sandbox (si reboot) : recréer le swap 2 Go (commande dans
`00_PLAN_ET_ETAT.md`), heap local 1024m/metaspace 640m NON commité
(`git checkout gradle.properties` avant commit), `--max-workers=1 --no-daemon`.

Journal : [00_PLAN_ET_ETAT.md](00_PLAN_ET_ETAT.md)
