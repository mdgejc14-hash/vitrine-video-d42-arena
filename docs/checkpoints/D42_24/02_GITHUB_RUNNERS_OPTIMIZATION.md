# D42.24 — 02. OPTIMISATION DES WORKFLOWS (coût et temps, couverture intacte)

## État des lieux (vérifié sur e5f2f8c)
- 16 workflows ; **tous ceux de la chaîne de qualification tournent déjà
  sur `ubuntu-latest`** (standard gratuit en public). Aucun runner
  renforcé payant. 3 workflows self-hosted (cleanup, mock-server,
  qa-interactive) hors chaîne, inactifs.
- Cache Gradle déjà actif (`gradle/actions/setup-gradle@v4`).
- Concurrency déjà en place (e2e-lab, api-security, deploy).

## Optimisations retenues (sans réduction de couverture)
1. **Réutilisation des preuves acquises** (règle D42.24 §6) :
   - 600 musiques : JAMAIS reconstruites — audit par manifestes +
     échantillonnage (audio-audit).
   - 120 combinaisons qualifiées D42.21 : non relancées.
   - 37 e2e officiels rc10 : transposés à rc11 (code identique sauf
     BuildConfig clé — preuve D42.23) ; e2e miroir sur build équivalent
     (voir 09), e2e officiel exact au reset des minutes privées.
2. **Exécution sur le miroir public** = coût marginal nul.
3. **Garde d'activation propre** : les workflows à secrets (deploy,
   api-security, audio-audit, backup) restent sautés sur le miroir tant
   que la variable de dépôt `OPS_ENABLED` n'est pas `true` — contenu de
   fichier IDENTIQUE entre privé et miroir (pas de divergence) :
   `if: github.repository == 'mdgejc14-hash/vitrine-video' ||
        (github.repository == 'mdgejc14-hash/vitrine-video-d42-arena' &&
         vars.OPS_ENABLED == 'true' &&
         github.event_name != 'pull_request')`
   (sur le privé la 1re clause suffit ; sur le miroir : push/dispatch
   uniquement — les PR externes n'ont de toute façon jamais les
   secrets, on évite en plus le bruit de runs rouges).
4. **Rétention artefacts 14 jours** conservée ; aucun artefact
   volumineux inutile téléversé sur le privé.
5. **Une seule chaîne complète de qualification** après corrections.

## Séquence d'exécution prévue (chaque étape = preuve GitHub)
| # | Workflow | Déclencheur | Durée attendue | Prérequis secrets miroir |
|---|---|---|---|---|
| 1 | backup D1 → B2 | dispatch | ~5-10 min | lot 1 + lot 3 |
| 2 | deploy-production (0.9.1-d42.23 + migrations + smoke) | tag `worker-deploy-3` | ~10-25 min | lot 1 |
| 3 | api-security (Firebase réel, worker local) | dispatch | ~15 min | lot 2 |
| 4 | audio-audit (B2 : 600 + variations + SHA-256) | tag `audio-audit-1` | ~30 min | lot 1+2 |
| 5 | e2e build équivalent (même code + clé réelle, signature jetable) | dispatch | ~40-90 min | FIREBASE_WEB_API_KEY |

Coût total : **0 FCFA** (runners publics standards).
La séquence 1 peut être différée (D1 Time Travel 30 j = filet de
sécurité) si le fondateur n'ajoute d'abord que le lot 1 ; les
migrations D42.23 sont additives/idempotentes et déjà appliquées
jusqu'à 0011 en production (à re-vérifier au déploiement).
