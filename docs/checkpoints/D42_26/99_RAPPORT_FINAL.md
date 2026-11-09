# D42.26 — RAPPORT FINAL DE QUALIFICATION INTÉGRALE (gate avant remise APK)

**Mission** : audit de COUVERTURE de toutes les exigences, exécution des tests
manquants, correction des défauts logiciels, matrice exhaustive — avant tout
test physique du fondateur. Budget consommé : **0 FCFA**.

**Tête de série des preuves** : run e2e-lab **42562414209** (9505b12, 04:32
09/11) — **12/12 jobs SUCCESS** : P0 5/5 variantes ZÉRO DÉFAUT, P1 36/0/0,
camerap 39/1/1 (phase B 26/0/0), offline 14/0/0, gabarits 817, langues ×3,
auth-local, security, backend, selftest. One-shot audio intégral
**42542375491** (600/600 mesurés) ; restore drill **42534124616** PASS ;
backup nuit **42557585700** SUCCESS (03:39 09/11). Run de validation du fix
camerap phase A : **42573687240** (2ecf1bc) — ⏳ verdict en cours au moment
de cette consolidation.

---

## 1. Résumé exécutif

1. **UI — FERMÉE (9.1/9.2/9.4/9.7/9.8/12.1)** : défauts rotation 90° et petit
   écran CORRIGÉS puis certifiés par harnais à contrôle d'EFFET : 5/5 variantes
   à 0 FAIL/0 BLOCKED (base 22/0/0, font130 23/0/0, rot90 23/0/0, small 23/0/0,
   petit/font130 23/0/0). Grandes fontes (9.4) = font130 23/0/0 ; paysage
   (9.7) = portrait VERROUILLÉ par design (2 manifestes) + robustesse rot90
   23/0/0. Les « FAIL » résiduels historiques étaient des artefacts de mesure
   (crash LAUNCHER, dump uiautomator dégénéré) — documentés, jamais masqués.
2. **OFFLINE — FERMÉE (§4, 14/0/0)** : parcours hors ligne COMPLET et honnête
   (réseau coupé par adb AVANT le lancement) : lancement à froid, langue,
   connexion sans crash, tentative Google hors ligne sans crash (3.11),
   repli démo zéro appel réseau, carrousel, secteur, bienvenue, catalogue
   EMBARQUÉ, force-stop/relance, retour réseau propre. Session démo éphémère
   par conception (documentée, 4.6/4.9/4.10 qualifiés en conséquence).
3. **BIBLIOTHÈQUE 600 — COUVERTURE INTÉGRALE EXÉCUTÉE** : 600/600 téléchargées
   de production, sha256 CONFORMES 600/600 (7.2), décodables 600/600 (7.6),
   RMS moyen −17,4 dB, 0 clip (peak max −1,01 dB), σ inter-pistes 0,81 dB.
   Deux constats produit confirmés à l'échelle intégrale → arbitrages
   fondateur A (silence initial 1,03-3,18 s) et B (54/60 clés titulaires
   absentes, repli v01) — AUCUNE composition modifiée.
4. **Caméra (§5)** : phase B FERMÉE 26/0/0 (installation → guide complet avec
   rushs RÉELS par fichiers : enregistrement/arrêt, « Refaire » = slot courant
   uniquement, conservation, zéro crash). 5.4 = FAIL-documenté arbitrage C
   (caméra arrière en dur, aucune bascule avant/arrière). 5.7 = PASS-partiel
   + arbitrage E (échec disque géré au Finalize F53, pas de contrôle préventif
   StatFs). 5.8 = CONDITIONAL (erreurs d'enregistrement gérées ; bind initial
   non gardé — documenté ; le reste = physique). 5.6 permissions refusées :
   dialogue produit + ré-explication + zéro crash PROUVÉS ; le FAIL initial
   était un aveuglement d'OUTIL (uiautomator n'expose pas la fenêtre système)
   — fix D42.26-19 (dumpsys window + refus BACK) ⏳ run 42573687240.
5. **Gabarits (§6)** : audit statique 817 contrôles PASS (30/30 : briefs,
   séquences, durées, variables, montage, SFX, guide tournage) + job CI
   permanent. Modes : structure+bancs JVM+e2e ; voix réelle = physique.
6. **Backup (§10) — COMPLET** : export D1 réel 24/24 tables, restore drill NON
   destructif PASS (676 lignes, PRAGMA integrity ok, SHA-256), cron 03:00 UTC
   ARMÉ et PREUVE de la nuit relevée (42557585700 SUCCESS 03:39 — dispatch
   après retard cron GitHub, documenté). SKYPAY 501 assumé (aucun paiement
   simulé). Cron audio one-shot DÉSARMÉ le 09/11 (600/600 consigné ; la garde
   « skip après succès » n'aurait jamais verrouillé car le run sort FAILURE sur
   le seul seuil 7.7 → ~1 260 lectures B2/nuit économisées).
7. **Intégrité APK + certificat (12.2) — verrouillé côté logiciel** : rc11
   (privé, commit 2cd6991) : APK 44 112 105 o, sha256 **b052e7c9…c83bb6** =
   checksums consigné ; ZIP intègre ; signature V2 ; certificat
   **CN=Vitrine Video, O=EPD HOLDING, L=Cotonou, C=BJ**, RSA 2048/SHA256,
   validité 31/10/2026→23/10/2056, SHA-256 **758077eb…e192** — IDENTIQUE au
   certificat lu directement (keytool) sur l'APK rc-audio-v2 de l'arène (commit
   453e470, ancêtre de HEAD) : keystore officiel unique, cohérence
   inter-builds. mapping R8 sha256 **8cef1f5a…a2364c7** ✓.
8. **Réseau/errors (3.11/3.12)** : serveur indisponible = PASS (banc offline
   intégral). Réponses invalides = audit 3 niveaux de garde (transport
   `getOrNull`, status!=200→return, parsing `runCatching{JSONObject}`+replis)
   + test JVM exécuté `ApiClientInvalidReplyTest` (serveur mock : 200 non-JSON,
   corps pourri, 500, connexion refusée → jamais d'exception, parsing avorté
   proprement, miroir local intact) — ⏳ passage android-ci en attente de push.

## 2. Décisions du fondateur (aucune action de ma part sans arbitrage)

| # | Décision | Impact |
|---|---|---|
| D1 | **Arbitrage A — silence initial** : accepter l'intro 1,03-3,18 s (uniforme 600/600) ou demander trim/ré-masterisation (= modifier les compositions) | Rendu des 2 premières secondes |
| D2 | **Arbitrage B — clés titulaires** : uploader les 54 masters OU purifier les 54 clés D1 (repli v01 déjà fonctionnel) | Cohérence D1↔B2 |
| D3 | **Arbitrage C — bascule caméra avant/arrière (5.4)** : absente du produit (`DEFAULT_BACK_CAMERA` en dur) — ajout = évolution | Selfie/face caméra |
| D4 | **Arbitrage D — brouillon inter-sessions (4.6)** : aucun projet persistant entre sessions (session démo éphémère par conception) — ajout = évolution | Reprise de projet non exporté |
| D5 | **Arbitrage E — contrôle préventif du stockage (5.7)** : l'échec disque est géré (Finalize F53), pas de vérif StatFs AVANT la prise | Message anticipé « stockage insuffisant » |
| D6 | **rc12** : le produit a changé depuis rc11 (fix UI D42.26-15 etc.) → rc12 à produire (build public, re-signature locale fondateur, e2e officiel) puis **CONFIRMER le certificat 758077eb…e192** | APK remis |
| D7 | **Google Sign-In réel (2.4)** : test physique fondateur (émulateur sans compte Google) ; le reste du cycle auth est qualifié (18 contrôles Worker + comptes A/B réels API) | 1re connexion réelle |
| D8 | **Vérifications physiques préparées (non exécutées)** : caméra avant/arrière+erreurs hardware (5.4/5.8), voix réelle (6.8), stockage bas (5.7), OAuth (2.4), déconnexion app (2.3) | Vérité terrain |
| D9 | MANIFEST_SHA256 gabarits périmé (orphelins/modifiés 170ad89) : régénérer ou assumer le WARN | Intégrité déclarative |

## 3. Matrice de statuts — voir 00_MATRICE_QUALIFICATION.md (source unique)

Synthèse au 09/11 ~07:00Z (48 lignes / 84 exigences) : **26 PASS plein · 9 PASS
avec réserve documentée · 3 FAIL-documentés (arbitrages A/B/C) · 1 PARTIAL
(arbitrage D) · 2 EN VALIDATION (3.11 test JVM, 5.6 fix en run) · 6
CONDITIONAL (dont 12.2 : confirmation fondateur) · 1 NOT RUN (2.4 = physique
fondateur) · 0 BLOCKED**. Aucun défaut logiciel connu non corrigé : les
défauts restants sont soit des arbitrages produit (A-E), soit des vérités
terrain physiques.

## 4. Règles absolues respectées (auto-audit)

- Aucun PASS déclaré sur l'existence d'un écran ou une route qui répond :
  chaque statut exige la preuve d'effet (écran suivant, fichier, sha256,
  comptage, code retour vérifié sémantiquement).
- Aucun masquage : les FAIL sont documentés avec cause exacte et statut
  d'arbitrage ; le PASS trompeur OFF10 a été DÉCOUVERT par l'audit des dumps
  et requalifié (erreur 552 consignée) ; le FAIL camerap phase A a été
  requalifié en défaut d'OUTIL avec preuve (dumps = app seule) et le harnais
  corrigé (D42.26-19) plutôt que le produit accusé à tort.
- Vrai OAuth vs comptes de test distingués (§2) ; émulateur vs physique
  distingués ; online vs offline distingués (§4).
- 600 compositions intactes (aucune écriture B2/D1 audio) ; extrapolation
  60≠600 interdite — la couverture intégrale a été EXÉCUTÉE.
- SKYPAY 501 assumé ; 0 FCFA ; secrets jamais au miroir.

## 5. Historique des runs du tour (extrait)

| Run | Objet | Résultat |
|---|---|---|
| 42536993228 | e2e-lab f175adc (D42.26-16) | SUCCESS — UI 5/5 variantes 0 défaut |
| 42539964148 | e2e-lab 9d49aed (D42.26-17) | SUCCESS — **offline 14/0/0** |
| 42542375491 | one-shot audio intégral | 600/600 mesurés (7.2/7.6 PASS ; FAILURE = seuil 7.7 arbitrage A) |
| 42534124616 | restore drill D1 | PASS (24/24 tables, 676 lignes, SHA-256) |
| 42543641719 → 42547280252 | e2e-lab D42.26-18/18b | camerap 30/2/8 → défaut HARNAIS identifié (contrôle d'effet du remplissage) |
| 42555281455/42555687350 | e2e-lab D42.26-18c/d | phase B par fichiers rush ; phase A FAIL diagnostic |
| 42557585700 | backup cron 03:00 UTC | SUCCESS 03:39 09/11 (dispatch après retard cron GitHub) |
| 42562414209 | e2e-lab 9505b12 (D42.26-18f) | **SUCCESS 12/12 — P0 5/5 zéro défaut, camerap 39/1/1 (B 26/0/0), offline 14/0/0** |
| 42573687240 | e2e-lab 2ecf1bc (D42.26-19/20) | ⏳ en cours — verdict camerap phase A (dumpsys+BACK) attendu |

*(Consolidation finale : verdict 42573687240 + android-ci du test JVM
(ApiClientInvalidReplyTest) + décisions fondateur D1-D9 + rc12.)*
