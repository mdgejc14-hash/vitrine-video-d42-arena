# D42.23 — 04. FIREBASE / GOOGLE AUTHENTICATION (Phase C)

## Concordance app ↔ Worker ↔ projet Firebase (vérifié au code)
- Worker (`src/index.js`) : `PROJECT_ID = "vitrine-video"`, JWKS Google
  securetoken, issuer+audience vérifiés — 401 « A valid Firebase ID token
  is required » **actif en production** (sondes D42.23/02).
- App (`FirebaseAuthGateway.kt`) : initialisation MANUELLE
  (FirebaseOptions) — apiKey = `BuildConfig.FIREBASE_API_KEY`
  (gradle `vvFirebaseApiKey`), projectId = **"vitrine-video"** (concordant),
  applicationId = `1:609889830251:web:3fbac877b49c108a93782e`.
- `signInWithGoogleIdToken` : récupère (uid, ID token) — le token est
  OBLIGATOIRE côté worker (correctif audit final : sans lui, welcome-grant
  partait avec un Bearer vide = crédits jamais attribués).

## D23-3 [CRITIQUE — découvert et corrigé] APK public avec clé Firebase FACTICE
- **Preuve** : l'APK rc10-audio-v2 publié (release 438084850, sha256
  `4e2acf14…`) contient UNIQUEMENT `AIzaSyD42LABDUMMYKEY00000000000000000`
  (extraction dex : une seule clé AIzaSy présente). Cause : le miroir public
  porte volontairement une clé factice (la clé réelle ne devait pas être
  publiée dans le SOURCE public) et le workflow release-official-build
  **n'injecte aucune clé** → l'APK public a embarqué la factice.
- **Conséquence sans correctif** : connexion Google impossible chez le
  fondateur/les commerçants (« API key not valid »), donc pas de token, pas
  de welcome-grant/crédits, pas de téléchargement BGM authentifié. Exactement
  le type de défaut que D42.23 devait attraper avant le premier test physique.
- **Sonde contrastée non destructive** (signInWithPassword email inexistant,
  aucune écriture) :
  - clé réelle `AIzaSyCKxf…-Hys` → `INVALID_LOGIN_CREDENTIALS` = clé VALIDE
    et active (elle atteint la vérification d'identifiants) ;
  - clé factice → `API key not valid. Please pass a valid API key.`.
- **Correctif appliqué (D23-3)** :
  1. La clé RÉELLE est committée dans la branche `d42.23-production` du
     dépôt PRIVÉ (commit D42.23-02 `2cd6991` — même valeur que main du
     privé, qui la porte depuis l'origine) ;
  2. APK de production reconstruit EN LOCAL depuis cette branche :
     tests unitaires feature-export + assembleRelease R8 full avec
     `-PvvApkSha256=758077eb…` (porte d'intégrité), signature OFFICIELLE
     directe via `vv-signing/` (gitignoré) — réplication exacte de l'étage 1
     CI + signature ;
  3. Vérifications de l'APK : clé factice ABSENTE, clé réelle PRÉSENTE,
     certificat `758077eb…`, sha256, mapping.txt conservé ;
  4. Release publiée dans le DÉPÔT PRIVÉ (aucune exposition publique de
     la clé au-delà de la distribution normale de l'APK).
- **Architecture qui en découle** (documentée) : builds PUBLICS du miroir =
  validation e2e avec clé factice (le parcours e2e n'exerce pas le login
  Google) ; builds PRODUCTION = dépôt privé (clé réelle + secrets).
  Après déblocage D23-1, un tag build dans le privé produit l'APK
  signé officiellement en CI.

## Chaîne d'authentification — état des vérifications
- Scénarios serveur (création, connexion, session, isolation A/B,
  révocation, falsifiés) : couverts par `security-ci.mjs` (1029 lignes)
  via API Security CI — exécution réelle bloquée D23-1 (dispatch prévu
  sur `d42.23-production` dès déblocage).
- Session locale (repli sans compte) : validée E2E (P1_session_locale).
- Connexion Google réelle : nécessite Play Services + compte —
  **test physique fondateur (checklist A2)** ; tous les ingrédients sont
  maintenant raccordés (clé réelle, projet concordant, worker 401→prêt).
- Réinstallation/reconnexion : jetons Firebase + données métier côté D1
  (bootstrap serveur) — couverts par security-ci au déblocage.
