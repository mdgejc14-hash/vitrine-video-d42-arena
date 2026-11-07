# D42.20 — 00. STATUT EXÉCUTIF

**Mission** : recherche audiovisuelle, direction musicale, restauration des 600 sons,
audit SaaS global, qualification commerciale.
**Date d'ouverture** : 07/11/2026. **Exécution** : agent (moi), fondateur = validation finale.
**Règle de preuve** : chaque affirmation = preuve ou mention NON VÉRIFIÉE. Jamais de test prétendu.

---

## Journal des phases (10)

| # | Phase | Statut | Preuve / note |
|---|---|---|---|
| 1 | Inventaire : retrouver les 600 compositions | **TERMINÉE** | cp. 01 (sondes production vertes + déterminisme prouvé ; nuance : ~39 fichiers de la 1re vague pré-patch non reproductibles à l'octet, v01 vérifié DIRECTEMENT contre la production) |
| 2 | Étude des 30 gabarits AVANT régénération | EN COURS | matrice D42.19 lue (matrice_30_gabarits_bpm_styles_sfx.csv) ; recherche pro (TikTok/Meta/Oakes/Galan/EBU R128) À FAIRE |
| 3 | Direction musicale par secteur ET gabarit | À FAIRE | base = matrice + mesures Phase 4 + écoutes fondateur |
| 4 | Audit des 600 (mesures objectives + écoute) | EN COURS | régénération locale : 129/600 (continue en arrière-plan, resumable) ; outil `audio_v2_outils/audit600.py` écrit et testé ; 1re mesure : silence numérique 0–0,5 s + première attaque 2,39 s (corrobore la plainte fondateur) |
| 5 | Synchronisation musique/montage | À FAIRE | repères riser/drop par gabarit dans la matrice (fenêtres 30 i/s) |
| 6 | Régénération KEEP/IMPROVE/REGENERATE | À FAIRE | générateur déterministe local = coût 0 FCFA ; jamais toucher aux originaux |
| 7 | Validation comparative dans les vrais gabarits | À FAIRE | aveugle si possible ; décisions du fondateur |
| 8 | Ingénierie téléchargement B2→Android | **TERMINÉE (analyse)** | BgmStore.kt : 1 piste/catégorie → `files/bgm/`, hors-ligne définitif ; clés jamais embarquées (auth Bearer + Worker) |
| 9 | Voix facultative + 4 scénarios de mixage | À FAIRE | cible mix D42.19 : −14 LUFS intégrés, −1 dBTP, ducking −14 dB (75/325 ms) — à JUSTIFIER, pas copier |
| 10 | Audits SaaS (parrainage, offline, Google Auth, Cloudflare/D1, crédits, partage) | À FAIRE | acquis antérieurs intacts (ne pas rejouer) ; SKYPAY reste `501 billing_not_configured` |

## Livrables attendus
- 23 checkpoints `docs/checkpoints/D42_20/00…22` (celui-ci = 00).
- Rapport final : 40 questions, preuve par réponse.
- Bibliothèque `audio/bgm_v2/` si régénération validée (jamais de bascule production sans validation).

## Verrous actifs
1. **PAT GitHub supprimé à la clôture D42.18** → aucun push possible ; les checkpoints sont
   écrits localement (`lab20/docs/checkpoints/D42_20/` + copie de secours `/home/user/D42_20_backup/`).
   → **ACTION FONDATEUR** : fournir un PAT neuf (portée repo) pour pousser le travail D42.20.
2. **Aucune clé B2 en local** (env. requises par `ingest_bgm.py`, jamais committées — conforme).
   Conséquence : pas de listing B2 direct. CONTOURNÉ : régénération déterministe locale prouvée
   octet-identique (voir cp. 01) + routes Worker authentifiées pour vérifier la production.
3. Workspace persistant ~428 Mo > plafond snapshot 128 Mo (best-effort) → `lab16/.git`+`docs/`
   déjà perdus 2×. Mitigation : repo re-cloné (`lab20`, miroir public), copies de secours des
   checkpoints, tout dans `.cache` exclu du snapshot = régénérable.
4. Défaut latent audio D42.18 (export sans piste audio si gabarit attend BGM — musique jamais
   `EditedMediaItem`) : NON CORRIGÉ à ce stade — phase 5/9 de D42.20, cycle CI dédié requis
   (et PAT nécessaire).

## Décisions structurantes prises ce tour
- **A1** : l'audit des 600 se fait sur copies locales régénérées, PAS sur des téléchargements B2
  (impossible sans clés) — légitimé par preuve d'identité octet (sha256 3/3 contre flux production).
- **A2** : la mesure objective (silence initial, RMS/LUFS, spectre, tempo) est faite par l'outil ;
  **l'écoute humaine reste au fondateur** (règle : jamais prétendre une écoute non faite).
  L'outil produira un échantillon stratifié + grille /100 pour l'écoute guidée.
- **A3** : aucune écriture vers B2/production pendant l'audit. La régénération v3 éventuelle
  se fera en local dans un préfixe séparé, avec manifeste de correspondance, et bascule
  SEULEMENT après validation fondateur (règle non négociable 1–2).

## Avancement régénération locale (pour mémoire entre tours)
- Pilote : `/home/user/.cache/audio600/` — commande : `python3 audio_v2_outils/regen600.py --shard k/2`.
- Résumable (jsonl par shard). Si le dossier est vide au tour suivant : relancer 2 shards.
