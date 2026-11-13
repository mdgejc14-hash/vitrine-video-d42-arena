# D42.32 — Lot 4 : localisation FR/EN complète (P1)

## Périmètre couvert

1. **Écrans / boutons / notifications / erreurs** : parité FR/EN des 7 modules
   vérifiée par `I18nKeyCoverageTest` (100 clés dashboard, 54 onboarding,
   41 camera, 40 brief, 30 export, 10 catalog, 7 design system) — **aucune
   clé EN manquante**, aucune clé FR rendue en EN détectée.
2. **30 gabarits — surface marchande** : traduction EN complète par overlay
   clé sur **identifiants techniques stables** (nouveau
   `assets/i18n/gabarits_ui_l10n_v1.json`, 80 Ko) :
   - 5 formats affichés (New arrivals, Before and after, Showcasing a
     product, Sale, A customer tells the story) ;
   - 30 phrases courtes commerciales ;
   - 6 libellés de secteurs ;
   - 240 entrées de champs (label + aide + exemple) ;
   - 7 titres de sections de formulaire ;
   - 81 prises (libellé + consigne caméra) ;
   - 52 segments de guide parole (quoi montrer / quoi raconter / exemple).
   Total : **376 chaînes uniques traduites** (dictionnaire source :
   `docs/checkpoints/D42_32/lot4_traductions.py`).
3. **Textes incrustés dans la vidéo** : déjà couverts par `GabaritL10n`
   (53 textes + badges, `resolve()` appelé à l'export avec la langue) —
   inchangés, contrat intact.
4. **Mélange caméra « Film your take » + consignes FR** : cause racine = les
   consignes de prises venaient du JSON canonique FR. Corrigé à la racine :
   `CameraGuideActivity` applique l'overlay EN → titre ET consignes
   cohérents dans la langue choisie.

## Architecture (SSOT)

```
JSON canoniques 30 gabarits (FR, JAMAIS modifiés, Room = source de vérité)
   │
   ├─ GabaritL10n.resolve(texte, langue)      → textes incrustés vidéo (existant)
   └─ GabaritUiL10n.traductions(ctx, lang, id) → surface UI (nouveau D42.32)
        clé = id gabarit / id champ / id prise / index segment (stables)
        repli FR champ par champ si traduction absente (jamais de vide)
```

- `GabaritJson.parse|parseBrief|parsePrises|parseCheckRows` acceptent un
  overlay optionnel `t` (défaut null = comportement inchangé, tests
  existants intacts).
- Appliqué aux 4 points d'affichage : `CatalogActivity` (résumés),
  `BriefActivity` (formulaire + récap), `CameraGuideActivity` (consignes),
  `ExportActivity` (récap E7). `parsePreviewTexts` reste FR = textes vidéo
  (localisés par GabaritL10n au rendu).
- Langue : `VitrineLocale.saved()` (choisie une fois, conservée partout —
  mécanisme D42.30 inchangé).

## Contrôles automatiques (exigés par la mission)

| Contrôle | Test | État |
|---|---|---|
| EN manquant (XML) | `I18nKeyCoverageTest` (7 modules) | existant, vert |
| EN manquant (gabarits) | **`GabaritUiL10nCoverageTest`** (nouveau) : 30 gabarits × champs/sections/prises/segments, variables {…} préservées FR↔EN | ajouté |
| Texte codé en dur | **`HardcodedUiTextCheckTest`** (nouveau) : zéro `Text("…")` FR littéral dans les 6 modules UI | ajouté (0 occurrence actuelle) |
| Mixte FR/EN | couverture gabarits + parité XML + le mélange caméra corrigé à la racine | couvert |
| Texte FR rendu en EN | balayage heuristique des values/ (FR) : aucun texte anglais détecté | vérifié ce lot |

## Limites documentées (aucun défaut caché)

- Les **exemples** de champs gardent une saveur locale (Akpakpa, Cotonou ;
  Chez Awa ; robe wax) — choix produit assumé, pas des traductions ratées.
- `notes_adaptation`, `action_montage`, `sfx_libelle_simple` : champs
  internes de production, jamais affichés au marchand → non traduits.
- ES/JA : retirés du produit (D42.30), archives `content/archive_i18n/`
  intactes — preuves historiques conservées.
