# D42.23 — 03. BASE D1 (Phase B/D)

## État vérifié (lectures non destructives)
- `/health` production : `database: connected`, `schema: ready`,
  `applicationTables: 8` — cohérent avec migrations 0001-0012 appliquées
  au déploiement D40 (01/11, runs privés 41312068176/41312551179).
- **AUCUNE migration nouvelle** entre D40 et D42.23 : `db/migrations/`
  strictement identiques privé ↔ miroir (0001-0012) → le déploiement
  D42.23 est CODE-SEUL (aucun risque de schéma).

## Contrôles bloqués par D23-1 (directs, via wrangler)
- Counts réels des tables métier (merchant_identity, quota_ledger,
  referrals, billing_orders, audio_catalog, bgm_library) ;
- état EN_LIGNE des 564 pistes attendues en ligne ;
- réconciliation B2 (audio-audit-1, lectures) ;
- backup D1 (échec cron depuis le 04/11 — cause D23-1, pas un défaut
  du script : dernier succès 41573746856 du 03/11, 29 s).

## Ce que le code garantit (audit D42.22 réutilisé)
- quota eventId = clé primaire → idempotence consommation ;
- welcome-grant verrou empreinte + INSERT OR IGNORE ;
- parrainage paliers/5 idempotent ; isolation par firebase_uid (JWKS).
- Le workflow deploy (d42.23-production) vérifie lui-même le schéma
  distant avant de déployer (4 tables PASS/FAIL) — il s'exécutera au
  déblocage D23-1 et ses PASS seront la preuve directe.
