# D42.3 — État de reprise

**Branche privée :** `d42.2` · **Miroir public :** `mdgejc14-hash/vitrine-video-d42-arena` @ `6f71ade`
**Référence :** `audit-d41` @ `cf26af5` · PR #2 ouverte, non fusionnée · `main` `74edd98`

---

## 1. Acquis

| Élément | État |
|---|---|
| Filtre de gabarit vs découpage en lots | **séparés** — `d42_templates` / `d42_shard` / `d42_shards` |
| Contrôle explicite de sélection | **en place** — échec immédiat si le gabarit demandé diffère |
| Récapitulatif CI avec `run_smoke=0` | **corrigé** — vert uniquement si validation verte |
| `restaurants_maquis_T1` rendu | **oui**, 1 ligne de manifeste, `SUCCEEDED` |
| Prix groupé `25 000 FCFA` | **corrigé et vérifié** |
| Numéro de téléphone non coupé | **corrigé et vérifié** |
| Porte A (6 chaînes) | **3 sur 6 — non validée** |

## 2. Blocage restant — éditorial, pas technique

| Chaîne | Raison | Où corriger |
|---|---|---|
| `OFFRE D42 DIAGNOSTIC` | `restaurants_maquis_T1` n'affiche jamais `{nom_offre}` (présent seulement dans `copywriting`) | ajouter une scène portant `{nom_offre}` dans `data/src/main/assets/gabarits/restaurants_maquis/T1.json`, ou utiliser `T3`/`T4` |
| `CONTACTEZ-NOUS` | **0 gabarit sur 30** ne contient de libellé CTA | ajouter un champ CTA dans `gabarit_l10n_v1.json` + une scène qui l'affiche |
| `STOCK LIMITÉ` | la l10n dit `Stock limité` | décider de la casse produit ; ne pas contourner au rendu |

Ces trois points sont des **décisions éditoriales** sur 30 gabarits : elles
changent le contenu commercial produit, pas le moteur. À arbitrer avant toute
matrice.

## 3. Prochaine action exacte

```
Option A (préférée) : ajouter dans restaurants_maquis_T1 une scène
  « {nom_offre} » et un libellé CTA dans la l10n, puis rejouer la porte A.
Option B : valider la porte A sur restaurants_maquis_T3, qui affiche déjà
  {nom_offre}, en acceptant l'absence de CTA.
```

Une fois la porte A complète : portes B (en/es/ja) sur le même gabarit, puis
seulement la matrice.

## 4. Preuves

`preuves_d423/` : `manifeste_fr.jsonl` (1 ligne, SHA-256
`9a0d27ef…`), `frames_prix_badge.png`, `frame_contact.png`, `logcat_run3.txt`.

## 5. Ne pas refaire

- Ne pas re-suspecter la correction temporelle : elle est démontrée.
- Ne pas conclure depuis `mots_beat_sheet > 0` : lire `D42-SELECTION`.
- Ne pas injecter de texte après rendu pour « compléter » la porte A.
