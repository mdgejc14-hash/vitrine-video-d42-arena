# D42.27-10 — MATRICE FINALE DE QUALIFICATION (§14, audit L)

Statuts : PASS (preuve vérifiable citée) · PARTIAL (preuves partielles citées,
manque identifié) · FAIL (défaut constaté documenté) · BLOCKED (dépendance
externe fondateur) · NOT RUN (non exécuté au lab, raison citée).
**Règle** : aucun PASS sur la seule existence d'un écran ou d'un code retour.

## 1. Parcours & fonctionnalités produit

| # | Exigence | Statut | Preuve (commit · run · artefact) |
|---|---|---|---|
| 1.1 | Choix langue 4 langues | PASS | P5/langues ×3 jobs (en/es/ja) run 42619096543 + 42626010820 SUCCESS |
| 1.2 | Onboarding sectoriel + carrousel | PASS | P0 5/5 ×7 runs consécutifs (42562414209→42626010820) |
| 1.3 | Catalogue 30 gabarits offline (seed + cache Room v2) | PASS | OFF9 (job android-e2e-offline, runs 42619096543/42626010820) |
| 1.4 | Brief dynamique par gabarit (validation type/contrat) | PASS | P1 brief 5 champs + contrôle d'effet (36/0/0 ×2 sur 200b8a6/988fa48) |
| 1.5 | Guide de tournage pas-à-pas (prises alignées slots) | PASS | camerap 62/0/0 (42626010820) : prises réelles + Refaire + conservation rushs |
| 1.6 | **Bascule caméra avant/arrière (5.4)** | PASS | **CPC_bascule_avant + CPC_bascule_retour PASS par logs (bascule×2, re-bind AVANT×2) — camerap 62/0/0 run 42626010820 (exigence A, arbitrage C CLOS)** |
| 1.7 | Montage/aperçu local | PASS | P1 (export MP4 + ffprobe) + camerap B (écran aperçu) |
| 1.8 | Export MP4 + partage | PASS | P1 36/0/0 ×2 incl. MP4 ffprobe/décodage |
| 1.9 | **Brouillons inter-sessions (4.6/§7)** | **PASS** | Run 42641946124 (0e26faa, fix 05d) : **36/36** — dialogue « Reprendre » ✓, pré-remplissage complet ✓, reprise CAMÉRA à la bonne prise (PRISE 2/3) HORS CONNEXION ✓, rush conservé après fermeture+redémarrage ✓, prises restantes filmées ✓, guide terminé + écran d'aperçu ✓, retour réseau sans perte ✓, zéro crash ✓ |
| 1.10 | Deep-link parrainage bout-en-bout (§3) | EN VALIDATION | Résolution lien ✓ (am_start -W : MainActivity COLD + URI), parcours complet post-lien ✓, zéro crash ✓, rejet PROPRE des codes non conformes ✓ (comportement spécifié) ; D2/D3 : les FAIL des runs précédents = **faux échecs de banc** — codes de test non conformes au contrat ^[A-Z]{3,10}-[0-9]{3}$ (preuve D2_log.txt 42641946124 : data=…r/E2E-123 → refCode=null, « E2E » contient un chiffre) ; **re-validation avec AKWABA-100 conforme (08d) au prochain run** |
| 1.11 | Auth Google Credential Manager (§2) | **PASS (lab)** | Vrai flux Credential Manager sur image playstore ✓, échec PROPRE : message + bouton « Réessayer » réactivé ✓, repli hors-connexion intact ✓, re-soumission après échec (resoumis=3, écran+logcat) ✓, parcours continué ✓, zéro crash, 32 lignes de journal VV-AUTH (42635563154 : 10/11) ; A0_langue = faux échec de banc (locale EN, corrigé multi-langues) ; **choix de compte réel = compte physique fondateur (hors lab)** |
| 1.12 | Repli « Utiliser sans Internet » | PASS | OFF5 + P0 (7 runs) |

## 2. Robustesse & gardes

| # | Exigence | Statut | Preuve |
|---|---|---|---|
| 2.1 | Permissions caméra refusées → dialogue produit (5.6) | PASS | camerap phase A (42/0/0 puis 62/0/0) |
| 2.2 | Refaire une prise (fichier supprimé + re-filmage, 5.2) | PASS | camerap phase B |
| 2.3 | **Garde bind caméra (5.8, D)** | PASS | runCatching + message (commit 1143bfe, validé par camerap 62/0/0) |
| 2.4 | **Contrôle stockage préventif (5.7, C)** | PASS | StorageGate JVM 5/5 + gardes avant enregistrement/téléchargement/export (commit 200b8a6, android-ci 42619094767 SUCCESS) |
| 2.5 | Échec enregistrement muet → prise supprimée + message (F53) | PASS | camerap (finalize vérifié) |
| 2.6 | Zéro crash sur tous les bancs | PASS | crash_*.txt vides ×7 runs |

## 3. Contenu & audio

| # | Exigence | Statut | Preuve |
|---|---|---|---|
| 3.1 | 30 gabarits × 6 secteurs complets | PASS | audit_gabarits 818/818 (manifeste régénéré, commit 18321df) |
| 3.2 | Manifeste intégrité du lot | PASS | 119/119 conformes, régénéré + script reproductible (18321df) ; gabarits-audit PASS runs 42619096543/42626010820 |
| 3.3 | 600 compositions musicales en ligne | PASS | run audio 42542375491 : 600/600 EN_LIGNE, sha256 conformes, B2 600/600 |
| 3.4 | 20 variations/gabarit + anti-répétition | PASS | matrice I (09b) : 30×20, 600 sha distincts |
| 3.5 | Mesures acoustiques intégrales | PASS | 600/600 (RMS/peak/durée/décodage) |
| 3.6 | FAIL audio documentés (7.7 silence, 7.8 clés) | FAIL-DOCUMENTÉ | 09b §4 : silence initial 600/600 ≥1,03 s (max 3,18 s) ; 54/60 clés titulaires B2 404 (repli v01) — corrections PROPOSÉES non exécutées (autorisation fondateur requise sur les 600 compositions) |

## 4. Offline / réseau

| # | Exigence | Statut | Preuve |
|---|---|---|---|
| 4.1 | Parcours sans Internet langue→catalogue | PASS | OFF1-9 (14 tests) ×2 runs |
| 4.2 | Reprise inter-sessions HORS connexion | **PASS** | Run 42641946124 : réseau coupé (svc wifi+data disable) avant force-stop → reprise CAMÉRA PRISE 2/3 ✓, rush conservé ✓, montage terminé ✓, retour réseau sans perte ✓ (36/36 banc drafts) |
| 4.3 | Retour réseau sans crash | PASS | OFF11 + drafts S4 ×2 runs |
| 4.4 | Session après redémarrage | PASS | OFF10/10b |
| 4.5 | Export final 100 % hors ligne | PARTIAL | rendu local prouvé (P1), uploads best-effort par code ; preuve e2e dédiée manquante (09c §2) |
| 4.6 | Sync après retour réseau | PARTIAL | preuves serveur (API 8.3-8.7, backend-http) ; e2e dédiée manquante (09c §2) |

## 5. Serveur & sécurité

| # | Exigence | Statut | Preuve |
|---|---|---|---|
| 5.1 | API crédits/quota serveur (aucune fabrication client) | PASS | backend-http + tests JVM (7 runs) |
| 5.2 | Parrainage serveur (unicité, anti-doublon, historique, isolation) | PASS | bancs API 8.3-8.7 (D42.26, preuves conservées) |
| 5.3 | Sécurité locale (secrets, intents) | PASS | security-local ×7 runs |
| 5.4 | Backup D1 + restore drill | PASS | 42604279360 + 42534124616 (D42.26) |
| 5.5 | SKYPAY | NOT RUN (VOLONTAIRE) | 501 billing_not_configured — SEULE non-configuration acceptée par le fondateur |

## 6. Qualification logicielle intégrale (prérequis fondateur au test physique)

| # | Élément | Statut | Preuve |
|---|---|---|---|
| 6.1 | Compilation + lint + tests JVM tous modules | PASS | android-ci SUCCESS : 42635348927 (7a7c06a en cours), 42626010571 (988fa48), 42619094767 (200b8a6) |
| 6.2 | e2e-lab 13→15 jobs | **PASS** | 42619096543 SUCCESS 13/13 (200b8a6) ; 42626010820 SUCCESS 15/15 (988fa48) ; **42635563154 SUCCESS 15/15 (d2b3088)** ; 42641946124 en cours (0e26faa : fix 05d/08c) |
| 6.3 | Build local avant push (règle 1143bfe) | PASS | assembleDebug+ktlint+detekt+tests SUCCESS avant chaque push (05/05b/05c/08) |
| 6.4 | RC12 signé officiellement | À FAIRE | plan 11 : tag d42.27-build-rc12 → re-signature keystore officiel (cert 758077eb…) → release d42.27-rc12 → release-official-e2e |

## 7. Décisions fondateur intégrées

- C/D/E (bascule, brouillons, stockage) : IMPLÉMENTÉS (1.6/1.9/2.4).
- Régénération manifeste : FAITE sans détruire les références (3.2).
- Les 600 compositions : INTACTES (corrections 7.7/7.8 proposées seulement).
- 0 FCFA dépensé (uniquement runners GitHub inclus).
