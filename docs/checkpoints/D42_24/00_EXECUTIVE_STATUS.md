# D42.24 — 00. STATUT EXÉCUTIF

**Mission** : déblocage total à **0 FCFA** (aucune dépense, aucun runner
payant), raccordement des services réels (Cloudflare/Firebase/B2),
qualification, livraison APK prêt pour le premier test physique.
Référence D42.23 : privé `59de59c` / miroir `e5f2f8c` / APK rc11
(release privée 438156110).

## Contraintes fondatrices (ordre du fondateur)
- Budget 0 FCFA : pas de minutes achetées, pas de plafond relevé, pas
  d'abonnement, pas de runner payant, pas de service tiers payant.
- Stratégie prioritaire : **tout exécuter sur le miroir public**
  (`mdgejc14-hash/vitrine-video-d42-arena`) — runners standards
  `ubuntu-latest` gratuits en illimité sur dépôts publics.
- Jamais de keystore / mots de passe / clés B2 / tokens Cloudflare /
  identifiants Firebase dans le contenu public du dépôt.
- Exposition temporaire du privé = dernier recours, confirmation
  fondateur explicite requise au préalable.
- Publication temporaire ≠ confidentialité (des tiers peuvent copier).
- SKYPAY reste `501 billing_not_configured` — aucun paiement réel ou
  simulé. Ne pas reconstruire les 600 musiques, ne pas relancer les 120
  combinaisons, ne pas refaire les 37 e2e sans modification pertinente.

## État au démarrage (08/11/2026 ~10:15 UTC — même journée que D42.23)
- **Worker production = 0.9.0 (code D40)** — vérifié /health en direct :
  `{"status":"ok","database":"connected","schema":"ready",
  "applicationTables":8,"version":"0.9.0"}`. Le déploiement D42.23
  (0.9.1-d42.23, `?v=N`, SKYPAY) attend toujours l'exécution bloquée.
- **Miroir public** : `e5f2f8c` — android-ci **SUCCESS**
  (42468965871) et e2e-lab **SUCCESS** (42468965793, conclu 10:23 UTC —
  le miroir est ENTIÈREMENT VERT au figéage D42.23, conclusion du point
  resté ouvert de D42.23-11).
- **APK rc11** (distribution) : release privée 438156110 — APK
  44 112 105 o, sha256 `b052e7c9…c83bb6`, cert `758077eb…`, clé Firebase
  réelle. keystore source intact localement (keystores/).
- **Config Android** : `vvApiBaseUrl=https://vitrine-video-api.
  mdgejcinfluence.workers.dev` (production) dans gradle.properties ET
  valeur par défaut des 5 modules — aucune URL de preview ✓.
- **Workflows** : tous les workflows utiles tournent déjà sur
  `ubuntu-latest` (standard) ✓ — aucun `*-xl` payant nulle part.

## Incident de démarrage résolu : PAT perdu + dépassement snapshot
1. La sauvegarde sandbox (plafond ~128 Mo) avait perdu le PAT fondateur
   et les `.git` : cause racine = workspace à **355 Mo** d'historique
   local des missions D39→D42.23.
2. **PAT restitué par le fondateur** (recolé 08/11) → stocké
   `/home/user/.d42_secrets/` chmod 600, jamais affiché/committé.
   Vérifié : login `mdgejc14-hash` ✓.
3. **Archive intégrale** des 89 dossiers historiques (200 391 117 o,
   tar.gz sans .git, sans secrets/keystores/drive/clones courants) →
   release PRIVÉE `workspace-archive-2026-11-08` (id **438171680**),
   asset `legacy_d42_workspace_2026-11-08.tar.gz` (taille exacte
   vérifiée). Restitution : télécharger + `tar xzf` dans /home/user.
4. Purge locale effectuée → workspace **34 Mo / 209 fichiers** (sous le
   plafond) : le snapshot redevient fiable (plus de perte .git/PAT).
5. Miroir re-cloné (public), vvprod à re-cloner du privé (voir 07).

## Décisions d'architecture (mission §2/§3 — appliquées)
- **Miroir public = usine de qualification** : runners standards
  gratuits. Le privé reste détenteur des artefacts de distribution.
- E2E final sur l'APK distribué : **rc11 reste en release privée**
  (décision D23-3 maintenue, rien ne lève l'interdiction d'exposition).
  Le miroir qualifie un build RELEASE équivalent (même code, clé réelle
  via secret, signature CI jetable) ; l'e2e officiel sur l'artefact
  exact reprendra sur le privé au reset des minutes gratuites
  (2 000 min/mois). Le fondateur peut à tout moment choisir l'option
  « publier rc11 en asset miroir » (exposition assumée) — non fait par
  défaut.

## Plan D42.24
1. ~~Diagnostic zéro-coût (01)~~ ✓ + optimisation runners (02) ✓ +
   secrets/dépôts (03) ✓ (confirmations API faites : 16 secrets privé /
   0 miroir ; billing API = 403 hors périmètre PAT — documenté).
2. Workflows miroir : garde `vars.OPS_ENABLED` + durcissement, push.
3. Probe privé (workflow témoin) : le quota s'est-il reconstitué ?
4. Secrets miroir : ajout fondateur via UI (liste exacte au 03) ;
   `FIREBASE_WEB_API_KEY` posé par l'agent si l'API le permet.
5. Chaîne : backup → `worker-deploy-3` → api-security → `audio-audit-1`
   → e2e équivalent (09).
6. Checkpoints 04-11 au fil des exécutions, rapport final, livraison.
