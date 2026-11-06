# D42.14 — Défauts ouverts

Classement : **P0** = empêche un parcours critique · **P1** = gêne réelle · **P2** = cosmétique ou hypothèse.
Aucun défaut n'est fermé sans preuve, aucun ne l'est sur la foi de « ça compile ».

## P0 — bloquent la livraison

| # | Défaut | Statut | Preuve / cause exacte |
|---|---|---|---|
| D1 | **La RC6 n'a jamais été exécutée** dans le laboratoire | **OUVERT** | 9 tentatives documentées (`01_RELEASE_TESTS.md` §3) : 403 Actions sur le dépôt privé, pas de KVM local, artefacts publics inaccessibles sans jeton (401) |
| D2 | **Caméra réelle jamais testée** | **OUVERT** | seuls des tournages sur caméra émulée (`-camera-back emulated`) |
| D3 | **Connexion Google réelle** non exécutée | **OUVERT** | ni `google-services.json`, ni compte de test |
| D4 | **Routes authentifiées du Worker** | **PARTIELLEMENT LEVÉ** | banc local **18/18** (`tools/e2e/auth_harness.mjs`) ; reste ouvert : jeton Google réel |
| D5 | **Brief → caméra → export** non abouti | **CAUSE TROUVÉE, CORRECTIF PRÊT** | le bouton `Continuer` est exposé par Compose dans **1 px de haut** (`[455,2071][625,2072]`) : `tap` visait le bord de la fenêtre. Corrigé par `point_de_clic()` (`mode=surface`), vérifié hors appareil par `test_ciblage.py` **3/3** |

## P1 — gêne réelle, correctif prêt

| # | Défaut | Statut | Détail |
|---|---|---|---|
| D6 | **Paysage** : `S03b` / `S04b` déclarés hors écran | **CORRIGÉ côté mesure** (commits `38e1fe3`) | les écrans défilent ; le test ne défilait pas avant de juger (`10_PAYSAGE.md`) |
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
