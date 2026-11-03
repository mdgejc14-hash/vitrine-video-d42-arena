# D42.2 — REVUE D'EXPOSITION PUBLIQUE

> **Statut : PROCÉDURE PRÊTE, AUDIT NON EXÉCUTÉ.**
> L'audit porte sur un arbre source qui n'est pas disponible : le clone de
> travail a été perdu (restauration du bac à sable, `.git` absent) et l'accès au
> dépôt privé exige un PAT qui a été retiré. Aucun fichier n'a donc pu être
> inspecté, et **aucune exposition publique n'a été réalisée**.
>
> Ce document contient : ce qui a été contrôlé malgré tout, le contrôleur
> automatique écrit pour l'occasion, les décisions d'architecture retenues, et
> les risques résiduels. Il devra être complété par la sortie réelle du
> contrôleur avant toute publication.

---

## 1. État réel au moment de la rédaction

| Élément | État |
|---|---|
| Dépôt privé `mdgejc14-hash/vitrine-video` | **privé**, intact, `main` = `74edd98` |
| PR #2 | ouverte, non fusionnée (dernier état vérifié : tête `cf26af5`) |
| Accès API | **impossible** — PAT absent de l'environnement |
| Clone local | **perdu** (`.git` absent, modules vides) |
| Miroir public | **non créé** |
| Secrets exposés | **aucun** (rien n'a été publié) |

**Conclusion immédiate : la décision de publier n'a produit aucune exposition à
ce stade.** C'est l'état le plus sûr possible.

---

## 2. Contrôles prévus — et l'outil qui les exécute

Le contrôleur `d422/scripts/scan-exposition.sh` refuse l'exposition sur quatre
familles de défauts. Il masque les correspondances : aucun secret n'apparaît en
clair dans sa sortie, qui est destinée à être lue et archivée.

### 2.1 Fichiers interdits par leur nom (17 motifs)

| Catégorie | Motifs |
|---|---|
| Clés de signature | `*.keystore`, `*.jks`, `*.p12`, `*.pfx` |
| Clés cryptographiques | `*.pem`, `*.key`, `id_rsa*`, `id_ed25519*` |
| Configuration secrète | `.env`, `.env.*`, `.dev.vars`, `.dev.vars.*`, `.netrc`, `.git-credentials` |
| Sauvegardes de mots de passe | `*.kdbx` |
| Identité Firebase | `google-services.json`, `GoogleService-Info.plist` |
| Stockage objet | `b2_keys.json`, `.b2_keys.json`, `*secret*.json` |

### 2.2 Motifs de secrets dans le contenu (16 expressions)

PAT GitHub (`ghp_`, `github_pat_`), jeton OAuth (`gho_`), clé Google API
(`AIza…`), clé AWS (`AKIA…`), bloc `PRIVATE KEY`, Stripe live et test, CinetPay,
FedaPay, `applicationKey` Backblaze, identifiants Cloudflare, affectation de mot
de passe en clair, URL `*.workers.dev`, adresses e-mail réelles, numéros
béninois `+229` à 8 chiffres.

### 2.3 Configurations locales et artefacts

`local.properties`, `*.log`, `logcat*.txt`, `*.mp4`, `*.wav`, `*.m4a`, `*.apk`,
`*.zip` — retirés du snapshot : les médias volumineux appartiennent aux
artefacts Actions, pas à Git.

### 2.4 Historique Git

Le miroir est **aplati par construction** : `git archive <commit>` extrait un
arbre sans `.git`, puis un dépôt neuf est initialisé. Aucun objet historique
n'est republié — donc aucun secret enfoui dans une vieille révision ne peut
ressurgir. Le contrôleur vérifie en plus l'absence de motifs dans les objets Git
lorsque le dossier `.git` existe.

---

## 3. Mesures de sécurité du snapshot

| Mesure | Mise en œuvre |
|---|---|
| Extraction sans historique | `git archive <commit> \| tar -x` |
| Historique aplati | `git init` neuf, un seul commit |
| Fichiers interdits supprimés **avant** le scan | étape 3 du script |
| Exposition conditionnée au scan | `exit 1` si une anomalie subsiste |
| Manifeste d'empreintes | `MANIFESTE_MIROIR.md` : 1 ligne par fichier, sha256 |
| Traçabilité source | commit + arbre source inscrits dans le manifeste et le message de commit |
| Réversibilité | dépôt distinct, suppression par un seul appel API |

---

## 4. Configuration du dépôt public

| Règle | Application |
|---|---|
| Déclenchement manuel | tous les workflows de rendu en `workflow_dispatch` uniquement (déjà en place depuis `8dffb80`) |
| Aucun déploiement | aucun workflow de publication dans le snapshot |
| Permissions minimales | `permissions: contents: read` à la racine |
| `GITHUB_TOKEN` lecture seule | idem ; écriture réservée au seul job de publication d'artefacts |
| Aucun secret hérité | le miroir est un dépôt neuf : aucun secret de dépôt n'y est copié |
| Aucun `pull_request_target` | vérifié par le contrôleur (à ajouter, cf. §6) |
| Aucune migration D1 distante | seuls les workflows locaux/émulateur sont conservés |
| Aucun identifiant de production | les workflows de production ne sont pas copiés |

---

## 5. Données utilisées dans les tests

Les données de test sont synthétiques et sans lien avec un commerçant réel :

| Champ | Valeur |
|---|---|
| nom du commerce | `CHEZ D42 TEST` |
| offre | `OFFRE D42 DIAGNOSTIC` |
| prix | `25 000 FCFA` |
| ville | `COTONOU` |
| WhatsApp | `+22900000000` (fictif) |
| badge | `STOCK LIMITÉ` |
| CTA | `CONTACTEZ-NOUS` |

Les fixtures vidéo sont des générations FFmpeg (fond uni, marqueurs
géométriques) : aucune personne, aucun lieu, aucune marque.

---

## 6. Risques résiduels — assumés et écrits

| Risque | Gravité | Traitement |
|---|---|---|
| Un secret non couvert par les 33 motifs | moyenne | revue **manuelle** de la sortie du contrôleur avant le premier `push` |
| Un secret dans un binaire non analysé par `grep -I` | faible | les binaires > 200 ko sont retirés ; les autres sont listés dans le rapport |
| Fork ou clone créé par un tiers pendant l'exposition | **élevée, non réversible** | risque explicitement accepté par le propriétaire (§11 de l'ordre) |
| Divergence miroir / dépôt privé | moyenne | `MANIFESTE_MIROIR.md` + comparaison d'arbres à chaque synchronisation |
| Le miroir devienne source de vérité | moyenne | règle inscrite en tête du `README` du miroir et dans le manifeste |
| Artefacts publics (APK, MP4, logs) | moyenne | données synthétiques uniquement ; aucun journal de production |
| Le contrôleur lui-même rate un motif | faible | liste des motifs versionnée, revue à chaque nouveau fournisseur |

### Manque identifié dans l'outil

Le contrôleur ne vérifie pas encore la présence de `pull_request_target` dans les
workflows. **À ajouter avant la première publication :**

```bash
grep -rn "pull_request_target" "${RACINE}/.github" && {
  echo "INTERDIT : pull_request_target detecte"; exit 1; }
```

---

## 7. Procédure de fermeture

1. Tous les correctifs transférés vers `audit-d41` (PR #2).
2. Comparaison d'arbres source/privé fichier par fichier.
3. Tests verts sur la tête privée.
4. Rapport final publié.
5. Identifiants des runs et artefacts utiles archivés.
6. Suppression du miroir : `DELETE /repos/{compte}/{miroir}`.
7. Confirmation `404` à la lecture du dépôt.
8. Vérification : `vitrine-video` toujours `private: true`.
9. Vérification : `main` toujours à `74edd98`.
10. Vérification : PR #2 toujours `open`, `merged: false`.

**La suppression ne récupère pas les forks ni les clones.** Ce risque est
documenté et accepté.

---

## 8. Verdict de cette revue

**L'exposition publique n'est PAS autorisée en l'état** : l'arbre source n'a pas
été inspecté. Le contrôleur est prêt, la procédure est écrite, les données de
test sont propres — mais aucun des 33 motifs n'a pu être confronté aux fichiers
réels.

Séquence obligatoire avant toute publication :

```
1. fournir un PAT
2. git clone + git checkout audit-d41 (vérifier cf26af5)
3. bash d422/scripts/scan-exposition.sh ~/work/vv-d42
4. lire INTÉGRALEMENT la sortie (revue manuelle)
5. ajouter le contrôle pull_request_target manquant
6. relancer le scan → doit afficher « AUCUN SECRET DETECTE »
7. seulement alors : bash d422/scripts/creer-miroir.sh ...
```
