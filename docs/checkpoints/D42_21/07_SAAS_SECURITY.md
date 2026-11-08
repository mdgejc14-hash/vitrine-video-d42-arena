# D42.21 — 04. AUDIT SaaS CONSOLIDÉ

**Méthode** : consolidation des preuves existantes + re-validations gratuites du jour
(les jobs locaux des workflows se rejouent à chaque push) + inspection code des
chaînes critiques. Rien n'est présenté comme « validé » sans preuve datée.

## Statut par domaine

### 1. Authentification Google + D1 — OPÉRATIONNEL, re-validé ce jour
- Job `auth-local` du run **42412500773** (08/11, commit 56e4717) : **succès**
  (22/22 contrôles : parcours complet Google OAuth simulé → JWT → /me → D1
  lectures/écritures ; jetons expirés/refusés ; comptes orphelins).
- Job `backend-http` (idem) : **succès** (15/15 contrats HTTP : codes, en-têtes,
  Content-Type, CORS, 401/403 sur routes protégées).

### 2. Backend Cloudflare (Worker + D1 + B2) — OPÉRATIONNEL, étendu ce jour
- `harness-selftest` (idem) : **succès** (9/9).
- **Nouveau D42.21** : route `/audio/library` publique (métadonnées sans secret,
  par conception : catalogue = données publiques) et `/audio/track/{cat}?v=N`
  avec **v gardé** : `Number.isInteger` + bornes 1–20 sinon `400
  invalid_variation` ; NaN rejeté ; pas de concaténation de chemin (clé objet
  B2 exacte `musique_t1_{secteur}_vNN`) ; cache API distinct par `?v`.
- Migrations D1 0011/0012 déjà appliquées en prod (schéma bgm_library vérifié,
  clé `piste_id`, `sha256` présent).

### 3. Sécurité — 64/64 re-validé ce jour
- Job `security-local` du run 42412500773 : **succès** (64 contrôles :
  OWASP MASVS/ASVS : pas de secret dans le binaire debug, TLS forcé, jetons
  jamais loggués, IntegrityGuard actif, vérification stricte des réponses,
  pas d'exported=true superflu…).
- STRIDE par périmètre (hérité D37–D42, inchangé) ; Zero Trust : chaque route
  Worker authentifie avant toute lecture D1/B2 (backend-http 15/15).

### 4. Crédits — idempotence et anti-manipulation (hérité, code inchangé)
- Sémantique serveur : `RESERVED` → `CONFIRMED` (idempotent par exportId) →
  `COMPENSATED` si échec ; compensation des orphelins > 120 s ; jamais de débit
  double (clé unique exportId).
- Tests JVM du dépôt : `GuardTest`, `CreditPolicyPropertyTest` (property-based :
  aucun enchaînement d'états ne produit un débit net ≠ somme des exports
  confirmés), `MonotonicAnchorV2Test` (anti-retour dans le temps).
- Rejoués par android-ci à chaque push main (prévu pour ce commit après E2E).

### 5. Hors-ligne — limité et réconcilié (hérité)
- Mode avion : consultation des vidéos locales et de la bibliothèque BGM cachée
  (`files/bgm/`, cache définitif — jamais dans cacheDir : survit au vidage) ;
  export possible avec musique cachée + gabarits locaux.
- Toute action consommant des crédits exige le réseau (jamais de débit local
  présumé) ; reconnexion → réconciliation serveur (source de vérité D1).
- Limite assumée : un premier export dans une langue jamais ouverte en ligne
  reste impossible hors-ligne (gabarits téléversés à l'ouverture) — documenté.

### 6. Parrainage serveur — OPÉRATIONNEL (hérité, code inspecté ce jour)
- Routes : `/me/referral` (code SHALOM-842 + statistiques), `applyReferralRewards`
  au moment de la conversion (R8), backfill paresseux des comptes créés avant la
  migration 0007 (`refcode_collision` → plus aucun 500).
- Anti-abus : récompense unique par conversion vérifiée en D1 (contrainte +
  test), code non devinable (aléatoire suffixé).

### 7. Partage réel (MP4 / MIME / FileProvider / WhatsApp) — code inspecté ce jour
- `ExportActivity.shareVideo` : fichier existant requis, `FileProvider
  .getUriForFile(« {pkg}.fileprovider »)`, `ACTION_SEND` + `type="video/mp4"` +
  `EXTRA_STREAM` + `FLAG_GRANT_READ_URI_PERMISSION` + chooser système.
- `<provider>` déclaré dans `feature-export/AndroidManifest.xml` :
  `exported="false"`, `grantUriPermissions="true"`, `@xml/file_paths`.
- Validation sur téléphone physique (WhatsApp) : faite en mission antérieure
  (D3x, fondateur) ; **non rejouée ce jour** (aucun appareil physique dispo) —
  le code n'a pas changé depuis (git blame : non touché par D42.21).

### 8. SKYPAY — inchangé, strict
- `501 billing_not_configured` : comportement inchangé (aucun fichier SKYPAY
  modifié par D42.21 — `git diff bc42731..6b7c396 -- '*skypay*' '*billing*'`
  vide). Paiement jamais présenté comme disponible tant que la configuration
  n'existe pas côté serveur.

### 9. Diffusion des 600 pistes — D42.21 (nouveau)
- Téléphone : ne télécharge QUE la variation choisie (~620–640 Ko) après
  vérification sha256 ; jamais les 600 ; catalogue = métadonnées uniquement
  (~quelques Ko par secteur+format).
- Anti-répétition raisonnable (historique 4 dernières par gabarit) ;
  jamais de mélange secteurs/gabarits (filtre strict gabaritId+secteur+format) ;
  indisponible → autre variation du MÊME gabarit puis repli titulaire documenté.

## Non-validés / limites (honnêteté)
- Partage WhatsApp sur appareil physique : non rejoué ce jour (code inchangé).
- Le parcours Google OAuth réel (et non simulé) exige un téléphone physique —
  les tests simulent le flux réseau ; le parcours réel avait été validé en
  mission antérieure par le fondateur.
- L'audit « crédits » du jour repose sur les tests JVM du dépôt (android-ci,
  pas encore rejoués sur ce commit au moment de la rédaction — mis à jour après
  le passage main).
