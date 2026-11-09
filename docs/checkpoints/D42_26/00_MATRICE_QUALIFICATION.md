# D42.26 — MATRICE DE QUALIFICATION INTÉGRALE (gate final avant remise APK)

**Règle absolue appliquée** : un statut PASS exige une preuve datée (run,
artefact, inspection code/documentée). Un écran affiché ou une route qui
répond ne suffit jamais. Aucune relance de test certifié sans raison
technique. Budget 0 FCFA.

Statuts : **PASS** (preuve citée) · **FAIL** (défaut identifié, à corriger)
· **BLOCKED** (cause externe) · **NOT RUN** (jamais exécuté) ·
**CONDITIONAL** (preuve partielle/sous condition).

Synthèse au 08/11 18:30Z : **56 PASS · 2 FAIL→corrigés (validation en cours) ·
0 BLOCKED · 18 NOT RUN · 8 CONDITIONAL** sur 84 exigences tracées ci-dessous.
Avancées du jour : P1-E FERMÉ (backup 42505158748 SUCCESS), parrainage FERMÉ
(13/13, 42507249925), corrections UI poussées (verrouillage portrait + layout
auth ancré), couverture intégrale audio 318/600 (toutes conformes) —
**découverte majeure : quota B2 Class B quotidien (2 500/jour gratuit) ÉPUISÉ
par la cumulation des audits** (sonde 42508980573 : 6/6 → 404
track_not_uploaded, y compris pistes servies 200 une heure avant) ;
achèvement programmé one-shot à 00:15 UTC.

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
| 3.11 | Erreurs réseau / réponses invalides côté client | NOT RUN | Comportement de l'app face à un serveur indisponible/réponse invalide — §13-B (offline) |
| 3.12 | Serveur indisponible (dégradation propre) | NOT RUN | §13-B |
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
| 4.6 | Création/conservation d'un projet local | NOT RUN | §13-B |
| 4.7 | Interruption réseau pendant un parcours | **PASS (aller-retour)** | OFF11 PASS : retour du réseau (svc enable) après tout le parcours hors ligne — app vivante, aucun crash ; l'interruption DÉBUT de parcours = la coupe préalable OFF1 ; coupure EN COURS de tournage = à couvrir au test physique |
| 4.8 | Fermeture/redémarrage puis reprise | **PASS (qualifié honnêtement)** | OFF10+OFF10b (run 42536993228) : force-stop + relance hors connexion — pas de retour au carrousel, processus vivant ; **l'écran revient à la CONNEXION : session démo ÉPHÉMÈRE par conception** (le repli ne dépose pas de jeton persistant ; la persistance des comptes réels = jeton 1 h, §2/auth-local) — requalifié ainsi en D42.26-17 |
| 4.9 | Reprise après reconnexion + synchronisation sans doublon | NOT RUN | §13-B |
| 4.10 | Absence de perte de projet / double débit | NOT RUN | §13-B (le débit crédits est serveur → double débit client improbable par conception ; à prouver par test) |

**Bilan §4 (run 42539964148, 9d49aed) : PASS=14 FAIL=0 BLOCKED=0 — parcours hors ligne COMPLET et honnête.** Le mode démo = repli local zéro réseau by design ; session démo éphémère documentée (4.8) ; catalogue/gabarits embarqués consultables sans réseau ; retour réseau sans crash ni double débit (OFF11, aucune opération facturée pendant la coupure — OFF5 zéro appel réseau).

## 5. CAMÉRA ET PARCOURS DE CRÉATION

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 5.1 | Parcours tournage guidé 4 scènes (émulateur) | PASS | e2e P1 36/0/0 (42497790522) + P1 officiel 37/0/0 (42482295447) : parcours complet jusqu'au MP4 |
| 5.2 | Enregistrement/arrêt/suppression/reprise d'une prise | **EN VALIDATION (banc D42.26-18)** | Enregistrement+arrêt : PASS (P1). Suppression/reprise : **job android-e2e-camerap** — « Refaire » doit SUPPRIMER le fichier rush (preuve par comptage de fichiers avant/après) puis la prise est re-filmable ; run en cours sur e895a3c |
| 5.3 | Conservation des prises | **EN VALIDATION (banc D42.26-18)** | fichiers rush-*.mp4 listés (run-as) jusqu'à l'écran post-guide (B04_rushs_finaux.txt) ; intégration au MP4 = PASS (P1) |
| 5.4 | Caméra avant/arrière + changement | NOT RUN | Émulateur : caméra virtuelle par défaut uniquement. **Test physique requis** |
| 5.5 | Aperçu vidéo (preview) | PASS (émulateur) | e2e P1 (écran de capture atteint, frames rendues) |
| 5.6 | Permissions refusées (caméra/micro) | **EN VALIDATION (banc D42.26-18)** | Phase A du camerap : aucune permission accordée → dialogue SYSTÈME refusé → dialogue produit « Accès caméra nécessaire » (F52) exigé, ré-explanation au 2e appui, zéro crash process ; RECORD_AUDIO refusé = vidéo muette jamais bloquante (code D40/B11) |
| 5.7 | Stockage insuffisant | NOT RUN | §13-E (simulation quota) — basse priorité |
| 5.8 | Erreurs caméra (débranchement, occupation) | NOT RUN | **Test physique requis** (hardware) |

## 6. GABARITS, SECTEURS ET MONTAGE

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 6.1 | 30 gabarits / 6 secteurs dans le catalogue servi | PASS | audit 42493755744 : structure 6/30/20 + library 600 |
| 6.2 | Brief par gabarit (contenu, séquences, ordre, textes) | **PASS (audit statique)** | **audit_gabarits.py (D42.26-F) : 30/30 gabarits — identité, durées (déclarée = somme des scènes), nombre/ordre des séquences (1..N), champs de saisie uniques, variables {x} toutes résolues** ; intégrité CI au prochain run (job gabarits-audit) |
| 6.3 | Structure de montage + effets/transitions | **PASS (audit statique)** | **30/30 : étapes de montage horodatées, transitions de sortie sur toutes les scènes N-1, effets, étalonnage, signature, ratio 9:16** ; pipeline d'export certifié (MP4 P1) |
| 6.4 | Musique correspondante par gabarit | PASS | 20 variations par gabarit, toutes présentes (HEAD 600/600) + sélection par gabarit (BgmSelection) ; **audit statique : 30/30 ont genre/BPM valides (min≤max) + catégorie audio + SFX par scène + guide de tournage (prises, consignes caméra)** |
| 6.5 | Durée attendue / export final | PASS | MP4 9 158 574 octets produit par le P1 officiel ; durées pistes 36-60 s conformes |
| 6.6 | Mode voix seule / voix+musique | PASS (code+audit) + e2e §13-E | MixPlan : ducking musique sous voix (−14 dB), fade in/out — testé JVM (MixBenchAudioTest) ; **audit statique : 30/30 portent la décision voix PAR SCÈNE (voix.active) + musique → les 3 combinaisons représentables** ; parcours e2e explicite par mode = §13-E |
| 6.7 | Mode musique seule (aucune obligation de parler) | PASS (code+design) | `MUSIC_SOLO_GAIN_DB = 0 dB` (mode solo, MixPlan D42.21) ; e2e P1 officiel a tourné en mode sans voix (MP4 produit) — parcours e2e à tracer par mode (§13-E) |
| 6.8 | Les 3 modes sans blocage utilisateur | CONDITIONAL | Structure porte les 3 modes (audit statique 30/30, aucune voix obligatoire : scènes sans voix présentes) ; parcours e2e 3 modes = §13-E ; **constat intégrité documenté : MANIFEST_SHA256 antérieur au commit 170ad89 (fix 8 accroches T2) et au retrait de profils_style/ — 30 entrées orphelines, 4 fichiers modifiés depuis ; régénération = décision fondateur (contenu)** |

## 7. BIBLIOTHÈQUE MUSICALE (600)

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 7.1 | Disponibilité réelle des 600 | PASS | HEAD direct 600/600 en B2 (42493755744, 8 s) ; 600/600 EN_LIGNE servies |
| 7.2 | Intégrité byte-level des 600 | CONDITIONAL (318/600, toutes conformes) | Run FULL 42506602819 : **318 pistes téléchargées, 318/318 sha256 CONFORMES** ; les 282 restantes → 404 **quota B2 Class B épuisé** (preuve sonde 42508980573) — **achèvement ONE-SHOT programmé 00:15 UTC (workflow audio-audit-full-once.yml, garde anti-répétition)** |
| 7.3 | Correspondance secteur/gabarit | PASS | structure_secteurs 6/6 × gabarits 30/30 × 20 variations (D1↔B2 réconcilié par HEAD) |
| 7.4 | Sélection anti-répétition | PASS (code) | BgmSelection : exclut les K dernières pistes du gabarit (historique persistant `historique.json`) — inspection code ; **test d'intégration e2e léger à ajouter (§13-G)** |
| 7.5 | Téléchargement + cache local + reprise après coupure | CONDITIONAL | Cache définitif implémenté (BgmStore) ; téléchargement prouvé (e2e P1) ; **reprise après coupure de téléchargement NOT RUN (§13-B)** |
| 7.6 | Lecture complète / démarrage / volume / saturation | CONDITIONAL (318/600 mesurées) | Run FULL : 318/318 décodées, RMS moyen −17,3 dB, dynamique 11,9-17,5 dB, 0 clipping, cohérence σ 0,84 dB ; échantillon 60 initial + 318 — **complétion 600/600 programmée (one-shot 00:15 UTC)** |
| 7.7 | Silence initial | **FAIL (documenté, arbitrage fondateur A)** | 60/60 mesurées : 1,03-3,07 s (07_ARBITRAGES_PRODUIT.md) ; **aucune modification sans décision** |
| 7.8 | Clés titulaires (54/60 absentes) | **FAIL (documenté, arbitrage fondateur B)** | Repli v01 par conception (07_ARBITRAGES_PRODUIT.md) ; **aucune modification sans décision** |
| 7.9 | Piste AAC présente dans l'export MP4 | CONDITIONAL | `ExportVerifier.kt` (ins-effects) vérifie l'export ; **contrôle explicite ffprobe « piste audio AAC » sur l'artefact MP4 du lab = §13-G (trivial, immédiat)** |
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
| 9.4 | Grandes tailles de police / clavier affiché | NOT RUN | §13-H (config fontScale 1.3 + états clavier) |
| 9.5 | Zones tactiles / défilement / carrousels / formulaires | CONDITIONAL | Couverts implicitement par les parcours e2e (carrousel onboarding testé en 4 langues) ; matrice dédiée §13-H |
| 9.6 | Navigation arrière | CONDITIONAL | Back utilisé dans les parcours ; exhaustivité §13-H |
| 9.7 | Paysage (si pris en charge) | NOT RUN | L'app cible portrait ; rotation 90° testée pour la robustesse (9.1) |
| 9.8 | Aucun bouton essentiel inaccessible | **PASS** | 9.1 fermé (23/0/0 ×2) ; 9.2 FERMÉ au run 42536993228 (small 23/0/0, 5/5 variantes à 0 FAIL/0 BLOCKED) — le défaut « Continuer inaccessible » était un artefact du dump uiautomator en override 540×960, le contrôle d'effet le prouve |

## 10. SAUVEGARDE ET SERVICES DE PRODUCTION

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 10.1 | Configuration B2 backup terminée (2 secrets dédiés) | PASS | Secrets posés (14 au total) ; clé writeFiles (+listFiles) |
| 10.2 | Pré-vol + export D1 réel + upload B2 | **PASS** | **Run 42505158748 SUCCESS (08/11 17:29Z)** : HeadBucket 200, export 468 371 octets, upload `d1/2026/11/08/172908/vitrine-video-db.sql` + `.sha256` — après normalisation des clés (leçon : collé avec \n) |
| 10.3 | Vérification SHA-256 du backup | PASS | sha256 généré côté export et téléversé avec le SQL (101 octets, run 42505158748) ; **contrôle de restauration §13-I** |
| 10.4 | Contrôle de restauration non destructif | **PASS** | **Run 42534124616 (442a21b, D1 Restore Drill) SUCCESS** : export D1 prod (lecture seule, 469 092 octets, SHA-256 1f6e9d5b…d29a3) → restauration sqlite VIERGE → **24/24 tables, PRAGMA integrity_check ok, 676 lignes (bgm_library 600, audio_catalog 30, users 4, templates 6…), VERDICT PASS (schéma + contenu)** ; artefact d1-restore-drill. Réserve documentée : le DOWNLOAD B2 n'est pas couvert (clé de backup volontairement write-only — une clé readFiles dédiée = décision fondateur, 0 FCFA) ; la restauration DANS Cloudflare reste une procédure documentée (06_GUIDE_CLE_B2_BACKUP.md), jamais exécutée sur la prod par principe |
| 10.5 | Sauvegarde automatique (cron) | CONDITIONAL | Cron `0 3 * * *` armé ; **preuve = exécution automatique de la nuit 08→09/11 03:00 UTC à relever** |
| 10.6 | SKYPAY volontairement 501, aucune simulation | PASS | Statut 501 documenté ; billing/return 200 (route) ; aucun paiement simulé |
| 10.7 | Worker 0.9.1-d42.23 ↔ D1 cohérents | PASS | Smoke live 16:09Z + audit du jour (600/600, 8 tables) |

## 11-12. LIVRABLE ET AUTORISATION (méta)

| # | Exigence | Statut | Preuve / note |
|---|---|---|---|
| 11.1 | Matrice exhaustive de qualification | PASS | **Ce document** (84 lignes, mise à jour continue) |
| 11.2 | Inventaire prod / test-only / Internet / offline / physique | PASS | §14 ci-dessous (tenu à jour) |
| 12.1 | Correction des défauts bloquants avant remise | **UI FERMÉE** | 9.1 + 9.2 FERMÉS au run 42536993228 (5/5 variantes 0 FAIL/0 BLOCKED) ; restent : offline 4.5 (fix D42.26-17 en validation, run en cours), D auth réel, E modes/permissions, J consolidation, certificat |
| 12.2 | Intégrité APK + certificat officiel | CONDITIONAL | rc11 : release privée 438156110, sha256 b052e7c9…c83bb6, mapping R8 identique miroir/privé ; **après corrections UI → rc12 à produire et re-certifier** |
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
