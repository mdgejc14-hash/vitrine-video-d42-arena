# D42.34 — Lot 6 · Non-régression (preuves exécutées)

## Validation locale complète — commande CI exacte

`./gradlew ktlintCheck detekt testDebugUnitTest checkModuleGraph --continue`
(sans daemon, 1 worker) — **BUILD SUCCESSFUL**, base 139e4b3.

### Résultats par module (XML JUnit agrégés)

| Module | Tests | Échecs |
|---|---|---|
| core-guard | 27 | 0 |
| core-model | 11 | 0 |
| data | 82 | 0 |
| feature-brief | 25 | 0 |
| feature-camera | 17 | 0 |
| feature-catalog | 18 | 0 |
| feature-dashboard | 37 | 0 |
| feature-export | 7 | 0 |
| feature-onboarding | 31 | 0 |
| ins-capture | 4 | 0 |
| ins-effects | 99 | 0 |
| ins-thermal | 2 | 0 |
| **TOTAL** | **360** | **0** |

ktlint : 0 violation · detekt : 0 violation · checkModuleGraph : OK ·
`:app:compileDebugKotlin` + `:app:compileDebugAndroidTestKotlin` : OK.

### CI distante (GitHub Actions, android-ci)

- 8bb3dcc (Lots 1+2) : run 43701266188 **SUCCESS**
- 01f1044 (Lots 1→4 + correctif seed) : run 43703917910 **SUCCESS**
- 139e4b3 (Lot 5) et commit final : vérifiés au push (voir 00_PLAN_ET_ETAT.md)

## Invariants préservés (vérifiés, aucun reset destructif)

| Invariant | Preuve |
|---|---|
| 30 gabarits, IDs canoniques, JSON inchangés | aucun fichier `data/src/main/assets/gabarits/` modifié (diff des commits) ; `D34SeedRoomRegressionTest` : 30 summaries seedés, rawJson non nul |
| `nombre_scenes` jamais modifié | aucun code ne l'écrit ; libellé UI = prises (Lot 1), compteur HUD = prises (Lot 3) |
| Moteur de composition protégé | ExportWorker : seuls ajouts = jalons `KEY_PHASE` + refactors d'extraction (verdictRepli/espaceStockageInsuffisant) — aucun pipeline/effet modifié ; ins-effects 99/99 |
| 600 compos audio | aucun fichier audio touché ; BgmStore/mixeur inchangés |
| Contrats serveur inchangés | aucun contrat modifié ; bootstrap/checkout appelants uniquement |
| CinetPay 501 `billing_not_configured` | startCheckout inchangé, message discret existant conservé |
| RC15 immuable / pas de push main / pas d'APK signé / pas de RC16 | aucun push main (ls-remote : main = bb759f8) ; aucune release créée |
| D42.33 galerie + visuel | aucun fichier `docs/checkpoints/D42_33/` ni ressource D42.33 touché (hors 3 drawables carrousel + 3 logos, cible explicite de l'ordre CR-5) |
| Parcours générique brief/caméra | BriefScreen + GuidedShootingOverlay intacts (mode libre inchangé) |
| Quotas/crédits/brouillons/auth/export | portes et stores inchangés (seule lecture `merchant_name` ajoutée côté prefs session) |

## Couverture des défauts fondateur D42.34

| Défaut (CR) | Correction | Preuves |
|---|---|---|
| CR-1.1 secteur perdu → 30 mélangés | `restaurerSession()` relit `sector` ; état explicite `EtatSecteurPerdu` | D34-01/02 + `D34Lot1CatalogVisualCheckTest` 3/3 |
| CR-1.2 « 15 scènes » au lieu des prises | libellé « N s · N prises guidées », pellicule par prise | D34-03 + test 3/3 |
| CR-2 import rushs impossible (T5) | picker gabarit + slots + fusion filmée>importée | D34-04/05/06 + `RushsImportTest` 7/7 + `D34Lot2BriefImportVisualCheckTest` 3/3 |
| CR-3 double parcours caméra « Scène 1/26 » | guide générique supprimé en mode gabarit, états explicites, HUD prise seul | D34-07→10 + `D34Lot3CameraStatesVisualCheckTest` 4/4 |
| CR-3 bis « Scène 1/0 » | compteur seulement si scènes réelles | D34-09 |
| CR-3 ter seed Room CI | `seedIfEmpty` deux formes de listing | `D34SeedRoomRegressionTest` + Lot2CameraActivity 3/3 |
| CR-4 identité inventée/déduite | displayName Google réel + repli nom_commerce, jamais d'email | audit 05 + compilation/dashboard 37/37 |
| CR-4 bis CTA paywall morts | « Choisir … » actifs ×3, checkout réel branché | `PaywallUiCheckTest` (spec D42.34) |
| CR-4 ter % montage inventés | phases métier réelles, barre indéterminée conservée | feature-export 7/7 |
| CR-5 carrousel 3 mêmes personnes | 3 métiers Drive D, textes inchangés | D34-11 + test 2/2 |
| CR-5 bis logo non officiel (splash/marque) | mark.png officiel reconstruit (silhouettes mesurées 125/255 ≠ avant) | D34-12 + mesures PIL 07 |

## Limites honnêtes restantes (documentées, pas masquées)

1. **Images de maquette** : licences à acquérir ou photos propres avant Play
   Store (CREDITS_PHOTOS.md) ;
2. **Import rushs = vidéos uniquement** (le moteur compose des rushs vidéo ;
   photo demanderait une évolution moteur non justifiée par l'ordre) ;
3. **Nom de package (capture fondateur 020028)** : aucune occurrence dans le
   code caméra (recherche exhaustive) — à re-localiser sur téléphone si le
   défaut persiste (probable dialogue système OEM) ;
4. **E2E instrumenté** (`renduTemoignageSlotsImportes`, `rendusDeProduction`)
   : requiert émulateur/appareil — non exécutable dans la sandbox CI, à
   lancer sur le banc avant publication ;
5. Splash : durée/animation système non observables en Robolectric (thème
   API 31+) — vérification fondateur sur téléphone requise.
