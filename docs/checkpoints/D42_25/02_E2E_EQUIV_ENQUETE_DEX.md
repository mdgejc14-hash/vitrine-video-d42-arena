# D42.25 — 02. ENQUÊTE E2E-ÉQUIVALENT : le dex sans clé (résolu)

**Symptôme initial** (runs 42477586620, 42479256822, 42480435635) : l'étape
« Vérifications de l'artefact » échoue — « clés AIzaSy présentes dans le dex :
0 » : ni la clé réelle, ni la factice, ni le fallback. APK par ailleurs
conforme (signée du certificat de recette annoncé, taille 44 112 105 o).

## Méthode (élimination factuelle, chaque hypothèse testée)

1. **Le secret est-il bon ?** OUI — API Security CI 42478068047 SUCCESS
   (auth Firebase A/B réelle avec ce même secret).
2. **Le mécanisme env→Gradle fonctionne-t-il ?** OUI — reproduit en local :
   `ORG_GRADLE_PROJECT_vvFirebaseApiKey` résolu par `providers.gradleProperty`
   sous Gradle 9.6.0, **et il PRIME sur `gradle.properties` du root**
   (VERDICT=ENV_GAGNE, test multi-module).
3. **L'env atteint-il l'étape build ?** OUI — visible (masqué ***) dans le
   contexte de l'étape (logs GitHub).
4. **La propriété est-elle résolue dans le runner ?** OUI — DIAG run 42479256822 :
   « propriété = secret (env ORG_GRADLE_PROJECT résolu) », longueur 39.
5. **Le BuildConfig généré contient-il la clé réelle ?** OUI — DIAG :
   `feature-onboarding/build/generated/source/buildConfig/release/…/BuildConfig.java`
   contient la clé réelle.
6. **Le check est-il valide par conception ?** OUI — appliqué à la rc11
   officielle (release privée 438156110, sha256 b052e7c9…c83bb6) : le dex
   contient exactement 1 chaîne AIzaSy (la clé réelle) ; la méthode
   `strings` (fichier en argument ou stdin) la trouve dans les deux formes.
7. **R8 a-t-il éliminé la classe porteuse ?** NON — `AuthActivity` (manifest,
   donc conservée) instancie directement `FirebaseAuthGateway`
   (AuthActivity.kt:80) ; mapping R8 miroir : FirebaseAuthGateway présent
   (54 occurrences) ; R8 **9.4.24 identique** des deux côtés.
8. **Les dex sont-ils identiques ?** OUI — **preuve absolue** : les mappings
   R8 du build miroir (artefact run 42480435635) et de la rc11 (asset privée
   723529571) sont **octet pour octet identiques** (sha256 commun
   `8cef1f5a0053fd95b270a15e5d05e51fa2c802346407bf12c32586692a2364c7`,
   même `pg_map_id` `9d2f38a2…097a`). Même mapping ⇒ même dex ⇒ **la clé
   réelle EST dans le dex de l'APK équivalente.**

## Verdict

**Le build est CORRECT ; le coupable est le check lui-même** :
`subprocess.run(['strings', dex], …, text=True)` a renvoyé un flux vide/0 clé
sur le runner (cause exacte côté image runner non identifiée — binutils/
comportement sur fichier non-ELF — mais le fait est établi par la preuve 8).
Le harnais avait raison d'échouer sur un signal, mais le signal était un
artefact de mesure, pas un défaut de l'APK.

**Preuve binaire directe (run 42481593759, check binaire f3fa0bd)** :
`clé réelle présente (binaire) : True` — la clé exacte est bien dans le dex
de l'APK équivalente (taille 9 437 628 o, 1 occurrence AIzaSy). Deuxième
défaut du check découvert au même run : la détection « factice »
`b'D42LAB' in data or b'DUMMY' in data` produisait un **faux positif** —
« DUMMY » apparaît 2× dans TOUT dex sain (chaînes CEA/media3 :
`DTVCC_PACKET…DUMMY…DURATION_TO_ADVANCE` — vérifié sur le dex rc11 lui-même :
DUMMY=2, D42LAB=0, dummy exacte=0).

## Correctifs (2 commits)

- **f3fa0bd (D42.25-08)** : check réécrit en **analyse binaire directe** —
  `data = open(dex,'rb').read()` puis `key.encode() in data` (comparaison
  octet à octet de la clé exacte, zéro dépendance binutils/locale/décodage),
  DIAG intégrés (taille, sha256, occurrences AIzaSy, comparaison au dex rc11).
- **0a5d2bb (D42.25-09)** : détection factice = valeur EXACTE
  `AIzaSyD42LABDUMMYKEY` (publique, committée dans gradle.properties) au lieu
  de la recherche large « DUMMY » qui matchait des chaînes anodines.

## Enseignements consignés

- Un contrôle qui dépend d'un outil externe (`strings`) peut échouer SANS
  erreur visible (stdout vide ⇒ tous les compteurs à 0) — préférer la
  comparaison binaire directe pour les preuves.
- Une détection « factice » par sous-chaîne large (DUMMY) génère des faux
  positifs : toujours chercher la valeur exacte.
- La preuve par le mapping R8 (sha256 + pg_map_id) établit l'identité de
  deux dex sans échanger les binaires — méthode réutilisable.
- Attention au disque du bac à sable : un téléchargement tronqué par
  « No space left on device » a d'abord faussé la comparaison des mappings
  (62 Mo reçus sur 81 Mo) — toujours vérifier la taille attendue d'un
  asset téléchargé.
- L'égalité de tailles (APK 44 112 105 o, dex 9 437 628 o) entre rc11 et
  équivalente n'implique PAS l'égalité de contenu (sha256 différents) ;
  seule la preuve de contenu (binaire/mapping) compte.
