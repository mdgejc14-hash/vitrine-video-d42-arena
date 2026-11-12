# D42.31 — Plan et état : galerie visuelle intégrale, revue UX/UI fondateur, livraison commerciale

## Mission

**Phase A (en cours)** : produire la galerie visuelle EXACTE de RC15 (chaque
écran, 30 gabarits, FR/EN, clavier, petit écran, police agrandie, hors
connexion, états d'erreur/chargement/succès), l'auditer UX/UI, la pousser sur
GitHub, puis **S'ARRÊTER à la porte de validation visuelle du fondateur**.
**Phase B (verrouillée jusqu'au retour du fondateur)** : corrections
regroupées, galerie de révision, non-régression, puis RC16.

## Règles de la mission

- RC15 **IMMUTABLE** — release 442574529, asset 738360276, tag `d42.30-rc15`,
  SHA-256 `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936`
  (re-téléchargée et re-vérifiée ce jour depuis la release).
- **Aucune modification produit en Phase A** : seuls des outils de capture
  (`tools/e2e/run_gallery.sh`) et documents sont ajoutés.
- Captures brutes, non retouchées ; données 100 % fictives (RobeWax,
  0197000000, 15 000 FCFA, Akpakpa, BoutiqueAwa) ; jamais de vraies données.
- Caméra de l'émulateur = flux **ÉMULÉ** (scène virtuelle) — identifié comme
  tel partout ; le capteur physique reste BLOCKED_DEVICE_TEST (fondateur).
- Aucun PASS fabriqué : un écran manquant = gap documenté dans la galerie.
- FR/EN uniquement ; es/ja restent hors parcours actif (acquis D42.30).
- Budget 0 FCFA ; CinetPay reporté ; GitOps (push + checkpoint + preuves).

## Outils créés (Phase A)

| Fichier | Rôle |
|---|---|
| `tools/e2e/run_gallery.sh` | Pilote de capture : parcours réel complet sur l'APK RC15 exacte, screencap à chaque étape, manifest.tsv + gaps.txt, profils base/font130/petit/offline, FR/EN |
| `.github/workflows/visual-gallery.yml` | Workflow dispatch-only (concurrence séparée du lab) : télécharge l'asset RC15, vérifie le SHA-256, 2 jobs (gallery-fr : base+font130+petit ; gallery-en-offline : en base + fr offline) |

## Répertoire cible

`docs/checkpoints/D42_31/visual-review/` : `01_accueil/` … `20_hors_connexion/`
(20 dossiers), `README.md` (galerie interactive cliquable), `SCREEN_INVENTORY.csv`,
`UX_AUDIT.md`.

## Journal

- **12/11 13:0x — reprise vérifiée** : origin/main = f9c0338 (ls-remote) ;
  sandbox régénéré (remote+identité refaits, reset --hard) ; run documentaire
  43206182246 (f9c0338) récupéré : 14/14 SUCCESS, fonctionnel camerap 62/0/0,
  p1 35/0/0, OFFX 41/0 — 3ᵉ vert consécutif du harnais D42.30-18. APK RC15
  re-téléchargée depuis la release : 44 470 123 o, SHA-256 exact
  fd28ffc7… (identité RC15 confirmée). Toutes les validations D42.30 restent
  acquises (aucune campagne relancée).
- **12/11 — outils Phase A écrits** : run_gallery.sh (bash -n OK) +
  visual-gallery.yml (dispatch-only, sha256 verify intégré). Push puis
  dispatch : capture en cours.
