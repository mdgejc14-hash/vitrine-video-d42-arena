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
| 2 | Étude des 30 gabarits AVANT régénération | EN COURS | JSON gabarits riches localisés (content/gabarits_v2/gabarits/{secteur}/{T*}.json : scène par scène) ; **recherche documentaire TERMINÉE → cp. 03** (TikTok/Meta/Oakes 2007/Oakes&North 2006/Galan 2009/EBU R128 s1-s2/AES TD1004/BS.1770-4) ; fiches de direction À ÉCRIRE (après mesures) |
| 3 | Direction musicale par secteur ET gabarit | À FAIRE | base = matrice + mesures Phase 4 + écoutes fondateur |
| 4 | Audit des 600 (mesures objectives + écoute) | EN COURS | pipeline 08/11 (correction lameenc → `/home/user/pylibs`) ; progression = lignes de `audio_v2_mesures/mesures600.jsonl`. **Premiers résultats (46 pistes)** : 46/46 avec silence numérique 0–0,5 s ET première attaque > 2 s (min 2,14 / méd 2,25 / max 2,41) — défaut UNIVERSEL ; LUFS −16,09..−15,99 ✓ ; TP ≤ −1,01 ✓ ; LRA méd 3,19 LU ; densité méd 1,51 év/s (faible pour du percussif 100+ BPM) ; offset DC léger 0,0011–0,0015 sur une partie des pistes (mineur) ; estimateur BPM à affiner |
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
1. ~~PAT GitHub supprimé~~ → **JETON FOURNI PAR LE FONDATEUR le 08/11** (ancien jeton,
   transmis dans la messagerie). Vérifié auprès de GitHub : authentifié `mdgejc14-hash`,
   push autorisé sur le miroir public. Stocké `~/.d42_secrets/gh_token.txt` (chmod 600),
   jamais affiché, jamais dans une URL/commit/fichier versionné. **Risque signalé** : le
   jeton a circulé en clair dans la messagerie → révocation recommandée après la mission.
   Premier commit D42.20 poussé et vérifié distant : `bc42731`.
2. **Aucune clé B2 en local** → les ~38 originaux exacts de la première vague (hors v01
   déjà récupéré) ne sont pas téléchargeables sans clés B2 lecture (canal sécurisé requis).
3. Workspace persistant > plafond snapshot 128 Mo : **3e incident au tour du 08/11**
   (lab20/.git + arbre presque entier, D42_18 amputé à 349 Ko). Mitigations : re-clone
   systématique, sauvegardes `D42_20_backup/`, jsonl de reprise, installs pip dans
   `/home/user/pylibs` (persistant).
4. Défaut latent audio D42.18 (export sans piste audio si BGM attendue) : NON CORRIGÉ —
   phases 5/9, cycle CI dédié (jeton maintenant disponible).
5. **Écart architecture identifié (ordre §5)** : l'app télécharge 1 piste/catégorie et le
   Worker sert la variation 1 en repli (`src/index.js:1996`, fallback `ORDER BY variation
   LIMIT 1` dans `routeAudioTrack` l.1952 ; client `BgmStore.kt:46` `ensureGabaritCached`
   → `downloadTrack` l.68) — la spécification « choisir parmi les 20 du gabarit » n'est
   pas implémentée. Correction à concevoir (Worker + BgmStore + export Media3 + tests).

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
