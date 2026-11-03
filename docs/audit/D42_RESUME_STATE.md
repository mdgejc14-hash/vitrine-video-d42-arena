# D42.2 — État de reprise

> **Reprise : `cf26af5` (branche `audit-d41`).**
> **Blocage actuel : aucun identifiant GitHub disponible.**
> Ce fichier est conçu pour qu'un autre agent reprenne sans rien retrouver du
> bac à sable. Tout ce qui est nécessaire est soit sur GitHub, soit dans
> `/home/user/d422/`.

Dernière mise à jour : 2026-11-03 (nuit).

---

## 1. Où en est la mission

| Élément | Valeur |
|---|---|
| Branche de travail | `audit-d41` |
| Commit de référence | `cf26af5` (D42-P12) |
| Dépôt privé | `mdgejc14-hash/vitrine-video` — **privé**, `main` = `74edd98` |
| PR #2 | **ouverte, non fusionnée** |
| Miroir public | **non créé** |
| Paiement | `501 billing_not_configured` — inchangé |
| D42.1 | diagnostic racine **établi** (rapport livré) |
| D42.2 | correctif **écrit, non compilé** ; audit d'exposition **écrit, non exécuté** |

---

## 2. Ce qui bloque, précisément

| Blocage | Conséquence | Déblocage |
|---|---|---|
| **PAT absent** | aucun clone, aucun push, aucun dispatch | fournir un PAT neuf (l'ancien a été exposé en clair, à révoquer) |
| **Clone local perdu** | `.git` absent, modules vides dans `work/vv-d42` | re-cloner |
| **Budget Actions privé à −7 min** | plus aucune minute facturable | miroir public (runners gratuits illimités) |
| **49 MP4 sur 53 perdus** | preuves visuelles réduites à 9 planches | rejouer les portes après correctif |

---

## 3. Livrables prêts dans `/home/user/d422/`

| Fichier | Rôle | État |
|---|---|---|
| `scripts/scan-exposition.sh` | 33 motifs de secrets, refuse l'exposition | écrit, non exécuté |
| `scripts/creer-miroir.sh` | snapshot aplati + scan + push | écrit, non exécuté |
| `patches/KineticTypography.kt` | correctif du rendu commercial | écrit, **non compilé** |
| `patches/OverlayTextLayout_ajouts.kt` | 3 fonctions pures, testables JVM | écrit |
| `patches/OverlayTextLayoutTest_ajouts.kt` | 5 tests de non-régression | écrit |
| `patches/SentinelRenderInstrumentedTest.kt` | test de pixels sur MP4 réel | écrit |
| `patches/APPLIQUER.md` | procédure pas à pas + estimation de coût | écrit |
| `docs/D42_PUBLIC_EXPOSURE_REVIEW.md` | revue d'exposition | écrit, audit à exécuter |
| `docs/D42_RESUME_STATE.md` | ce fichier | — |

Preuves conservées hors dépôt : `/home/user/preuves_d421/` (9 planches,
3 MP4 de générations différentes, fixture sentinelle, 120 manifestes,
40 mesures audio). **Ces preuves ne sont pas dans Git** : elles doivent être
publiées comme artefacts Actions au prochain run, pas commitées.

---

## 4. Diagnostic D42.1 — rappel de la cause racine

`KineticTypography` est passé de `TextOverlay` (taille indépendante du bitmap) à
`BitmapOverlay` + `StaticOverlaySettings` **sans échelle**. Preuve visuelle sur
trois générations du même moteur :

| Échantillon | Génération | Texte observé |
|---|---|---|
| `d42_art4` (7,04 s) | avant D42 | « Un nouveau plat chez », « À DÉCOUVRIR », « LES INGRÉDIENTS » — lisible |
| `d42_art7` (35,04 s) | milieu D42 | « n nouveau plat chez Chez Chant » — timbre-poste, tronqué |
| 9 planches + 40 MP4 | après D42 | **aucun texte** |

---

## 5. Prochaine action exacte

```
1. Fournir un PAT (droits : repo).
2. git clone https://github.com/mdgejc14-hash/vitrine-video.git ~/work/vv-d42
   cd ~/work/vv-d42 && git checkout audit-d41 && git rev-parse --short HEAD   # cf26af5
3. bash ~/d422/scripts/scan-exposition.sh ~/work/vv-d42
   → lire la sortie EN ENTIER (revue manuelle)
4. Appliquer d422/patches/APPLIQUER.md, étapes 1 à 3.
5. ./gradlew :ins-effects:testDebugUnitTest --tests "*OverlayTextLayoutTest*"
   → les tests de hauteur DOIVENT échouer avant correctif, passer après.
6. Bash ~/d422/scripts/creer-miroir.sh ~/work/vv-d42 cf26af5 <compte> vitrine-video-d42-arena
7. Sur le miroir : dispatch unique, 2 rendus FR (≈ 12 min).
8. Inspecter 6 frames. PORTE A franchie ou retour au diagnostic.
```

---

## 6. Coût mesuré (D42, pour dimensionner D42.2)

| Poste | Mesure |
|---|---|
| Rendu validation 540×960 | 220 s |
| Rendu production 1080×1920 | 758 s |
| Boot émulateur (KVM réel) | 63 s |
| Chaîne fixe (checkout + install + collecte) | ≈ 5 min |
| Compilation APK + tests | ≈ 5 min |
| Total D42 consommé | 905 min |

Sur miroir public : ces durées ne sont pas décomptées du quota privé, mais les
limites de concurrence (20 jobs) et de durée (6 h/job) restent.

---

## 7. Règles de continuité (à respecter sans exception)

1. **Pousser avant de continuer** : aucun lot de travail de plus d'une heure ne
   doit vivre uniquement dans le bac à sable. C'est exactement ce qui a coûté la
   perte du code D42.
2. **Ne jamais stocker de MP4 dans Git** : artefacts Actions uniquement.
3. **Le dépôt privé reste canonique** : le miroir ne reçoit jamais de commit
   direct qui ne serait pas transféré ensuite.
4. **Aucune matrice** tant que la porte A n'est pas franchie visuellement.
5. **Aucun secret** dans un commit, un artefact, un log ou une réponse.
