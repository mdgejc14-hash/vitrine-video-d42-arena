# D42.34 — Audit des causes racines (défauts fondateur démontrés par le code)

Méthode : lecture ciblée du code sur la branche `d42.34-founder-acceptance-fixes`
(base 85bb823), symbole par symbole, sans exécution lourde. Chaque cause racine est
démontrée par un extrait vérifiable avant toute correction. Les sections sont ajoutées
lot par lot, au fil des diagnostics.

---

## CR-1 · Catalogue : « modèles répétés » après choix de secteur (P0 ①)

### Chaîne auditée (exhaustive, conforme à l'ordre)

| Maillon | Fichier / symbole | Verdict |
|---|---|---|
| Choix secteur | `OnboardingActivity.kt` l.229-236 : `saveSession(uid, sector)` écrit `"sector"` dans prefs `vv_session` ; retour `putExtra("sector", sector?.code)` | ✓ sain |
| Réception Main | `MainActivity.kt` l.179 : `REQ_ONBOARDING → sectorCode = data?.getStringExtra("sector")` ; l.115/128 : survit à la recréation via `KEY_SECTOR` | ✓ sain |
| Lancement catalogue | `MainActivity.kt` l.293-301 : `launchCatalog()` → `putExtra("sector", sectorCode)` | ✓ sain (transmet la valeur, même null) |
| Réception catalogue | `CatalogActivity.kt` l.42 : `Sector.fromCodeOrNull(intent.getStringExtra("sector"))` | ✓ sain (null si absent) |
| État Compose | `CatalogScreen.kt` l.72 : `var sector by remember { mutableStateOf(initialSector ?: Sector.TOUS) }` | **✗ REPLI SILENCIEUX TOUS** |
| Filtre | `GabaritCatalogLogic.kt` l.14-18 : `visible()` filtre par `sectorFromGabaritCode(it.secteur)` | ✓ sain |
| Mapping secteur | `Gabarit.kt` l.23-31 : les 6 codes canoniques → enum, exhaustif | ✓ sain |
| Persistance gabarits | `GabaritRepository.kt` : cache Room fidèle (tous champs dont `nombrePrises`) | ✓ sain |

### Cause racine CR-1.1 (démontrée) — le secteur n'est jamais restauré depuis `vv_session`

`MainActivity.restaurerSession()` (l.106-111) ne relit que `token` et `uid` :

```kotlin
private fun restaurerSession() {
    val prefs = getSharedPreferences("vv_session", MODE_PRIVATE)
    authToken = prefs.getString("token", null)
    authUid = prefs.getString("uid", null)
}   // ← "sector" (écrit par OnboardingActivity.saveSession) n'est JAMAIS relu
```

Pourtant `OnboardingActivity.saveSession()` (l.212-218) persiste bien
`prefs["sector"] = sector.code`. Conséquence : tout parcours qui atteint le catalogue
**sans repasser par l'onboarding** a `sectorCode == null` :

1. **Entrée dashboard « Reprendre »** (`MainActivity` l.92 : `vv_reprise=true` →
   `peutProposerReprise()` → l.330/345 `launchCatalog()` avec `sectorCode` null).
2. Reprise de brouillon refusée (« Nouvelle vidéo ») après une relance d'app.
3. Tout futur point d'entrée direct vers le catalogue.

`CatalogScreen` l.72 replie alors **silencieusement** sur `Sector.TOUS` → les **30
gabarits** s'affichent : les titres similaires inter-secteurs (ex. témoignages client
présents dans les 6 secteurs — voulu par le catalogue canonique) deviennent des
« répétitions » à l'écran. C'est exactement le défaut photographié (capture 015013).

**Correction racine (Lot 1) — APPLIQUÉE et testée (v. commit Lot 1)** :
`restaurerSession()` relit aussi `"sector"` → `sectorCode` (garde `?.let`
pour ne jamais écraser une valeur plus fraîche). Le secteur persisté par
l'onboarding accompagne ainsi TOUT parcours, y compris la reprise dashboard.
Aucune donnée nouvelle, aucun contrat modifié.

**Défense en profondeur (exigence « jamais Sector.TOUS silencieux ») —
APPLIQUÉE et testée** : `CatalogScreen` n'affiche plus la grille des 30 quand
`initialSector == null` (anomalie réelle après correction ci-dessus) : il
affiche l'état explicite `catalog_secteur_perdu_titre`/`_texte` (bandeau
design system `BandeauEtat` niveau `ErreurDouce`, icône `ic_warning`),
récupérable via la rangée de filtres ouverte. Un `Sector.TOUS` EXPLICITE
(harnais de captures, repli hors-ligne documenté) conserve l'ancien
comportement — distinction testée (`D34Lot1CatalogVisualCheckTest`).

### Cause racine CR-1.2 (démontrée) — libellé « X s · N scènes · M prises »

`feature-catalog/src/main/res/values/strings_catalog.xml` l.10 :

```xml
<string name="catalog_gabarit_meta">%1$d s · %2$d scènes · %3$d prises</string>
```

affiche « 15 s · 15 scènes · 3 prises » — le « 15 scènes » interdit par l'ordre
(le fondateur voit « scènes » comme du jargon montage, pas tournage).

**Données déjà conformes** : `GabaritJson.parse()` l.194
`nombrePrises = root.optJSONArray("prises")?.length() ?: 0` → le nombre de prises
est bien calculé du JSON chargé ; `nombreScenes` et `dureeTotaleS` proviennent du
JSON canonique (non modifiés — conforme P0 ②).

**Correction racine (Lot 1) — APPLIQUÉE et testée** : libellé → `%1$d s · %3$d prises guidées` (FR) /
`%1$d s · %3$d guided takes` (EN) ; appel `stringResource` inchangé (les 3 args
restent passés, seul le gabarit de chaîne change — `%2$d` disparaît du texte).

**Décision visuelle associée — APPLIQUÉE et testée** : `VignetteCatalogue.dessinerDecorVignette`
dessine désormais une cellule de pellicule **par prise guidée** (paramètre
`prises`), aligné sur « N prises guidées ». Le champ JSON `nombre_scenes`
n'est PAS touché (P0 ② respecté) ; les 4 sites d'appel passent
`g.nombrePrises` (le repli skins passe `null` = pas de pellicule, inchangé).

**Preuves Lot 1** (Robolectric, `D34Lot1CatalogVisualCheckTest`, sdk 34,
qualifiers fr-w360dp-h820dp, GraphicsMode NATIVE) :
- `secteur_perdu_etat_explicite_sans_grille_silencieuse` PASS — état
  explicite affiché, AUCUNE carte gabarit quand `initialSector == null` ;
- `secteur_perdu_recuperable_par_choix_du_metier` PASS — clic secteur Mode
  → les 5 modèles du secteur s'affichent ;
- `libelle_carte_prises_guidees_sans_mot_scenes` PASS — méta T1 Mode
  (35 s, 3 prises réels du JSON) affichée, plus aucune occurrence du
  libellé fautif ;
- captures : `D34-01/02/03_*.png` (build/visual-check, intégrées à la
  galerie au Lot non-régression).
- Module complet : 18 tests / 0 échec ; `:app:compileDebugKotlin`,
  ktlint et detekt verts sur `:app` + `:feature-catalog`.

---

## Référence canonique des prises (base des Lots 2 et 3)

Inventaire exhaustif des 30 JSON (script, cf. `02_MATRICE_GABARITS_30.csv`) :

- **81 prises** au total (30 gabarits), champ `prises[]` systématiquement présent.
- Champs réels d'une prise (noms canoniques, à utiliser tels quels — l'ordre citait
  des noms de travail, le code mappe sur ces clés réelles) :
  `id`, `libelle`, `duree_cible_s`, `consigne_camera`, `type_plan`, `mouvement`,
  `lumiere`, `astuce`, `photo_acceptee`, `scenes_alimentees`,
  `guide_parole_scenes`, `segments_guide_parole` (`scene`, `quoi_raconter`,
  `quoi_montrer`, `exemple`).
- **`photo_acceptee = true` sur les 81 prises** : chaque prise accepte une vidéo OU
  une photo → contrat naturel de l'import rushs (Lot 2) : **1 prise = 1 média**,
  jamais de concaténation aveugle de fichiers.
- `scenes_alimentees` relie chaque prise aux scènes du montage : c'est le pont
  prises[] (tournage) ↔ scenes/nombre_scenes (montage, moteur) exigé par le P0 ②.

## Sections suivantes (ajoutées au fil des lots)

- CR-2 · Import rushs (`OpenMultipleDocuments` → GabaritBriefScreen, URI
  persistantes, contrat slots) — Lot 2.
- CR-3 · Caméra générique (`buildSceneGuides(script, durationS)`, HUD, countdown,
  écran noir Scène 1/0, nom de package) — Lot 3.
- CR-4 · Identité marchand / paywall / montage — Lot 4.
- CR-5 · Carrousel 3 métiers / splash — Lot 5.
