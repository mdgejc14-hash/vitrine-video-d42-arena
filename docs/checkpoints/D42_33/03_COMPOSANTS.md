# D42.33 — 03 Composants du design system (core-designsystem)

Base : commit 67e3674 + correctif VertVoile (ordre d'initialisation).

## Set d'icônes (§6) — 26 VectorDrawables XML

Grille 24, contour **1,75 dp**, bouts/jointures arrondis, teinte au rendu
(`IconeVitrine`) : arrow_back, check, close, plus, chevron_right, info, warning,
share, refresh, phone, mail, bell, play (plein autorisé), download, camera, film,
clock, cloud, wifioff, gift, shield, target, wave, video.
Logos tiers OFFICIELS non recolorés : `ic_google_g` (4 couleurs officielles),
`ic_whatsapp` (#25D366). Zéro nouvelle dépendance (pas de material-icons-extended).

## Composants livrés (spec §7 — une seule source de vérité chacun)

| # | Composant | Spec | Fichier |
|---|---|---|---|
| 1 | `BoutonPrimaire` — pilule 56, dégradé OrangeHi→OrangeStore, shOrange, échelle 0,98 à l'appui, désactivé #EDEFF5 sans ombre, chargement spinner 18 | §7.1 | Boutons.kt |
| 2 | `BoutonSecondaire` — pilule 46, filet Line, variante douce OrangeVoile/OrangeDeep | §7.2 | Boutons.kt |
| 3 | `BoutonIcone` — 40 dp rayon 14, variantes Clair/Voile/Verre, cible 48 | §7.3 | Boutons.kt |
| 4 | `IconeVitrine` + `PastilleLogoTiers` (44 dp, logos officiels) | §6 | Boutons.kt |
| 5 | `CarteVitrine` — rayon 22/26, padding 18/20, shSm/shMd, plate→filet | §7.4 | Cartes.kt |
| 6 | `CarteHeroSombre` — navy + 2 halos, Label blanc 60, Num 40, badges blanc 10 %, décor anneau orange 56 | §7.5 | Cartes.kt |
| 7 | `haloSombre()` — halo orange haut droit + navy bas gauche (blocs sombres = pas d'ombre) | §5 | Cartes.kt |
| 8 | `BadgeVitrine` — 22 dp, 4 teintes sémantiques | §7.6 | Badges.kt |
| 9 | `ChipFiltre` — 32 dp, actif navy | §7.6 | Badges.kt |
| 10 | `PointSynchro` — 7 dp + halo, 3 états | §7.6 | Badges.kt |
| 11 | `LigneListe` + `TuileIcone` — min 72, vignette 48, progression, action/chevron | §7.7 | LigneListe.kt |
| 12 | `BarreProgression` — 4 dp, piste #EDEFF5, vert si terminé | §7.8 | Progression.kt |
| 13 | `StepperScenes` — 4 segments espacés 4 dp, actif orange/validé navy | §7.8 | Progression.kt |
| 14 | `AnneauProgression` — épaisseur 6, arc dégradé orange, libellé TOUJOURS sous l'anneau | §7.11 | Progression.kt |
| 15 | `ChampFormulaire` — 56 dp rayon 18, label Tiny au-dessus, focus orange, erreur ambre, compteur 90 % | §7.9 | Champ.kt |
| 16 | `FeuilleVitrine` — coins 30, poignée 40×4, shLg | §7.10 | Feuille.kt |
| 17 | `TuilePrise` — 16:9 rayon 18, badge durée réel, états vide/validée/à refaire | §7.12 | TuilePrise.kt |
| 18 | `BarreOnglets` — 74+26, 4 entrées + slot central, action centrale 56 orange décalée −18 | §7.13 | TabBar.kt |
| 19 | `BandeauEtat` — rayon 18, hors-ligne ambre (jamais rouge), 4 niveaux | §7.14 | BandeauEtat.kt |
| 20 | `OverlayViseur` + `BandeauConsigne` + `BoutonStopCamera` (64 dp rouge) | §7.15 | OverlayCamera.kt |
| 21 | `CarteVide` — §10 | §10 | EtatsVides.kt |
| 22 | `CarteFormule` — grille tarifaire officielle, recommandée navy, CTA honnête (inactif tant que paiement non branché) | note §8 | CarteFormule.kt |

## Règles respectées

- Aucune string en dur dans le DS (libellés passés par l'appelant) — sauf
  structure purement décorative.
- Aucune donnée inventée : chiffres/durées/libellés toujours en paramètre.
- Un seul CTA orange possible par écran : `BoutonPrimaire` est la SEULE source
  du dégradé + shOrange.
- Cibles tactiles ≥ 48 dp partout (boutons icône, points, chips).
- Les mêmes ViewModels/contrats ne sont pas touchés : composants purs UI.

## Écarts documentés (choix techniques Compose)

1. **Ombres** : multi-couches CSS → ombre Compose unique teintée navy/orange
   (Elevation.kt, API 28+ pour la teinte, neutre en-dessous).
2. **Verre (glass)** : translucide blanc 18 % sans backdrop-blur réel (API 31+
   requis pour RenderEffect ; dégradation cohérente sur le parc cible).
3. **Halos** : cercles flous approchés par cercles pleins semi-transparents
   (pas de blur par pixel sur API 24).

## Validation

- Passe ktlint manuelle (imports triés, sans doublon, sans fantôme).
- Compilation : android-ci sur la branche (run en cours au commit suivant).
