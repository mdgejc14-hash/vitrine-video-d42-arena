# Carte & Graphe de Navigation — Vitrine Vidéo (règle « Zéro Cul-de-Sac »)

Orchestration centrale : `MainActivity` (wizard `startActivityForResult`).
Règle de graphe projet : aucune transition feature → feature directe
(`checkModuleGraph`), tout passe par l'orchestrateur.

## 1. Graphe d'écrans (nœuds & transitions)

```
            ┌──────────────────────────────────────────────────────────────┐
            │                    MainActivity (orchestrateur)              │
            └──┬──────────┬───────────┬───────────┬──────────┬──────────┬──┘
   REQ_LANGUAGE│ REQ_AUTH │REQ_ONBOARD│ REQ_CATALOG│ REQ_BRIEF│ REQ_CAMERA│
               ▼          ▼           ▼           ▼          ▼          ▼
          E1 Language  E2 Auth    E3 Onboarding  E4 Catalog  E5 Brief  E6 CameraGuide
          (4 langues)  (SSO 1-tap)(carousel →    (grille     (script,  (overlay guidé
                                   secteur →      filtrée     rushs     9:16, 3A, R4)
                                   welcome)       secteur)    galerie)      │
               │          │           │           │          │             │ OK(input)
               └─────────────────────┴───────────┴──────────             ▼
                    chaînage OK résultat → étape suivante          E7 ExportActivity
                                                                    (preview cinétique
                                                                     + WorkManager)
```

Transitions avant (résultat `RESULT_OK`) :
E1 → E2 → E3 → E4 → E5 → E6 → E7. Chaque écran `finish()` après transmission de
son résultat (extras typés : `firebase_token/uid`, `ref_code`, `sector`,
`welcome_credits`, `skin_id/name`, `script`, `duration_s`, `client_rushes`, `input`).

## 2. Comportement exact du Retour natif Android (`stepBack()`)

| Écran E_n | Appui Retour (RESULT_CANCELED) | Comportement orchestré | État conservé |
|---|---|---|---|
| E1 Language | `finish()` orchestrateur | quitte l'app (premier écran : aucun précédent) | n/a |
| E2 Auth | relance E1 | change de langue possible | locale déjà sauvegardée |
| E3 Onboarding | relance E2 | SSO 1-tap rejouable (session Google silencieuse) | token/uid/ref en champs orchestrateur |
| E4 Catalog | relance E3 | corrige le secteur | token/uid/ref conservés |
| E5 Brief | relance E4 | corrige le gabarit | sector + credits conservés |
| E6 CameraGuide | relance E5 | corrige script/rushs | skin_id/name conservés |
| E7 Export | pile système | retour orchestrateur post-camera (parcours terminé) | n/a |

**Certification : aucun appui Retour ne crashe et n'éjecte vers l'accueil**
hors E1 (sortie volontaire). Implémentation : `MainActivity.stepBack(requestCode)`
+ relance chaînée avec extras restaurés (commit `980af43`).

## 3. Certification « Zéro Cul-de-Sac » (D19)

| Contrôle | Verdict | Preuve |
|---|---|---|
| Aucun bouton sans listener | ✅ | revue de code : chaque `Button`/`FilterChip`/`clickable` a un `onClick` réel (E1 langues, E2 SSO, E3 cartes+continue, E4 chips+cartes, E5 ajouter rushs+valider, E6 record/stop+modale R4 oui/non, E7 rendu) |
| Aucun écran bloquant | ✅ | chaque écran a ≥ 2 sorties (action valide + Retour natif) ; erreurs = messages explicites (`BriefValidator`, `camera_blocked`, `catalog_offline`) jamais de freeze |
| Parcours hors-ligne validable | ✅ | catalogue cache offline (`CatalogRepository` + bannière `catalog_offline`), export local WorkManager sans réseau, SSO = seul point réseau obligatoire (documenté) |
| Retours intra-écran | ✅ | E3 : carousel ←→ secteurs ←→ welcome dans la même Activity (back interne Compose) ; E4 : chips secteurs modifient le filtre sans quitter l'écran |

## 4. Restes assumés

- E7 Export : retour système vers l'orchestrateur post-camera (le rush est déjà
  transmis) ; un re-parcours complet repart de E1 — choix produit documenté
  (export = fin de chaîne, notification WorkManager prend le relais écran éteint).
- Dashboard (partage/exports précédents) hors wizard principal : accessible
  après export, non inclus dans la chaîne E1→E7.
