# D42.14 — Autotest du harnais (6/6) et vérité du run 42228009767

## 1. Run 42228009767 — statut exact, relevé à 14 h 2x UTC (API anonyme)

| Champ | Valeur |
|---|---|
| Statut | `completed` |
| Conclusion | **`failure`** |
| commit | `554cb90` · branche `d42.13-lab` · événement `push` |
| Créé → terminé | 13:45:02Z → **14:05:11Z** (20 min 09 s) |
| Tentative | 1 |

### Conclusion par job

| Job | Conclusion | Durée | Étape fautive |
|---|---|---|---|
| `backend-http` | **success** | 26 s | — |
| `android-e2e` | **success** | 19 min 09 s | — |
| `android-e2e-langues (en)` | **success** | 7 min 46 s | — |
| `android-e2e-langues (es)` | **success** | 6 min 01 s | — |
| `android-e2e-langues (ja)` | **success** | 5 min 25 s | — |
| `android-e2e-p1` | **failure** | 20 min 06 s | **étape 8 — `P1 catalogue -> export (caméra émulée)`** |

Étapes du job P1 : ① setup ✔ ② checkout ✔ ③ java ✔ ④ gradle ✔ ⑤ APK debug ✔
⑥ ffprobe ✔ ⑦ KVM ✔ ⑧ **P1 ✘** ⑨ artefacts ✔ + 4 étapes de nettoyage ✔.
Annotation GitHub : *« The process `/usr/bin/sh` failed with exit code 2 »*.

**Aucun job en cours, aucun job bloqué.** Le seul échec est le parcours caméra.

### Artefacts (7, tous disponibles, non expirés)

| Nom | Taille |
|---|---|
| `e2e-petit-ecran` | 11 305 327 o |
| `e2e-pixel5` | 7 484 594 o |
| `e2e-langue-ja` | 2 044 351 o |
| `e2e-langue-en` | 1 966 711 o |
| `e2e-langue-es` | 1 869 784 o |
| `e2e-p1` | 1 345 797 o |
| `backend-http` | 1 516 o |

**Téléchargement impossible sans jeton** : `GET /actions/artifacts/{id}/zip` → **401**,
`GET /actions/jobs/{id}/logs` → **403** (vérifié de nouveau aujourd'hui, même sur dépôt
public). Les métadonnées, elles, sont lisibles anonymement — c'est ce qui alimente les
tableaux ci-dessus.

**Cause de l'échec côté script** : la dernière ligne du bloc `script:` du run était
`[ -s "$f" ] && ffprobe … | tee …`. Sans MP4 produit, cette liste renvoie un code non nul
et le shell du runner (`sh -e`) fait échouer l'étape — donc le job — **alors que le harnais
avait tout mesuré et consigné**. Corrigé dans `2d63761` (branche `if/else` + `true` final) :
l'absence de MP4 redevient un **résultat**, plus une panne d'infrastructure.

## 2. Deux défauts du harnais trouvés et corrigés aujourd'hui

Le point commun des quatre runs en échec est le même écran (brief/caméra). Rien ne
distinguait « l'application ne répond pas » de « le harnais tape à côté ». D'où
`tools/e2e/selftest_harness.py` : un **faux `adb`** (placé en tête de `PATH`) sert des
arbres UIAutomator préparés, et le **vrai `ui.py`** est exécuté dessus. Aucun appareil,
aucun émulateur, 10 secondes.

### Défaut A — le mode `surface` était mort

`cmd_tap` appelait `_wait()` (dump n° 1), puis refaisait un `dump_nodes()` (dump n° 2).
Les `Element` d'ElementTree se comparent **par identité** : la cible venait du dump n° 1,
la table des parents du dump n° 2. `surface_reelle()` ne trouvait donc **jamais** d'ancêtre
et retombait sur `bas_large`.

Conséquence mesurée : sur l'écran du brief, `bas_large` choisit le **dernier** élément
cliquable pleine largeur — c'est-à-dire **la barre de navigation**, pas le bouton
`Continuer`. Le correctif du matin aurait donc échoué à nouveau au run suivant, pour une
raison différente et invisible.

**Correction** : la cible est ré-ancrée dans le dump courant avant le calcul du point.

### Défaut B — `surface_reelle()` pouvait renvoyer la fenêtre entière

Le premier candidat ≥ 48×48 était retenu sans regarder s'il était cliquable ni s'il
s'agissait de la racine. Sur un texte de 1 px dont l'ancêtre immédiat est la racine, le
point calculé était **(540, 1170) — le milieu de l'écran** : exactement le symptôme du run
42223776656, reproduit en une seconde.

**Correction** : priorité aux conteneurs `clickable="true"`, exclusion de tout rectangle
couvrant ≥ 95 % × 90 % de la fenêtre, et à défaut le **plus petit** conteneur exploitable.

### Résultats de l'autotest

```
PASS S1 bouton 1 px : tap au centre de la surface réelle :: code=0 taps=TAP 540 2025
PASS S2 libellé absent : wait échoue (pas de faux vert) :: code=1
PASS S3 caméra muette : l'absence de bascule est DÉTECTÉE :: code=1
PASS S4 bouton absent : tap échoue, aucun tap émis :: code=1 taps=(aucun)
PASS S5 contre-épreuve : le bouton présent EST tapé :: code=0 taps=TAP 540 2000
PASS S6 barre de navigation : le bouton d'action reste la cible :: code=0 taps=TAP 540 2025
AUTOTEST HARNAIS : 6/6 PASS
```

`S5` est la contre-épreuve : sans elle, un harnais qui échoue toujours passerait S2–S4.
`S6` est le piège réel de la barre de navigation.

L'autotest a **échoué deux fois avant d'être bon** (4/5 puis 4/6) : les deux échecs
correspondaient à un défaut réel, pas à un test mal écrit. C'est la démonstration que
le banc sait dire non.

**Statut : `PASS_HARNESS_SELFTEST`.** Ce n'est ni un test de l'application ni un test
d'appareil : c'est la preuve que l'instrument de mesure distingue le succès de l'échec.

## 3. Gestion du jeton dans le shell — corrigé

`T=$(cat …) curl …` ne définit **pas** `T` pour la suite : l'affectation ne vaut que pour
l'environnement de la commande qu'elle préfixe. `tools/gh_api.sh` applique désormais le
bon schéma :

1. affectation **seule, sur sa propre ligne** ;
2. test de non-vacuité **avant** l'appel ;
3. jeton transmis par en-tête, **jamais affiché, jamais écrit sur disque, jamais dans un log** ;
4. `unset TOKEN` dès l'appel terminé.

Vérifié : sans fichier, le script sort en **code 3** sans émettre de requête authentifiée.

## 4. Ce que cela change pour la suite

| Avant | Après |
|---|---|
| « le brief ne passe pas » | deux causes mécaniques du harnais identifiées, corrigées, testées |
| échec du job = panne d'infra | échec du job = résultat du parcours |
| mode `surface` supposé actif | prouvé actif (S1, S6) |
| aucune preuve que le harnais sait échouer | **6/6**, dont 2 contre-épreuves |
