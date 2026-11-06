# RAPPORT D42.14 — Qualification VITRINE VIDÉO

**Vendredi 6 novembre 2026, 14 h 20 UTC (15 h 20 Bénin)** · Échéance 7 nov. 10 h 00 · **NO-GO maintenu**

---

## 1. Ce qui a été produit depuis le dernier point (résultats, pas plan)

| Livrable | Résultat | Preuve |
|---|---|---|
| **Banc authentifié du Worker** | **18 / 18 PASS** | `artefacts/auth_report.json` |
| **Contrat HTTP non authentifié, 2ᵉ environnement** (bac à sable) | **15 / 15 PASS** | `artefacts/http_run_sandbox.txt` |
| **Cause exacte du blocage du brief** trouvée et corrigée | bouton exposé en **1 px** de haut → clic sur le bord de la fenêtre | `tools/e2e/ui.py` `point_de_clic()`, test **3/3** |
| **Paysage** : correction de la mesure | défilement avant verdict, vocabulaire PASS/FAIL intact | commit `38e1fe3` |
| **Signal CI** : absence de MP4 ≠ erreur d'infra | commit `2d63761` |
| **Matrice 120 régénérée** localement | 112 `OK` / 8 `RISQUE_TYPO` (fr 28/30, en 27/30, es 27/30, ja 30/30) | `artefacts/matrice_120_regenerree.csv` |
| **Banc authentifié exécutable en CI** | job `auth-local` ajouté au workflow | `.github/workflows/android-e2e-lab.yml` |

## 2. Le banc authentifié : comment c'est possible sans compte Firebase

Les 15 contrôles précédents ne prouvaient que le **rejet**. Aucune route métier n'avait
jamais été exécutée, parce que la JWKS Google est écrite en dur (`src/index.js:8-12`).

Solution retenue, **sans modifier une ligne du produit** :

1. le **Worker réel** est importé (`import worker from "../../src/index.js"`) ;
2. avant l'import, `globalThis.fetch` est intercepté : l'URL **exacte** de la JWKS Google
   reçoit une **JWKS locale** ; **toute autre sortie réseau est refusée** (compteur observé : **0**) ;
3. `jose` vérifie donc réellement signature, émetteur, audience, expiration ;
4. la base est une **vraie SQLite** (node:sqlite) avec les **12 migrations** appliquées,
   exposée par un adaptateur D1 minimal.

### Les 18 contrôles

| Domaine | Contrôles | Verdict |
|---|---|---|
| Migrations | 12 fichiers appliqués | **12/12** |
| Identité | bootstrap A, bootstrap B, `/me` valide, A ≠ B | **4/4** |
| Cryptographie | signature forgée (même `kid`), mauvaise audience, mauvais émetteur, jeton expiré | **4 × 401** |
| Crédits | dotation `{granted:true, credits_total:3}`, rejeu sans second crédit, nouvel appareil refusé (C16) | **3/3** |
| Facturation | `checkout` authentifié, plan réel `pass24h` → **501 `billing_not_configured`** | **1/1** |
| Quota | consommation `{ok:true}`, rejeu `{ok:true,dup:true}` sans débit | **2/2** |
| Isolation | B débitant l'appareil de A → **403** | **1/1** |
| Parrainage | auto-parrainage → **404 `code invalide`** | **1/1** |
| Réseau | aucune requête sortante | **1/1** |

**Statut : `PASS_LOCAL_HARNESS`.** Ce qui n'est **pas** prouvé : qu'un jeton émis par
**Google** pour l'application soit accepté (il faudrait un compte Firebase de test).
Le fournisseur d'identité est simulé ; **le serveur, la vérification JWT et la base sont réels**.

## 3. Pourquoi le brief ne se validait pas (cause exacte, enfin)

Le bouton `Continuer` du formulaire est exposé par Compose avec des bornes
**dégénérées** : `[455,2071][625,2072]` — **1 pixel de haut**, alors que le bouton réel
occupe `[44,1978][1036,2072]`. Le harnais tapait le centre de ces 1 px, c'est-à-dire le
**bord bas de la fenêtre** : l'appui ne faisait rien, **sans erreur**. D'où « bouton actionné
mais écran de validation absent ».

Correctif `point_de_clic()` (trois modes : `direct`, `surface`, `bas_large`), vérifié **hors
appareil** par `tools/e2e/test_ciblage.py` sur trois arbres uiautomator synthétiques reproduisant
les cas réels :

```
PASS texte dégénéré (1 px) -> surface du parent :: (540,2025) mode=surface
PASS bornes nulles -> dernier bouton pleine largeur :: (540,2025) mode=bas_large
PASS bornes franches -> centre direct :: (540,2046) mode=direct
CIBLAGE : 3/3 PASS
```

Le premier passage de ce test a d'ailleurs **échoué** (2/3) et révélé une régression :
mon premier jet héritait du rectangle de la racine et tapait au **milieu de l'écran**.
Corrigé avant livraison — c'est précisément l'intérêt d'un test exécutable.

## 4. Commits (locaux, prêts à pousser)

Branche `d42.13-lab`, clône `/home/user/lab` :

| Commit | Contenu |
|---|---|
| `38e1fe3` | paysage : défilement avant verdict |
| `2d63761` | CI : l'absence de MP4 redevient un résultat |
| `4b92808` | **banc authentifié 18/18** + job `auth-local` |
| `95c32f8` | checkpoints D42.14 mis à jour (état, défauts, verdict) |

## 5. Blocage de publication — et le contournement tenté

**Cause exacte** : `~/.d42_secrets/gh_token.txt` n'existe plus (le bac à sable a été
réinitialisé deux fois). Sans lui je ne peux **ni pousser**, **ni télécharger les artefacts**
(`/actions/artifacts/{id}/zip` → **401**, même sur dépôt public), **ni lire les logs de job**
(**403**).

**Contournements déjà appliqués** : re-clonage du miroir public (code récupéré), lecture de
l'état des runs par API anonyme (quota 60/h), dépouillement via les métadonnées d'artefacts,
vérifications hors appareil (`test_ciblage.py`), banc serveur local entièrement autonome.

**Ce qu'il reste à faire de votre côté (2 minutes)** : redéposer le fichier
`~/.d42_secrets/gh_token.txt`, **sans le coller dans la messagerie**. Dès qu'il est là :
push des 4 commits → run public → artefacts téléchargeables → brief/caméra/export relancés.

## 6. Ce qui reste impossible même avec le jeton

| Sujet | Cause |
|---|---|
| RC6 exécutée dans le laboratoire | Actions du dépôt privé non déclenchables par ce PAT (403), pas de KVM local |
| Caméra réelle | aucun téléphone au laboratoire |
| Google réel | aucun projet Firebase à nous |
| Export MP4 | dépend du parcours caméra |

→ protocole physique (12 min) : `09_PROTOCOLE_PHYSIQUE.md`.

## 7. Verdict

**NO-GO maintenu.** Ce qui a changé aujourd'hui : le **serveur** est désormais qualifié
au-delà du simple rejet (18 contrôles métier), le **paysage** est mesuré correctement, et la
**cause exacte** du blocage Android est identifiée et corrigée avec un test exécutable.
Ce qui n'a pas changé : **aucun parcours de la version signée n'a encore tourné sur un appareil**.
