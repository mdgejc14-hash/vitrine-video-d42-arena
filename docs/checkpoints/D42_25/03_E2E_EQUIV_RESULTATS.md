# D42.25 — 03. E2E-ÉQUIVALENT : RÉSULTATS COMPLETS (run 42482295447, SUCCESS)

**Run** : `android-e2e-production-equivalent` **42482295447** — attempt 2,
commit `0a5d2bb`, conclusion **SUCCESS** (08/11, terminé 14:08 UTC).
Premier passage complet et vert de l'histoire du miroir (attempt 1 :
DeadSystemException émulateur pré-app — flake infra, aucun rapport avec
l'APK).

**APK équivalente** : `app-release.apk`, 44 112 105 o,
sha256 `e94143eb964900faa90bf5d36a997134446ce2519e8f75299bc9bcbbe063cb64`
— R8, **clé Firebase réelle prouvée en comparaison binaire du dex**,
signature de recette (cert régénéré, empreinte vérifiée par apksigner),
tests unitaires feature-export (porte intégrité) PASS au préalable.

## P0 — parcours utilisateur (5 scénarios, 3 variantes)

| Variante | PASS | FAIL | BLOCKED | Lecture |
|---|---|---|---|---|
| pixel5-base | **22** | 0 | 0 | nominal parfait |
| pixel5-font130 | **23** | 0 | 0 | police 130 % : parfait |
| pixel5-rot90 | 17 | 3 | 3 | rotation : défauts d'accessibilité |
| petit_ecran-small (540x960) | 13 | 1 | 4 | petit écran : défauts d'accessibilité |

Échecs (agrégés rot90 + small, détails dans artefacts `pixel5-rot90/` et
`petit_ecran-small/`) : S09 écran d'activité non atteint, S04b bouton
principal introuvable même après défilement, S10 bouton Continuer absent ou
hors écran, S11 bouton perdu après défilement ; bloqués : S06 carrousel,
S12 carte secteur, S14/S15 parrainage, S17 catalogue.
**Ce sont des défauts UI réels d'accessibilité (rotation, petit écran) —
consignés tels quels, à traiter en lot produit ultérieur ; ils ne
compromettent pas le parcours nominal.**

## P1 officiel (harnais run_official_e2e.sh, caméra émulée) — 37 PASS / 0 FAIL

- Brief accepté → écran « Avant de commencer » ✓
- Écran « Filme ta prise » (caméra virtuelle émulateur) ✓
- Porte de consentement R4 : aucune affichée sans visage ✓
- **Tournage guidé : 3 prises enregistrées** (démarrage/arrêt/reprise,
  2 contrôles + guide terminé) ✓
- Rushs `rush-*.mp4` présents et non vides ✓
- Aperçu E7 atteint, « Créer ma vidéo » actionné → E8 ✓
- Export lancé, **notification du canal `vv_export`** (foreground service,
  dumpsys) ✓
- **Export poursuivi 45 s écran éteint** (réveil OK) ✓
- **« Vidéo prête ! » — export-0.mp4 = 9 158 574 octets** ✓
- Feuille de partage Android ouverte (partage WhatsApp-eligible) ✓
- **Aucune FATAL EXCEPTION** (logcat propre) ✓
- **Crédits serveur : journal 1 ligne, dernier état CONFIRMED, solde 2
  (attendu CONFIRMED/2) — PASS** ✓

## Ce que ça qualifie

- La chaîne produit de bout en bout sur APK RELEASE R8 (clé réelle) :
  onboarding → Google → brief → tournage guidé → montage auto → MP4 →
  partage → crédits serveur, **sans crash**.
- Le MP4 exporté est réel et vérifié (ffprobe PASS à l'étape dédiée).
- La qualification **par équivalence** de la rc11 (P2) est massivement
  renforcée : même code, même R8 (mapping identique au sha256 près — voir
  checkpoint 02), comportement e2e complet vert.
- Artefacts conservés 14 jours : captures/dumps/summary + mapping.txt
  (JAMAIS l'APK).

## Suites (hors périmètre du vert ci-dessus)

- Défauts d'accessibilité rot90/petit écran : à inscrire au backlog produit
  (lot D42.26+), preuves dans les artefacts.
- La signature reste de recette (l'officielle est privée) : la release
  finale rc11 (certificat officiel) reste la référence distribution.
