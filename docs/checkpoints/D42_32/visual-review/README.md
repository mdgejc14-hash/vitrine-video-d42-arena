# Galerie visuelle D42.32 — avant/après (revue fondateur)

**Produit réellement exécuté sur le commit candidat `a799c50`** — APK debug construite par le workflow, SHA-256 consigné dans chaque artefact (`apk_sha256.txt`). Aucune maquette, aucune image générée, aucune capture retouchée.

| | |
|---|---|
| **Commit candidat** | `a799c50` (main) — app issue de la chaîne D42.32 : Lots 1-10 + §4 quota serveur + §6 design system |
| **Avant (référence)** | RC15 `d42.30-rc15` — [galerie D42.31](../../D42_31/visual-review/README.md) (179 captures, release 442574529, SHA-256 `fd28ffc7…b78936`) |
| **Laboratoire** | e2e-lab **43582492529 = SUCCESS 15/15** (auth-local 22/22, backend-http quota 21/21, pixel5 23 PASS, camerap, offline, drafts, langues EN, petit-écran, security, gabarits-audit, **camera-diagnostic avec 2 MP4 réels**) |
| **Galerie** | visual-gallery-d42 **43582523983 = SUCCESS 3/3** (fr base 31 captures, fr suite 26, en base 50) |
| **Environnement** | Émulateur Android 11 (API 30), Pixel 5, 1080×2340 — **captures ÉMULATEUR, caméra ÉMULÉE** ; données 100 % fictives |
| **FLAG_SECURE** | Écrans d'export/aperçu/partage protégés par conception — preuves par **dumps XML + MP4 réellement exporté**, jamais contourné |
| **RC15** | Immuable — aucune RC16 avant l'accord explicite du fondateur (§12) |

Inventaires : [SCREEN_INVENTORY.csv](SCREEN_INVENTORY.csv) · [GABARITS_INVENTAIRE.csv](GABARITS_INVENTAIRE.csv) · [BEFORE_AFTER.csv](BEFORE_AFTER.csv) · [UX_AUDIT.md](UX_AUDIT.md) · manifeste captures : [captures/MANIFEST.tsv](captures/MANIFEST.tsv) · preuves caméra : [camera-preuves/](camera-preuves/) · runs : [RUNS.md](RUNS.md).

## Corrections D42.32 en une ligne chacune

1. **Lot 1+2** — Catalogue : le secteur choisi montre SES 5 gabarits (plus de filtre intégré), cartes premium.
2. **Lot 3+§5** — Caméra : diagnostic différentiel 4 sources ; mosaïque émulateur = scène virtuelle AVD (écart luminance Preview/MP4 0,1/1,0), AUCUNE modif CameraX ; physique = fondateur.
3. **Lot 4** — FR/EN complet (parcours + 30 gabarits).
4. **Lot 5** — Dashboard pro : en-tête nommé, carte crédits/qualité/sync honnête, action « Créer une vidéo ».
5. **Lot 6** — Parrainage : code visible + copier/partager + paliers.
6. **Lot 7+§4** — Tarifs exacts 500/3000/7500 ; **Pro 90 exports/30 j RÉELLEMENT appliqué côté serveur** (attribution serveur, contrôle atomique, idempotence) ; Pass 6, Boutique 200, cloud 1/5/20 ; 501 honnête.
7. **Lot 8** — Formulaires : WhatsApp international, prix stable, tutoiement, clavier « Suivant ».
8. **Lot 9** — Bienvenue : crédits confirmés, bouton épinglé 56 dp.
9. **Lot 10+§6** — Design system : PiedContinuer 52 dp, token AmbreAlerte, OrangeStore partout, déviations justifiées documentées.

## Sections (captures du candidat)


### Accueil & carrousel · avant RC15 : [galerie D42.31/01_accueil](../../D42_31/visual-review/01_accueil/)

[`splash_fr.png`](captures/01_accueil/splash_fr.png) — Splash (lancement)
![splash_fr.png](captures/01_accueil/splash_fr.png)
[`carrousel_1_fr.png`](captures/01_accueil/carrousel_1_fr.png) — Carrousel — Filme. Vends. C'est tout.
![carrousel_1_fr.png](captures/01_accueil/carrousel_1_fr.png)
[`carrousel_2_fr.png`](captures/01_accueil/carrousel_2_fr.png) — Carrousel — slide 2
![carrousel_2_fr.png](captures/01_accueil/carrousel_2_fr.png)
[`carrousel_3_fr.png`](captures/01_accueil/carrousel_3_fr.png) — Carrousel — slide 3
![carrousel_3_fr.png](captures/01_accueil/carrousel_3_fr.png)
[`splash_en.png`](captures/01_accueil/splash_en.png) — Splash EN
![splash_en.png](captures/01_accueil/splash_en.png)
[`carrousel_1_en.png`](captures/01_accueil/carrousel_1_en.png) — Carrousel EN — slide 1
![carrousel_1_en.png](captures/01_accueil/carrousel_1_en.png)


### Choix de la langue · avant RC15 : [galerie D42.31/02_langues](../../D42_31/visual-review/02_langues/)

[`langue_fr.png`](captures/02_langues/langue_fr.png) — Choix de langue (FR/EN seuls)
![langue_fr.png](captures/02_langues/langue_fr.png)
[`langue_en.png`](captures/02_langues/langue_en.png) — Language choice (FR/EN only)
![langue_en.png](captures/02_langues/langue_en.png)
[`langue_en_e2e.png`](captures/02_langues/langue_en_e2e.png) — Choix EN (job e2e langues)
![langue_en_e2e.png](captures/02_langues/langue_en_e2e.png)


### Authentification · avant RC15 : [galerie D42.31/03_authentification](../../D42_31/visual-review/03_authentification/)

[`auth_fr.png`](captures/03_authentification/auth_fr.png) — Connexion — bouton Google
![auth_fr.png](captures/03_authentification/auth_fr.png)
[`auth_en.png`](captures/03_authentification/auth_en.png) — Sign-in EN
![auth_en.png](captures/03_authentification/auth_en.png)
[`auth_offline.png`](captures/03_authentification/auth_offline.png) — Connexion hors réseau
![auth_offline.png](captures/03_authentification/auth_offline.png)


### Parrainage · avant RC15 : [galerie D42.31/04_parrainage](../../D42_31/visual-review/04_parrainage/)

[`etape_code_fr.png`](captures/04_parrainage/etape_code_fr.png) — Étape parrainage — saisie du code
![etape_code_fr.png](captures/04_parrainage/etape_code_fr.png)
[`dashboard_parrainage_fr.png`](captures/04_parrainage/dashboard_parrainage_fr.png) — Parrainage depuis le dashboard — jauge et code (Lot 6)
![dashboard_parrainage_fr.png](captures/04_parrainage/dashboard_parrainage_fr.png)
[`dashboard_parrainage_en.png`](captures/04_parrainage/dashboard_parrainage_en.png) — Referral from dashboard EN
![dashboard_parrainage_en.png](captures/04_parrainage/dashboard_parrainage_en.png)


### Crédits, bienvenue & formules · avant RC15 : [galerie D42.31/05_credits](../../D42_31/visual-review/05_credits/)

[`credits_bienvenue_fr.png`](captures/05_credits/credits_bienvenue_fr.png) — Bienvenue — confirmation des crédits (Lot 9)
![credits_bienvenue_fr.png](captures/05_credits/credits_bienvenue_fr.png)
[`paywall_fr.png`](captures/05_credits/paywall_fr.png) — Formules — Pass 500 / Pro 3000 / Boutique 7500 (Lot 7)
![paywall_fr.png](captures/05_credits/paywall_fr.png)
[`paywall_bas_fr.png`](captures/05_credits/paywall_bas_fr.png) — Formules — bas, badge Recommandé
![paywall_bas_fr.png](captures/05_credits/paywall_bas_fr.png)
[`paywall_suite_fr.png`](captures/05_credits/paywall_suite_fr.png) — Paywall (screenrecord repli, profil suite)
![paywall_suite_fr.png](captures/05_credits/paywall_suite_fr.png)
[`paywall_en.png`](captures/05_credits/paywall_en.png) — Plans EN
![paywall_en.png](captures/05_credits/paywall_en.png)
**`preuve_room_export_journal.db`** (1.7 Mo) — PREUVE quota app : base Room tirée du device — export_journal 1 ligne CONFIRMED, balanceAfter=2 (1 crédit bienvenue débité, eventId UUID)


### Secteurs (activité) · avant RC15 : [galerie D42.31/06_secteurs](../../D42_31/visual-review/06_secteurs/)

[`secteurs_fr.png`](captures/06_secteurs/secteurs_fr.png) — Choix du secteur (6 cartes 3D)
![secteurs_fr.png](captures/06_secteurs/secteurs_fr.png)
[`secteurs_bas_fr.png`](captures/06_secteurs/secteurs_bas_fr.png) — Secteurs — bas de liste
![secteurs_bas_fr.png](captures/06_secteurs/secteurs_bas_fr.png)
[`secteurs_en.png`](captures/06_secteurs/secteurs_en.png) — Sectors EN
![secteurs_en.png](captures/06_secteurs/secteurs_en.png)


### Catalogue · avant RC15 : [galerie D42.31/07_catalogue](../../D42_31/visual-review/07_catalogue/)

[`catalogue_haut_fr.png`](captures/07_catalogue/catalogue_haut_fr.png) — Catalogue — 5 gabarits du secteur (Lots 1+2)
![catalogue_haut_fr.png](captures/07_catalogue/catalogue_haut_fr.png)
[`catalogue_scroll_fr.png`](captures/07_catalogue/catalogue_scroll_fr.png) — Catalogue — défilé
![catalogue_scroll_fr.png](captures/07_catalogue/catalogue_scroll_fr.png)
[`catalogue_p1.png`](captures/07_catalogue/catalogue_p1.png) — Catalogue (job p1, parcours principal)
![catalogue_p1.png](captures/07_catalogue/catalogue_p1.png)
[`catalogue_en.png`](captures/07_catalogue/catalogue_en.png) — Catalog EN
![catalogue_en.png](captures/07_catalogue/catalogue_en.png)
[`catalogue_offline.png`](captures/07_catalogue/catalogue_offline.png) — Catalogue hors réseau
![catalogue_offline.png](captures/07_catalogue/catalogue_offline.png)


### Gabarits (vignettes) · avant RC15 : [galerie D42.31/08_gabarits](../../D42_31/visual-review/08_gabarits/)

[`vignettes_scroll_fr.png`](captures/08_gabarits/vignettes_scroll_fr.png) — Vignettes gabarits — gradients sectoriels (réf. GABARITS_INVENTAIRE.csv)
![vignettes_scroll_fr.png](captures/08_gabarits/vignettes_scroll_fr.png)
[`vignette_p1.png`](captures/08_gabarits/vignette_p1.png) — Vignettes (p1)
![vignette_p1.png](captures/08_gabarits/vignette_p1.png)


### Brief · avant RC15 : [galerie D42.31/09_brief](../../D42_31/visual-review/09_brief/)

[`brief_vide_fr.png`](captures/09_brief/brief_vide_fr.png) — Brief vide — Continuer désactivé
![brief_vide_fr.png](captures/09_brief/brief_vide_fr.png)
[`brief_rempli_fr.png`](captures/09_brief/brief_rempli_fr.png) — Brief rempli (valeurs fictives)
![brief_rempli_fr.png](captures/09_brief/brief_rempli_fr.png)
[`brief_final_fr.png`](captures/09_brief/brief_final_fr.png) — Brief — état final avant validation (PiedContinuer 52 dp, Lot 10)
![brief_final_fr.png](captures/09_brief/brief_final_fr.png)
[`brief_etape1_fr.png`](captures/09_brief/brief_etape1_fr.png) — Brief multi-étapes — étape 1
![brief_etape1_fr.png](captures/09_brief/brief_etape1_fr.png)
[`brief_etape8_fr.png`](captures/09_brief/brief_etape8_fr.png) — Brief multi-étapes — étape 8
![brief_etape8_fr.png](captures/09_brief/brief_etape8_fr.png)
[`brief_p1.png`](captures/09_brief/brief_p1.png) — Brief (job p1)
![brief_p1.png](captures/09_brief/brief_p1.png)
[`brief_bas_p1.png`](captures/09_brief/brief_bas_p1.png) — Brief — bas (bouton épinglé visible)
![brief_bas_p1.png](captures/09_brief/brief_bas_p1.png)
[`brief_drafts_reprise.png`](captures/09_brief/brief_drafts_reprise.png) — Brouillon repris (persistance saisie)
![brief_drafts_reprise.png](captures/09_brief/brief_drafts_reprise.png)
[`brief_drafts_partiel.png`](captures/09_brief/brief_drafts_partiel.png) — Saisie partielle sauvegardée
![brief_drafts_partiel.png](captures/09_brief/brief_drafts_partiel.png)


### Formulaires · avant RC15 : [galerie D42.31/10_formulaires](../../D42_31/visual-review/10_formulaires/)

[`whatsapp_clavier_fr.png`](captures/10_formulaires/whatsapp_clavier_fr.png) — Champ WhatsApp — clavier ouvert (Lot 8)
![whatsapp_clavier_fr.png](captures/10_formulaires/whatsapp_clavier_fr.png)
[`whatsapp_clavier_en.png`](captures/10_formulaires/whatsapp_clavier_en.png) — WhatsApp field — keyboard open EN
![whatsapp_clavier_en.png](captures/10_formulaires/whatsapp_clavier_en.png)


### Vérification avant tournage · avant RC15 : [galerie D42.31/11_verification](../../D42_31/visual-review/11_verification/)

[`verification_fr.png`](captures/11_verification/verification_fr.png) — Vérification avant tournage
![verification_fr.png](captures/11_verification/verification_fr.png)
[`verification_bas_fr.png`](captures/11_verification/verification_bas_fr.png) — Vérification — bas
![verification_bas_fr.png](captures/11_verification/verification_bas_fr.png)
[`ready_p1.png`](captures/11_verification/ready_p1.png) — ReadyCheck (job p1)
![ready_p1.png](captures/11_verification/ready_p1.png)


### Caméra · avant RC15 : [galerie D42.31/12_camera](../../D42_31/visual-review/12_camera/)

[`camera_guide_fr.png`](captures/12_camera/camera_guide_fr.png) — Guide de tournage — consignes
![camera_guide_fr.png](captures/12_camera/camera_guide_fr.png)
[`camera_preview_en.png`](captures/12_camera/camera_preview_en.png) — Viseur (flux ÉMULÉ)
![camera_preview_en.png](captures/12_camera/camera_preview_en.png)
[`camera_p1.png`](captures/12_camera/camera_p1.png) — Caméra guidée (job p1)
![camera_p1.png](captures/12_camera/camera_p1.png)
[`camera_ecran_p1.png`](captures/12_camera/camera_ecran_p1.png) — Écran caméra (job p1)
![camera_ecran_p1.png](captures/12_camera/camera_ecran_p1.png)
[`camera_permission_camerap.png`](captures/12_camera/camera_permission_camerap.png) — Dialogue permission caméra (job camerap)
![camera_permission_camerap.png](captures/12_camera/camera_permission_camerap.png)


### Prises guidées · avant RC15 : [galerie D42.31/13_prises](../../D42_31/visual-review/13_prises/)

[`countdown_a_en.png`](captures/13_prises/countdown_a_en.png) — Compte à rebours 3-2-1 (VÉRITABLE)
![countdown_a_en.png](captures/13_prises/countdown_a_en.png)
[`countdown_b_en.png`](captures/13_prises/countdown_b_en.png) — Compte à rebours — suite
![countdown_b_en.png](captures/13_prises/countdown_b_en.png)
[`rec_en.png`](captures/13_prises/rec_en.png) — Enregistrement — badge REC + HUD
![rec_en.png](captures/13_prises/rec_en.png)
[`arret_en.png`](captures/13_prises/arret_en.png) — Arrêt de prise
![arret_en.png](captures/13_prises/arret_en.png)
[`avant_en.png`](captures/13_prises/avant_en.png) — Bascule caméra avant
![avant_en.png](captures/13_prises/avant_en.png)
[`arriere_en.png`](captures/13_prises/arriere_en.png) — Bascule caméra arrière
![arriere_en.png](captures/13_prises/arriere_en.png)
[`refaire_en.png`](captures/13_prises/refaire_en.png) — Refaire une prise
![refaire_en.png](captures/13_prises/refaire_en.png)
[`scene2_en.png`](captures/13_prises/scene2_en.png) — Scène 2 du guide
![scene2_en.png](captures/13_prises/scene2_en.png)
[`prise_rec_p1.png`](captures/13_prises/prise_rec_p1.png) — Prise 1 — enregistrement (job p1)
![prise_rec_p1.png](captures/13_prises/prise_rec_p1.png)
[`prise_faite_p1.png`](captures/13_prises/prise_faite_p1.png) — Prise 1 faite (job p1)
![prise_faite_p1.png](captures/13_prises/prise_faite_p1.png)
[`prise2_rec_p1.png`](captures/13_prises/prise2_rec_p1.png) — Prise 2 — enregistrement (job p1)
![prise2_rec_p1.png](captures/13_prises/prise2_rec_p1.png)
[`refaire_camerap.png`](captures/13_prises/refaire_camerap.png) — Après Refaire (job camerap)
![refaire_camerap.png](captures/13_prises/refaire_camerap.png)


### Historique / tableau de bord · avant RC15 : [galerie D42.31/17_historique](../../D42_31/visual-review/17_historique/)

[`dashboard_fr.png`](captures/17_historique/dashboard_fr.png) — Mon espace — tableau de bord (Lot 5)
![dashboard_fr.png](captures/17_historique/dashboard_fr.png)
[`dashboard_bas_fr.png`](captures/17_historique/dashboard_bas_fr.png) — Dashboard — bas de page
![dashboard_bas_fr.png](captures/17_historique/dashboard_bas_fr.png)
[`dashboard_suite_fr.png`](captures/17_historique/dashboard_suite_fr.png) — Dashboard (profil suite, screenrecord repli)
![dashboard_suite_fr.png](captures/17_historique/dashboard_suite_fr.png)
[`dashboard_en.png`](captures/17_historique/dashboard_en.png) — Dashboard EN
![dashboard_en.png](captures/17_historique/dashboard_en.png)


### Profil & réglages · avant RC15 : [galerie D42.31/19_profil](../../D42_31/visual-review/19_profil/)

[`profil_reglages_fr.png`](captures/19_profil/profil_reglages_fr.png) — Réglages (langue, nettoyage, déconnexion)
![profil_reglages_fr.png](captures/19_profil/profil_reglages_fr.png)
[`profil_reglages_en.png`](captures/19_profil/profil_reglages_en.png) — Settings EN
![profil_reglages_en.png](captures/19_profil/profil_reglages_en.png)


### Hors connexion · avant RC15 : [galerie D42.31/20_hors_connexion](../../D42_31/visual-review/20_hors_connexion/)

[`offline_langue.png`](captures/20_hors_connexion/offline_langue.png) — Hors réseau — écran langue
![offline_langue.png](captures/20_hors_connexion/offline_langue.png)
[`offline_carrousel.png`](captures/20_hors_connexion/offline_carrousel.png) — Hors réseau — carrousel
![offline_carrousel.png](captures/20_hors_connexion/offline_carrousel.png)
[`offline_bienvenue.png`](captures/20_hors_connexion/offline_bienvenue.png) — Hors réseau — bienvenue
![offline_bienvenue.png](captures/20_hors_connexion/offline_bienvenue.png)
[`offline_redemarrage.png`](captures/20_hors_connexion/offline_redemarrage.png) — Hors réseau — redémarrage
![offline_redemarrage.png](captures/20_hors_connexion/offline_redemarrage.png)
[`offline_retour_reseau.png`](captures/20_hors_connexion/offline_retour_reseau.png) — Retour réseau — resynchronisation
![offline_retour_reseau.png](captures/20_hors_connexion/offline_retour_reseau.png)


### Conditions (petit écran, police 130 %, paysage)

[`petit_ecran_base.png`](captures/21_conditions/petit_ecran_base.png) — Petit écran 540×960 — secteurs
![petit_ecran_base.png](captures/21_conditions/petit_ecran_base.png)
[`petit_ecran_bienvenue.png`](captures/21_conditions/petit_ecran_bienvenue.png) — Petit écran — bienvenue (bouton 56 dp visible)
![petit_ecran_bienvenue.png](captures/21_conditions/petit_ecran_bienvenue.png)
[`petit_ecran_catalogue.png`](captures/21_conditions/petit_ecran_catalogue.png) — Petit écran — catalogue 5 gabarits
![petit_ecran_catalogue.png](captures/21_conditions/petit_ecran_catalogue.png)
[`font130_langue.png`](captures/21_conditions/font130_langue.png) — Police 130 % — langue
![font130_langue.png](captures/21_conditions/font130_langue.png)
[`font130_bienvenue.png`](captures/21_conditions/font130_bienvenue.png) — Police 130 % — bienvenue
![font130_bienvenue.png](captures/21_conditions/font130_bienvenue.png)
[`font130_catalogue.png`](captures/21_conditions/font130_catalogue.png) — Police 130 % — catalogue
![font130_catalogue.png](captures/21_conditions/font130_catalogue.png)
[`rot90_carrousel.png`](captures/21_conditions/rot90_carrousel.png) — Rotation paysage — carrousel
![rot90_carrousel.png](captures/21_conditions/rot90_carrousel.png)
[`rot90_bienvenue.png`](captures/21_conditions/rot90_bienvenue.png) — Rotation paysage — bienvenue
![rot90_bienvenue.png](captures/21_conditions/rot90_bienvenue.png)


### Export · avant RC15 : [galerie D42.31/16_export](../../D42_31/visual-review/16_export/)

**`export-tire-candidat.mp4`** (4.4 Mo) — VIDÉO RÉELLEMENT EXPORTÉE par le candidat (MP4 tiré du device, profil suite — contient aussi la musique BGM automatique)
**`dump_export_termine.xml`** (13 Ko) — PREUVE dump (écran FLAG_SECURE : capture pixel impossible par conception — protection produit, jamais contournée)
**`dump_partage_feuille.xml`** (10 Ko) — PREUVE dump (écran FLAG_SECURE : capture pixel impossible par conception — protection produit, jamais contournée)
**`dump_e7_apercu.xml`** (7 Ko) — PREUVE dump (écran FLAG_SECURE : capture pixel impossible par conception — protection produit, jamais contournée)


### Partage · avant RC15 : [galerie D42.31/18_partage](../../D42_31/visual-review/18_partage/)

**`dump_partage_feuille.xml`** (10 Ko) — PREUVE dump : feuille de partage OUVERTE (Share, export-0.mp4, Bluetooth, Messaging) — écran système sur FLAG_SECURE, capture pixel impossible


## Gaps documentés (jamais masqués)

- **FLAG_SECURE** (protection produit, jamais contournée) : aperçu E7, « Vidéo prête », notification, feuille de partage — `screencap` vide PAR CONCEPTION ; preuves = dumps XML (`dump_e7_apercu.xml`, `dump_export_termine.xml`, `dump_partage_feuille.xml`) + **MP4 réellement exporté** (`export-tire-candidat.mp4`, 4,4 Mo, contient la musique BGM automatique).
- **PNG vides sous charge swiftshader** (run e2e p1 : 27/26b/28/29/30 ; run galerie en : 034-041) — conservés dans les artefacts, jamais présentés comme captures ; les mêmes écrans sont prouvés autrement (dumps, MP4, run EN antérieur pour la visée).
- **Audio = automatique** (BgmSelection, 600 compositions) : pas d'écran de choix — by design ; preuve = code + tests + audit audio + BGM audible dans le MP4 exporté.
- **Caméra virtuelle AVD** : le viseur montre la scène synthétique colorée de l'émulateur — c'est la SOURCE, pas l'app (PreviewView et MP4 quasi identiques) ; **validation capteur physique = fondateur**.
- Profil « suite » : réglages non atteints après 5 défilements (gap du run suite) — couvert par le run **fr base** (`19_profil/profil_reglages_fr.png`) et **en base** (`profil_reglages_en.png`).

## Preuves tests (résumé)

| Banc | Run | Résultat |
|---|---|---|
| android-ci (compile + unitaires) | 43582492468 (a799c50) | **SUCCESS** |
| e2e-lab 15 jobs | 43582492529 (a799c50) | **SUCCESS 15/15** |
| auth-local (D41/D42.8 + 403 empreinte) | idem | 22/22 PASS |
| backend-http (contrat H1-H10 + quota_unit 21/21) | idem | PASS |
| camera-diagnostic v4 (2 rapports, 10 PNG, 2 MP4) | idem | **PASS — preuves complètes** |
| pixel5 (parcours nominal) | idem | 23 PASS / 0 FAIL |
| visual-gallery-d32 3 jobs | 43582523983 (a799c50) | **SUCCESS 3/3** |

Détail des artefacts : [RUNS.md](RUNS.md). Quota serveur : `tools/e2e/quota_unit.mjs` (21 tests frontière), SQL validé SQLite réel (90e OK / 91e refusée / rejeu idempotent), preuve app : `captures/05_credits/preuve_room_export_journal.db` (export_journal CONFIRMED, balanceAfter=2).

## Porte d'approbation (§12)

Cette galerie est la pièce à conviction pour la décision fondateur :
1. **Approbation** → Phase C : APK signée officiellement, checksum, E2E sur l'APK exacte, release GitHub, test capteur physique par le fondateur.
2. **Refus** → corrections ciblées, nouvelle galerie, nouvelle passe.

RC15 reste la référence tant que la porte n'est pas passée. Aucune RC16 n'a été construite.
