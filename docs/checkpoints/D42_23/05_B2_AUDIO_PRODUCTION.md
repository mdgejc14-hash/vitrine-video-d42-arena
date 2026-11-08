# D42.23 — 05. B2 / BIBLIOTHÈQUE AUDIO (Phase D)

## Acquis réutilisés (D42.21/22 — aucune reconstruction)
- 600 compositions = 6 secteurs × 100 = 30 gabarits × 20 variations.
  Bibliothèque créée pour éviter les problèmes de licence.
- Réconciliation D42.22 (checkpoint 03) : **569/600 octet-identiques à la
  production** (sha256 fichiers) ; **31 divergentes** = `batiment_travaux`
  uniquement (T1×17, T2×9, T3×5 — variations exactes listées) ;
  « 564 en ligne » = attendu EN_LIGNE production, À CONFIRMER par audit.
- Aucun original supprimé, aucune génération relancée (règles fondateur).

## Accès B2 — état
- Les objets audio sont servis PAR le Worker (binding B2
  `vitrine-video-media`) — jamais d'accès client direct. Les routes
  audio production existent (401 sans token — sondes D42.23/02).
- Vérification DIRECTE B2 (lecture, Range, cache, erreurs) : via
  `audio-audit-1` (workflow lecture seule, PRÊT, présent sur la branche
  `d42.23-production` du privé avec secrets B2_KEY_ID/B2_APPLICATION_KEY)
  — exécution bloquée D23-1.
- Le cache bord (Audio CACHE_EPOCH) et le refus de servir les Range
  depuis le cache plein sont implémentés côté Worker (audit code D42.22).

## Plan post-déblocage (une seule action fondateur)
1. Relever la limite de dépenses Actions (D23-1) ;
2. dispatch backup D1 (sauvegarde avant tout) ;
3. tag `audio-audit-1` sur `d42.23-production` (privé) → l'audit
   exécute : sondes authentifiées 30×{1..20}, réconciliation B2,
   vérification EN_LIGNE, tailles/sha256 — rapports en artefact.
