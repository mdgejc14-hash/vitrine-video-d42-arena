# D42.33 — 06 Famille Brief & Formulaires (famille D)

Commit : voir RUNS.md (commit unique famille 05-fix + 06 + CI). Écrans :
brief gabarit (E5), ReadyCheck (E4b), brief legacy (écran 6), champ
téléphone international. **Refait intégralement après le rollback sandbox
n°5** (13:50 UTC — HEAD local repéré à 8d530b1/D42.27, travail famille 06
non commité perdu, aucune perte sur GitHub).

## Réalisations (spec §7.5, §7.9, §8-D)

| Zone | Avant (D42.32) | Après (D42.33) |
|---|---|---|
| Marges | 16 dp | **20 dp**, espacement 12 |
| En-tête brief | headlineSmall + badge r8 + barre 6 dp GrisLiserai/OrangeStore | **H2 Navy + Sub Muted**, badge étape **FormePill + Label 11/700** sur BleuVoile, **BarreProgression §7.8** (4 dp, pill, piste #EDEFF5, remplissage OrangeStore) |
| Champs texte | OutlinedTextField M3 (label dedans) | **ChampFormulaire §7.9** : label Tiny 600 Navy AU-DESSUS, hauteur 56, rayon 18, focus = filet 2 dp OrangeStore + fond OrangeVoile, erreur AmbreAlerte, **message à hauteur RÉSERVÉE (min 18 dp — jamais de saut de layout)**, touche « Suivant » conservée (D42.32 Lot 8) |
| Champ prix | OutlinedTextField M3 | même look §7.9 (logique BRUTE/GROUPÉE/FCFA D42.30 INTACTE) |
| Champ téléphone | drapeau emoji + indicatif, champs M3 | **pastille typographique code ISO (BJ, FR…) — cohérente avec l'écran langue, plus aucun emoji drapeau (§6)** ; bouton pays 56 dp filet Line, champs look §7.9 ; lignes du sélecteur : pastille code + nom + indicatif |
| Sections | bandes r8 titleSmall | bandes **FormeTuile** + style **Label 11/700** (obligatoire BleuVoile/Navy, optionnelle repliée OrangeVoile/OrangeDeep) |
| Badges choix | TextButton r8 labelMedium | pilules **FormePill** Label (sélection OrangeVoile/OrangeDeep) |
| Pied | Button 52 dp M3 | **BoutonPrimaire pilule 56 dp** (testTag brief_continue) |
| ReadyCheck | Card M3 ×2, headlineSmall, Button M3 | tuiles blanches **rayon 22 + ombreSm**, H2/H3, rows **Sub Muted / Body 600 Navy**, badge FormePill, bandeau info FormeTuile, **BoutonPrimaire** (testTag ready_ok) |

Design system étendu (backward compatible, défauts inchangés) :
- `ChampFormulaire` : + `actionClavier: ImeAction` + `surSuivant` (touche
  Suivant → moveFocus(Down), comportement D42.32 Lot 8 préservé à l'identique).
- `MessagesChamp` : hauteur min 18 dp réservée (exigence §7.5 « pas de
  déplacement au clavier » — leçon D42.30 RC14).

Fonctionnel INTACT : validation `fieldError` (libphonenumber, règles JSON),
`ChampPrix` brute/groupée, `TelephoneField` E.164 + sélecteur recherchable,
brouillon D42.27 (onValuesChange), bouton épinglé D42.30 (imePadding +
navigationBarsPadding), `onSubmit(map)` inchangé. ReadyCheck : mesures
réelles du gabarit uniquement (format/métier/prises/infos), aucun état inventé.
Legacy BriefScreen (écran 6, non atteint par le parcours commercial) :
mêmes composants appliqués — aucun contrat modifié.

## Corrections CI regroupées dans le même commit (sortie de la boucle CI)

1. **detekt LongMethod CatalogScreen** (run 43600512583) : extraction
   `EnTteCatalogue` (91→40 lignes) — aucune logique déplacée.
2. **detekt LongMethod BriefFieldInput** (préventif, 90>80 après refonte) :
   extraction `ChampStandardGabarit` (33+56 lignes).
3. **Tests JVM / MavenArtifactFetcher** (run 43600512583) : diagnostic —
   Robolectric 4.17 télécharge `android-all-instrumented` au RUNTIME des
   tests, hors résolution Gradle (aucun cache setup-gradle, aucun retry) ;
   un 404 transient de Maven Central (FileNotFoundException
   HttpURLConnection.java:2055) faisait échouer 7 classes Robolectric en
   classMethod AVANT toute logique de test. Ce n'est PAS un défaut
   fonctionnel : le build est identique aux runs verts D42.32 (seul le
   trigger workflow diffère).
   **Fix déterministe** (`build.gradle.kts` racine) : Gradle résout les 2
   jars du dépôt — `14-robolectric-10818077-i7` (SDK 34 : les 13 classes,
   coordonnées lues dans DefaultSdkProvider 4.17) et
   `9-robolectric-4913185-2-i7` (SDK 28 : ExportForegroundInfoTest @Config
   méthode) — tâche `syncRobolectricAndroidAll`, puis chaque tâche Test
   démarre en mode offline documenté (`robolectric.offline=true` +
   `robolectric.dependency.dir`, lus par LegacyDependencyResolver,
   vérifié dans le bytecode 4.17 : LocalDependencyResolver attend
   `<dir>/<artifactId>-<version>.jar`). Aucun test désactivé, aucun
   résultat masqué ; un jar manquant échoue immédiatement et explicitement
   (« Path is not a file »).

## Tests

- BriefVisualCheckTest (Robolectric, SDK 34) : rend l'écran réel → CI.
- Static vérifié localement (pas de SDK en sandbox) : signatures
  BoutonPrimaire/ChampFormulaire/BarreProgression/MarqueVitrine, tokens,
  styles VitrineText, accolades, imports — tous contrôlés par script.
