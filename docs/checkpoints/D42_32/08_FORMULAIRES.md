# 08 — Lot 8 (P1) · Formulaires : conjugaison du tutoiement + clavier

## Défaut cité à l'audit (01_DIAGNOSTIC_UX.md, P1 formulaires)

« Tu pouvez laisser vide » (aide du champ témoignage) — et toute la famille
de fautes de conjugaison du tutoiement sur les textes issus des 30 gabarits.

## RCA démontrée (core-model, `Gabarit.kt` → `toInterfaceFrench`)

Le parseur adapte les libellés JSON (vouvoiement SSOT) en tutoiement UI.
Trois mécanismes produisaient des fautes :

1. **`EZ_REGEX` exige un radical ≥ 5 lettres** avant la terminaison `-ez`.
   « pouvez » (radical « pouv », 4 lettres) n'était JAMAIS conjugué ; le
   remplacement mécanique `vous→tu` donnait « **Tu pouvez** » — le défaut
   exact de l'audit. Même cause : « avez » (« tu avez préparé »), « rangez »,
   « Filmez » (×70), « Gardez » (×9), « Posez » (×1).
2. **`EZ_REGEX` produit `-e`** (impératif tu) même pour l'**indicatif** :
   « vous proposez » → « tu propose » (au lieu de « proposes ») ;
   « choisissez » → « Choisisse » (au lieu de « Choisis »).
3. **`vous` pronom OBJET** remplacé comme s'il était sujet :
   « les clients peuvent vous écrire » → « peuvent **tu** écrire » ;
   impératifs pluriels jamais touchés (« **Dites** ce que vous avez préparé »).

## Corrections (diff minimal, JSON sources INTACTS — SSOT préservée)

`toInterfaceFrench` uniquement :

- `VERB_EXCEPTIONS_V2` enrichie (application par **frontière de mot**, plus
  jamais par sous-chaîne) : Pouvez→Peux, Avez→As, Rangez→Ranges,
  Emballez→Emballes, Écrivez→Écris, Dites→Dis, Faites→Fais,
  Choisissez→Choisis, Proposez→Proposes, Dressez→Dresses, Parlez→Parles,
  Filmez→Filme, Gardez→Garde, Posez→Pose (+ formes minuscules).
- Règle « vous » pronom objet avec **élision correcte** : `t’` devant voyelle
  (« peuvent t’écrire »), `te` devant consonne (« peuvent te joindre »),
  apostrophe typographique `’` (cohérente avec les JSON).
- 1 entrée exacte figée (double retouche dans une même phrase).
- L'ancienne chaîne `.replace("Écrivez","Écris")` hors frontière supprimée
  (désormais dans la map bornée).

### Balayage exhaustif du corpus transformé (labels, aides, titres de
sections, consignes caméra, guides parole — 30 gabarits)

- Avant : 15 chaînes fautives (« Tu pouvez », « tu avez » ×2, « tu rangez »,
  « Choisisse » ×2, « tu dresse », « tu en parlez », « peuvent tu » ×3,
  « Dites…tu… » ×4, « Filmez/Gardez/Posez » restés pluriels).
- Après : **0 anomalie** (`\b[Tt]u \w+ez\b`, `Choisisse`, `peuvent tu`).
  Seul « -ez » survivant : « assez » (adverbe, correctement ignoré).
- Simulation miroir Python de l'algorithme Kotlin exact : 15/15 attendus.

### Test de caractérisation (nouveau)

`core-model/src/test/.../ToInterfaceFrenchTest.kt` : 15 cas = chaînes
RÉELLES du corpus (avant → après), + garde-frontière (« Bravez » ne devient
jamais « Bras » via l'exception « avez ») + règles générales préservées
(Tenez→Tiens, Soyez→Sois, Ajoutez→Ajoute, Vos→Tes).

## Clavier / prix / focus (reste du P1 formulaires)

- **WhatsApp international** : DÉJÀ complet (D42.30-09, libphonenumber
  8.13.50, E.164, collage détecté, BJ proposé jamais imposé) — rien refait.
- **adjustResize + imePadding** : combo DÉJÀ tranché par RCA D42.30-09
  (preuves e2e 5082856 / 8c9f514 : resize consomme l'inset, imePadding
  no-op, pied « Continuer » épinglé au-dessus du clavier) — rien refait.
- **ChampPrix** : DÉJÀ stable (D42.30 : valeur brute pendant l'édition,
  groupage visuel à la sortie, suffixe FCFA, erreur à hauteur réservée).
- **AJOUTÉ (Gboard)** : `ImeAction.Next` + `moveFocus(Down)` sur champs
  texte simple, prix et téléphone — la touche d'action du clavier passe au
  champ suivant (avant : retour ligne muet sur un champ singleLine).
- **AJOUTÉ (police agrandie 130 %)** : zone d'erreur réservée
  `height(20.dp)` → `heightIn(min = 20.dp)` — à taille normale AUCUN
  changement (pas de saut), mais un message d'erreur qui dépasse S'AFFICHE
  en entier au lieu d'être rogné.

Preuves visuelles clavier ouvert / petit écran / police 130 % : Phase B
(galerie), captures réelles attendues du job e2e-lab.

## CI — corrections portées par le même commit

- **316bb80 + b0a988b android-ci FAILURE** : (a) detekt `:data`
  `parseBrief` complexité 20>15 et test L10n 93 lignes/33>15 ;
  (b) compile Lot 3 `CameraDiagnosticActivity` (`prepare` inexistant sur
  `Recorder` → API réelle `prepareRecording`, import `PixelCopy` manquant,
  clé camera2 `ScalerStreamConfigurationMap` → `SCALER_STREAM_CONFIGURATION_MAP`,
  appel `ecrireRapport` sans son paramètre `rapport`).
- Corrigé : `parseBrief` scindé en `parseChamps`/`parseSections`
  (comportement identique) ; test L10n découpé en 5 tests ciblés (même
  couverture, chaque méthode < 80 lignes et complexité ≤ 15) ; les 4 fixes
  compile ci-dessus (pattern recopié de `CameraGuideActivity` qui compile
  depuis RC15).
- e2e-lab b0a988b : 4 jobs failed en cascade du même échec compile —
  rerun au prochain push.

## Limites honnêtes

- `toInterfaceFrench` reste pilotée par le corpus : toute NOUVELLE
  formulation « vous » dans les JSON doit passer par le test de
  caractérisation (sinonEZ_REGEX/exceptions peuvent produire une faute).
- « Bravez »-like (hors corpus) : non conjugué — documenté, assumé.
- Les champs `exemple` et `temps` des JSON ne passent PAS par
  `toInterfaceFrench` (exemples locaux, décision Lot 4 conservée).
