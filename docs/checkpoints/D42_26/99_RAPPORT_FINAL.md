# D42.26 — RAPPORT FINAL DE QUALIFICATION INTÉGRALE (gate avant remise APK)

**Mission** : audit de COUVERTURE de toutes les exigences, exécution des tests
manquants, correction des défauts logiciels, matrice exhaustive — avant tout
test physique du fondateur. Budget consommé : **0 FCFA**.

**Tête de série des preuves** : run e2e-lab **42539964148** (9d49aed) puis
**42543641719** (e895a3c) — 12/12 jobs SUCCESS ; one-shot audio intégral
**42542375491** ; restore drill **42534124616**. (Ce rapport est consolidé au
fil des verdicts ; les lignes ⏳ sont en attente du run en cours.)

---

## 1. Résumé exécutif

Le tour D42.26 a fermé les derniers angles morts de la qualification :

1. **UI — FERMÉE (9.1/9.2)** : les défauts rotation 90° et petit écran 540×960
   sont CORRIGÉS (verrouillage portrait produit 532b76b+c120fbd) puis
   certifiés par un harnais à contrôle d'EFFET (D42.26-16) : 5/5 variantes à
   0 FAIL/0 BLOCKED (base 22/0/0, font130 23/0/0, rot90 23/0/0, small 23/0/0,
   petit/font130 23/0/0 — run 42536993228). Les « FAIL » résiduels étaient
   des artefacts de mesure (crash du LAUNCHER de l'émulateur, dump
   uiautomator dégénéré en override 540×960) — jamais masqués, documentés.
2. **OFFLINE — FERMÉE (14/0/0)** : premier parcours hors ligne COMPLET et
   honnête (réseau coupé par adb au lancement) : lancement à froid, langue,
   connexion sans crash, repli démo zéro appel réseau, carrousel 3 écrans,
   secteur, bienvenue, catalogue embarqué, force-stop/relance, retour réseau.
   La session DÉMO est éphémère par conception (documenté, OFF10 requalifié
   honnêtement — le dump montrait l'écran connexion, le premier check était
   trompeur). Run 42539964148 (D42.26-17).
3. **BIBLIOTHÈQUE 600 — COUVERTURE INTÉGRALE PROUVÉE** : one-shot
   42542375491 : 600/600 pistes téléchargées de production, sha256 CONFORMES
   600/600, décodables 600/600, 0 clipping (peak −1,01 dB), cohérence σ 0,81 dB.
   Deux constats produit CONFIRMÉS à l'échelle intégrale, arbitrages
   fondateur A (silence initial uniforme 1,03-3,18 s) et B (54/60 clés
   titulaires absentes, repli v01) — AUCUNE composition modifiée.
4. **Caméra résiliente (5.2/5.3/5.6)** : banc dédié D42.26-18 (permissions
   refusées → dialogue produit explicite sans crash ; « Refaire » = suppression
   fichier + re-filmage ; conservation des prises). ⏳ verdict run en cours.
5. **Gabarits** : audit statique 817 contrôles PASS (30/30 gabarits : briefs,
   séquences, durées, variables, montage, SFX, guide tournage) + job CI.
6. **Backup** : restore drill NON destructif PASS (24/24 tables, 676 lignes,
   SHA-256 vérifié) ; cron 03:00 UTC armé — ⏳ preuve de la nuit à relever.

## 2. Ce qui reste la décision du fondateur (aucune action de ma part)

| # | Décision | Impact |
|---|---|---|
| D1 | **Arbitrage A — silence initial** : accepter l'intro 1,03-3,18 s (by design, uniforme 600/600) ou demander un traitement (trim/ré-masterisation = modification des compositions) | Rendu perçu des 2 premières secondes |
| D2 | **Arbitrage B — clés titulaires** : uploader les 54 masters OU purger les 54 clés D1 (le service marche déjà par repli v01) | Cohérence D1↔B2 |
| D3 | **rc12** : le produit a changé depuis rc11 (verrouillage portrait 532b76b+c120fbd) → rc12 à produire (étage 1 build public, étage 2 re-signature locale fondateur, étage 3 e2e officiel) puis **certificat de signature confirmé** | APK remis |
| D4 | **Google Sign-In réel (2.4)** : test physique fondateur (émulateur sans compte Google) ; le reste du cycle auth est qualifié (18 contrôles Worker + comptes A/B réels API) | 1re connexion réelle |
| D5 | **Caméra physique (5.4 avant/arrière, 5.8 erreurs hardware, voix réelle 6.8)** : vérifications physiques préparées, non exécutées | Vérité terrain |
| D6 | MANIFEST_SHA256 gabarits périmé (30 orphelins, 4 modifiés par 170ad89) : régénérer ou assumer le WARN | Intégrité déclarative |

## 3. Matrice de statuts — voir 00_MATRICE_QUALIFICATION.md (source unique)

Résumé : §1-3 PASS (gouvernance, backend réel, services prod) ; §4 offline
**PASS 14/0/0** ; §5 caméra PARTIEL→⏳ (5.1/5.5 PASS, 5.4/5.7/5.8
physiques/NOT RUN documentés) ; §6 gabarits PASS (modes : structure+bancs
JVM+e2e musique seule ; voix réelle = physique) ; §7 bibliothèque
**600/600 INTÉGRAL** (2 FAIL = arbitrages A/B) ; §8 parrainage PASS ;
§9 UI **FERMÉE** ; §10 backup PASS (10.5 ⏳) ; §12 : UI+offline fermées, restent
D-auth-physique, J-consolidation (ce rapport), certificat (D3).

## 4. Règles absolues respectées (auto-audit)

- Aucun PASS déclaré sur l'existence d'un écran ou une route qui répond :
  chaque statut exige la preuve d'effet (écran suivant, fichier, sha256,
  comptage, code retour HTTP vérifié sémantiquement).
- Aucun masquage : les FAIL sont documentés avec leur cause exacte et leur
  statut d'arbitrage ; le PASS trompeur OFF10 a été DÉCOUVERT par l'audit des
  dumps et requalifié (erreur 552 consignée).
- Vrai OAuth vs comptes de test distingués partout (§2) ; émulateur vs
  physique distingués (PASS_EMULATOR/PASS_DEVICE) ; online vs offline
  distingués (§4).
- 600 compositions intactes (aucune écriture B2/D1 audio) ; extrapolation
  60≠600 interdite — la couverture intégrale a été EXÉCUTÉE.
- SKYPAY 501 assumé ; 0 FCFA ; secrets jamais au miroir.

## 5. Historique des runs du tour (extrait)

| Run | Objet | Résultat |
|---|---|---|
| 42536993228 | e2e-lab f175adc (D42.26-16/16b) | SUCCESS 11/11 — UI 5/5 variantes 0 défaut |
| 42539964148 | e2e-lab 9d49aed (D42.26-17) | SUCCESS 11/11 — **offline 14/0/0** |
| 42542375491 | one-shot audio intégral (dispatch manuel, cron retardé — documenté) | 22 PASS / 4 FAIL (arbitrages A/B confirmés intégral) |
| 42543641719 | e2e-lab e895a3c (D42.26-18) | SUCCESS 12/12 — camerap 30/2/8 (défaut harnais tap sans effet → 18b) |
| ⏳ | e2e-lab 46acd6a/d7b5cd7 (D42.26-18b) | en cours — verdict camerap attendu |
| 42534124616 | restore drill | PASS (24/24 tables, SHA-256) |

*(Consolidation finale après verdict camerap + cron backup 03:00 UTC.)*
