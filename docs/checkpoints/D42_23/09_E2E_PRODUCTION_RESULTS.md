# D42.23 — 09. RÉSULTATS E2E (Phase H/I)

## E2E officiel certifié (réutilisé — code Android inchangé)
- **rc10-audio-v2** (release publique 438084850, APK sha256
  `4e2acf14…`, cert `758077eb…`) : run **42456670342** SUCCESS —
  **PASS=37 FAIL=0 BLOCKED=0** sur l'APK téléchargé DEPUIS la release
  (contrôles sha256 + certificat avant installation).
- Contenu : parcours complet (installation→partage), export FGS écran
  éteint 45 s, MP4 9 140 832 o (h264 1080p + AAC 44,1 kHz, 34,99 s,
  décodage rc=0), non-muette (−53,3 dB moyen / crête −27,3 dB),
  crédits CONFIRMED/solde 2, aucun crash. Artefact 13608501901.
- **Portée exacte (découverte D42.23)** : session SANS compte →
  export + SFX embarqués validés ; la chaîne BGM authentifiée n'est
  PAS couverte (voir 02/06).

## CI du code D42.23 (miroir, gratuit)
- `68a31fb` : android-ci **42465877635 SUCCESS** ; API Security
  **skipped** (cadrage dépôt privé — 42465877627) ; e2e-lab annulé par
  concurrency au profit de `03639c2` (7/9 jobs verts à l'annulation).
- `03639c2` : android-ci + e2e-lab **en cours au moment de l'écriture**
  (résultats à reporter au figéage).
- Incident : run 42465876563 (workflow invalide, garde dupliquée) —
  corrigé, voir 10.

## APK rc11-production (correctif D23-3 — build local)
- Construit depuis `d42.23-production` (privé, commit `2cd6991`) :
  tests unitaires feature-export + `:app:assembleRelease` R8 full avec
  `-PvvApkSha256=758077eb…`, signature officielle via `vv-signing/`
  (gitignoré), clé Firebase RÉELLE.
- Vérifications : [à compléter au figéage — clé dex, cert, sha256,
  mapping.txt]
- Release : dépôt PRIVÉ (tag `d42.23-rc11`), asset APK + mapping.txt +
  preuves. [à compléter : id release, sha256]

## E2E de production complet — plan au déblocage D23-1
1. tag `worker-deploy-3` (privé) → déploiement + smoke renforcé
   (billing/return 200 + version 0.9.1-d42.23) ;
2. dispatch `API Security CI` (privé, ref d42.23-production) ;
3. tag `audio-audit-1` (privé) ;
4. tag build rc11 dans le privé → re-run e2e-official sur l'artefact
   exact remis au fondateur (re-certification intégrale).
