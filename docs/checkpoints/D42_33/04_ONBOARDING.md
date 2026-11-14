# D42.33 — 04 Famille Onboarding (famille A + B)

Commit : eba2f2d (sur 541ac8c). Écrans : splash, carrousel ×3, langue, auth,
code parrain, secteurs, bienvenue/crédits.

## Réalisations (spec §8-A/B, §9.1, §9.2, §9.4)

| Écran | Fichier | Changements visuels | Fonctionnel |
|---|---|---|---|
| Ouverture | `themes.xml` + `splash_logo_tuile.png` | Fond **navy** #022358 (avant blanc), insigne dans une **tuile blanche rayon 26** 288 px (PIL : tuile + logo 180). | Splash système conservé (installSplashScreen), flux onCreate INTACT. Écart documenté : pas de barre 3 dp (non rendue par l'API splash 12+) ; ≤ 1,2 s garanti par le système. |
| Carrousel ×3 | `CarouselScreen.kt` | **§9.2 intégral** : photos plein cadre (3 WebP locaux), voile navy dégradé 45 %, marque en tuile blanche 44, pagination actif = pilule 18 orange / inactifs 6 blanc 45 %, **H1 29 blanc**, Sub blanc 80 % 2 lignes, CTA pilule 56, lien « Passer ». | Pager/swipe + avance par CTA conservés ; `carousel_cta` testTag ajouté. Nouvelle chaîne `carousel_skip` FR/EN. |
| Langue | `LanguageScreen.kt` | Fond Bg, titre H2, **cartes-options 72 dp rayon 22 + shSm**, pastille typographique « FR »/« EN » sur voile orange (**emojis drapeaux supprimés** — §6), chevron. | onPick("fr"/"en") inchangé ; FR/EN seuls. |
| Auth | `activity_auth.xml` | Fond Bg, insigne tuile blanche 26, titre Jakarta 21, sous-titre Sub Muted, **bouton Google = pilule blanche 56 filet Line + logo G officiel multicolore** (drawableStart), repli « sans compte » ancré 48 dp, **3 bénéfices réels** avec coches. | IDs/types/Button référencés par AuthActivity INTACTS (auth_google_button, auth_offline_button, progress, preparing, status). Chaînes bénéfices FR/EN (vérités produit : export local, montage hors ligne D19, SSO sans mot de passe). |
| Code parrain | `OnboardingScreens.kt` | Marge 24→**20**, H2 + badge « 2 / 3 », **ChampFormulaire §7.9** (label au-dessus, erreur ambre, testTag refcode_field), CTA pilule (refcode_continue), lien « passer sans code » 48 dp. | RefCodeParser + onDone(normalise/null) inchangés. |
| Secteurs | `SectorCard3D.kt` + `OnboardingScreens.kt` | Cartes rayon **22** ; sélection = **filet 2 dp OrangeStore + coche pastille orange** (§8-B) ; non sélectionnée = shSm sans filet (règle §7.4) ; illustration 4:3 conservée (D42.13) ; libellé BodyStrong ; **emoji fallback supprimé** (pastille typographique). Marge 20, titre H2, CTA pilule (sector_continue). | Grille 2 col + gouttière 12, sélection par défaut MODE, barre épinglée D42.12 : INTACTS. |
| Bienvenue | `OnboardingScreens.kt` | **§9.4 intégral** : fond navy + halos, marque + badge « Compte créé », **tuile cadeau 96 orange rayon 30 double anneau**, **H1 « Félicitations ! »** (titre générique — jamais de prénom), carte de solde blanc 6 % rayon 26 + badge Confirmé + **3 tuiles « Vidéo 1/2/3 » quand le solde confirmé = 3** (sinon chiffre réel en Num — jamais inventé), 3 réassurances réelles, CTA pilule « Créer ma première vidéo », « Plus tard », mention carte bancaire. | **Les 4 états honnêtes D42.30 conservés à l'identique** (attente/ok/horsligne/refuse + messageRefus exact). Signature WelcomeScreen inchangée. CTA et « Plus tard » mènent tous deux à onContinue (même action réelle, aucun contrat modifié). |

## Photographies carrousel (mission « photographies prioritaires »)

3 WebP 720×1280 embarqués dans `feature-onboarding/res/drawable-nodpi/`
(générés par l'agent, description du sujet : commerçante africaine en boutique
de mode → prise de vue produit au smartphone → résultat vidéo prête à publier ;
famille artistique cohérente lumière dorée, aucun texte dans l'image).
⚠️ Limite documentée : l'environnement d'exécution n'a pas de vision — les
PNG sources sont versionnés dans `assets_carrousel/` (workspace) et les WebP
embarqués ; le fondateur les validera à la porte d'approbation. Licence :
générées pour le projet (manifeste ASSET_LICENSES.md à venir, galerie).

## Chaînes ajoutées (FR source / EN parité)

`carousel_skip` · `auth_benefit_1/2/3` · `welcome_title` (« Félicitations ! » /
« Congratulations! », remplace « Bienvenue »/« Welcome ») · `welcome_sub_gift`
· `welcome_solde_titre` · `welcome_badge_confirme/attente` · `welcome_video_n`
· `welcome_reassur_1/2/3` · `welcome_cta` · `welcome_plus_tard` ·
`welcome_no_card` · `welcome_badge_compte`.

⚠️ Changement de libellé assumé et documenté : CTA bienvenue « Continuer » →
« Créer ma première vidéo » (spec §9.4, écran signature « à reproduire au plus
près »). **Adaptation d'instrumentation** : `tools/e2e/run_p0.sh` S16 tape le
nouveau libellé avec repli sur l'ancien (même contrôle d'effet : bouton
d'accueil → catalogue) ; `run_gallery.sh` idem (CTA_BIENVENUE). Aucune
sémantique de test modifiée.

## Vérifications en cours

- android-ci sur eba2f2d (compilation + ktlint + detekt + tests JVM).
- e2e-lab complet au checkpoint 12 (non-régression).
