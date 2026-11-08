# D42.25 — 08. VALIDATION SÉCURITÉ (P0 — avant usage des nouveaux secrets)

Audit réalisé AVANT toute consommation des secrets fondateur (mission
§3). Référentiel : 16 workflows du miroir au commit `df15b6f`/`bb4e8b3`.

## Contrôles effectués (tous PASS)

| Contrôle | Résultat | Preuve |
|---|---|---|
| Permissions minimales GITHUB_TOKEN | **PASS** — `permissions: contents: read` sur les 5 workflows consommant des secrets (deploy, api-security, audio-audit, backup, e2e-équivalent) | lecture des fichiers |
| `pull_request_target` dangereux | **PASS — AUCUN** sur les 16 workflows | `grep -rl pull_request_target` = vide |
| Code non fiable via PR | **PASS** — seul `pull_request` (jamais `_target`) sur api-security : les PR n'ont JAMAIS accès aux secrets (comportement GitHub) ; de plus la garde miroir exclut l'événement `pull_request` | garde job-level |
| Déclencheurs privilégiés limités aux collaborateurs | **PASS** — tags + `workflow_dispatch` uniquement (créer un tag/pousser = accès écriture requis) | `on:` de chaque workflow |
| Secrets en arguments de commande | **PASS** — tous par `env:`/`ORG_GRADLE_PROJECT_*` ; la clé Firebase n'apparaît jamais en CLI (masquée `***` dans les logs, vérifié run 42477208491) | logs |
| Secrets dans artefacts/sorties/rapports | **PASS** — api-security n'uploade AUCUN artefact ; e2e-équivalent n'uploade que captures/logs/cert de recette (jetable) ; `.dev.vars` écrit seulement sur le runner éphémère | fichiers + logs |
| Actions tierces | **PASS** — sources officielles : actions/checkout@v4, setup-node@v4, setup-java@v4, setup-python@v5, gradle/actions/setup-gradle@v4, reactivecircus/android-emulator-runner@v2 | fichiers |
| Chemins de checkout avant injection | **PASS** — secrets injectés au niveau étape, après checkout | fichiers |
| Secrets de signature au miroir | **PASS — ABSENTS** : `VV_KEYSTORE_B64`/`VV_STORE_PASSWORD` interdits et non présents (inventaire API : 9 secrets + OPS_ENABLED) | API GitHub |
| Secrets B2 rétention au miroir | **PASS — ABSENTS** (hors chaîne, non nécessaires) | API GitHub |
| Dépôt privé rendu public | **PASS — jamais fait** (le privé reste privé ; aucune exposition) | — |

## OPS_ENABLED — fermé par défaut (exigence D42.25 §3)
- **Avant** (D42.24) : garde `vars.OPS_ENABLED != 'false'` = ouvert par
  défaut — NON CONFORME à l'exigence P0 de D42.25.
- **Après** (`df15b6f`) : la première étape « Gate OPS_ENABLED » de
  deploy-production / audio-audit / backup **refuse par défaut** :
  elle n'autorise QUE si `vars.OPS_ENABLED == 'true'` (variable de
  dépôt, posable par le fondateur via l'interface) **OU**
  `secrets.OPS_ENABLED == 'true`» (secret, posable par l'agent via API).
  Sans l'un des deux : `::error::` + exit 1 — aucune opération sensible
  ne démarre. Preuve de fonctionnement : le run Deploy 42476870643 a
  franchi la gate car le secret OPS_ENABLED=true était posé (PUT 201)
  ; sans lui le refus est immédiat.
- api-security-tests : exempté de la gate (tests locaux SANS écriture
  production ; auto-déclenché sur push de chemins qualifiés — une gate
  par défaut fermée y créerait du bruit rouge sur chaque push de
  qualification). Son pré-vol secrets reste fail-closed (7 secrets
  requis, échec clair sinon). Justification documentée ici.
- Le secret `OPS_ENABLED` du miroir = interrupteur agent réversible :
  le supprimer (décision fondateur) ferme toute la chaîne ops.

## Résultats de sécurité RÉELS (run 42477195502, bb4e8b3 — API Security CI SUCCESS)
Vérifiés avec les VRAIS comptes Firebase A/B et les VRAIES clés B2 du
fondateur : comptes distincts, jetons réels ; sans jeton → refusé ;
jeton invalide → refusé ; isolation A/B complète (commerce, projet,
commande, collections) ; quota/crédits : empreinte non liée refusée,
aucun décrément frauduleux ; idempotence commande ; webhook billing :
signature invalide 401, corps malformé 400, montant hors grille 422 ;
catalogue audio 30 pistes/6 secteurs ; streaming B2 réel + cache
immutable + Range ; BGM 600 pistes étiquetées synthèse CC0.
**Aucun faux résultat : chaque PASS vient d'une réponse HTTP réelle.**
