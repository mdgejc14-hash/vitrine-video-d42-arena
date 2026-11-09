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
| 1.10 | Deep-link parrainage bout-en-bout (§3) | **PASS** | Run 42647493665 (83da04e) : **7/7** — ACTION_VIEW https://vitrine.video/r/AKWABA-100 résolu vers l'app ✓, « Code parrain détecté : AKWABA-100 » AFFICHÉ à l'écran auth ✓, étape parrainage champ PRÉ-REMPULI ✓, parcours complet post-lien (catalogue) ✓, app vivante ✓, zéro crash ✓ ; rejet propre des codes non conformes prouvé au passage (runs précédents) |
| 1.11 | Auth Google Credential Manager (§2) | **PASS (lab)** | Vrai flux Credential Manager sur image playstore ✓, échec PROPRE : message + bouton « Réessayer » réactivé ✓, repli hors-connexion intact ✓, re-soumission après échec (resoumis=3, écran+logcat) ✓, parcours continué ✓, zéro crash, 32 lignes de journal VV-AUTH ; **11/11 au run 42647493665** (A0_langue multi-langues) ; **choix de compte réel = compte physique fondateur (hors lab)** |
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
| 6.1 | Compilation + lint + tests JVM tous modules | PASS | android-ci SUCCESS : 42647493287 (83da04e), 42658870561 (ea0edde), 42635348927 (7a7c06a), 42626010571 (988fa48), 42619094767 (200b8a6) |
| 6.2 | e2e-lab 13→15 jobs | **PASS** | 42619096543 SUCCESS 13/13 ; 42626010820, 42635563154, 42641946124 (drafts 36/36), 42647493665 (deeplink 7/7, auth 11/11), 42658870536 : SUCCESS 15/15 |
| 6.3 | Build local avant push (règle 1143bfe) | PASS | assembleDebug+ktlint+tests SUCCESS avant chaque push (05/05b/05c/05d/08/08c) |
| 6.4 | RC12 signé officiellement | **PASS** | Build d42.27-build-rc12 → 83da04e (42652646514 SUCCESS) ; re-signature locale cert 758077eb…33e192 (verify --print-certs conforme) ; APK ef85cff7…0655 (44 124 921 o) ; **release-official-e2e 42658920860 SUCCESS 41/41** (certificat constaté en CI, parcours P1 complet, export 7 536 097 o, ffprobe h264+aac 34,99 s, écran éteint 45 s, partage, zéro crash) ; release d42.27-rc12 (APK+mapping+checksums) |

## 7. Décisions fondateur intégrées

- C/D/E (bascule, brouillons, stockage) : IMPLÉMENTÉS (1.6/1.9/2.4).
- Régénération manifeste : FAITE sans détruire les références (3.2).
- Les 600 compositions : INTACTES (corrections 7.7/7.8 proposées seulement).
- 0 FCFA dépensé (uniquement runners GitHub inclus).

## 8. Bilan final D42.27 (§14)

**QUALIFICATION LOGICIELLE INTÉGRALE LIVRÉE — RC12 publiée avec preuves.**

- Lignes PASS prouvées par runs cités : 1.1–1.9, 1.10, 1.11 (lab),
  2.x, 3.x (gabarits 818, audio 600 audités), 4.1–4.2, 5.x, 6.1–6.4.
- PARTIAL documenté : export/sync post-retour réseau (preuves serveur
  existantes, e2e dédiée manquante) ; choix de compte Google réel
  (compte physique fondateur, hors lab).
- FAIL-DOCUMENTÉ (corrections proposées, en attente d'autorisation
  fondateur — les 600 compositions restent intactes) : silence initial
  ≥ 1,03 s ; 54/60 clés titulaires B2 en 404.
- NOT RUN volontaire : SKYPAY (501, décision fondateur).
- Release : https://github.com/mdgejc14-hash/vitrine-video-d42-arena/releases/tag/d42.27-rc12
- Journal complet : 11_RC12_JOURNAL.md. 0 FCFA dépensé.
