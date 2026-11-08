# PAQUET FONDATEUR D42.23 — une décision, puis une séquence mécanique

**À lire après RAPPORT_FINAL_D42_23.** Le fondateur ne teste RIEN tant que
la séquence ci-dessous n'est pas terminée (règle D42.17+ maintenue).

## La décision unique — D23-1 (facturation GitHub Actions)

Les dépôts **privés** du compte n'ont plus de minutes Actions : tout
workflow y meurt en 3-5 s sans exécuter une étape (vérifié en direct le
08/11 ; le backup D1 quotidien échoue depuis le 04/11 pour cette cause).
Le miroir public, lui, fonctionne (gratuit).

**Action proposée (option a — recommandée)** :
1. GitHub → Settings → **Billing and plans** → Spending limit
   (Actions and Packages) → relever la limite (même 5-10 $ suffit pour
   la séquence : ~1-2 h de runners au total).
2. Prévenir l'agent (message dans la conversation) — rien d'autre.

**Alternative (option b — déconseillée)** : déplacer les secrets
Cloudflare/Firebase/B2 vers le miroir public pour tout exécuter en
gratuit. Déconseillée : la signature (VV_*) ne peut pas y aller, et des
secrets de production sur un dépôt public va contre l'architecture
retenue au correctif D23-3.

## Ce qui est déjà prêt (aucune action fondateur requise)

- APK distribution **rc11** en release **privée** `d42.23-rc11`
  (id 438156110) : sha256 `b052e7c9…c83bb6`, cert `758077eb…`, clé
  Firebase réelle (preuves : checkpoints 04/09).
- Branche `d42.23-production` du privé = code D42.23 prêt à déployer
  (version worker `0.9.1-d42.23` observable via /health, smoke renforcé).
- Workflows du privé cadrés sur le privé ; déclencheurs vérifiés :
  `worker-deploy-*` (déploiement), `audio-audit-*` (audit),
  api-security (dispatch), motifs `d42.23-build-*` / `d42.23-rc*`
  ajoutés aux builds/e2e officiels par l'agent au figéage.

## Séquence post-déblocage (exécutée par l'agent, vérifiable par le fondateur)

| # | Action | Preuve de succès attendue |
|---|--------|---------------------------|
| 1 | Vérifier qu'Actions privé vit (run de contrôle) | un run exécute > 0 étape |
| 2 | Backup D1 (dispatch `backup-d1-to-b2`) | run SUCCESS, archive B2 |
| 3 | Tag `worker-deploy-3` → déploiement Worker | smoke : /health `0.9.1-d42.23`, billing/return 200, `?v=N` présent |
| 4 | Dispatch `api-security-tests` (ref `d42.23-production`) | 2 comptes, tests SUCCESS |
| 5 | Tag `audio-audit-1` | audit audio production SUCCESS |
| 6 | Re-certification e2e : re-push du tag `d42.23-rc11` (release 438156110 existante) | e2e-official télécharge l'ASSET exact de la release, PASS=37 FAIL=0 |
| 7 | Rapport de clôture + remise | checkpoints 09/11 complétés, GO final |

Notes : (i) l'e2e-official travaille sur l'asset de la release taguée
(`d42.23-rc*` — motif ajouté au figéage) : c'est l'artefact exact
distribué qui est re-certifié, PAS un rebuild (un rebuild donnerait un
sha256 différent). (ii) Le workflow `d42.23-build-*` (motif également
ajouté) servira aux futurs rc12+ si le code Android change.

Après l'étape 7 uniquement, le fondateur peut installer l'APK rc11 sur
un appareil physique (téléchargement depuis la release privée,
vérification sha256 via `rc11_checksums.txt`).

## Garde-fous (inchangés)

- PAT fondateur : usage limité au dépôt vitrine vidéo, jamais affiché,
  jamais versionné, permissions jamais élargies ; suppression = décision
  fondateur après livraison vérifiée.
- Secrets GitHub : jamais extraits ni affichés ; si un secret n'est pas
  transmis à un workflow → corriger le workflow, pas recréer le secret.
- Aucun budget payant consommé sans autorisation explicite (la décision
  D23-1 ci-dessus EST cette autorisation pour la séquence).
