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

## État courant (réconciliation post-rollback)

- **HEAD local = distant = `2a19d49`**, arbre propre sauf patch §4 en cours
  (src/index.js, tools/e2e/quota_unit.mjs, workflow backend-http).
- **e2e-lab 43520993407 (2a19d49) = COMPLETED SUCCESS 15/15** : pixel5 23 PASS/0 FAIL,
  bienvenue 3/3, p1 brief + WhatsApp E.164, camerap TOUT PASS, petit-ecran 60 PNG,
  deeplink/offline/lang_en OK. Artefacts ids dans le journal de session.
- Commits locaux perdus au rollback (à recréer, diffs connus) :
  **Lot 10** (PiedContinuer 52 dp + 10_DESIGN_SYSTEM.md, couleurs HUD caméra + ambre
  BriefScreen:67 conservées), **squelette Phase B** (5 fichiers visual-review/ :
  README, GABARITS_INVENTAIRE.csv 30, SCREEN_INVENTORY.csv 18, BEFORE_AFTER.csv 12,
  UX_AUDIT.md 7 statuts), **fix caméra v2 §5**.
- Stash « debris pre-D42.30 rollback » présent — NE PAS pop.
- Tâche actuelle : §4 à committer → recréer Lot 10 + squelette Phase B + fix caméra v2
  → §6 harmonisation → push groupé + CI + §5 artefacts caméra → galerie §8 → rapport.
- Porte d'approbation : **FERMÉE** (galerie avant/après pas encore produite).

## Prochain travail (ordre)

1. Commit §4 (worker quota + quota_unit.mjs + CI backend-http) — présent working tree.
2. Recréer Lot 10 + 10_DESIGN_SYSTEM.md ; squelette visual-review/ ; fix caméra v2 §5.
3. §6 harmonisation design system + tests ciblés consommateurs.
4. Push groupé → android-ci + e2e-lab sur le commit candidat → §5 artefacts caméra.
5. Phase B : captures authentiques (émulateur identifié) → galerie avant/après complète.
6. Rapport §8 → **ARRÊT à la porte d'approbation fondateur** (avant toute RC16/Phase C).
