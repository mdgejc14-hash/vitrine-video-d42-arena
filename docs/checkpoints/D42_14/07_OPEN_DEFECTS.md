# D42.14 — Défauts ouverts

Classement : **P0** = empêche un parcours critique · **P1** = gêne réelle · **P2** = cosmétique ou hypothèse.
Aucun défaut n'est fermé sans preuve, aucun ne l'est sur la foi de « ça compile ».

## P0 — bloquent la livraison

| # | Défaut | Statut | Preuve / cause exacte |
|---|---|---|---|
| D1 | **La RC6 n'a jamais été exécutée** dans le laboratoire | **OUVERT** | 9 tentatives documentées (`01_RELEASE_TESTS.md` §3) : 403 Actions sur le dépôt privé, pas de KVM local, artefacts publics inaccessibles sans jeton (401) |
| D2 | **Caméra réelle jamais testée** | **OUVERT** | seuls des tournages sur caméra émulée (`-camera-back emulated`) |
| D3 | **Connexion Google réelle** non exécutée | **OUVERT** | ni `google-services.json`, ni compte de test |
| D4 | **Routes authentifiées du Worker** | **LEVÉ (banc)** | `auth_harness.mjs` **22/22** + suite de sécurité **64/64** en local ; reste ouvert : jeton **Google réel** (`PASS_PROD`) |
| D5 | **Brief → caméra → export** non abouti | **CAUSE TROUVÉE, CORRECTIF PRÊT** | le bouton `Continuer` est exposé par Compose dans **1 px de haut** (`[455,2071][625,2072]`) : `tap` visait le bord de la fenêtre. Corrigé par `point_de_clic()` (`mode=surface`), vérifié hors appareil par `test_ciblage.py` **3/3** |

## P1 — gêne réelle, correctif prêt

| # | Défaut | Statut | Détail |
|---|---|---|---|
| D6 (F) | **Paysage** : `S03b` / `S04b` déclarés hors écran | **CORRIGÉ côté mesure** (commits `38e1fe3`) | les écrans défilent ; le test ne défilait pas avant de juger (`10_PAYSAGE.md`) |
| D7 | **Paysage** : `S12_selection_secteur`, `S17_catalogue` échouent en `rot90` | **OUVERT** | captures inaccessibles sans jeton ; hypothèse = verdict pris avant changement d'écran |
| D8 | Paysage peu confortable (en-tête 88 dp + 4 cartes ne tiennent pas en 1080 px) | **OUVERT** | piste `values-land` (logo réduit) — non appliquée : elle exige un build + test que je ne peux pas lancer aujourd'hui |
| D9 | **Bouton `Continuer` du brief grisé sans dire ce qui manque** | **OUVERT** (produit) | « Quartier et ville » est hors écran ; Nielsen #1. Piste : libellé dynamique « Il reste 1 champ : Quartier et ville » |
| D10 | `release-e2e.yml` n'a **jamais tourné** | **OUVERT** | aucun commit du runner dans la branche après 3 push |

## P2 — cosmétique / hypothèse

| # | Défaut | Statut |
|---|---|---|
| D11 | 8 combinaisons **T2** au-delà de 20 em (fr 2, en 3, es 3) | **OUVERT** — 3 rendus ciblés suffiraient |
| D12 | **Auto-parrainage** accepté par la base (garde seulement applicative, `src/index.js:2478`) | **OUVERT** — défense en profondeur absente |
| D13 | Déconnexion / reconnexion non exposées dans le parcours | **NOT_RUN** |
| D14 | Lenteur de transition (35–40 s) sur émulateur **froid** | **DOCUMENTÉ, pas un défaut produit** — aucune mesure sur téléphone réel |

## Ce qui n'est PAS un défaut (ne pas « corriger »)

- **L'application suit la langue du système** au premier lancement : comportement voulu, la langue reste modifiable.
- **`501 billing_not_configured`** sur la facturation : état exigé tant que SKYPAY n'a pas d'identifiants.
- **Le repli « sans compte »** : il fonctionne réellement (mode hors ligne), il est seulement **déclaré** comme tel à l'écran.
- **Le carrousel lent au premier lancement** : compilation à froid de l'émulateur.

### Défauts du HARNAIS trouvés et fermés ce tour

| # | Défaut | Preuve | État |
|---|---|---|---|
| H1 | mode `surface` **mort** (ElementTree compare par identité : cible d'un dump, parents d'un autre) ⇒ repli systématique sur `bas_large`, qui désigne la **barre de navigation** | S6 de `selftest_harness.py` | **CORRIGÉ** |
| H2 | `surface_reelle()` pouvait renvoyer la **fenêtre entière** ⇒ tap au milieu de l'écran (540,1170) | S1 | **CORRIGÉ** |
| H3 | dernière ligne du `script:` CI : `[ -s ] && ffprobe` ⇒ job rouge sans MP4, signal brouillé | run 42228009767, exit 2 | **CORRIGÉ** (`2d63761`) |
| H4 | `T=$(cat …) curl …` : variable non définie pour la suite | — | **CORRIGÉ** (`tools/gh_api.sh`) |

Ces quatre défauts sont des défauts de **mesure**, pas de produit. Les fermer ne valide
aucun parcours : cela garantit seulement que le prochain run dira la vérité.

### Défauts fermés ce tour (suite sécurité)

| # | Défaut | Résolution |
|---|---|---|
| D8 | `security-ci.mjs` **BLOCKED** (5 secrets Firebase) — 64 contrôles jamais exécutés | **LEVÉ** : pont local + IdP local ⇒ **64/64 PASS** (`PASS_LOCAL_HARNESS`) |
| D9 | Contrôle BGM obsolète : attendait `synthese_procedurale_v1`, la base livrée contient `v2` (générateur `finalize_audio_v2.py`) | attente alignée sur **v2**, documentée dans le code et ici — la base était conforme, le test était en retard |
| H5 | Adaptateur D1 : `batch()` sans `meta.changes` ⇒ 503 `transition_race_or_event_write_failed` | métadonnées fournies (`__executer`) |
| H6 | `caches` non défini sous Node ⇒ 500 sur `/api/v1/audio/track` | shim mémoire dans le pont |

### Nouveau défaut applicatif découvert et corrigé (D42.14, 6 nov. 16 h)

| # | Défaut | Preuve | État |
|---|---|---|---|
| **A1** | **Double lancement des écrans d'orchestration** (`MainActivity`) : Language ×2 (637 ms), Auth ×2 (32 ms), Onboarding ×2 (12 ms). L'instance périmée restée sur la pile fait réapparaître un carrousel vierge après le `finish()` de l'instance pilotée → **catalogue jamais atteint** (intermittent, ~1 run sur 3) | logcat du run 42241430727 (P1, échec, doublons) **vs** run P0 réussi du même commit (**aucun doublon**) — cause Racine : recréation/course au lancement | **CORRIGÉ** (`c588993`) : lancements initiaux seulement à la création (`savedInstanceState == null`) + garde `lancerUneSeuleFois()` (1 s) sur la chaîne automatique — les retours utilisateur (`stepBack`) gardent leurs lancements directs |

**Chronologie de la découverte** : le harnais corrigé (`point_de_clic`) a d'abord fait PASSER
`P1_activite_continue` (le bouton 1 px est désormais actionné — **preuve en émulateur réel**),
14 PASS record, puis l'échec s'est DÉPLACÉ au catalogue. Le diagnostic par logcat (désormais
téléchargeable avec le jeton) a montré le doublon d'activités — invisible avant, parce que le
harnais tapait à côté et masquait le symptôme. **Correction d'instrument puis découverte de
défaut produit : c'est l'enchaînement attendu d'un harnais qui dit la vérité.**

### Incidents CI corrigés ce tour (chaîne de preuve des rendus)

| # | Incident | Correctif |
|---|---|---|
| C1 | `qemu-system` ne démarrait plus : `libpulse.so.0` absente de l'image `ubuntu-22.04` (run 42242981946, aucun rendu) | `apt-get install libpulse0` avant lancement (3 jobs concernés) — **vérifié : l'émulateur bootte** (run 42245217052) |
| C2 | Smoke : `Error: Invalid userId -2` dès `am instrument` — seul appel **sans** shard (args `-e` vides) alors que les lots shardés passaient | args vides omis + shard explicite `0/1` dans l'appel smoke (`426dfee`) — **en cours de validation** |
| C3 | Workflows de rendu jamais déclenchables : `workflow_dispatch` interdit au PAT (403 mesuré) et `on.push` volontairement sans émulateur (D42-BUDGET) | exception étroite documentée sur la branche **jetable** `d42-render-check` |

### Défauts du harnais (suite) — causes racines closes ce tour

| # | Défaut | Impact mesuré | Correctif |
|---|---|---|---|
| H7 | `remplir_champ` : awk sur `E2E FIELD` alors que `ui.py champs` émet `E2E CHAMP` | **aucune saisie n'a jamais eu lieu** — validation du brief en échec dans TOUS les runs ; les « valeurs » des dumps étaient des placeholders | `88e364e` (miroir) + `0c7a9f9` (privé) |
| H8 | le contrôle négatif « prix invalide » laissait « abc » dans le champ (le remplissage valide ne traite que les champs vides) | `P1_brief_valide` FAIL au run 42246994818 | `918feaa` : le champ est vidé après le contrôle |
| H9 | autotest insensible au adb du runner (`ANDROID_SDK_ROOT` non neutralisé) | `harness-selftest` 3/6 en CI (4 pseudo-PASS) | `94d8f9e` : les deux variables neutralisées + contrôle S0 — **7/7 en CI** |

### Défaut applicatif P1-critique découvert au run 42257226019 (88e364e) — corrigé

| # | Défaut | Preuve | État |
|---|---|---|---|
| **A2** | **Crash caméra** : `QualitySelector.from(UHD/FHD)` **sans stratégie de repli** → `IllegalArgumentException: Unable to find selected quality` à `InsCameraBinder.kt:68` → **FATAL EXCEPTION** dès l'écran de tournage. Touchait tout capteur sans FHD/UHD : émulateur de CI **et téléphones d'entrée de gamme** (cible du produit) | `crash.log` du run 42257226019 (première fois que le parcours atteignait la caméra : le crash était masqué depuis l'origine par l'échec de validation du brief) | **CORRIGÉ** (`56676df` miroir, `769c828` privé) : `QualitySelector.from(qualité, fallbackStrategyOf(Quality.LOWEST))` |

**Enchaînement des causes ce tour** (chaque correction a dévoilé la suivante — comportement
attendu d'un harnais qui dit la vérité) :
ciblage 1 px → catalogue atteint → doublon d'activités (A1) corrigé → catalogue vert →
saisie jamais effectuée (H7 : FIELD/CHAMP) corrigée → **brief validé pour la première
fois** → crash caméra (A2) corrigé → le parcours peut enfin atteindre prises/export.
