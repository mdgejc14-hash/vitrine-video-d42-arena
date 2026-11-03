# RAPPORT D42.2 — MIROIR PUBLIC, PERSISTANCE ET FERMETURE DU RENDU COMMERCIAL

**Date :** 2026-11-03 · **Branche :** `d42.2` (privé) · **Miroir :** `vitrine-video-d42-arena`

> **Statut : PORTE A FRANCHIE sur le mécanisme, non sur les cinq chaînes exigées.**
> Le texte commercial est désormais visible et lisible sur **100 % des frames**
> d'un MP4 produit par le vrai moteur Android. La cause racine est établie et
> corrigée. Les portes B–E ne sont pas franchies. La PR #2 est ouverte et non
> fusionnée. `main` est intacte.

---

## 1. Cause racine — établie par preuve visuelle, pas par déduction

### 1.1 Ce que le code faisait

`MotionComposition.fromClientRushes` rebasait chaque mot sur son plan :

```kotlin
.map {
    val debut = (it.startS - plan.t0).coerceIn(0.0, dureePlan)
    val fin = (it.endS - plan.t0).coerceIn(debut, dureePlan)
    it.copy(startS = debut, endS = fin)
}
```

Chaque plan recevait donc des mots horodatés dans `[0, durée du plan]`, soit
environ `[0 s ; 1,2 s]`.

### 1.2 Ce que Media3 fait réellement

Les `TimestampWrapper` sont évalués sur la **timeline globale** de la
composition, pas sur le temps relatif de l'`EditedMediaItem`.

Conséquence : **tous les mots de tous les plans tombaient dans la première
seconde de la vidéo.** Un spectateur ne voyait qu'un flash de texte au tout
début, puis plus rien pendant 34 secondes.

### 1.3 Les preuves, dans l'ordre où elles ont été obtenues

| # | Expérience | Résultat | Ce que ça élimine |
|---|---|---|---|
| 1 | Traces `D42-TRACE` sur 3 points | beatsheet 4 002 o / **15 mots** → worker **15 mots, 31 plans, 3 rushes** → typographie **overlays produits**, taille 52 px | beat sheet vide, perte de données entre maillons |
| 2 | Sonde : 3 bandes opaques, fenêtres 0-10 / 10-20 / 20-30 s | rouge à **3 s**, verte à **13 s**, bleue à **23 s** | « les overlays ne sont pas composés » ; `TimestampWrapper`, échelle et ancrage fonctionnent |
| 3 | Texte rendu, échantillonnage à 2, 6, 10… s | aucun texte | (faux négatif : les frames tombaient toutes après la 1ʳᵉ seconde) |
| 4 | Analyse à **4 im/s**, 140 frames | texte **uniquement sur 5 frames**, de 0 à **1,25 s** | « le dessin des glyphes échoue » |
| 5 | Suppression du rebasage | texte sur **100 %** des 70 frames | — |

L'expérience 4 est décisive : le texte existait, il était simplement confiné à
la première seconde.

### 1.4 Correction

```kotlin
// horodatages ABSOLUS conservés, bornés à zéro (TimestampWrapper rejette < 0)
.map { it.copy(startS = it.startS.coerceAtLeast(0.0)) }
```

Le filtre `it.endS > plan.t0 && it.startS < plan.t1` reste : chaque plan ne
reçoit que les mots qui le concernent, mais **à leur heure réelle**.

---

## 2. Honnêteté sur les correctifs intermédiaires

Trois changements ont été introduits pendant le diagnostic. **Un seul est
démontré nécessaire : la suppression du rebasage.**

| Changement | Nécessaire ? | Preuve |
|---|---|---|
| Horodatages absolus | **oui, démontré** | run 8 : 100 % des frames ; run 7 : 1,25 s |
| Taille liée à la hauteur (`baseSizePxFor`) | amélioration | 52 px = 5,42 % au lieu de 42 px = 4,37 % ; le texte était déjà visible à 42 px dans le run 7 |
| Bitmap plein cadre + `setScale(1,1)` | **non démontré** | le run 7 utilisait déjà ce dispositif ; aucun A/B ne l'isole |
| `Canvas.drawText` au lieu de `StaticLayout` | non démontré | remplacement effectué avant de connaître la cause ; plus simple, conservé |

Je ne présente donc pas ces trois derniers comme des correctifs du défaut :
ce sont des améliorations plausibles, dont la nécessité n'est pas prouvée. Les
conserver sans preuve serait exactement le travers que D42.1 interdisait.

---

## 3. Porte A — état réel

| Critère | Résultat |
|---|---|
| Le texte est composé par le moteur Android (pas FFmpeg) | **oui** — APK de production, `ExportWorker`, Media3 |
| Texte visible dans les frames extraites | **oui**, 100 % des frames |
| `25000 FCFA` lisible | **oui** (run 41714843343, frame à 30 s) |
| Nom du commerce | **oui** — « Chez D42 Test » |
| Mots-clés en orange | **oui** — « À DÉCOUVRIR » |
| `OFFRE D42 DIAGNOSTIC` | **non observé** dans ce rendu |
| `COTONOU` | **non observé** |
| `STOCK LIMITÉ` / `CONTACTEZ-NOUS` | **non observés** (dépendent de scènes et du badge, `badge=none`) |

**Pourquoi les trois chaînes manquent :** l'entrée `templates` du workflow n'a
pas été honorée — les rendus portent sur `batiment_travaux_T1/T2` et non
`restaurants_maquis_T1`. Le gabarit de construction n'utilise pas les scènes
« offre / localisation / badge ». Le mécanisme est prouvé ; le jeu de scènes
n'est pas encore celui exigé. **Ce n'est pas une porte A complète.**

---

## 4. Compteurs de la chaîne (run 41714843343)

| Maillon | Mesure |
|---|---|
| 3. `GabaritBeatSheet.build` | 4 002 octets, 15 mots, fr |
| 6. `ExportWorker` | 15 mots, 31 plans, 3 rushes |
| 8. `KineticTypography` | 32 appels, ~40 overlays, taille 52 px, géométrie 540×960 |
| 8b. rendu effectif | `"25000 FCFA" taille=52 yPx=648 base=696 w=286 bitmap=540x960` |
| 9. MP4 | 11 025 685 octets, 35 s, 540×960 |

---

## 5. Miroir public

| Élément | Valeur |
|---|---|
| Dépôt | `mdgejc14-hash/vitrine-video-d42-arena` (public) |
| Création | snapshot aplati du commit `13eb3c6`, arbre `5d79ad88…` |
| Commit initial | `dbf3e58` |
| HEAD | `57fc62f` (données porte A, source privée `fe3200c`) |
| Fichiers | 577 + manifeste (604 lignes d'empreintes) |
| Contrôle de confidentialité | **0 anomalie** |

### Correspondance privé ↔ miroir

| Privé | Miroir | Contenu |
|---|---|---|
| `13eb3c6` | `dbf3e58` | snapshot initial + correctif typographie |
| `cba9d67` | `53788a7` | type `HEIGHT_FRACTION` |
| `cad455b` | `710a74b` | traçabilité `D42-TRACE` |
| `a3421a4` | `e85c6aa` | sonde à bandes |
| `fe899df` | `39fda47` | `Canvas.drawText` |
| `2626a16` | `b75a1e8` | **cause racine** |
| `fe3200c` | `57fc62f` | données porte A |

**Les checks GitHub du miroir ne valident pas le commit privé** : les SHA
diffèrent. La correspondance est assurée par la copie fichier à fichier et par
les empreintes du manifeste.

---

## 6. Secrets — ce que le scan a réellement trouvé

| Détection | Décision |
|---|---|
| Clé Google API dans `gradle.properties:20` | neutralisée dans le miroir ; **toujours présente dans le privé et dans son historique** |
| Clé Google API dans `scripts/audio/probes_audio_v2.py:18` | idem |
| `database_id` D1 prod et preview dans `wrangler.jsonc` | remplacés par des zéros dans le miroir |
| `mock-server/data/uploads/*.mp4` | retiré du miroir |
| 3 workflows de production | **écartés** du miroir |
| `.dev.vars.example` | conservé — uniquement des noms, aucune valeur |
| `+22997000000` dans deux tests | **synthétique**, admis |

**Défaut d'outil corrigé en route :** le contrôle d'historique annonçait « ok »
alors que la clé y figurait. Cause : `git log | grep -q` ferme le tube, `git`
reçoit SIGPIPE et `set -o pipefail` transforme le succès en échec. Corrigé en
capturant la sortie avant de la tester. Ce contrôle a ensuite bien signalé
« motif de secret dans l'historique (3 lignes) », ce qui **justifie à lui seul
l'historique aplati** : rendre le dépôt privé public directement aurait exposé
la clé.

---

## 7. Portes restantes

| Porte | État | Blocage |
|---|---|---|
| A — rendu commercial FR visible | **partielle** | entrée `templates` non honorée ; 3 chaînes sur 5 non observées |
| B — 4 langues | non commencée | — |
| C — scènes / effets / positions | non commencée | — |
| D — collecte sans collision | non commencée | nommage déjà corrigé en `96f6223`, à rejouer |
| E — audio | non commencée | −21,8 LUFS mesurés, cible non confirmée |

**Aucune matrice ne doit être lancée** tant que la porte A n'est pas complète.

---

## 8. Coût

| Poste | Valeur |
|---|---|
| Minutes privées consommées | **0** (aucun run sur le dépôt privé) |
| Runs sur le miroir public | 9 (dont 2 échecs de compilation, 1 annulé) |
| Durée par run complet | 10 à 12 min |
| Quota privé | toujours **−7 min** (dépassement inchangé depuis D42) |

Le miroir public a rempli son rôle : **aucune minute facturable n'a été
consommée** pour produire ces preuves.

---

## 9. Prochaine action exacte

1. Corriger l'entrée `templates` du workflow (elle est ignorée : les rendus
   sortent en `batiment_travaux` au lieu du gabarit demandé).
2. Relancer **un** rendu sur `restaurants_maquis_T1`, `fr`, `badge=stock_limite`,
   pour obtenir `OFFRE D42 DIAGNOSTIC`, `COTONOU`, `STOCK LIMITÉ`,
   `CONTACTEZ-NOUS` dans les frames.
3. Si les 5 chaînes apparaissent : porte A complète → enchaîner les portes B
   (en/es/ja) sur le même gabarit.
4. Ne lancer la matrice 120 qu'après A et B.

---

## 10. Ce que ce rapport ne prétend pas

- La porte A n'est **pas** complète.
- Les portes B–E ne sont **pas** franchies.
- Le correctif de taille et le bitmap plein cadre ne sont **pas** démontrés
  nécessaires — seul le rebasage l'est.
- D42 n'est **pas** terminée ; D41 n'est **pas** modifiée.
- Le miroir public existe toujours et doit être supprimé après la porte E.
- Les MP4 produits restent des artefacts Actions : aucun n'est versionné.

---

# ADDENDUM D42.3 — CÂBLAGE DES GABARITS ET VALIDATION EXACTE

**Date :** 2026-11-03 · **Branche :** `d42.2` · **Miroir :** `6f71ade`

## 1. Défaut corrigé : le filtre de gabarit était perdu

Le workflow passait `shard:N/8` **dans l'argument des gabarits**. Le motif shard
l'emportait dans `cibles()`, la liste restait les 30 gabarits, et `limite=1` ne
gardait que le premier venu : le rendu était vert, mais sur
`batiment_travaux_T1` au lieu du gabarit demandé.

| Notion | Avant | Après |
|---|---|---|
| Filtre de gabarit | écrasé par le lot | `d42_templates`, argument 3 |
| Indice du lot | confondu avec le filtre | `d42_shard`, argument 9 |
| Total des lots | confondu avec le filtre | `d42_shards`, argument 10 |
| Badge | figé à `none` | entrée `badge` du workflow |
| Profil, langue, limite | déjà distincts | inchangés |

Ordre d'application dans `cibles()` : **filtre, puis contrôle, puis lot, puis
plafond**. Un gabarit demandé introuvable provoque un échec immédiat ; une
demande d'un seul gabarit doit rendre exactement une cible.

Journal obtenu : `D42-SELECTION filtre=restaurants_maquis_T1 demandes=1
selectionnes=1 ids=restaurants_maquis_T1 lots=1 indice=1`.

## 2. Récapitulatif CI

`smoke=skipped` n'est accepté que si `run_smoke=0` **et** validation `success`.
Tout autre cas reste rouge. Le run 41722190374 est entièrement vert, smoke
inclus comme `skipped` légitime.

## 3. Deux défauts de rendu corrigés

| Défaut | Preuve | Correctif |
|---|---|---|
| Prix brut `25000 FCFA` | 8b.texte du run 41718770982 | `grouperMilliers` sur `{prix}` → `25 000 FCFA` |
| Numéro coupé `…+2299700` / `0000` | frames du run 41718770982 | `splitLines` ne coupe plus dans une suite de chiffres, préfère un séparateur, et garde le `+` avec ses chiffres |

Tests JVM ajoutés : `un numero de telephone n_est jamais coupe en deux`,
`la coupure prefere un separateur de champs`,
`le plus international reste avec les chiffres`,
`le prix est groupe par milliers dans le texte affiche`.

## 4. Rendu de référence (run 41722190374)

| Élément | Valeur |
|---|---|
| Gabarit demandé / exécuté | `restaurants_maquis_T1` / `restaurants_maquis_T1` |
| Langue, badge, profil | fr, `stock_limite`, validation 540×960 |
| Lignes du manifeste | **1** |
| MP4 | 15 204 494 o, 35,04 s, h264 540×960 + aac 48 kHz |
| SHA-256 | `9a0d27efa018d6bb6dda9f564af806841f71a5f47963a60ee757af49e3a2737e` |
| Durée du rendu | 149 025 ms |
| Worker | `SUCCEEDED` |

## 5. Les six chaînes demandées — verdict

| # | Chaîne exigée | Observée | Verdict |
|---|---|---|---|
| 1 | `Chez D42 Test` | oui, scène d'ouverture et carte de contact | **conforme** |
| 2 | `OFFRE D42 DIAGNOSTIC` | **jamais** | **absent** |
| 3 | `25 000 FCFA` | oui, après correctif | **conforme** |
| 4 | `COTONOU` | oui, carte de contact | **conforme** |
| 5 | `STOCK LIMITÉ` | « Stock limité » | **casse différente** |
| 6 | `CONTACTEZ-NOUS` | **jamais** | **absent** |

**3 conformes sur 6. Porte A NON validée** — l'ordre interdit de la déclarer si
une seule valeur manque.

### Pourquoi 2 et 6 sont absents — cause structurelle, pas technique

- `{nom_offre}` n'apparaît dans `restaurants_maquis_T1` **que** dans
  `copywriting.formules_prix[0]`, une phrase de conseil au commerçant qui
  **n'est jamais affichée**. Aucune scène ne porte l'offre. 14 des 30 gabarits
  l'affichent (dont `restaurants_maquis_T3` et `T4`) ; **T1 non**.
- **Aucun des 30 gabarits** ne contient de libellé CTA : `CONTACTEZ-NOUS`
  n'existe nulle part dans les textes de scène. La scène de contact rend
  `nom_commerce · quartier_ville · whatsapp`, sans appel à l'action.
- Le badge est rendu fidèlement à la l10n : `Stock limité`, pas `STOCK LIMITÉ`.
  La casse exigée diffère de la chaîne produit.

Ces trois écarts ne peuvent pas être fermés par le moteur : ils demandent une
modification éditoriale des gabarits (ajouter une scène « offre » dans T1 et un
libellé CTA dans les 30 gabarits, ou dans la l10n). Les fabriquer après rendu
est interdit et n'a pas été fait.

## 6. Transfert vers `audit-d41`

Non exécuté : la branche `d42.2` est poussée, la PR #2 reste ouverte et non
fusionnée. Procédure vérifiable préparée :

```
git diff cf26af5..d42.2 --stat          # 12 fichiers touchés
git log --oneline cf26af5..d42.2        # 18 commits
```

Le transfert se fera par `git merge --no-ff d42.2` après accord, jamais par
copie aveugle de fichiers.

## 7. Coût

Runs publics : 5 pour D42.3 (2 échecs de compilation corrigés en cours de
route). Minutes privées : **0**. Paiement inchangé : `501`.
