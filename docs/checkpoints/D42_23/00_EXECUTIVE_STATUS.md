# D42.23 — 00. STATUT EXÉCUTIF

**Mission** : raccordement total aux services de production, qualification,
remise prête à installer. Point de départ `43de5bc` (D42.22). GitHub = source
de vérité. Aucun acquis D42.15-22 recommencé.

## Fait (audit du 08/11 ~09:15 Bénin)
- **Phase A — audit secrets TERMINÉ** (voir 01) : les 16 secrets
  (Cloudflare ×3, Firebase ×5, B2 ×6, signature ×2) sont dans le dépôt
  PRIVÉ `mdgejc14-hash/vitrine-video` ; le miroir public n'en a aucun ;
  aucun environnement GitHub n'existe. Le PAT fondateur révèle 5 dépôts
  (dont privés `vitrine-video`, `le-labeur`, `LE-LABEURs`).
- **Phase B — état production ÉTABLI** (voir 02) : le Worker
  `vitrine-video-api.mdgejcinfluence.workers.dev` sert le code **D40**
  (déployé 01/11) — SANS `?v=N` (20 variations) ni routes SKYPAY ;
  santé OK (D1 connecté, schéma prêt, 8 tables) ; auth Firebase ACTIVE
  (401 vérifiés) ; routes audio présentes mais protégées.
- **Découverte e2e D42.22 corrigée** : l'audio du MP4 e2e (session locale,
  sans compte) = SFX/ambiance EMBARQUÉS, pas la bibliothèque musicale
  réseau — la chaîne BGM authentifiée n'est PAS couverte par l'e2e
  existant (détails 02/§ découverte).
- **Défaut D23-1 découvert** : minutes GitHub Actions du compte ÉPUISÉES
  pour les dépôts PRIVÉS (tout workflow du privé meurt en 3-5 s, zéro
  étape, aucun runner — vérifié en direct par dispatch ; le miroir public
  gratuit fonctionne). Backup D1 quotidien en échec depuis le 04/11 pour
  cette cause. Seule une action fondateur (limite de dépenses) débloque.
- Préparation du déploiement : version worker marquée `0.9.1-d42.23`
  (observable via /health) + smoke test deploy renforcé (preuve que le
  code D42.23 est réellement en production).

## Séquence restante
1. Pousser branche `d42.23-production` (code D42.23) vers le dépôt PRIVÉ
   (prêt à déployer par tag `worker-deploy-3` dès déblocage D23-1).
2. CI miroir sur le commit D42.23-01 (android-ci + e2e-lab).
3. Checkpoints 03-09 au fil des validations.
4. Verdict + rapport + paquet fondateur (action facturation unique).

## Découverte D23-3 (critique, corrigée en cours)
- **APK rc10-audio-v2 = clé Firebase FACTICE** (`AIzaSyD42LABDUMMYKEY…`,
  extraite du dex de l'asset publié) : la connexion Google aurait échoué
  au premier test physique. Correctif : clé réelle (privé) committée en
  branche `d42.23-production` (commit `2cd6991`), APK reconstruit +
  signé localement, release dans le PRIVÉ (voir 04).

## Blocage unique
**D23-1 (facturation Actions dépôts privés)** — déploiement Worker, tests
API réels (security-ci 2 comptes), audit audio production (audio-audit-1),
backup D1 : tous PRÊTS, tous dans le dépôt privé qui ne peut plus exécuter
de jobs. Documenté avec preuves au 10. Le self-hosted (runner local) est
interdit par le périmètre du PAT (Administration refusée — 403 vérifié).
