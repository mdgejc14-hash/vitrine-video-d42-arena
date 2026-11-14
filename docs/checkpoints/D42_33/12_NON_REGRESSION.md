# Famille 12 — Non-régression (audit du moteur, parcours, services, contrats)

**Statut : TERMINÉE — audit documenté sur fefd022, CI VERTE (43609958062).**
**Base de comparaison : bb759f8 (= origin/main, D42.32 clos) → fefd022, 18
commits, 149 fichiers (+6 783 / −1 265).**

## 1. Moteur fonctionnel — INTACT (fichiers absents du diff)

Vérifié par `git diff --name-only bb759f8..fefd022` : **aucune modification**
de :
- `ExportWorker`, `ExportActivity` (porte crédits/gateThen/compensation/
  observeExport/FLAG_SECURE — famille 08 n'a touché que les vues XML/Compose),
- `ins-effects/**` (mixeur audio, **600 compositions audio intactes**),
- `BackendSync`, Workers/D1/B2 (serveur, quotas, parrainage serveur,
  idempotence, sécurité — CinetPay toujours 501 honnête),
- `DraftStore`, gabarits/templates (**30 gabarits**), `AuthActivity`
  (Google Sign-In/Firebase — seul `activity_auth.xml` restylé),
- scripts sécurité (`security-ci.mjs` etc.), `gh_api.sh`.

## 2. Fichiers moteur touchés — 3, tous additifs et documentés

| Fichier | Changement | Famille |
|---|---|---|
| `app/.../MainActivity.kt` | +entrée `vv_reprise` (9 lignes, extra absent = démarrage inchangé) | 09 |
| `data/.../Daos.kt` | +2 requêtes LECTURE SEULE (`countSucceeded`, `lastSucceededTs`) | 09 |
| `feature-dashboard/.../DashboardActivity.kt` | câblage additif (relireDonneesProjet, surOnglet, relancerReprise, onLater) — sync/checkout/share/copie/dialogues intacts | 09/10 |

## 3. Parcours e2e — dépendances vérifiées présentes

- Chaînes : « Créer ma première vidéo », « Félicitations ! », « Continuer
  avec Google », « Choisissez un modèle de vidéo », « Filme ta prise »,
  « Verrouiller et enregistrer », « Changer de caméra », « Caméra prête »,
  « Créer ma vidéo » ✓ (grep direct).
- testTags : `welcome_cta`, `carousel_cta`, `sector_continue`,
  `refcode_field`, `refcode_continue`, `brief_continue`, `ready_ok`,
  `preview_create`, `dash_*`, `price_*`, `ref2_gauge` ✓.
- Les libellés §9.4 (« Félicitations ! », CTA bienvenue) ont été introduits
  en famille 04 **avec** la mise à jour des bancs (`run_p0.sh`,
  `run_gallery.sh` — repli sur l'ancien libellé inclus). Évolution
  volontaire de la refonte, pas une régression.
- Chaînes caméra : seules suppressions = `camera_faces_ok/ko` (labels
  techniques UI, famille 07, non référencées par les bancs — vérifié par
  grep à l'époque) et « (R4) » retiré de `camera_blocked` (dialogue
  ConsentGate intact).

## 4. Tests — aucun retrait, aucune désactivation

- `@Test` : **290 (bb759f8) → 296 (fefd022)** — uniquement des ajouts
  (ResponsiveA11yCheckTest ×6).
- Modifications de tests existants, toutes documentées dans les
  checkpoints : DashboardVisualCheckTest (header avatar : `dash_app_name`
  retiré, +`dash_tab_create/home`), PaywallUiCheckTest (prix « · N FCFA »,
  +solde 0/`paywall_later`), appelants `onChoose` nommés.
- CI verte fefd022 = ktlint + detekt + tests JVM/Robolectric de TOUS les
  modules + lint + graphe (run 43609958062).

## 5. Campagnes acquises (réutilisées, budget 0 FCFA — non relancées)

- e2e-lab instrumentés D42.32 : 43586092282 (b5a1462), 43582492529
  (a799c50) — parcours complets auth→export sur runner physique.
- android-ci : 43586092209, plus toute la chaîne D42.33
  (43602520884 → 43609958062, deux rouges diagnostiqués et corrigés).

## 6. Gouvernance — vérifiée

- **origin/main = bb759f8 inchangé** (aucun push main ; l'incident
  « commit local sur main » de la famille 10 a été corrigé avant tout
  push, main locale remise à bb759f8).
- **RC15 immuable** : release 442574529 (d42.30-rc15) intacte, tags
  inchangés, aucune RC16, aucun build/signature/publication.
- Budget 0 FCFA : aucun service payant, aucune capture contrefaite,
  FLAG_SECURE jamais contourné.

## Conclusion

La refonte D42.33 est **purement visuelle** : moteur, parcours, services et
contrats préservés ; les 3 incursions dans le code moteur sont additives,
minimales et documentées. Prête pour la galerie (famille 13) puis la porte
d'approbation.
