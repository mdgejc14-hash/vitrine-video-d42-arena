# D42.34 — Plan d'exécution et état — Corrections fondateur avant approbation

**Mission** : corrections fonctionnelles et visuelles ciblées, exclusivement à partir des
défauts démontrés par le fondateur (ordre D42.34 + addendum « couteau suisse »).
**Échéance : 18/11/2026** · Budget 0 FCFA · GitHub = unique source de vérité.

## État opérationnel (journal permanent)

| Rubrique | Valeur |
|---|---|
| HEAD distant de départ | `85bb823` (d42.33-visual-redesign, vérifié par ls-remote) |
| Branche active | `d42.34-founder-acceptance-fixes` (créée depuis 85bb823, aucun reset) |
| main | `bb759f8` — intouché, vérifié |
| Dernier HEAD distant sauvegardé | (aucun commit D42.34 pour l'instant) |
| Lot actif | **Lot 0 — Reprise et diagnostic** |
| Lots terminés | — |
| Lots en cours | Lot 0 (diagnostic causes racines) |
| Lots non commencés | 1 Catalogue · 2 Brief/rushs · 3 Caméra · 4 Identité/abos/montage · 5 Visuel · 6 Non-régression |
| CI | aucune exécutée en D42.34 pour l'instant (dernière D42.33 : 43662646267 SUCCESS sur 85bb823) |
| Éléments locaux non poussés | présents checkpoint initial uniquement (ce commit) |

## Intégrité vérifiée au départ (Lot 0)

- Branche créée depuis `85bb823` → **tout l'état D42.33 est préservé par construction**
  (30 gabarits, moteur, galerie, checkpoints D42_33, tests — aucun fichier touché).
- 30/30 gabarits JSON présents : batiment_travaux 5 · coiffure_beaute 5 · immo_auto 5 ·
  restaurants_maquis 5 · shops_small_business 5 · vetements_mode 5.
- Moteur et compositions audio : intacts (aucun diff depuis 85bb823).
- Rollback n°12 du workspace local constaté et traité : état local ancien stashé
  (`rollback12`), reprise depuis HEAD distant réel — aucun reset destructif.

## Sources fondateur inventoriées (Lot 0)

- **Source A/B (uploads)** : 5 PNG dans la sandbox (`/home/user/uploads/image-1..5.png`)
  — planche de référence et/ou captures de défauts. **Limite honnête** : l'agent n'a pas
  de capacité vision ; identification programmatique (dimensions/métadonnées) + les
  descriptions précises de l'ordre font foi pour le diagnostic.
- **Source C (Drive, vérifiée et ouverte)** : dossier `1DbQxChPm05Ec8yLd_KvtqMUm6wAKQAty`
  — 17 fichiers : `00_Planche_16_ecrans_v3.png` + 16 écrans de référence individuels
  (01_connexion … 16_parrainage).
- **Source D (Drive, vérifiée et ouverte)** : dossier `1_rxI0KNEhvxKWeZvA7RLFJA2_qKcXeyi`
  — 13 ressources + `CREDITS_PHOTOS.md` (registre de provenance lu et consigné).
  - 6 photos secteurs (mode, beaute, food, batiment, auto, boutique) ;
  - parrainage.jpg (poignée de main, point focal 42 %) ;
  - photo-merchant / photo-camera / photo-product (portraits 9:16 et produit) ;
  - mark.png (insigne) + wordmark.png (insigne + VITRINE VIDÉO) — marque intangible.
  - **Licences** : images de recherche web utilisées dans les maquettes ; le registre
    exige achat/remplacement avant production Play Store. ⇒ Réserve bloquante
    consignée : utilisation autorisée pour le développement/maquette vivante,
    **remplacement obligatoire avant toute publication** (cohérent : pas de RC16,
    pas de build commercial).
  - Couleurs de marque confirmées : orange `#F95C0F`, navy `#022358`, blanc
    (= tokens D42.33, aucun écart).

## Problèmes fondateur → causes racines (matrice de diagnostic)

| # | Défaut constaté (source) | Cause racine candidate | Lot |
|---|---|---|---|
| 1 | Modèles répétés au catalogue après choix de secteur (capture 015013) | à auditer : transmission secteur onboarding→catalogue, replis défensifs `Sector.TOUS` | 1 |
| 2 | Compteur `Scène 1/26` + durée `1,2 s` (015706) | confusion `nombre_scenes`/sous-plans moteur vs `prises[]` | 1/3 |
| 3 | `PRISE 1/3` coexistant avec `Scène 1/26` (015809) | double parcours : guide gabarit + `buildSceneGuides(script, durationS)` générique | 3 |
| 4 | Compte à rebours (015948) | à vérifier : alignement réel du décompte avec l'enregistrement | 3 |
| 5 | Écran noir `Scène 1/0` + nom de package technique (020028) | parcours générique avec `prises.size == 0` ; nom technique affiché | 3 |
| 6 | Import rushs absent du parcours gabarit (`GabaritBriefScreen` sans picker) | picker `OpenMultipleDocuments()` seulement dans BriefScreen générique | 2 |
| 7 | `Bonjour boutique` / noms génériques | identité marchand non reliée au profil réel (Google/Firebase/Room) | 4 |
| 8 | `Paiement bientôt disponible` (CTA morts) | `paywall_soon` + `boutonActif = false` neutralisent `onChoose` | 4 |
| 9 | Montage : minuteurs techniques (1,2 s, micro-séquences) | présentation branchée sur les sous-plans moteur au lieu des phases métier réelles | 4 |
| 10 | Carrousel : images peu diversifiées | ressources à remplacer par 3 métiers distincts (Drive D : photo-merchant / secteur_food / secteur_mode) | 5 |
| 11 | Accueil/logo premium | à aligner sur la planche (mark/wordmark officiels) | 5 |

Chaque ligne sera confirmée par audit de code ciblé (symboles, extras Intent, clés)
avant toute modification — cause racine d'abord, correction chirurgicale ensuite.

## Règles de gouvernance actives

D42.33 intacte · pas de push main · RC15 immuable · pas de RC16 · pas de build signé ·
CinetPay 501 `billing_not_configured` (aucune transaction fictive) · pas d'écran
Aide & Contact · 600 compositions audio protégées · identifiants canoniques des
gabarits inchangés · `nombre_scenes` jamais modifié pour masquer un compteur ·
aucun test désactivé · aucun FAIL→PASS.

## PROCHAINE ACTION ATOMIQUE

Audit ciblé cause racine #1 (catalogue/secteur) : tracer `sector` de
`OnboardingActivity` → `MainActivity` → catalogue (extras Intent, clés prefs,
`GabaritRepository`/`GabaritCatalog`), puis écrire `01_AUDIT_CAUSES_RACINES.md`
(section catalogue) et produire `02_MATRICE_GABARITS_30.csv` par script.
