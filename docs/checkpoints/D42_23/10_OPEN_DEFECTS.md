# D42.23 — 10. DÉFAUTS OUVERTS

## Incident résolu : workflow preview-d1-migrations invalide (1 run)
- Run 42465876563 (miroir, `68a31fb`) : failure sans jobs — la garde
  D42.23 a été ajoutée ALORS que ce workflow en portait déjà une
  (clé `if:` dupliquée = YAML invalide pour GitHub). Corrigé au commit
  suivant (doublon retiré — la garde d'origine suffit). Le run d'api-security
  `42465877627` = **skipped** confirme que le cadrage fonctionne ailleurs.

## D23-1 [BLOQUANT production] Minutes GitHub Actions épuisées (dépôts privés)
- **Symptôme** : tout workflow du dépôt privé `vitrine-video` meurt en
  3-5 s — zéro étape exécutée, aucun runner attribué. Vérifié en direct :
  dispatch backup du 08/11 08:55 → run 42464996752, failure en 4 s.
  Même motif sur backup (04→07/11), android-ci (d42.5, 04/11),
  release-e2e (d42.14, 06/11 ×11). Le miroir PUBLIC exécute
  normalement (jobs gratuits) — même compte.
- **Cause racine** : quota de minutes Actions du compte épuisé pour la
  période (les dépôts privés sont facturés ; les publics sont gratuits).
  Les « échecs » release-e2e ×11 et android-ci ×6 du privé ne sont PAS
  des échecs de code mais des non-démarrages.
- **Conséquences** : backup D1 quotidien en échec depuis le 04/11
  (dernier succès 03/11 03:41) ; déploiement Worker D42.23, tests API
  réels (security-ci 2 comptes), audit audio production (audio-audit-1)
  — tous PRÊTS, bloqués.
- **Action fondateur (unique, ~2 min)** : GitHub → Settings → Billing →
  Plans and usage → Actions → relever la spending limit (> 0) OU attendre
  la réinitialisation mensuelle. Alternative sans coût : ajouter les
  secrets requis au dépôt public miroir (qui exécute gratuitement) —
  sauf secrets de signature (VV_* restent au privé, règle D42.17).
- **Non contournable techniquement** : runner self-hosted interdit
  (l'API runners renvoie 403 au PAT fourni — permission Administration
  absente ; élargir le jeton est interdit sans autorisation).

## D23-2 [produit] Chaîne BGM authentifiée non couverte par l'e2e
- L'e2e officiel D42.22 (session locale sans compte) a validé
  export+SFX, PAS le téléchargement BGM (login → token → catalog →
  variation → B2 → cache → mix). Voir 02/§découverte. Validation via
  audio-audit-1 + test physique (points B2/B3/C1 de la checklist D42.22).

## D23-3 [CRITIQUE, corrigé] APK public avec clé Firebase factice
- L'APK rc10-audio-v2 (release publique 438084850) embarque la clé
  FACTICE (preuve : extraction dex ; sonde contrastée identitytoolkit —
  factice = « API key not valid », réelle = « INVALID_LOGIN_CREDENTIALS »).
  Sans correctif : connexion Google impossible au premier test physique.
- Correctif : clé réelle dans la branche privée `d42.23-production`
  (commit `2cd6991`) + APK production reconstruit/signé localement +
  release dans le privé (détails checkpoint 04).

## Hérités
- D22-1 (secrets miroir public) : REQUALIFIÉ — les secrets existent dans
  le privé (16, noms conformes) ; le blocage devient D23-1 (facturation).
- D2 : rendu export > 40 min sur émulateur (matériel réel attendu).
- Défaut systémique musique (intros : hook 0,3/10, remplissage 0,0,
  pulsation 4,9 ; 526 IMPROVE / 74 REGENERATE) — traitement ultérieur
  par mesures/briefs, JAMAIS de relance globale.
- D11 : dettes complexité detekt.
- D3-D6 : voir docs/checkpoints/D42_21/08_OPEN_DEFECTS.md.
