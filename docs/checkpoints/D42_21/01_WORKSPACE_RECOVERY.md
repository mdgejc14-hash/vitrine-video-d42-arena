# 01 — Récupération workspace (5e effacement) — GitHub seule mémoire

**Date** : dim. 08/11/2026 (~01:00–02:00 Bénin)
**Statut** : récupération TERMINÉE (conforme à la rectification fondateur : pas de chantier de reconstruction)

## 1. Ce qui s'est passé

Vers 00:15 (08/11), un 5e effacement du workspace a détruit les chemins non encore
sauvegardés dans le snapshot (plafond ~128 Mo dépassé par les artefacts de diagnostic) :

| Chemin | Impact | Statut |
|---|---|---|
| `lab20/.git` + arborescence | Dépôt de travail éventré (seuls fichiers racine survivent) | Remplacé par `lab20_restore` (clone frais `d42.13-lab` @ `c242d99`) |
| `~/.cache/audio600/` | 564 mp3 régénérés + shards regen avec sha | PERDUS — **interdiction fondateur de relancer** les générations |
| `~/.cache/bt/` | build-tools (apksigner) | Re-téléchargeable (build-tools_r34) |
| `/tmp/p*art/` | artefacts P1 téléchargés | Re-téléchargeables via API GitHub |
| `.d42_secrets/` | jeton GitHub | Ancien jeton révoqué (il avait de toute façon été exposé) — nouveau PAT fourni par le fondateur 08/11 ~01:30 |
| docs 06/07/08 non commités | squelette 06, fiches 07 (31 divergentes), audit SaaS 08 | Reconstitués depuis la mémoire de session puis commités |

**Survivants** : `audio_v2_mesures/` (mesures600.jsonl + classement600.jsonl 600/600),
`audio_v2_outils/` + `plan_gabarits_reconstruit.json`, `~/keystores/` (vitrine.keystore,
signing.properties, VV_KEYSTORE_B64.txt), `~/livrables/` (APK signés antérieurs),
backup D42_20.

## 2. Décisions fondateur (rectification 08/11)

1. **GitHub = SEULE autorité/mémoire** ; un checkpoint non vérifié distant = non publié.
2. Ne pas transformer la perte en chantier de reconstruction ; ne relancer les 600 pistes
   **que si techniquement indispensable** (elles ne le sont pas : classement + mesures
   600/600 survivent, production = 564 pistes déjà en ligne).
3. Ne pas conclure depuis `enabled=true` seul — preuve d'exécution exigée.
4. Ne pas remplacer une piste parce qu'elle diffère de la régénération locale
   (respect des originaux production ; 31 divergentes documentées).
5. Après un « Something went wrong » : vérifier git/checkpoint/processus/workflows puis
   reprendre à la prochaine opération non terminée.

## 3. Vérifications faites à la récupération

- Dépôt lisible anonymement (clone/ls-remote/runs OK) ; artefacts+logs = 401/403 anonymes → jeton requis.
- `lab20_restore` cloné (depth 50, `d42.13-lab`, HEAD `c242d99` = dernier poussé D42.21).
- Nouveau jeton vérifié : login `mdgejc14-hash`, artefact 13594745867 téléchargé HTTP 200.
- Historique P1-debug analysé : **jamais vert depuis sa création** (voir 02_EXPORT_ROOT_CAUSE.md).

## 4. Leçon durable

Committer PLUS TÔT ; ne jamais laisser le workspace dépasser le plafond de snapshot ;
tout artefact utile est téléchargé hors de `/home/user` (via `/tmp`) ou commité/poussé
immédiatement. Les mesures et classements 600/600 ont été re-commités dans ce dépôt
(`donnees/`) dès la récupération pour ne plus jamais dépendre du workspace.
