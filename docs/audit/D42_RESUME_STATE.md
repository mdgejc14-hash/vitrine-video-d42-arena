# D42.2 — État de reprise

**Branche privée :** `d42.2` (tête `fe3200c`)
**Miroir public :** `mdgejc14-hash/vitrine-video-d42-arena` (tête `57fc62f`)
**Référence canonique :** `audit-d41` @ `cf26af5` · PR #2 ouverte, non fusionnée
**`main` :** `74edd98` — intacte

---

## 1. Acquis de cette session

| Élément | État |
|---|---|
| Cause racine du texte absent | **établie et corrigée** : rebasage des mots sur le plan |
| Texte visible dans le MP4 | **oui**, 100 % des frames (run 41714843343) |
| Porte A | **partielle** — prix et nom visibles, 3 chaînes sur 5 non observées |
| Miroir public | créé, 0 secret, historique aplati |
| Traçabilité 10 maillons | 3 points instrumentés (`D42-TRACE`) |
| Budget privé consommé | **0 minute** |

## 2. Blocage immédiat

L'entrée `templates` du workflow `virtual-render-validation.yml` **n'est pas
honorée** : les rendus sortent en `batiment_travaux_T1/T2` quel que soit le
gabarit demandé. Tant que ce point n'est pas réglé, les scènes « offre /
localisation / badge » ne sont jamais rendues et la porte A ne peut pas être
complétée.

## 3. Prochaine action exacte

```
1. Lire .github/scripts/d42-render.sh : voir comment `templates` est transmis
   à l'instrumentation (-e d42_templates ...). Corriger le passage.
2. Dispatch unique : templates=restaurants_maquis_T1, langs=fr,
   langs_lot=fr, profils=validation, shards=1, shards_json=[1], limite=1,
   run_smoke=0.  (~11 min)
3. Extraire 6 frames, vérifier les 5 chaînes de la porte A.
```

## 4. Ce qui ne doit pas être refait

- Ne pas relancer la sonde : elle a rempli son rôle (preuve que les overlays
  sont composés).
- Ne pas re-suspecter `setScale` : le run 7 avait déjà le bitmap plein cadre et
  le texte apparaissait — le défaut était temporel.
- Ne pas échantillonner les frames à 2, 6, 10 s : un défaut confiné au début de
  la vidéo est invisible à ces instants. Analyser à 4 im/s sur toute la durée.
- Ne pas conclure depuis `mots_beat_sheet > 0` : ce compteur est recalculé par
  le test, pas lu dans le worker.

## 5. Reprise si le bac à sable est restauré

```
git clone https://github.com/mdgejc14-hash/vitrine-video.git ~/work/vv-d42
cd ~/work/vv-d42 && git checkout d42.2 && git rev-parse --short HEAD   # fe3200c
```
Le miroir se reconstruit avec `docs/audit/d42_2_scripts/creer-miroir.sh`.
