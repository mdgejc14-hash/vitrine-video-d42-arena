# Google SSO — préparation release signée (side-loading site EPD HOLDING)

## État du code (commit courant)
- `GoogleSsoClient` (feature-onboarding) : Credential Manager API, 1-tap, sans téléphone.
- `AuthActivity` : bouton unique « Continuer avec Google » ; plus aucun bouton démo visible.
- `app/build.gradle.kts` : `SSO_WEB_CLIENT_ID` et `ADMIN_EMAILS` injectés au build via
  propriétés Gradle `-PvvWebClientId=… -PvvAdminEmails=…` (jamais de secret en dur).
- `AdminGate` (core-model) : contrôle d'accès administrateur par email Gmail, testé en JVM.

## Procédure console Google Cloud (compte administrateur principal Gmail)
1. Console Google Cloud → projet Vitrine Video → APIs & Services → Credentials.
2. Créer un client OAuth **Android** avec le SHA-256 de la clé de signature release :
   `keytool -list -v -keystore vitrine.keystore -alias vitrine` → copier l'empreinte SHA-256
   (certificat interne actuel : d18c1098…3a). Package : `video.vitrine.app`.
3. Créer un client OAuth **Web** (type Web application) : c'est lui qui fournit l'id token
   attendu par Firebase Auth. Copier sa valeur dans `vvWebClientId` au build release.
4. Firebase Console → Authentication → Google : activer et coller le même web client id.
5. Écran de consentement : ajouter l'email administrateur principal comme compte de test
   pendant la phase « Testing », puis publier l'app OAuth en production.

## Side-loading (téléchargement direct sur le site)
- Aucun passage par Play : le SSO Google fonctionne dès lors que le SHA-256 de la clé qui
  signe l'APK distribué est déclaré à l'étape 2. Toute nouvelle clé de signature impose
  de répéter l'étape 2 (rotation de clé = nouvelle empreinte).
- L'APK CI actuel est signé clé debug : acceptable pour recette interne, interdit en
  production site. Pour la production : builder avec le keystore interne (props locales)
  ou migrer la clé vers GitHub Secrets (option proposée, non demandée).

## Accès administrateur
- Build release : `./gradlew assembleRelease -PvvAdminEmails="admin@epdholding.com"`
  (liste séparée par virgules). `AdminGate.isAdmin(email, BuildConfig.ADMIN_EMAILS)`.
- Injection sans mise à jour d'app possible plus tard via la route Workers §2.4 (clé
  `admin_emails`), sans toucher au coffre-fort src/.
