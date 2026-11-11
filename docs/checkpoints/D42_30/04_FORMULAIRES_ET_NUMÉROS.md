# D42.30 — 04_FORMULAIRES_ET_NUMÉROS

## WhatsApp international (P1-E — codé, poussé 10a12e1/b5033f7, CI verte 5082856)

- **libphonenumber 8.13.50** (version intégrant le plan de numérotation béninois
  post-30/11/2024). Test JVM direct contre le JAR Maven Central (preuve
  exécutable, /tmp reproduit par javac -cp libphonenumber-8.13.50.jar) :
  - `+2290197000000` (01 9X) VALIDE ; `+2290160000000` (01 6X) VALIDE ;
    `+2290120000000` (01 2X) VALIDE ; `+33612345678` VALIDE pour FR ;
  - **`+22997000000` (ancien 8 chiffres) reste VALIDE** dans les métadonnées
    8.13.50 : l'ARCEP maintient une période de transition — Google garde les
    deux formes. Le champ ACCEPTE donc les deux (règles réelles du pays,
    jamais une regex maison) ;
  - **exemple contextuel BJ = `+229 01 95 12 34 56`** (généré par
    `getExampleNumberForType(BJ, MOBILE)`) : l'aide à l'écran montre TOUJOURS
    le format actuel 01/10 chiffres — plus jamais d'exemple codé en dur.
- Sélecteur de pays Dialog recherchable (~240 régions, BJ en tête, JAMAIS
  imposé), saisie nationale, collage E.164 auto-détecté (pays + forme
  nationale), aucun reformatage pendant la frappe, ligne « Enregistré : +E164 ».
- Valeur du champ = E.164 si valide, sinon texte brut ; « Continuer » bloqué
  par fieldError tant qu'invalide.
- Migration des 60 JSON (30 assets + 30 content) : exemple
  « +229 01 97 00 00 00 », aide « Choisissez votre pays… » ; versionCode 2 →
  re-seed Room automatique (mécanisme F48 vérifié dans GabaritRepository).
- **Harnais migrés (D42.30-07)** : run_p1/run_camerap/run_drafts/run_audio_modes
  — numéro de test `+22997000000` → `+2290197000000` (7 occurrences). L'ancien
  resterait accepté (cf. transition) mais les preuves doivent montrer le format
  ACTUEL. run_official_e2e délègue à run_p1 → couvert pour la RC15.

## Prix et clavier (P1-D — codé, poussé 10a12e1, CI verte 5082856)

- BriefActivity `windowSoftInputMode=adjustResize` + `imePadding()` sur les
  écrans Brief/ReadyCheck : le formulaire respire sous Gboard.
- Champ prix (ChampPrix) : valeur BRUTE pendant l'édition (le curseur ne
  saute JAMAIS), groupage visuel « 1 500 » uniquement à la sortie du champ,
  suffixe FCFA, emplacement d'erreur RÉSERVÉ (hauteur fixe — plus de saut de
  layout quand le message apparaît/disparaît).
- Preuve d'acceptation restante : capture avant/après sur émulateur petit
  écran clavier ouvert (étape 8 / matrice finale).
