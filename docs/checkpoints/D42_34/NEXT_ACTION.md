# PROCHAINE ACTION — D42.34

**Lot 3 TERMINÉ (fin du double parcours caméra, 16/16 tests)** — commit en
cours de push. Si interruption : vérifier `git log` distant ; si le commit
Lot 3 est présent, passer directement au **Lot 4**.

**Lot 4 — identité marchand / abonnements / montage** (CR-4) :

1. **Identité** : audit `GoogleSsoClient`, `FirebaseAuthGateway`,
   `BackendSync.bootstrap`, `DashboardActivity/Screen` — plus de « Bonjour
   boutique »/noms déduits d'emails/Awa Koffi ; nom = profil Google/Firebase
   RÉEL ou nom de commerce renseigné, sinon « Bonjour » seul.
2. **Abonnements** : `PaywallScreen` — CTA actifs (Pass 24 h 500 / Pro
   3 000 / Boutique 7 500 FCFA, badge Recommandé sur Pro), checkout réel,
   501 `billing_not_configured` = message discret honnête (CinetPay inchangé).
3. **Montage** : phases métier réelles du Worker (assemblage, musique,
   sous-titres, rendu, vérif) — aucun % / ETA inventé ; indéterminé si non
   mesurable.
4. Écrire `05_IDENTITE_MARCHAND.md` (causes racines démontrées AVANT
   correction).
5. Corrections + tests + captures, commit + push + CI.

Rappel RAM sandbox (si reboot) : recréer le swap 2 Go (commande dans
`00_PLAN_ET_ETAT.md`), heap local 1024m/metaspace 640m NON commité
(`git checkout gradle.properties` avant commit), `--max-workers=1 --no-daemon`.

Journal : [00_PLAN_ET_ETAT.md](00_PLAN_ET_ETAT.md)
