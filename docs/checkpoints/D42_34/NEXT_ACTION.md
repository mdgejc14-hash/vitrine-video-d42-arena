# PROCHAINE ACTION — D42.34

**Lot 5 TERMINÉ (carrousel 3 métiers, logo/splash officiels, 12 captures
dans visual-review/)** — commit en cours de push. Si interruption : vérifier
`git log` distant ; si le commit Lot 5 est présent, passer au **Lot 6**.

**Lot 6 — non-régression et livraison** (dernier lot) :

1. Validation locale COMPLÈTE : `testDebugUnitTest` sur tous les modules +
   `:app:compileDebugKotlin` + ktlintCheck + detekt (aucun contrôle
   désactivé) — preuve 08_NON_REGRESSION.md.
2. Écrire `08_NON_REGRESSION.md` : résultats par module, invariants
   préservés (30 gabarits, nombre_scenes, moteur, contrats serveur, RC15,
   CinetPay 501, IDs), couverture D42.34 (quels défauts fondateur → quelles
   preuves).
3. Écrire `09_RAPPORT_LIVRAISON.md` : récapitulatif fondateur (CR-1→CR-5),
   ce qui reste à faire sur téléphone fondateur (tests manuels + E2E
   instrumenté `renduTemoignageSlotsImportes` sur émulateur), limite
   honnête images/licences avant Play Store.
4. Commit + push + CI verte → STOP à la porte d'approbation fondateur.

Rappel RAM sandbox (si reboot) : recréer le swap 2 Go (commande dans
`00_PLAN_ET_ETAT.md`), heap local 1024m/metaspace 640m NON commité
(`git checkout gradle.properties` avant commit), `--max-workers=1 --no-daemon`.

Journal : [00_PLAN_ET_ETAT.md](00_PLAN_ET_ETAT.md)
