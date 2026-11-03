# CARTOGRAPHIE 1 — Parcours Utilisateur (UX Flow) « Commerçant pressé »

Légende : ✅ livré · 🎯 cible de ce cycle (vision reprise) · ⏳ planifié.
Règle d'or : **budget ≤ 8 clics** de l'ouverture à l'export. Le marchand ne voit
JAMAIS le découpage de montage : il filme 2 à 4 prises, le moteur fait le reste.

## 1. Flux visuel global

```
 OUVERTURE (splash logo)
      |
      | 1 CLIC                      +-----------------------------+
      +---------------------------> | E1 LANGUE                   |
                                    | 4 drapeaux FR/EN/ES/JA      | ✅
                                    +-----------------------------+
      | 1 TAP (SSO 1-tap, sans telephone)
      v
 +-------------------+     premier lancement uniquement
 | E2 COMPTE GOOGLE  | --> (tuto carousel 3 slides, SKIPPABLE 1 tap) ✅/🎯
 +-------------------+
      | 1 CLIC
      v
 +----------------------------------------------+
 | E3 SECTEUR + CATALOGUE (fusion visuelle)     |
 | cartes 3D -> catalogue DEJA filtre secteur   | ✅ filtre / 🎯 fusion 1 écran
 | "Choisissez un modele" : 1 tap sur carte     |
 +----------------------------------------------+
      | 1 CLIC (gabarit choisi)
      v
 +----------------------------------------------+
 | E4 BRIEF ULTRA-SIMPLE : 3 VARIABLES          |
 |  [Nom produit] [Prix] [Offre]                | 🎯 (script voix AUTO-GENERE)
 |  + option : ajouter mes rushs galerie        | ✅ picker existant
 +----------------------------------------------+
      | 1 CLIC (valider)
      v
 +----------------------------------------------+
 | E5 TOURNAGE GUIDE INS : 2 A 4 PRISES MAX     |
 |  Prise 1 Vue produit   [1 tap = verrou+rec]  | 🎯 (26 scenes -> 2-4 prises)
 |  Prise 2 Detail/texture                      | ✅ overlay cadre/jauge/R4
 |  Prise 3 Prix/offre (option)                 | ✅ 3A + ML Kit R4
 |  Prise 4 En situation (option)               |
 +----------------------------------------------+
      | automatique (0 clic)
      v
 +----------------------------------------------+
 | E6 MOTEUR LOCAL (arriere-plan, 0 action)     |
 | beat sheet 1,5 s -> plans maps sur rushs    | ✅ WordClock/BeatGrid
 | zooms z(t), transitions, typo cinetique     | ✅ MotionComposition
 | mix -14 LUFS + ducking                      | ✅ AudioChain (banc)
 +----------------------------------------------+
      | 0 clic (notification quand pret)
      v
 +----------------------------------------------+
 | E7 PREVIEW DYNAMISEE + PARTAGE/EXPORT        | 🎯 lecture auto du rendu
 +----------------------------------------------+
```

## 2. Table par écran (action marchand / moteur caché / statut)

| # | Écran | Action marchand | Clics | Moteur caché | Statut |
|---|---|---|---|---|---|
| E1 | Langue | 1 tap drapeau | 1 | i18n 4 locales, persistance locale | ✅ |
| E2 | Compte | 1 tap Google | 1 | Firebase SSO JWKS, parrainage | ✅ |
| E2b | Tuto carousel | 0–1 tap (skip) | 0–1 | slogans officiels | ✅ (🎯 skip 1 tap + 1re fois seulement) |
| E3 | Secteur+Catalogue | 2 taps (secteur, gabarit) | 2 | manifest B2 JSON, cache offline, filtre secteur | ✅ filtre / 🎯 fusion |
| E4 | Brief 3 variables | 3 saisies + 1 tap | 1 | génération script voix = Nom+Prix+Offre ; durée auto 30 s | 🎯 (actuel : script libre = trop lourd) |
| E5 | Tournage | 1 tap par prise (2–4) | 2–4 | verrou 3A, gate R4, cadre 9:16, consignes courtes | 🎯 (actuel : guide 26 plans = rejeté) |
| E6 | Montage | 0 | 0 | plans 1,5 s → rushIndex, z(t), transitions, typo orange, mix | ✅ moteur / 🎯 mapping prises |
| E7 | Preview/export | 1 tap partager | 1 | WorkManager local, notification | ✅ statique / 🎯 lecture auto |

**Total cible : 8 à 11 taps dont 2–4 obligatoires de tournage.** Aucun écran
bloquant, retour natif = étape précédente partout (certifié NAVIGATION_GRAPH.md).

## 3. Ce qui CHANGE vs ce qui RESTE (décision vision)

| Élément | Décision | Pourquoi |
|---|---|---|
| 26 scènes de tournage | ❌ SUPPRIMÉ du parcours marchand | usine à gaz, tue la promesse « 30 s » |
| 2–4 prises nommées (Vue / Détail / Prix / Situation) | 🎯 nouveau protocole tournage | langage commerçant, pas langage monteur |
| Découpage 1,5 s, z(t), transitions, typo cinétique | ✅ RESTE, côté moteur uniquement | c'est la signature visuelle, invisible pour l'utilisateur |
| Script voix libre | 🎯 remplacé par 3 variables | le marchand pense produit/prix/offre, pas scénario |
| WordClock / beat sheet | ✅ RESTE | synchronisation voix/texte = qualité pro |
