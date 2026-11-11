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
- **Harnais migrés (D42.30-07 puis 09)** : d'abord `+22997000000` →
  `+2290197000000` ; **D42.30-09 (RCA 8c9f514)** : le numéro de test devient
  la forme NATIONALE `0197000000` — celle du hint, insensible à la perte du
  « + » à l'injection (constat D42.26-18f), tapée par les 4 bancs
  (p1/camerap/drafts/audio_modes) ; `remplir_champ` efface 24 caractères
  (8 DEL laissaient des concaténations invalides) ; preuves sur dump
  NORMALISÉ (espaces ôtées : `0197000000` couvre « 01 97 00 00 00 » ET
  « +2290197000000 » ; `15000` couvre « 15 000 »).
- **Tolérance indicatif collé (D42.30-09, app)** : `versE164` accepte
  « 2290197000000 » (indicatif sans « + ») — essai direct prioritaire,
  re-essai sans indicatif seulement après échec (un fixe « 2290… » reste
  interprété tel quel). Test JVM `TelephoneValidatorTest` : 7 cas dont
  national 10 chiffres, collage international, indicatif collé, ancien format
  8 chiffres, invalides, exemple généré, France.
- **Diagnostic harnais différencié (D42.30-09)** : si un dump porte
  « n'est pas valide », le FAIL du brief NOMME le champ et dit que Continuer
  est correctement désactivé (au lieu de « 4 essais sans effet ») — avec
  remontée du formulaire pour capter le message hors écran.
  run_official_e2e délègue à run_p1 → couvert pour la RC15.

## Prix et clavier (P1-D — codé 10a12e1, retiré à tort 67f6421, REMIS D42.30-09)

- BriefActivity `windowSoftInputMode=adjustResize` + `imePadding()` sur les
  écrans Brief/ReadyCheck : le formulaire respire sous Gboard.
  **D42.30-09 : adjustResize REMIS** après RCA 8c9f514 — le retrait (théorie
  « double inset ») avait laissé le pied épinglé SOUS le clavier ouvert
  (insets IME non propagés sans adjustResize). Avec le CTA épinglé hors
  scroll, adjustResize le garde au-dessus du clavier ; le « 1 px » de 5082856
  était dû au bouton DANS le scroll, configuration disparue.
- Champ prix (ChampPrix) : valeur BRUTE pendant l'édition (le curseur ne
  saute JAMAIS), groupage visuel « 1 500 » uniquement à la sortie du champ,
  suffixe FCFA, emplacement d'erreur RÉSERVÉ (hauteur fixe — plus de saut de
  layout quand le message apparaît/disparaît).
- Preuve d'acceptation restante : capture avant/après sur émulateur petit
  écran clavier ouvert (étape 8 / matrice finale).
