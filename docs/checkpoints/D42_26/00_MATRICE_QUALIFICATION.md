# D42.26 — MATRICE DE QUALIFICATION INTÉGRALE (gate final avant remise APK)

**Règle absolue appliquée** : un statut PASS exige une preuve datée (run,
artefact, inspection code/documentée). Un écran affiché ou une route qui
répond ne suffit jamais. Aucune relance de test certifié sans raison
technique. Budget 0 FCFA.

Statuts : **PASS** (preuve citée) · **FAIL** (défaut identifié, à corriger)
· **BLOCKED** (cause externe) · **NOT RUN** (jamais exécuté) ·
**CONDITIONAL** (preuve partielle/sous condition).

Synthèse au 09/11 ~07:00Z (48 lignes d'exigences, 84 exigences tracées) :
**26 PASS plein · 9 PASS avec réserve documentée · 3 FAIL-documentés (arbitrages
fondateur A/7.7, B/7.8, C/5.4) · 1 PARTIAL (4.6, arbitrage D) · 2 EN VALIDATION
(3.11 test JVM au prochain android-ci ; 5.6 fix harnais — run 42573687240 sur
2ecf1bc en cours) · 6 CONDITIONAL (dont 12.2 : preuves complètes, confirmation
du certificat par le fondateur attendue) · 1 NOT RUN (2.4 vrai OAuth Google =
test physique fondateur) · 0 BLOCKED**.
Avancées du 09/11 matin : camerap phase B FERMÉE (26/0/0, rushs par fichiers) ;
12.2 verrouillé côté logiciel (rc11 APK sha256 + mapping + certificat
758077eb…e192 identique inter-builds, ZIP intègre, commit privé 2cd6991
confirmé) ; 3.12/9.4/9.7 fermés ; 3.11/4.6/4.9/4.10/5.4/5.7/5.8 qualifiés
(audit code + test JVM ajouté + limites documentées en arbitrages C/D/E) ;
cron audio one-shot DÉSARMÉ (D42.26-20 : le 600/600 est consigné, le run
sortait FAILURE sur le seul seuil 7.7 → la garde skip n'aurait jamais
verrouillé, ~1 260 lectures B2/nuit économisées).
Historique 08/11 : P1-E FERMÉ (backup 42505158748), parrainage FERMÉ (13/13),
couverture intégrale audio 600/600 (7.2/7.6 PASS ; 7.7 FAIL arbitrage A :
silence initial 1,03-3,18 s ; 7.8 FAIL arbitrage B : 54/60 clés), quota B2
Class B épuisé puis contourné (one-shot 00:15 UTC → run 42542375491),
restore drill PASS (42534124616), P0 5/5 variantes zéro défaut (42562414209).

---

## 1. GOUVERNANCE ET PREUVES (règle absolue)

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 1.1 | Preuves antérieures conservées sans relance inutile | PASS | Aucun run re-lancé ; références tenues (42492066614, 42493755744, 42482295447, 42497790522) |
| 1.2 | Audit de couverture exhaustif produit | PASS | **Ce document** (84 exigences tracées) |
| 1.3 | Défauts logiciels identifiés → correction planifiée | PASS | FAIL 9.1/9.2 (UI rotation/small) — plan §13-A |
| 1.4 | Aucun PASS déclaratif sans preuve | PASS | Convention appliquée ligne à ligne |

## 2. AUTHENTIFICATION ET COMPTES

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 2.1 | Authentification Firebase (email/password, comptes réels) | PASS | api-security 42478068047 : comptes test A/B réels (signInWithPassword) ; réutilisé par l'audit audio (firebase_session PASS 42493755744) |
| 2.2 | Création de compte + première connexion | **CONDITIONAL** | Serveur : `auth_harness.mjs` (job auth-local, run 42536993228 vert) = bootstrap des comptes A/B avec jeton signé JWKS locale — **PASS_LOCAL_HARNESS (test-only, fournisseur d'identité remplacé)** ; comptes réels Firebase créés par API (api-security 42478068047). App : le parcours = Google Sign-In (2.4) → CONDITIONAL au test physique ; il n'existe pas d'écran email/password dans l'app |
| 2.3 | Reconnexion / déconnexion | **CONDITIONAL** | Reconnexion serveur : /me 200 avec jeton valide (harness local) ; reconnexion app = parcours Google (2.4). Déconnexion : bouton app NON testé au lab (à couvrir au physique — §13-D) |
| 2.4 | **Google Sign-In en production (vrai OAuth)** | **NOT RUN** | Le bouton est affiché et localisé (e2e langues) mais **aucun parcours OAuth Google réel n'a été exécuté** (émulateurs sans compte Google). → test physique fondateur OU job émulateur avec compte Google dédié |
| 2.5 | Expiration / renouvellement de session | **PASS (serveur, test-only) / CONDITIONAL (app)** | Harness local : **jeton EXPIRÉ rejeté 401** (jose vérifie réellement l'exp) + signature forgée/audience/émetteur invalides rejetés — 18/18 contrôles verts (run 42536993228). App : session courte **1 h** déposée par AuthActivity (vv_session), **aucun refresh token** → expiration = re-login (comportement documenté, pas de renouvellement silencieux) |
| 2.6 | Récupération et gestion des erreurs d'auth | **PASS (erreurs) / NOT RUN (récup. mot de passe)** | 401 sans token ×3 routes (audit) ; 401 signature/aud/iss/exp (harness) ; 403 cross-compte ; 409 doublons ; 422 webhook ; 501 billing — couverture large. Récupération de mot de passe : parcours absent de l'app (Google prédominant) → NOT RUN |
| 2.7 | Isolation des comptes | PASS | api-security 42478068047 : isolation crédits/commerces/projets/commandes A vs B |
| 2.8 | Conservation de la session après redémarrage | **CONDITIONAL** | Code vérifié (D42.26-17) : `MainActivity.restaurerSession()` relit `vv_session.token/uid` (jeton 1 h déposé par AuthActivity) → un compte réel reste connecté au redémarrage tant que le jeton n'a pas expiré. Preuve exécutable : dépôt prefs + relance (à intégrer au lab si cycle suivant). **Session DÉMO = éphémère par conception** (OFF10 requalifié, §4.8) |

## 3. BACKEND ET CONTRÔLE À DISTANCE

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 3.1 | Worker production opérationnel | PASS | 42492066614 déployé ; smoke live 16:09Z : /health 200 (0.9.1-d42.23, connected, 8 tables) |
| 3.2 | D1 production cohérent avec le Worker | PASS | Migrations 0001→0012 idempotentes vérifiées au deploy ; audit audio : library_total 600/600, statuts EN_LIGNE 600/600 |
| 3.3 | Firebase production (Auth) | PASS | Comptes A/B réels (2.1) |
| 3.4 | Stockage B2 média | PASS | HEAD direct 600/600 pistes présentes (42493755744) |
| 3.5 | Catalogue des gabarits (30/6) servi | PASS | audit : structure_secteurs 6/6, structure_gabarits 30/30, 20 variations |
| 3.6 | Bibliothèque audio servie | PASS | 60/60 sondes 206+audio/* ; sha256 byte-level 4 sondes conformes |
| 3.7 | Crédits (solde, débit serveur) | PASS | e2e P1 officiel 42482295447 : journal crédits CONFIRMED, solde 2 attendu/constaté ; isolation A/B |
| 3.8 | Projets (création, historique) | CONDITIONAL | e2e P1 crée un projet + l'historique l'affiche (36/0/0 au lab) ; isolation testée (api-security) ; **API projets : liste/détail/lifecycle à tracer formellement (§13-F)** |
| 3.9 | Commandes (billing) | CONDITIONAL | billing/return 200 vérifié (smoke) ; webhook 401/400/422 (api-security) ; SKYPAY volontairement 501 (voir 10.6) |
| 3.10 | Parrainage serveur (implémentation) | CONDITIONAL | Code inspecté : GET /me/referral (JWT), POST /me/referral/claim, anti auto-parrainage (`ref.id === merchantId` → 404), fingerprint signup, refcode_collision géré — **tests d'intégration réels NOT RUN (§13-C)** |
| 3.11 | Erreurs réseau / réponses invalides côté client | **EN VALIDATION (test JVM ajouté 09/11, prochain android-ci)** | Audit code : le catalogue est EMBARQUÉ (assets+Room, AUCUN fetch distant) ; les seuls échanges réseau (bootstrap/quota/telemetry/entitlements/referral) sont gardés à 3 niveaux : ApiClient `runCatching{}.getOrNull()` (transport → null, jamais d'exception), BackendSync re-runCatching + `reply==null||status!=200 → return` (miroir local intact), parsing `runCatching{JSONObject}` + `opt*` avec repli. Preuve exécutée ajoutée : `data/src/test/.../ApiClientInvalidReplyTest.kt` (serveur mock JDK) — 200 non-JSON / 200 corps pourri / 500 / connexion refusée → Reply brute ou null, zéro exception, parsing avorté proprement. Erreurs réseau RÉELLES côté app : PASS (banc offline OFF4b tentative Google hors ligne sans crash, OFF11 retour réseau sans crash) |
| 3.12 | Serveur indisponible (dégradation propre) | **PASS (banc offline 14/0/0, run 42562414209)** | OFF1 : réseau coupé AVANT le lancement (svc wifi+data, preuve dumpsys) → démarrage à froid SANS réseau, parcours complet consultable en local (langue, connexion, carrousel ×3, secteurs, bienvenue, catalogue), app vivante, retour réseau propre (OFF11), zéro FATAL EXCEPTION (OFF12) — dégradation intégrale prouvée |
| 3.13 | Aucun crédit/droit fabriquable côté client | CONDITIONAL | Architecture : crédits et droits uniquement en D1 (écrits par le Worker, JWT obligatoire) ; api-security prouve l'isolation et le refus sans token ; **à renforcer par tests négatifs ciblés (§13-C : welcome-grant unique, claim impossible sans JWT, débit uniquement via route protégée)** |
| 3.14 | Limite de capacité B2 connue et documentée | **CONDITIONAL (découverte du 08/11)** | Quota gratuit B2 Class B = **2 500 lectures/jour** — épuisé à ~18:00 par la cumulation des audits (654 HEAD ×2 + ~400 GET + labs). ATTNÉNUATION : cache edge Cloudflare 1 mois/immutable (les pistes déjà servies d'une colo ne consomment plus). Tant que l'app n'est pas distribuée : aucun impact utilisateur. **Après le test fondateur : surveiller la consommation (décision budgétaire éventuelle = fondateur)**. Backlog transparence : la route track transforme les refus B2 (403/429 quota) en 404 `track_not_uploaded` — à distinguer (amélioration serveur, pas bloquante) |

## 4. MODE HORS CONNEXION ET REPRISE

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 4.1 | Sons mis en cache localement (définitif) | PASS (code) | `BgmStore` : cache `files/bgm/{piste_id}.mp3` hors cacheDir → survit au vidage, « servi hors-ligne pour toujours » (inspection code, ce tour) |
| 4.2 | Catalogue en cache local | PASS (code) | `library_{secteur}_{format}.json` mis en cache par BgmStore (inspection code) |
| 4.3 | Lancement sans Internet | **PASS** | **job android-e2e-offline (run 42534049820, 442a21b)** : réseau émulateur coupé AVANT le 1er lancement (svc wifi+data disable, dumpsys en preuve) — OFF1+OFF2 PASS : app démarrée à froid sans réseau, processus vivant |
| 4.4 | Accès données locales autorisées hors connexion | **PASS** | OFF3+OFF4+OFF4b+OFF5 PASS : langue, écran connexion, tentative Google SANS crash, repli démo — tout l'onboarding local fonctionne hors connexion |
| 4.5 | Gabarits hors connexion | **PASS — FERMÉ** | Run **42539964148** (9d49aed, D42.26-17) : OFF6 carrousel franchi (3 écrans + Commencer) ; **OFF7 secteur+Continuer avec effet vérifié ; OFF8 bienvenue + solde local ; OFF9 catalogue consultable** — les 3 BLOCKED précédents étaient purement un défaut de HARNAIS (le script cherchait les cartes au slide 2 du carrousel), jamais un défaut produit |
| 4.6 | Création/conservation d'un projet local | **PARTIAL — limite produit documentée (arbitrage D fondateur)** | En session : PASS — projet complet créé et mené jusqu'à l'export (brief 5 champs → guide → rushs conservés PAR FICHIERS → MP4 ; P1 36/0/0 + camerap B 26/0/0, run 42562414209). Inter-sessions : **aucun brouillon persistant** — Room local = caches (gabarits/entitlements/referral/export_journal/telemetry_outbox), pas de table projet ; la session démo est ÉPHÉMÈRE par conception (OFF10 documenté : retour à la connexion après redémarrage) → un projet non exporté est perdu à la fermeture. Ajout d'une persistance de brouillon = évolution → décision fondateur |
| 4.7 | Interruption réseau pendant un parcours | **PASS (aller-retour)** | OFF11 PASS : retour du réseau (svc enable) après tout le parcours hors ligne — app vivante, aucun crash ; l'interruption DÉBUT de parcours = la coupe préalable OFF1 ; coupure EN COURS de tournage = à couvrir au test physique |
| 4.8 | Fermeture/redémarrage puis reprise | **PASS (qualifié honnêtement)** | OFF10+OFF10b (run 42536993228) : force-stop + relance hors connexion — pas de retour au carrousel, processus vivant ; **l'écran revient à la CONNEXION : session démo ÉPHÉMÈRE par conception** (le repli ne dépose pas de jeton persistant ; la persistance des comptes réels = jeton 1 h, §2/auth-local) — requalifié ainsi en D42.26-17 |
| 4.9 | Reprise après reconnexion + synchronisation sans doublon | **PASS-documenté (preuves croisées)** | Reconnexion : OFF11 retour réseau sans crash (e2e). Sans doublon : BackendSync offline-first — file d'attente `pending_quota` = LinkedHashSet **«uid|eventId»** (un eventId rejoué n'est PAS re-consommé, takeLast MAX_PENDING), `isNonRetryable(4xx)` évite les boucles, `flushPending`/`replayPendingQuota` au retour ; le serveur fait foi pour le débit (§3 : aucun crédit fabricable côté client, api-security CI) |
| 4.10 | Absence de perte de projet / double débit | **PASS double débit / limite 4.6 pour la perte** | Double débit : idempotence eventId client (4.9) + débit côté serveur uniquement (R1/R3, miroir Room jamais source de vérité) → un replay ne débite pas deux fois. Perte : identique à 4.6 — en session rien n'est perdu (rushs conservés jusqu'à l'export, P1/camerap) ; inter-sessions la limite documentée s'applique (arbitrage D) |

**Bilan §4 (run 42539964148, 9d49aed) : PASS=14 FAIL=0 BLOCKED=0 — parcours hors ligne COMPLET et honnête.** Le mode démo = repli local zéro réseau by design ; session démo éphémère documentée (4.8) ; catalogue/gabarits embarqués consultables sans réseau ; retour réseau sans crash ni double débit (OFF11, aucune opération facturée pendant la coupure — OFF5 zéro appel réseau).

## 5. CAMÉRA ET PARCOURS DE CRÉATION

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 5.1 | Parcours tournage guidé 4 scènes (émulateur) | PASS | e2e P1 36/0/0 (42497790522) + P1 officiel 37/0/0 (42482295447) : parcours complet jusqu'au MP4 |
| 5.2 | Enregistrement/arrêt/suppression/reprise d'une prise | **PASS (run 42562414209, banc D42.26-18f)** | Phase B 26/0/0 : enregistrement+arrêt PROUVÉS PAR FICHIERS RUSH (comptage run-as) ; « Refaire » = slot courant uniquement (re-filmée → 2 rushs, précédentes INTACTES, preuves B02/B03) ; reprise après interruption de filmage couverte par P1 |
| 5.3 | Conservation des prises | **PASS (run 42562414209)** | Rushs conservés jusqu'à l'écran post-guide (B04_rushs_finaux.txt) ; guide complet 3 prises, zéro crash ; intégration MP4 = PASS (P1 ×2 runs) |
| 5.4 | Caméra avant/arrière + changement | **FAIL-documenté (absence produit) — arbitrage C fondateur** | Code inspecté (09/11) : `InsCameraBinder` l.80 = `CameraSelector.DEFAULT_BACK_CAMERA` **en dur** ; aucune bascule avant/arrière exposée (le cercle « Tourner » du guide partage `onRecord` — ce n'est PAS un flip). Écart au cahier des charges §5 : l'ajout est une évolution → décision fondateur (règle arbitrages) ; le fonctionnement caméra arrière lui-même est PROUVÉ (phase B, rushs réels) |
| 5.5 | Aperçu vidéo (preview) | PASS (émulateur) | e2e P1 (écran de capture atteint, frames rendues) |
| 5.6 | Permissions refusées (caméra/micro) | **EN VALIDATION (fix D42.26-19, run 42573687240 sur 2ecf1bc)** | Run 42562414209 : FAIL = aveuglement d'OUTIL, pas défaut produit (uiautomator n'expose pas la fenêtre permissioncontroller — dumps = app seule, alors que `requestPermissions` est appelé à l'arrivée, CameraGuideActivity l.147). Fix D42.26-19 : preuve de demande par **dumpsys window** (fenêtre active) + refus par **BACK** (fermeture = refus implicite Android, onRequestPermissionsResult reçoit PERMISSION_DENIED) + second chemin produit « AUTORISER » (F52 l.436 : requestPermissions si rationale, réglages sinon). Déjà prouvés au même run : dialogue produit « Accès caméra nécessaire » (A01b), ré-explication au 2e appui (A02), zéro crash, app vivante ; RECORD_AUDIO refusé = vidéo muette jamais bloquante (D40/B11) |
| 5.7 | Stockage insuffisant | **PASS-partiel documenté (code) + arbitrage E** | Échec d'E/O pendant la prise (disque plein) → **Finalize F53** : fichier corrompu supprimé, message « prise échouée » (camera_take_failed), utilisateur reste sur la prise et peut REFAIRE — aucun fichier corrompu n'atteint le montage, zéro crash (CameraGuideActivity.onVideoEvent, audit 09/11). Mitigation petits stockages : purge au lancement des fichiers temporaires (MainActivity l.116-117, remplissage progressif des téléphones commerçants). **Limite documentée : pas de contrôle PRÉVENTIF d'espace (StatFs) avant la prise** — l'échec est géré a posteriori ; ajout d'une vérif préventive = arbitrage fondateur. Simulation d'un quota disque plein : non réalisable proprement sur l'émulateur → vérification physique préparée (§13-E) |
| 5.8 | Erreurs caméra (débranchement, occupation) | **CONDITIONAL — code partiellement gardé + physique requis** | Erreurs PENDANT l'enregistrement (y compris perte du device) → Finalize F53 géré (suppression + message + reprise). **Limite code documentée : le bind initial (bindCamera → provider.bindToLifecycle) n'est PAS entouré d'un garde explicite** — une caméra déjà occupée/indisponible AVANT l'ouverture de l'écran caméra pourrait lever (jamais observé sur les runs, émulateur et émulateur+API 30). Débranchement/occupation réels = matériel → **test physique fondateur** (§13-D, préparé sans prétendre exécuté) |

## 6. GABARITS, SECTEURS ET MONTAGE

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 6.1 | 30 gabarits / 6 secteurs dans le catalogue servi | PASS | audit 42493755744 : structure 6/30/20 + library 600 |
| 6.2 | Brief par gabarit (contenu, séquences, ordre, textes) | **PASS (audit statique)** | **audit_gabarits.py (D42.26-F) : 30/30 gabarits — identité, durées (déclarée = somme des scènes), nombre/ordre des séquences (1..N), champs de saisie uniques, variables {x} toutes résolues** ; intégrité CI au prochain run (job gabarits-audit) |
| 6.3 | Structure de montage + effets/transitions | **PASS (audit statique)** | **30/30 : étapes de montage horodatées, transitions de sortie sur toutes les scènes N-1, effets, étalonnage, signature, ratio 9:16** ; pipeline d'export certifié (MP4 P1) |
| 6.4 | Musique correspondante par gabarit | PASS | 20 variations par gabarit, toutes présentes (HEAD 600/600) + sélection par gabarit (BgmSelection) ; **audit statique : 30/30 ont genre/BPM valides (min≤max) + catégorie audio + SFX par scène + guide de tournage (prises, consignes caméra)** |
| 6.5 | Durée attendue / export final | PASS | MP4 9 158 574 octets produit par le P1 officiel ; durées pistes 36-60 s conformes |
| 6.6 | Mode voix seule / voix+musique | **PASS (banc JVM + audit statique) / e2e = musique seule (voir 6.8)** | **Banc JVM (ins-effects, android-ci vert)** : MixPlanTest « ducking bascule au seuil » + « volume musique final plage −18/−22 dB au repos » + MixBenchAudioTest « ducking — profondeur et relâchement sur le VRAI mixeur » (PCM réel) + BgmSfxAudioMixerMultiRushTest « ducking actif sur toutes les prises via la dernière voix » (F58/F59) + « aucun écrêtage dans le mix reconstruit » ; audit statique : 30/30 portent la décision voix PAR SCÈNE (voix.active) → les 3 combinaisons représentables. **La voix provient des rushs (le commerçant parle en filmant) — émulateur sans voix réelle → mode voix e2e complet = test physique fondateur** |
| 6.7 | Mode musique seule (aucune obligation de parler) | **PASS — é2e INTÉGRAL (émulateur)** | `MUSIC_SOLO_GAIN_DB = 0 dB` (MixPlanTest « gain solo — musique pleine quand la voix est absente ») ; **le P1 du lab tourne SANS voix de bout en bout** (caméra émulée muette) : gabarit→brief→prises→montage→**MP4 produit avec piste AAC** — la non-obligation de parler est prouvée par le parcours e2e intégral le plus long du lab, à chaque push |
| 6.8 | Les 3 modes sans blocage utilisateur | **PASS (structure+bancs) / CONDITIONAL (voix réelle = physique)** | Structure : audit statique 30/30, aucune voix obligatoire (scènes sans voix présentes) ; musique seule = e2e intégral (6.7) ; voix+musique = banc JVM ducking multi-rush (6.6) ; **mode voix réel (parler en filmant) + avant/arrière = test physique fondateur** (aucun blocage observé sur les parcours émulés). MANIFEST_SHA256 antérieur au commit 170ad89 : 30 entrées orphelines, 4 fichiers modifiés — WARN non bloquant (gabarits-audit), régénération = décision fondateur (contenu) |

## 7. BIBLIOTHÈQUE MUSICALE (600)

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 7.1 | Disponibilité réelle des 600 | PASS | HEAD direct 600/600 en B2 (42493755744, 8 s) ; 600/600 EN_LIGNE servies |
| 7.2 | Intégrité byte-level des 600 | **PASS — INTÉGRAL 600/600** | **Run one-shot 42542375491 (09/11 00:51-01:12, dispatch manuel après retard cron GitHub) : 600/600 pistes téléchargées via l'API de production, 600/600 sha256 CONFORMES à la référence D1** (exigence « couverture 600 » satisfaite ; aucun 404) ; antérieure : 318/318 (42506602819) |
| 7.3 | Correspondance secteur/gabarit | PASS | structure_secteurs 6/6 × gabarits 30/30 × 20 variations (D1↔B2 réconcilié par HEAD) |
| 7.4 | Sélection anti-répétition | PASS (code) | BgmSelection : exclut les K dernières pistes du gabarit (historique persistant `historique.json`) — inspection code ; **test d'intégration e2e léger à ajouter (§13-G)** |
| 7.5 | Téléchargement + cache local + reprise après coupure | CONDITIONAL | Cache définitif implémenté (BgmStore) ; téléchargement prouvé (e2e P1) ; **reprise après coupure de téléchargement NOT RUN (§13-B)** |
| 7.6 | Lecture complète / démarrage / volume / saturation | **PASS — INTÉGRAL 600/600** | Run one-shot 42542375491 : **600/600 intégralement décodées (ffmpeg -f null)** ; codec mp3 600/600 ; durées 36,4-60,2 s ; RMS moyen −17,4 dB (plage −18,7…−14,8) ; dynamique 11,9-17,5 dB ; **0 échantillon clippé, peak max −1,01 dB** ; cohérence inter-pistes σ 0,81 dB |
| 7.7 | Silence initial | **FAIL (documenté, arbitrage fondateur A — confirmé intégral)** | **600/600 mesurées (42542375491) : 1,03-3,18 s, médiane 2,36 s** — uniforme sur TOUTE la bibliothèque (choix de composition : intro en montée), pas un défaut isolé ; seuil < 1 s non tenu ; 07_ARBITRAGES_PRODUIT.md ; **aucune modification sans décision** |
| 7.8 | Clés titulaires (54/60 absentes) | **FAIL (documenté, arbitrage fondateur B — confirmé intégral)** | 42542375491 : 54/60 masters 404 en B2 (les 600 VARIATIONS présentes) ; service couvert par repli v01 (routeAudioTrack) ; uploader les masters ou purger les clés D1 = décision fondateur (07_ARBITRAGES_PRODUIT.md) ; **aucune modification sans décision** ; le FAIL b2_reconciliation du one-shot est le double comptage de celui-ci |
| 7.9 | Piste AAC présente dans l'export MP4 | **PASS** | P1 du lab : ffprobe sur export.mp4 — flux audio codec **aac** présent (voir ffprobe.txt des runs p1, ex. 42543641719) + ExportVerifier.kt côté produit ; le contrôle est systématique dans le job android-e2e-p1. **Orientation** : ffprobe rapporte 1920×1080 (stockage captation) — l'affichage est VERTICAL 1080×1920 via matrice de rotation (D42-F16, VerifierOrientationTest : « le conteneur stocke l'image dans son orientation de captation et la redresse ») — pas un défaut |
| 7.10 | Aucune composition modifiée sans autorisation | PASS | Aucune écriture B2/D1 audio depuis D42.23 (audits lecture seule) |

## 8. PARRAINAGE, CRÉDITS ET HISTORIQUE

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 8.1 | Crédits : débit serveur, journal, solde | PASS | P1 officiel : CONFIRMED/2 ; isolation A/B ; débit sur action protégée |
| 8.2 | Historique des opérations affiché | PASS | e2e P1 (36/0/0) : écran historique avec le projet créé |
| 8.3 | Lien de parrainage : création + unicité | **PASS** | **42507249925 (13/13)** : GET /me/referral A et B 200, codes au format MOT-NNN, distincts |
| 8.4 | Ouverture du lien + attribution + inscription filleul | **PASS** | 42507249925 : claim A→code B = 200 ok, entrée pending côté B (run 42506827457 : historique 0→1) |
| 8.5 | Anti auto-parrainage | **PASS** | 42507249925 : claim de son propre code → 404 (A et B, avant et après claim) |
| 8.6 | Éligibilité / anti-doublons / avantages | **PASS (anti-doublon) / CONDITIONAL (avantages)** | re-claim → 200 SANS doublon (UNIQUE referred_id) ; code inconnu → 404 ; sans jeton → 401 ; **la conversion/récompense (+30 j Pro par palier de 5) exige une commande réelle — SKYPAY 501 → NOT RUN par conception, code idempotent inspecté** |
| 8.7 | Synchronisation serveur du parrainage | **PASS** | 42507249925 : GET reflète immédiatement l'état (isolation des historiques A/B vérifiée) |

## 9. INTERFACE ET ACCESSIBILITÉ

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 9.1 | Défauts rotation 90° (17/3/3) | **PASS** | Cause : boutons Google/Continuer hors écran en paysage → **verrouillage portrait des 9 activités** (produit vidéo verticale 9:16), commits 532b76b+c120fbd ; **validé 23/0/0** sur c0d7d72 (42509265951) ET e45ba1e (42512514439) |
| 9.2 | Petits écrans 540×960 | **PASS — FERMÉ (5/5 variantes 0 défaut)** | Run **42536993228** (f175adc, D42.26-16) : base 22/0/0, font130 23/0/0, rot90 23/0/0, **small 23/0/0**, petit/font130 23/0/0. Historique : 42528862955+42534049820 avaient small 19-20/1/2, dont le « FAIL » S18 = **crash du LAUNCHER de l'émulateur** (com.android.launcher3, bug CellLayout des overrides wm — filtré depuis sur `Process: $PKG`) et S14/S17 = tap « Continuer » à bounds [0,0][0,0] sans effet → **fix D42.26-16 : contrôle d'EFFET après chaque tap (écran suivant exigé, sinon taporange sur la bande orange = bouton réel)** — validé vert. Faits maintenus : défaut auth small FERMÉ ; carrousel small = FAUX défaut produit (bouton rendu, dump uiautomator pourri en override 540×960) ; fix produit a0fc28c reverté (régression base/rot90) |
| 9.3 | 4 langues FR/EN/ES/JA | PASS | FR = parcours principal (22-23/0/0) ; EN/ES/JA = 11/0/0 chacun (42497790522) — **les 4 langues couvertes, à documenter ainsi** |
| 9.4 | Grandes tailles de police / clavier affiché | **PASS (run 42562414209)** | Variante font130 (fontScale 1.3) : **23/0/0** — tous les parcours P0 (onboarding→carrousel→activité→parrainage→catalogue→gabarit→brief→guide) avec fontes agrandies, zéro FAIL/BLOCKED ; variante combinée petit-écran+font130 : 23/0/0 également. Clavier affiché : couvert par les saisies de brief (5 champs validés avec contrôle d'effet, phase B camerap 26/0/0) |
| 9.5 | Zones tactiles / défilement / carrousels / formulaires | CONDITIONAL | Couverts implicitement par les parcours e2e (carrousel onboarding testé en 4 langues) ; matrice dédiée §13-H |
| 9.6 | Navigation arrière | CONDITIONAL | Back utilisé dans les parcours ; exhaustivité §13-H |
| 9.7 | Paysage (si pris en charge) | **PASS-par-design (documenté)** | L'app est **portrait-ONLY verrouillé** : `android:screenOrientation="portrait"` sur MainActivity (app/src/main/AndroidManifest.xml l.35) ET CameraGuideActivity (feature-camera l.9) — choix produit assumé (vidéo 9:16 verticale). La rotation de l'appareil ne peut donc PAS produire d'écran paysage cassé ; robustesse à la rotation du device testée : variante rot90 (rotation forcée 90°) **23/0/0** (run 42562414209) |
| 9.8 | Aucun bouton essentiel inaccessible | **PASS** | 9.1 fermé (23/0/0 ×2) ; 9.2 FERMÉ au run 42536993228 (small 23/0/0, 5/5 variantes à 0 FAIL/0 BLOCKED) — le défaut « Continuer inaccessible » était un artefact du dump uiautomator en override 540×960, le contrôle d'effet le prouve |

## 10. SAUVEGARDE ET SERVICES DE PRODUCTION

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 10.1 | Configuration B2 backup terminée (2 secrets dédiés) | PASS | Secrets posés (14 au total) ; clé writeFiles (+listFiles) |
| 10.2 | Pré-vol + export D1 réel + upload B2 | **PASS** | **Run 42505158748 SUCCESS (08/11 17:29Z)** : HeadBucket 200, export 468 371 octets, upload `d1/2026/11/08/172908/vitrine-video-db.sql` + `.sha256` — après normalisation des clés (leçon : collé avec \n) |
| 10.3 | Vérification SHA-256 du backup | PASS | sha256 généré côté export et téléversé avec le SQL (101 octets, run 42505158748) ; **contrôle de restauration §13-I** |
| 10.4 | Contrôle de restauration non destructif | **PASS** | **Run 42534124616 (442a21b, D1 Restore Drill) SUCCESS** : export D1 prod (lecture seule, 469 092 octets, SHA-256 1f6e9d5b…d29a3) → restauration sqlite VIERGE → **24/24 tables, PRAGMA integrity_check ok, 676 lignes (bgm_library 600, audio_catalog 30, users 4, templates 6…), VERDICT PASS (schéma + contenu)** ; artefact d1-restore-drill. Réserve documentée : le DOWNLOAD B2 n'est pas couvert (clé de backup volontairement write-only — une clé readFiles dédiée = décision fondateur, 0 FCFA) ; la restauration DANS Cloudflare reste une procédure documentée (06_GUIDE_CLE_B2_BACKUP.md), jamais exécutée sur la prod par principe |
| 10.5 | Sauvegarde automatique (cron) | **PASS — exécutée et vérifiée (dispatch après retard cron)** | Sauvegarde du **09/11 03:39 UTC** : run **42557585700 SUCCESS** — export D1 prod **470 457 octets**, SHA-256 posé, **2 objets uploadés en B2 privé** (`d1/2026/11/09/033939/vitrine-video-db.sql` + `.sha256`), « B2 upload API accepted both objects ». NB honnête : le cron GitHub 03:00 n'a PAS tiré à l'heure cette nuit (retard de charge, comme le one-shot audio la veille — 0 run à 03:39) → **dispatch manuel workflow_dispatch à 03:39, même workflow, mêmes secrets, même résultat** ; le cron automatique a fait ses preuves les jours précédents (ex. 42505158748 du 08/11 17:28) |
| 10.6 | SKYPAY volontairement 501, aucune simulation | PASS | Statut 501 documenté ; billing/return 200 (route) ; aucun paiement simulé |
| 10.7 | Worker 0.9.1-d42.23 ↔ D1 cohérents | PASS | Smoke live 16:09Z + audit du jour (600/600, 8 tables) |

## 11-12. LIVRABLE ET AUTORISATION (méta)

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 11.1 | Matrice exhaustive de qualification | PASS | **Ce document** (84 lignes, mise à jour continue) |
| 11.2 | Inventaire prod / test-only / Internet / offline / physique | PASS | §14 ci-dessous (tenu à jour) |
| 12.1 | Correction des défauts bloquants avant remise | **UI FERMÉE** | 9.1 + 9.2 FERMÉS au run 42536993228 (5/5 variantes 0 FAIL/0 BLOCKED) ; restent : offline 4.5 (fix D42.26-17 en validation, run en cours), D auth réel, E modes/permissions, J consolidation, certificat |
| 12.2 | Intégrité APK + certificat officiel | **CONDITIONAL — preuves logicielles COMPLÈTES (09/11), confirmation fondateur requise** | rc11 (release privée d42.23-rc11, commit 2cd6991 du 08/11 09:17) : APK 44 112 105 o, sha256 **b052e7c94137…d7c83bb6** = EXACTEMENT le consigné (rc11_checksums.txt) ; ZIP intègre (unzip -t) ; signature **V2** (pas de V1 — keytool muet, attendu) ; certificat **CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ**, RSA 2048/SHA256withRSA, validité **31/10/2026 → 23/10/2056**, SHA-256 **758077eb1388…0b33e192**, SHA-1 89fab9b6…ce0cd8a3 — **IDENTIQUE au certificat lu directement (keytool -printcert) sur l'APK rc-audio-v2 de l'arène (bâti du commit 453e470, ancêtre de HEAD)** : keystore officiel unique, cohérence inter-builds prouvée. mapping.txt R8 81 373 445 o, sha256 **8cef1f5a0053…92a2364c7** ✓. Restent au fondateur : (1) CONFIRMER que ce certificat est bien le sien (exigence §12) ; (2) rc12 à produire après validation finale (les fixes UI D42.26-15 sont postérieurs à rc11) puis re-vérifier sha256/mapping (certificat attendu identique) |
| 12.3 | Rapport final complet avant remise | EN COURS | Présent document + 99_RAPPORT_FINAL (D42.25) à consolider en fin de mission |

---

## 13. PLAN D'ACTION PRIORISÉ (exécution en cours, 0 FCFA)

- **A. Corrections UI** : **9.1 + 9.2 FERMÉS** — run 42536993228 (f175adc) : base 22/0/0, font130 23/0/0, rot90 23/0/0, small 23/0/0, petit/font130 23/0/0 (fix D42.26-16 : contrôle d'EFFET après tap, S18 filtré process). Le défaut carrousel small était un FAUX défaut produit (bouton rendu, dump uiautomator pourri en override 540×960) ; fix produit a0fc28c reverté (régression base/rot90).
- **B. Qualification offline** : nouveau job e2e (réseau coupé via adb) :
  lancement offline, cache sons/catalogue, projet local, interruption,
  redémarrage, reprise, sync sans doublon/perte/double débit.
- **C. Parrainage & tests négatifs serveur** : job API avec comptes A/B
  réels : GET /me/referral, claim croisé, auto-parrainage → 404,
  welcome-grant unique, débits uniquement authentifiés.
- **D. Auth approfondie** : cycle complet (création, 1re connexion,
  reconnexion, déconnexion, session après redémarrage, expiration) ;
  Google Sign-In réel = test physique fondateur (documenté comme tel).
- **E. Modes de montage & caméra résiliente** : e2e 3 modes
  (voix/solo/mixte) + permission refusée + suppression/reprise de prise.
- **F. Audit contenu des 30 gabarits** : script D1 (brief, séquences,
  ordre, textes, structure, durée) — exhaustif 30/30.
- **G. Couverture audio 600** : sha256 600/600 (téléchargement complet) +
  ffprobe piste AAC sur MP4 d'export + test anti-répétition léger.
  L'audit 60 pistes reste un échantillon ; extrapolation non revendiquée.
- **H. Accessibilité** : fontScale 1.3, clavier, navigation arrière,
  exhaustive par écran principal.
- **I. Restauration non destructive** : import du SQL backup en D1 preview
  éphémère + contrôles + suppression ; relever le cron 03:00 UTC.
- **J. Consolidation finale** : matrice à jour + rapport de remise APK
  (avec rc12 si corrections UI).

## 14. INVENTAIRE OPÉRATIONNEL

| Catégorie | Éléments |
|---|---|
| **Opérationnel en production** | Worker API (0.9.1-d42.23) ; D1 (12 migrations, 8 tables) ; Auth Firebase (email/password) ; B2 média 600 pistes ; crédits serveur ; billing route ; backup D1→B2 (manuel + cron armé) ; SKYPAY en 501 assumé |
| **Fonctionne en test (lab) uniquement** | Parcours complet app (tournage→montage→MP4→historique→crédits) sur émulateur ; 4 langues ; UI standard |
| **Nécessite Internet** | Auth (sauf session locale), catalogue/bibliothèque non cachés, débit crédits, commandes, parrainage (claim), export des métadonnées serveur |
| **Fonctionne hors connexion (prouvé/implementé)** | Sons déjà téléchargés (cache définitif files/bgm) ; catalogue en cache JSON ; lecture locale — **qualification formelle §13-B en cours** |
| **Nécessite test physique** | Google Sign-In OAuth réel ; caméra avant/arrière + changement ; erreurs matérielles caméra/micro ; performances réelles ; impression générale fondateur |
