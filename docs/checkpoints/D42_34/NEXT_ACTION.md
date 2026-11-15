# PROCHAINE ACTION — D42.34

**Lot 4 TERMINÉ (identité réelle, CTA actifs, phases worker, 44 tests
verts)** — commit en cours de push. Si interruption : vérifier `git log`
distant ; si le commit Lot 4 est présent, passer au **Lot 5**.

**Lot 5 — visuel final** (CR-5) :

1. **Carrousel** : 3 slides = 3 métiers/personnes DIFFÉRENTS (commerce
   femme / restauration / mode), textes inchangés — remplacer les images
   par les ressources Drive D (photo-merchant / secteur_food /
   secteur_mode) AVEC registre de licences (déjà consigné : remplacement
   obligatoire avant publication Play Store).
2. **Splash** : logo officiel centré premium (mark.png/wordmark.png Drive
   D), pas de fausse animation.
3. Identifier le composant carrousel actuel (onboarding ?) et ses assets.
4. Écrire `07_DESIGN_VISUEL.md` (décisions + preuves).
5. Corrections + tests + captures, commit + push + CI.

Rappel RAM sandbox (si reboot) : recréer le swap 2 Go (commande dans
`00_PLAN_ET_ETAT.md`), heap local 1024m/metaspace 640m NON commité
(`git checkout gradle.properties` avant commit), `--max-workers=1 --no-daemon`.

Journal : [00_PLAN_ET_ETAT.md](00_PLAN_ET_ETAT.md)
