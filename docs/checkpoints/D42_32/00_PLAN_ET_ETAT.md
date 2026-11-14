# D42.32 — Plan et état : reconception UX/UI commerciale (Phase A/B/C)

> Réconcilié D42.32 §3 après rollback sandbox (commits locaux 3536e44/a9c4a00/59cf0bb
> perdus, HEAD réparé sur origin/main = 2a19d49). L'historique ci-dessous est la
> vérité Git ; rien n'est réécrit, les états sont mis à jour.

## Références immuables

- **RC15** : release 442574529 · tag `d42.30-rc15` · asset `vitrine-video-rc15.apk`
  (44 470 123 o) · SHA-256 `fd28ffc75cc7ec22c0edd6dcf2c63b1d9fab31469505ede079ddb3aeb3b78936`.
- **Point de départ exact D42.32 : 2a19d49** (dernier commit poussé, Lots 1-9).
  9fbc261 = checkpoint final D42.31 (historique) ; 9cc233a/90f1ac5 = intermédiaires.
- RC15 reste la référence historique. **AUCUNE RC16 avant approbation visuelle du fondateur.**

## Chaîne des commits D42.32 (poussée, vérifiée distante)

`90f1ac5` (Lot 1) → `095d645` (Lot 2) → `f07ae5c` (Lots 5+6) → `9cc233a` (checkpoints)
→ `e47262a` (Lot 7 + detekt) → `316bb80` (Lot 4) → `b0a988b` (Lot 3) → `6d1ad6a` (Lot 8)
→ `d88dbbf` (Lot 9) → **`2a19d49`** (fix CI jsonPreview — vraie cause des runs rouges).

## Phase A — lots de corrections

| Lot | Priorité | Périmètre | État |
|---|---|---|---|
| 1 | P0 | Catalogue : secteur choisi → uniquement ses 5 gabarits, zéro filtre intégré (retour = sélection) | **TERMINÉ** — 90f1ac5, android-ci SUCCESS |
| 2 | P0 | Présentation catalogue : cartes premium, hiérarchie claire, 5 gabarits identifiables | **TERMINÉ** — 095d645, validé au push groupé (android-ci SUCCESS + e2e-lab 15/15 sur 2a19d49) |
| 3 | P0 | Caméra : diagnostic différentiel mosaïque (ImageAnalysis/PreviewView/VideoCapture/MP4) + présentation écran | **TERMINÉ (outil)** — b0a988b ; diagnostic 4 sources × 2 modes + banc instrumenté + job e2e. **Artefacts run 43520993407 insuffisants (camera-diagnostic 300 o) — récupération §5 à refaire (fix v2 perdu au rollback, à recréer)**. Physique = fondateur (06_CAMERA_DIAGNOSTIC.md). AUCUNE modif CameraX sans cause démontrée |
| 4 | P1 | Localisation FR/EN complète (parcours + 30 gabarits + notifications) | **TERMINÉ** — 316bb80 (overlay EN 376 chaînes par IDs stables ; détail 03_LOCALISATION_FR_EN.md) |
| 5 | P0 | Dashboard : en-tête pro, carte crédits, action principale, état sync honnête | **TERMINÉ** — f07ae5c, validé au push groupé |
| 6 | P0 | Parrainage : code immédiatement visible, copier/partager, paliers secondaires | **TERMINÉ** — f07ae5c, validé au push groupé |
| 7 | P0 | Tarifs : 3 formules exactes (Pass 500/6, Pro 3000/90, Boutique 7500/200), paiement 501 honnête | **TERMINÉ** — e47262a (SSOT 05_TARIFICATION.md ; écart fair_use → résolu par §4 ci-dessous) |
| 8 | P1 | Formulaires : WhatsApp international (+229/+33/+1), prix stable au clavier | **TERMINÉ** — 6d1ad6a (détail 08_FORMULAIRES.md) |
| 9 | P1 | Écran de bienvenue | **TERMINÉ** — d88dbbf (détail 09_BIENVENUE.md) |
| 10 | — | Design system : harmonisation (bleu marine/orange, typo, espacements) | **EN COURS (§6)** — perdu au rollback (PiedContinuer 52 dp + 10_DESIGN_SYSTEM.md), à recréer puis étendre |

## Directive finale §1-§12 — chantiers transverses

- **§4 Quota Pro 90/30 j RÉELLEMENT appliqué** : ENGAGÉ (patch worker non committé) —
  `PLAN_EXPORTS_LIMITS {pass24h:6, pro:90, boutique:200}` + `PLAN_CLOUD_LIMITS {1,5,20}`,
  helpers purs `planPeriodStart`/`decideQuota`, `routeQuotaConsume` réécrite
  (attribution SERVEUR : plan actif → repli bienvenue → refus ; contrôle atomique
  `INSERT OR IGNORE … SELECT … WHERE count < limite` ; idempotence event_id),
  `routeMyEntitlements` expose `plan_exports_used/left`, tests `quota_unit.mjs` 21/21
  + SQL validé SQLite réel (90e OK / 91e refusé / rejeu dup / cloud séparé).
  Pass 6, Boutique 200, cloud 1/5/20 ; crédits bienvenue/parrainage intouchés ;
  501 honnête. À committer.
- **§5 Caméra** : reprendre UNIQUEMENT la récupération d'artefacts (fix v2 perdu :
  adb root + sleep 3 + 4 rapports JSON + PNG + emulateur=true + luminance/quadrants).
- **§6 Design system** : harmonisation sans refonte (Lot 10 + boutons/champs/cartes/
  typos/espacements/couleurs/rayons/badges/états) — tests ciblés des consommateurs.
- **§7** Vérifier les 10 lots avec preuves réelles (compile ≠ terminé).
- **§8 Galerie** `docs/checkpoints/D42_32/visual-review/` — squelette perdu, à recréer.
- **§9** Non-régression ciblée groupée, résultats rattachés au commit exact.
- **§12 PORTE** : approbation visuelle fondateur APRÈS galerie ; RC15 immuable ;
  Phase C (APK signée, E2E sur l'APK exacte) seulement après approbation.

## Règles actives

- Corrections minimales par RCA démontrée ; tests ciblés par lot ; campagne groupée
  en fin de Phase A (justifiée par périmètre réellement modifié).
- Contrats serveur : crédits bienvenue/parrainage INTACTS ; 501 billing_not_configured honnête.
- Pas de modification des 600 compositions audio. Pas de CinetPay. Budget 0 FCFA.
- GitOps : chaque lot = diff contrôlé + tests + doc + commit descriptif + push + HEAD vérifié.
- Captures authentiques non retouchées, identifiées émulateur ; FLAG_SECURE documenté
  jamais contourné. FR/EN seuls sur le parcours commercial.

## État courant — PHASE B LIVRÉE, ARRÊT À LA PORTE

- **HEAD local = distant = `a799c50`** + commit galerie (ce push). Chaîne
  complète D42.32 : `2a19d49` → ae64aa1 (§4) → 95d0734 (Lot 10) → 765c841
  (squelette) → 905a4f6 (caméra v2) → ac29fdd (§6) → 33abc37 → 2a9ad15 (403 +
  v3) → 163e215 (caméra v4 + preuves) → a799c50 (workflow galerie + harnais
  adapté) → **commit galerie §8**.
- **Laboratoire VERT sur le candidat** : e2e-lab **43582492529 (a799c50) =
  SUCCESS 15/15** — camera-diagnostic v4 PASS (2 rapports 4 sources,
  emulateur=true, 10 PNG, **2 MP4 réels 443/430 Ko**), auth-local 22/22,
  backend-http (quota 21/21), pixel5 23 PASS, camerap, offline, offline-export
  (41 PASS + export.mp4 + vitrine-local.db), drafts, langues EN, petit-écran
  (60 PNG), security, gabarits-audit, selftest. android-ci SUCCESS.
- **Galerie §8 LIVRÉE** (`visual-review/`) : README illustré **80 images**,
  86 entrées de manifeste (FR base 31 + suite 26 + EN 50 + e2e-lab, toutes du
  candidat a799c50), 21 sections miroir D42.31, BEFORE_AFTER 12 corrections
  (liens avant RC15 ↔ après candidat), UX_AUDIT 7/7 CORRIGÉ+CAPTURÉ, RUNS.md
  (runs + artefacts + RCA caméra 4 runs), gaps documentés (FLAG_SECURE,
  PNG vides swiftshader, audio automatique, scène AVD), preuves quota
  (Room CONFIRMED balanceAfter=2), export-tire-candidat.mp4 (4,4 Mo).
- **Réserves portées au fondateur** : capteur physique (toutes captures
  caméra ÉMULÉES), FLAG_SECURE (dumps + MP4 réel), RC15 immuable.
- **PORTE D'APPROBATION : EN ATTENTE DU FONDATEUR** (§12). Aucune RC16
  construite. Après accord : Phase C (APK signée, checksum, E2E sur l'APK
  exacte, release GitHub, test capteur physique fondateur).

## Prochain travail

1. ~~Phase A (Lots 1-10 + §4 + §6)~~ ✓ · ~~non-régression groupée 15/15~~ ✓ ·
   ~~galerie §8~~ ✓ · ~~checkpoint final~~ ✓.
2. **ARRÊT** : attendre l'approbation visuelle du fondateur sur la galerie.
3. Après accord : Phase C (signature officielle, E2E APK exacte, release,
   capteur physique) — jamais avant.
