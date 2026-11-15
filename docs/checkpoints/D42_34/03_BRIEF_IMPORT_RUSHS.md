# D42.34 — CR-2 · Import des rushs dans le parcours gabarit (P0 ④)

## Défaut fondateur

« BriefActivity.OpenMultipleDocuments() existe mais n'est intégré qu'au
BriefScreen générique — pas dans GabaritBriefScreen. » Le fondateur ne peut
jamais fournir de vidéos/photos existantes (témoignage client en priorité) :
tout doit être filmé au guide caméra.

## Chaîne auditée (démonstration, base 60ab918)

| Maillon | Symbole | Verdict |
|---|---|---|
| Picker générique | `BriefActivity` l.45-56 : `pickRushs = registerForActivityResult(OpenMultipleDocuments())`, `takePersistableUriPermission` + ajout à `rushs` | ✓ existe |
| Écran générique | `refresh()` l.173-190 : `BriefScreen(rushCount, onAddRushs)` → résultat `client_rushes` | ✓ câblé |
| Écran gabarit | `renderGabarit()` l.119-168 : `GabaritBriefScreen(brief, initialValues, onValuesChange, onSubmit)` — **AUCUN paramètre rush, AUCUN picker** | **✗ cause racine** |
| Résultat gabarit | `onOk` l.143-162 : extras `brief_*`, `script`, `duration_s` — **pas de `client_rushes`** | **✗ conséquence** |
| Réception Main | `MainActivity` l.205 : `briefRushs = data?.getStringArrayExtra("client_rushes")` (null en parcours gabarit) | ✓ sain, jamais alimenté |
| Caméra | `CameraGuideActivity.finishWithPrises()` l.595-613 : `client_rushes` = `priseFiles` **aligné par slot** (1 fichier/prise, `""` si sautée) | ✓ contrat slots existant |
| Fusion actuelle | `MainActivity.launchExport` l.257 : `(briefRushs + camRushes)` **concaténation aveugle** | **✗ interdit par l'ordre** |
| Export | `ExportActivity` l.218+232 : `measureDurations(rushes)` (0,0 s pour slot vide, `content://` supporté) → `GabaritBeatSheet.build` | ✓ sain |
| Moteur | `ExportWorker` l.400 : `RushSlots.resolve` remplace les slots vides par le voisin AVANT l'indexation `rid` | ✓ sain |
| Beat sheet | `GabaritBeatSheet` l.19+134 : `decoupage_prises` → `rushIndex` (prise_N → N-1) : **l'index dans la liste = le contrat** | ✓ sain |

## Pourquoi la concaténation est fausse (démonstration)

`rushIndex` indexe la liste `rushes` : `prises[0]` ↔ slot 0. Si le marchand
importe 2 rushs client au brief (T5 : « Le client qui parle », « Le vêtement
porté ») puis filme 2 prises au guide, la concat actuelle produit
`[importé_1, importé_2, filmé_1, filmé_2]` : le moteur attache `importé_1` à
`prise_1`… et les rushs filmés sortent du gabarit (découpage à 4 slots alors
que `prises.size == 2`). C'est exactement la « concaténation aveugle » que
l'ordre interdit.

## Audit des 30 gabarits — qui demande l'import ?

| Famille | Formats (×6 secteurs) | Import rushs |
|---|---|---|
| T5 `T5_temoignage_client` « Un client raconte » | 6 gabarits, 2 prises chacun (`photo_acceptee` vrai partout) | **FACULTATIF proposé** — le client existe souvent déjà en vidéo/photo ; filmer reste possible |
| T1 nouvel arrivage · T2 avant/après · T3 montrer un produit · T4 promotion | 24 gabarits, mode `saisie_video` intégral (`politique_saisie.mode`) | **NON proposé** — « pas obligatoire partout » ; ces formats se tournent au guide |

Détection : `GabaritSummary.format.startsWith("T5_")` (identifiant canonique
stable, zéro modification des 30 JSON — contrats et IDs inchangés).

## Correction racine appliquée (Lot 2)

1. **`GabaritBriefScreen`** : nouveaux paramètres optionnels
   `prisesPourImport: List<PriseGuide>`, `rushSlots: List<String>`,
   `onImportRush`, `onClearRush` — section « Vidéos du client » rendue
   uniquement pour T5 : une ligne par prise (« Prise 1 · Le client qui parle »),
   1 prise = 1 média, bouton Retirer par slot, note honnête « ou filmez ces
   prises au guide caméra ».
2. **`BriefActivity`** : second contrat `OpenMultipleDocuments`
   (`video/*` uniquement) dédié au mode gabarit —
   chaque URI sélectionnée remplit le PREMIER slot libre (jamais au-delà de
   `prises.size`), `takePersistableUriPermission` conservé ; résultat
   `client_rushes` **aligné par slot** (taille = prises.size, `""` sinon).
3. **Brouillon** : les slots importés persistent à l'étape BRIEF via la clé
   réservée `vv_rush_slots` dans la sauvegarde existante (aucune migration
   Room, aucune nouvelle colonne) ; restaurés au retour dans le brief ;
   filtrés des extras `brief_*` du résultat.
4. **`MainActivity.launchExport`** : fusion **par slot** quand
   `gabaritId != null` (la prise FILMÉE prime sur l'importée, index par
   index, taille = prises.size) ; la concat historique reste pour le parcours
   générique (pas de prises, pas de slots).
5. **`core-model`** : fonction pure `RushsImport.fusionParSlot(brief, cam)`
   + tests unitaires JVM (alignement, priorité filmée, slots vides, tailles
   hétérogènes) — la règle est testée, pas implicite.

## Preuves (Lot 2) — exécutées, toutes vertes

- Unitaires JVM `core-model` : `RushsImportTest` — 7 tests (priorité filmée,
  slots vides, tailles hétérogènes, sérialisation rond-bourré bornée).
- Robolectric `feature-brief` : `D34Lot2BriefImportVisualCheckTest` — 3 tests
  PASS : T5 réel (JSON embarqué) section import affichée avec les 2 prises
  réelles ; slot rempli → Retirer visible ; T1 réel : section ABSENTE.
  Captures `D34-04/05/06_*.png` (build/visual-check).
- Modules complets : core-model 11/11, feature-brief 25/25 (0 échec) ;
  `:app:compileDebugKotlin` + `:app:compileDebugAndroidTestKotlin` verts ;
  ktlint + detekt verts sur core-model, feature-brief, app.
- E2E témoignage (émulateur requis, hors CI sandbox) : cas T5 ajouté au
  harnais instrumenté existant (`ProductionRenderInstrumentedTest`) —
  slots importés + prises filmées → MP4 vérifié + logs moteur. À exécuter
  sur émulateur/appareil fondateur (documenté, pas simulé).

## Limite honnête : vidéos uniquement

`photo_acceptee` (vrai sur les 81 prises) est un contrat JSON CAMÉRA — mais le
moteur de composition (`MotionComposition.fromClientRushes`) ne décode que des
rushs VIDÉO, et le guide caméra n'a pas de capture photo aujourd'hui. Importer
une photo produirait un export cassé. Le picker est donc limité à `video/*`
tant que le moteur n'a pas de cause démontrée pour composer des images
(moteur protégé par l'ordre). Consigné pour décision fondateur.

## Ce qui n'est PAS touché

Les 30 JSON canoniques, les IDs, `nombre_scenes`, le moteur, les contrats
serveur, le parcours générique BriefScreen, le guide caméra (Lot 3 séparé).
