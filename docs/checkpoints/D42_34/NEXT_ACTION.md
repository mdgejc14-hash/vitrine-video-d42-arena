# PROCHAINE ACTION — D42.34

**Lot 2 TERMINÉ (import rushs T5, fusion par slot, 36 tests verts)** — commit
en cours de push. Si interruption : vérifier `git log` distant ; si le commit
Lot 2 est présent, passer directement au **Lot 3**.

**Lot 3 — caméra guidée par les prises du gabarit** (CR-3, P0 ③) :

1. Re-auditer `CameraGuideActivity` : cause racine connue = parcours générique
   `buildSceneGuides(script, durationS)` affiché quand le mode gabarit/données
   ne se charge pas (« Scène 1/26 », écran noir « Scène 1/0 », nom de package,
   « 1,2 s »). Réparer le BRANCHEMENT, pas masquer le texte.
2. HUD gabarit = uniquement `PRISE n/prises.size` ; « Caméra prête » seulement
   après flux réel ; erreur récupérable si JSON impossible (retour
   brief/catalogue) ; interdit caméra guidée si prises.size == 0 ; consignes
   par prise (label/cameraInstruction/targetS/segments show/tell/example).
3. Countdown : vérifier alignement réel du décompte avec l'enregistrement.
4. Écrire `04_CAMERA_GUIDEE.md` (cause racine démontrée AVANT correction).
5. Corrections + tests + captures, commit + push + CI.

Rappel RAM sandbox (si reboot) : recréer le swap 2 Go (commande dans
`00_PLAN_ET_ETAT.md`), heap local 1024m/metaspace 640m NON commité
(`git checkout gradle.properties` avant commit), `--max-workers=1 --no-daemon`.

Journal : [00_PLAN_ET_ETAT.md](00_PLAN_ET_ETAT.md)
