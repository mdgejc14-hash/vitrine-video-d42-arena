# D42.27 — PLAN ET AUDIT DE CONTINUITÉ (démarrage depuis D42.26)

**Règle §1 appliquée** : reprise depuis le dernier checkpoint validé, aucun
travail déjà validé ne sera recommencé.

## 1. État retrouvé (audit du 09/11)

- **Dernier checkpoint** : `e68d23c` (D42.26-29) = HEAD = origin/main, dépôt
  clean, aucune session parallèle. Matrice D42.26 : 12.3 LIVRÉ, 0 EN
  VALIDATION, 0 BLOCKED ; code validé par **6 runs e2e-lab consécutifs
  complets** (42562414209 → 42588575128, tous 12/12 SUCCESS : P0 5/5 zéro
  défaut, camerap 42/0/0, P1 36/0/0, offline 14/0/0).
- **Runs post-clôture constatés** : android-ci + e2e-lab sur e68d23c
  SUCCESS ; backup D1→B2 42604279360 SUCCESS (09/11 10:51). Cron audio
  one-shot désarmé (aucun run parasite) ✓.
- **Confirmation fondateur D42.27** : SKYPAY reste 501
  billing_not_configured (seule fonctionnalité volontairement non
  configurée). Tout le reste doit être implémenté/testé/prouvé.
- **Moyens vérifiés** : keystore officiel présent hors dépôt
  (`/home/user/vvprod/vv-signing/vitrine.keystore` + signing.properties,
  jamais commité) ; clone production local `vvprod` (branche
  d42.23-production) avec **clé Firebase RÉELLE** (AIzaSyCKxfTh…, projet
  609889830251) ; l'arène utilise exprès la clé LABO (AIzaSyD42LAB…) ;
  image émulateur CI = API 30 google_apis (GMS présent → vrai flux
  Credential Manager testable au lab).

## 2. Preuves D42.26 CONSERVÉES (ne pas relancer)

UI 9.x (5/5 variantes zéro défaut ×6) · P1 36/0/0 · offline 14/0/0 ·
camerap 42/0/0 (permissions refusées + rushs réels + Refaire +
conservation) · gabarits 817 contrôles · audio 600/600 (sha256 + acoustique
détaillée INTÉGRALE : RMS/peak/silence mesurés sur les 600) · parrainage
API (8.3-8.7 : unicité, attribution, anti-doublon, anti-fraude simple,
historique, sync, isolation) · crédits/quota serveur (aucune fabrication
client) · backup + restore drill 24/24 tables · test JVM réseau 3.11 ·
12.2 méthode + empreintes (758077eb…e192 / 89fab9b6…d8a3) · SKYPAY 501.

## 3. Exigences SANS preuve suffisante → travail D42.27

| # | Exigence | État D42.26 | Action D42.27 |
|---|---|---|---|
| A | Bascule caméra avant/arrière (5.4) | FAIL-documenté (arbitrage C) | **IMPLÉMENTER** (fondateur : « terminer les fonctionnalités manquantes ») |
| B | Brouillons inter-sessions (4.6) | PARTIAL (arbitrage D) | **IMPLÉMENTER** (§7 : brief, scènes, relance, reprise, fin montage) |
| C | Contrôle préventif stockage (5.7) | PASS-partiel (arbitrage E) | **IMPLÉMENTER** (§8 : avant enregistrement/téléchargement/montage/export + message) |
| D | Garde bind caméra (5.8) | limite code documentée | **CORRIGER** (runCatching + message) |
| E | Auth Google réelle (2.x, §2 priorité absolue) | CONDITIONAL | Pousser au maximum : vrai flux Credential Manager sur émulateur GMS (bottom sheet), refus/annulation/erreurs ; distinguer API A/B ; session restore/expiration déjà prouvées serveur ; **le choix de compte réel exige un compte Google = fondateur/physique** |
| F | Parrainage deep-link bout-en-bout (§3) | ouverture navigateur/autre appareil non prouvée | **TESTER** : adb VIEW https://vitrine.video/r/CODE → parcours ; copie/partage = UI |
| G | Manifeste gabarits périmé (D9) | WARN (30 manquants + 4 modifiés) | **RÉGÉNÉRER** (sans détruire les fichiers ; fondateur l'autorise §5) |
| H | Rapport couverture 30 gabarits (§5) | 817 contrôles diffus | **PRODUIRE** le rapport par gabarit |
| I | Matrice musique-gabarit (§6) | variations/musique | **PRODUIRE** : 20 variations/gabarit, correspondance secteur, anti-répétition, pistes analysées (= 600/600 détaillées), FAIL identifiés (7.7 silence, 7.8 clés) + corrections PROPOSÉES (pas exécutées) |
| J | Matrice offline (§9) | 14 tests | **PRODUIRE** la matrice accessible-sans-Internet / cache / connexion / sync + perte/retour réseau par étape critique |
| K | RC12 (§13) | dossier rédigé | **CONSTRUIRE + SIGNER + VÉRIFIER + RELEASE** (merge arène→production local, clé réelle, keystore officiel, vérifs certificat/ZIP/sha256/mapping, lien release) |
| L | Matrice finale D42.27 (§14) | — | **PRODUIRE** (PASS/PARTIAL/FAIL/BLOCKED/NOT RUN + commit+workflow+résultat+artefact) |

## 4. Ordre d'exécution (isolée + testée + checkpoint chacune)

1. D42.27-01 : ce document.
2. D42.27-02 : bascule caméra (A) — binder sélecteur + bouton + 4 langues.
3. D42.27-03 : garde bind (D).
4. D42.27-04 : contrôle stockage (C) + test JVM.
5. D42.27-05 : brouillons (B) — Room + sauvegarde + reprise + harnais.
6. D42.27-06 : manifeste gabarits régénéré (G) + audit vert.
7. D42.27-07 : auth lab (E) — vrai bottom sheet + refus/erreurs.
8. D42.27-08 : deep link (F).
9. D42.27-09 : rapports H/I/J.
10. D42.27-10 : matrice finale (L).
11. D42.27-11 : RC12 (K) + release officielle.

Chaque lot est poussé puis validé par le lab (runs e2e-lab existants —
aucun nouveau quota payant, 0 FCFA). Les compositions audio ne sont pas
touchées. Aucun secret n'entre dans le dépôt.
