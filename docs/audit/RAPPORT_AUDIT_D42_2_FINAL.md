# RAPPORT D42.2 — MIROIR PUBLIC, PERSISTANCE ET RENDU COMMERCIAL

> **Statut : MISSION PRÉPARÉE, NON EXÉCUTÉE. Aucune porte franchie.**
> Blocage unique et total : **aucun identifiant GitHub disponible**. Le PAT
> fourni le 03/11 a été exposé en clair puis retiré avec la restauration du bac
> à sable ; il doit être révoqué. Sans lui : pas de clone, pas de miroir, pas de
> push, pas de dispatch.
>
> Ce rapport distingue strictement ce qui est **fait**, ce qui est **écrit mais
> non vérifié**, et ce qui est **impossible en l'état**.

---

## 1. État réel

| Livrable demandé | État |
|---|---|
| `docs/audit/D42_PUBLIC_EXPOSURE_REVIEW.md` | **écrit** — audit non exécuté (§8 du document) |
| `docs/audit/D42_RESUME_STATE.md` | **écrit** — prêt pour reprise par un autre agent |
| `docs/audit/RAPPORT_AUDIT_D42_2_FINAL.md` | **ce document** |
| Tests de non-régression | **écrits** (5 tests JVM + 1 test instrumenté de pixels) |
| Correctif `KineticTypography` | **écrit, non compilé, non exécuté** |
| MP4 sentinelle | **fixtures prêtes** ; MP4 non produit |
| Rapports FFprobe | **non produits** (aucun MP4 neuf) |
| Captures visuelles | **9 planches** de D42 conservées, aucune nouvelle |
| Artefacts workflows | **aucun** (aucun run) |
| Correspondance commits miroir/privé | **non applicable** (miroir non créé) |
| Preuves de restauration du dépôt privé | voir §6 |
| Rapport de fermeture du miroir | **non applicable** |

---

## 2. Décision de publication : non appliquée, et pourquoi c'est correct

L'ordre autorise une exposition publique temporaire. **Je ne l'ai pas
appliquée**, pour deux raisons indépendantes de ma volonté :

1. **Aucun identifiant** : la création d'un dépôt public exige un PAT. Il n'y en
   a pas.
2. **Aucun arbre à inspecter** : le clone de travail a été perdu. Publier sans
   avoir passé les 33 motifs de contrôle sur les fichiers réels aurait été
   exactement la faute que D42.2 interdit.

Résultat : **à cet instant, zéro octet du dépôt privé est public.** C'est l'état
le plus sûr possible compte tenu du blocage.

---

## 3. Le correctif du rendu commercial

### 3.1 Ce qui change

`KineticTypography` passe d'un bitmap à la taille du texte (dont l'échelle
dépend d'une sémantique Media3 non garantie) à un **bitmap plein cadre** sur
lequel le texte est dessiné à sa position exacte.

| Propriété | Avant (D42) | Après (D42.2) |
|---|---|---|
| Taille du bitmap | largeur du texte × hauteur de ligne | **largeur × hauteur de sortie** |
| Échelle | par défaut, dépendante du bitmap | **1, superposable au cadre** |
| Position | `setBackgroundFrameAnchor` (NDC) | texte **dessiné** dans le bitmap |
| Sensibilité à `Presentation` | forte (régression constatée) | **nulle** |
| Mémoire | un bitmap par mot, jamais libéré | cache à **une entrée**, 8 Mo, libéré en fin d'export |

### 3.2 Pourquoi cette approche plutôt qu'un `setScale` calculé

La documentation de `OverlaySettings.scale` ne garantit pas si l'échelle est
relative au bitmap ou au cadre. Sans appareil pour trancher, choisir l'une des
deux interprétations revient à rejouer le pari qui a échoué. Un bitmap plein
cadre est correct **dans les deux cas** — c'est un invariant, pas une hypothèse.

### 3.3 Ce qui n'a pas été fait, et ne doit pas être affirmé

- Le correctif **n'a jamais été compilé**. Une erreur de signature Media3 est
  possible, notamment sur `getBitmap(presentationTimeUs)`.
- Les 5 tests JVM **n'ont jamais tourné**, ni avant ni après.
- Aucun MP4 sentinelle n'existe.
- La liste des données injectées (`OFFRE D42 DIAGNOSTIC`, `25 000 FCFA`,
  `COTONOU`, `STOCK LIMITÉ`, `CONTACTEZ-NOUS`) est écrite dans le test, pas
  vérifiée à l'écran.

---

## 4. Fixtures sentinelles — produites et vérifiées

Trois vidéos de 12 s, 720×1280, 30 im/s, H.264 High, AAC 48 kHz mono, **85 kb/s**,
**sans aucun texte incrusté**. Chacune porte deux marqueurs géométriques
contrastés (carré fixe en haut à gauche, carré mobile en bas) et un fond uni
distinct (vert foncé / violet / brun).

Vérification faite : extraction d'une frame → fond uni + deux rectangles, aucun
glyphe. C'est ce qui manquait au jeu précédent, dont le « PRISE 1 » rendait la
lecture ambiguë.

Elles sont dans `d422/patches/` (à copier vers
`app/src/androidTest/assets/d42/sentinelle/`) et dans `preuves_d421/d421_fixtures/`.

---

## 5. Persistance — la leçon appliquée

La perte du code D42 (plusieurs heures de travail, 32 commits, un rapport) lors
de la restauration du bac à sable est la conséquence directe d'un travail resté
en local. La règle D42.2 — pousser avant de continuer — est donc inscrite en
tête du fichier de reprise, avec la liste de ce qui doit être poussé et quand.

Conséquence immédiate : **les 4 fichiers de `d422/patches/` et les 3 documents
ne sont pas versionnés.** Ils vivent dans `/home/user/d422/` et disparaîtront à
la prochaine restauration. C'est précisément le risque que la nouvelle règle
interdit — mais il ne peut être levé sans identifiant.

**Action prioritaire dès réception d'un PAT : pousser `d422/` en premier**, sur
une branche `d42.2`, avant toute autre manipulation.

---

## 6. Sécurité — état vérifié

| Contrôle | État |
|---|---|
| Dépôt principal privé | **oui** (404 sans authentification, dernier état vérifié) |
| `main` inchangée | `74edd98` |
| PR #2 | ouverte, `merged: false` |
| Paiement | `501 billing_not_configured` |
| Clé de paiement | **aucune** ajoutée |
| Déploiement | **aucun** |
| Migration D1 | **aucune** |
| Secret dans un commit | **aucun** (aucun commit n'a été fait) |
| Secret dans une réponse | **aucun** |

---

## 7. Coût

| Période | Minutes |
|---|---|
| D42 (03/11) | 905 min |
| D42.1 | **0 min** |
| D42.2 | **0 min** |
| Reste sur le quota privé | **−7 min** (dépassement) |

Aucune ressource n'a été consommée depuis l'arrêt d'urgence. Le miroir public
n'existant pas, ses minutes gratuites sont théoriques à ce stade.

---

## 8. Prochaine action exacte

**Une seule question bloque tout : fournir un PAT.**

Dès réception :

```
1. pousser /home/user/d422/ sur une branche d42.2  (persistance d'abord)
2. cloner le dépôt, vérifier cf26af5
3. scan-exposition.sh → revue manuelle → verdict
4. créer le miroir public (creer-miroir.sh)
5. appliquer le correctif, faire échouer puis passer les tests
6. un dispatch : 2 rendus FR sur le miroir (≈ 12 min)
7. inspecter 6 frames → PORTE A
```

Budget pour franchir A+B une fois débloqué : **≈ 45 min**, sur runners publics.

---

## 9. Ce que ce rapport ne prétend pas

- D42 n'est **pas** terminée.
- D41 n'est **pas** modifiée.
- Aucune porte A–E n'est franchie.
- Le correctif n'est **pas** validé : il est **écrit**.
- Le miroir public n'existe **pas**.
- Aucun MP4 commercial n'a été produit depuis le diagnostic.

La seule chose acquise dans cette unité de travail est un **diagnostic racine
prouvé** et un **correctif prêt à être éprouvé** — ce qui est exactement ce que
la mission demandait avant de relancer quoi que ce soit.
