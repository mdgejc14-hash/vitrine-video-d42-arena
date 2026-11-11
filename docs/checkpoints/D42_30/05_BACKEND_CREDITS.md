# D42.30 — 05_BACKEND_CREDITS

**Étape 2 (P0-B crédits/inscription) — codée dans dd5ca28, CI verte
(android-ci 5082856 ; e2e-lab : auth 10/10 SUCCESS, backend-http SUCCESS).**

Retour terrain (défaut n°1) : message « récupération des crédits » après
inscription — promesse mensongère.

## Enchaînement contrôlé (feature-onboarding)

auth → token vérifié → bootstrap → **confirmation serveur** → claim si code →
welcome-grant → solde confirmé → miroir local → affichage. Chaque étape
n'avance QUE sur la réponse réelle du serveur.

- `bootstrap()` n'est plus « fire and forget » : le résultat est attendu et
  classé avant de tenter le welcome-grant (avant : grant tenté sur profil
  inexistant → 404, puis message générique).
- **Welcome-grant (POST /api/v1/me/welcome-grant)** : les DEUX réponses 200
  sont des soldes CONFIRMÉS — `{granted:true, credits_total:N}` (premier
  appareil) et `{granted:false, credits_left:N, reason:"already_granted"}`
  (autre appareil a déjà reçu le grant) → affichage du solde dans les deux
  cas. La mission interdit « seront ajoutés plus tard » quand le serveur a
  répondu.
- **Sans code de parrainage = parcours NORMAL** (le claim est facultatif,
  branché uniquement si un code est présent — le parrainage déjà validé 7/7
  n'est pas re-testé ni perturbé).

## Taxonomie d'erreur (WelcomeScreen) — chaque cause a son message juste

| État | Cause technique | Message |
|---|---|---|
| attente | requête en cours | récupération en cours (honnbtement transitoire) |
| ok | solde confirmé (grant ou déjà-attribué) | solde affiché |
| solde_zero | 200 mais 0 crédit | solde 0 (pas de promesse) |
| horsligne | réseau indisponible (timeout/DNS) | explication réseau + compteur local |
| refuse 401 | session expirée | reconnexion |
| refuse 403 | `account_inactive` | compte inactif |
| refuse 404 | `profile_not_initialized` | profil à initialiser (bootstrap) |
| refuse ≥500 | `database_unavailable` 503 ou autre 5xx | serveur indisponible — réessayer |
| autre %d | tout autre code | erreur précise (numéro affiché) |

Contrat serveur (src/index.js, vérifié au code D42.30) : requireUser →
404 `profile_not_initialized` / 403 `account_inactive` / 503
`database_unavailable` ; welcome-grant 200 `{granted:…}` ; 400 si
fingerprint < 16. Résidus d'ancienne API purgés (grep creditsEchue/
enAttente/requestGrant/GrantState → PROPRE).

## Preuves existantes et restantes

- **backend-http SUCCESS** (contrat Worker réel : 404/403/503/200 par routes).
- **auth 10/10 SUCCESS** (Credential Manager Firebase réel).
- Reste (étape 8) : parcours inscription complet sur l'émulateur avec le
  worker de production D1 — capture de l'écran crédits montrant le SOLDE
  (pas « récupération »), et l'écran horsligne en mode avion.
