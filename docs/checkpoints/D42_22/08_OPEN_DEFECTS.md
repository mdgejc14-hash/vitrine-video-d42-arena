# D42.22 — 08. DÉFAUTS OUVERTS

## D22-1 [BLOQUANT déploiement + tests API réels] Secrets absents de CE dépôt
**Diagnostic complet du 08/11 ~06:40-06:50 (preuves par runs)** :
- `worker-deploy-2` (42455579181, 06:38) : `CLOUDFLARE_API_TOKEN:` et
  `CLOUDFLARE_D1_PREVIEW_API_TOKEN:` **VIDES** dans l'env du job (log l.175-177) ;
  Cloudflare : « Invalid format for Authorization header » (jeton vide).
- API Security CI (42442004667, 03:16) : `FIREBASE_WEB_API_KEY:` **VIDE**.
- Aucun environnement GitHub n'existe (API : total_count = 0) — pas un problème
  de raccordement environnement.
- Les runs de déploiement réussis du 01/11 (41312068176/41312551179) **ne sont
  pas dans CE dépôt** : ils ont tourné sur le dépôt PRIVÉ principal. Les
  captures du fondateur montrent les secrets du dépôt privé.
- CE dépôt (`vitrine-video-d42-arena`) est PUBLIC (miroir) ; aucun run B2/
  backup n'y a jamais eu lieu ; le wiring des workflows est CORRECT
  (noms exacts, pas d'environnement requis).
- **Action fondateur précise (une fois)** : dépôt `mdgejc14-hash/
  vitrine-video-d42-arena` → Settings → Secrets and variables → Actions →
  New repository secret → ajouter : `CLOUDFLARE_API_TOKEN` (jeton Cloudflare
  « Edit Cloudflare Workers » du compte d7dac13d…), puis (pour l'audit et les
  tests API) : `FIREBASE_WEB_API_KEY`, `FIREBASE_TEST_A_EMAIL`,
  `FIREBASE_TEST_A_PASSWORD`, `FIREBASE_TEST_B_EMAIL`,
  `FIREBASE_TEST_B_PASSWORD`, `B2_KEY_ID`, `B2_APPLICATION_KEY`. Ensuite :
  re-tag `worker-deploy-3` puis `audio-audit-1`.
- NOTE SÉCURITÉ : ce dépôt étant public, ne mettre AUCUN secret de SIGNATURE
  (VV_KEYSTORE_B64 reste au dépôt privé / hors Git — architecture D42.17
  maintenue).

## Hérités D42.21
- D2 : rendu export > 40 min sur émulateur (matériel réel attendu).
- D3-D6 : voir docs/checkpoints/D42_21/08_OPEN_DEFECTS.md.
- D11 : dettes complexité detekt (2 suppressions ciblées, refactors à planifier).

## D42.22 nouveaux (hors secrets)
- AUCUN. Clôture : android-ci (42456741706), e2e-lab 9/9 ×2 branches
  (42456741703/42456741399) et e2e-official 42456670342 (PASS=37 FAIL=0)
  tous VERTS sur le commit final `1c10cad`.
