# D42.14 — Authentification

## 1. Trois niveaux, séparés sans conversion

| Niveau | Ce qui est exécuté | Statut |
|---|---|---|
| 1. **Parcours sans Google** (session locale) | écran de connexion, bouton Google, repli « sans compte », persistance de session | **PASS_EMULATOR** |
| 2. **Contrat serveur** (jetons rejetés) | 401 sur absence de jeton, `alg=none`, confusion d'algorithme, jeton en URL | **PASS_HTTP** |
| 3. **Connexion Google réelle** | — | **BLOCKED** |

## 2. Niveau 1 — exécuté sur émulateur

| Scénario | Résultat | Preuve |
|---|---|---|
| Écran de connexion affiché (titre + promesse) | PASS | `03_connexion.png` (D42.13) |
| Bouton « Continuer avec Google » entièrement visible (portrait) | PASS | `S04b` |
| Bouton **localisé** dans les 4 langues | PASS ×4 | `Continue with Google`, `Continuar con Google`, `Googleで続ける` |
| Repli « sans compte » → **écran quitté** | PASS | `P1_session_locale` |
| Le repli n'ouvre **aucun appel réseau** | PASS (session locale) | code + absence d'erreur réseau au logcat |
| Bouton désactivé pendant la vérification de session | **observé** — cause racine de plusieurs échecs de harnais : il faut ré-appuyer | `AuthActivity.kt` : `isEnabled = false` → `true` |
| Déconnexion / reconnexion | **NOT_RUN** — aucun écran de déconnexion exposé dans le parcours actuel |

## 3. Niveau 2 — exécuté côté serveur (Worker local, 12 migrations)

| Scénario | Résultat |
|---|---|
| Requête sans `Authorization` (5 routes) | **401** |
| Jeton `alg=none` | **401** |
| Confusion RS256/HS256 (signature forgée avec la clé publique) | **401** |
| Jeton valide mais passé en `?token=` | **401** |
| Facturation sans identité | **401** — et **pas** 501 (aucune fuite d'état) |

## 4. Niveau 3 — pourquoi c'est bloqué, précisément

| Blocage | Détail vérifiable |
|---|---|
| `google-services.json` absent du dépôt | aucun client OAuth Android configuré pour ce build |
| Aucun compte Google de test | l'émulateur peut lancer le flux, mais personne ne peut l'autoriser |
| JWKS Google **en dur** côté serveur (`src/index.js:8-12`) | même avec un jeton local, la vérification côté Worker est infranchissable |

Ces trois points ne peuvent pas être contournés par du code de laboratoire. Le **protocole
physique** (`09_PROTOCOLE_PHYSIQUE.md`, étape 4) est la seule voie : il utilise votre
téléphone et votre compte, et ne demande aucun secret.

## 5. Ce que le protocole physique doit révéler (et qui compte produit)

| Observation attendue | Pourquoi elle compte |
|---|---|
| Le sélecteur de compte s'ouvre | présence effective des Services Google sur l'appareil |
| Retour dans l'app **sans message d'erreur** | le jeton est accepté par le Worker de production |
| Message d'erreur **actionnable** en cas d'échec | D42.12 a remplacé les noms de classe obfusqués par des messages lisibles — c'est le moment de le vérifier |
| Crédits de bienvenue affichés | la chaîne `me/welcome-grant` fonctionne réellement (aujourd'hui `BLOCKED` côté HTTP) |

**Ne m'envoyez jamais** de mot de passe, de code de vérification ou de jeton : les captures
suffisent, et l'adresse e-mail peut être masquée.
