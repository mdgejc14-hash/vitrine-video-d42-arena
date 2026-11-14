# D42.33 v2 — Audit de fidélité au design (écran par écran)

**Ordre fondateur du 14/11 (prioritaire, échéance 18/11/2026).** Question posée : *la refonte
respecte-t-elle la direction artistique originale ?* Réponse apportée écran par écran, avec pour
chaque ligne : **maquette / fichier / composant / capture / statut**. Détail complet des états,
langues et résolutions : `SCREEN_INVENTORY.csv` (même dossier, **90 états inventoriés** :
21 CONFORME + 3 CONFORME partiel + 57 NON PROUVÉ à capturer au Lot 2 + 7 ÉCART ASSUMÉ +
1 NON APPLICABLE + 1 DOCUMENTÉ). Galerie visuelle : `visual-review/` (transformée au Lot 3).

## Méthode (honnête, reproductible)

1. **Référentiel** : `SOURCES/spec/05_Spec_design_a_transmettre.md` (lue intégralement, 419 l.),
   34 maquettes 1179×2556, `SOURCES/references/`. L'environnement d'exécution n'a **pas de
   capacité vision** sur les PNG (constat du checkpoint 00, toujours vrai) : la **spécification
   chiffrée** fait autorité, et la conformité chromatique est **prouvée par analyse de pixels**
   (outil versionné `visual-review/tools/audit_tokens.py` : % de pixels conformes aux tokens §3,
   tolérance anticrénelage ΔE Manhattan ≤ 24).
2. **Vérité terrain** : code du dépôt (branche `d42.33-visual-redesign` @ 3a28366) + captures
   authentiques existantes (Robolectric CI D42.33 ; émulateur e2e D42.32 = AVANT).
3. **Statuts** — `CONFORME` (preuve capture + code) · `NON PROUVÉ` (code audité conforme, capture
   APRÈS à produire au Lot 2) · `ÉCART ASSUMÉ` (divergence documentée, décision motivée, fondateur
   tranche) · `NON APPLICABLE` (décision fondateur) · `DOCUMENTÉ` (recensement honnête).
   **Aucun FAIL n'est transformé en PASS.**

## A. Preuve programmatique chromatique (audit_tokens.py)

Captures APRÈS (v1, 26 uniques) — part des pixels sur les tokens officiels §3 :

| Capture APRÈS | % tokens | Hors-tokens dominant | Nature |
|---|---|---|---|
| 01 langue | 98,6 % | AA Line/Bg | négligeable |
| 03 secteurs | 92,8 % | AA Line/Bg | négligeable |
| 05/06/07 guides caméra | 99,4–99,7 % | AA | **l'AVANT contenait 13,8–19,3 % de gris #323232 (vieux fond) — éradiqué** |
| 08 import rushs | 98,0 % | AA | négligeable |
| 09 aperçu export | 95,4 % | halo navy | légitime §5 |
| 10 marque | 99,2 % | AA orange | négligeable |
| 12/13 dashboard | 94,0–95,8 % | #213E6C + #8A4330 = **halos** | légitime §5 (halos orange/navy) |
| 14 parrainage | 97,4–97,9 % | AA | négligeable |
| 15 paywall | 86,8–87,2 % | #14336E/#4D3543 = dégradé CTA + halos | légitime §3/§5 |
| 16 réglages | 94,6 % | AA Line | négligeable |
| 20/21/22/23/24 robustesse | 85,0–97,4 % | idem ci-dessus | légitime |
| 02 carrousel | 19,0 % | **photo plein cadre** | contenu, pas un écart UI |

Verdict : **aucune couleur hors tokens dans la peinture UI des captures v1** ; les résidus
sont de l'anticrénelage, les halos prévus §5, le dégradé CTA §3/7.1 ou du contenu photo.
La capture 02 (carrousel) est en qualifier **defaut 320×470** — à refaire en w360dp-h820dp (Lot 2).

## B. Audit écran par écran (12 parcours)

Légende statuts : ✅ CONFORME · ◐ NON PROUVÉ (Lot 2) · ⚠ ÉCART ASSUMÉ · ⛔ NON APPLICABLE.

| # | Écran | Maquette | Fichier / composant | Capture APRÈS | Statut |
|---|---|---|---|---|---|
| P01 | Ouverture (splash) | 01 | `themes.xml` Theme.SplashScreen | impossible Robolectric | ◐ code conforme ; barre §9.1 non rendue par l'API splash (écart documenté) |
| P01 | Sélection langue FR/EN | 03 | `LanguageScreen` | ✅ FR / ◐ EN | ✅ 98,6 % |
| P01 | Connexion FR/EN/offline | 04, 05 | `AuthActivity` + `activity_auth.xml` | ◐×3 | XML repeint (Jakarta/Inter + tokens vérifiés au code) |
| P01 | Code parrain (deep-link) | 06 | `AuthActivity` + `RefCodeParser` | ◐ | ⚠ pas de saisie manuelle (parcours D41 F34/F63) |
| P01 | Bienvenue / crédits | 27 | `WelcomeScreen` (§9.4 : 3 tuiles physiques) | ◐ | ✅ code (checkpoint 04) |
| P02 | Carrousel ×3 + EN | 02 | `CarouselScreen` | ◐ (v1 = 320×470, slide 1 seulement) | ✅ code ; captures Lot 2 |
| P02 | Secteurs FR/EN + bas | 07 | `OnboardingScreen` | ✅ FR / ◐×2 | ✅ 92,8 % |
| P03 | Catalogue (secteur, tuiles, scroll, EN, offline) | 08 | `CatalogScreen` | ✅×2 FR / ◐×3 | ✅ filtrage prouvé sémantiquement |
| P03 | Détail gabarit | 09 | — (tuile → brief direct) | — | ⚠ **écran absent du parcours réel** (interdit d'ajouter) |
| P04 | Brief étapes 1→8 (vide/rempli/récap/drafts/bas) | 10, 11 | `GabaritBriefScreen` (BriefHeader, PiedContinuer, champs §7.9) | ◐×7 | ✅ code (checkpoint 06) |
| P04 | Import rushs | — | `BriefScreen` | ✅ | ✅ 98,0 % |
| P04 | WhatsApp clavier FR/EN | — | `TelephoneField` | ◐×2 | clavier non rendu par Robolectric (limite honnête) |
| P04 | Préparation caméra §9.6 | 33 (+12) | `ReadyCheckScreen` (4 tests, score, CTA conditionnel) | ◐×2 | ✅ code (checkpoint 06) ; écran NOUVEAU D42.33 (pas d'AVANT par nature) |
| P04 | Consentement client | 16 | `AlertDialog` porte R4 | — | ⚠ dialogue système vs maquette dessinée (porte légale immuable) |
| P05 | Guides caméra ×3 secteurs | 13 | `GuidedShootingOverlay` | ✅×3 | ✅ 99,4–99,7 % (gris AVANT éradiqué) |
| P05 | Viseur prise, countdown, REC, arrêt, refaire, scène 2 | 13, 14, 15 | `PriseGuideScreen` | ◐×7 | ✅ code (checkpoint 07) |
| P05 | Permission refusée ; diagnostic | 13 | dialogues + `CameraDiagnosticActivity` | ◐×2 | §10 |
| P06 | Revue des prises (écran dédié) | 17 | — (validation prise par prise dans le HUD) | — | ⚠ **écran absent du parcours réel** |
| P07 | Aperçu montage E7 | 18 | `VideoPreviewScreen` | ◐ (v1 = panneau seul 360×199) | ✅ code ; écran complet Lot 2 |
| P07 | Montage en cours E8 | 19 | `ExportActivity` + `activity_export.xml` | ◐ | ✅ code (tokens en dur vérifiés) |
| P08 | Export prêt | 20 | état SUCCEEDED de E8 (CTA 56 dp orange + lien 48 dp #D34905) | ◐ | ⚠ **§9.5 non reproduit littéralement** : pas d'écran dédié aplat orange + feuille r30 (parcours inchangeable) |
| P09 | Partage | 21 | `ACTION_SEND` feuille système | — | ⚠ feuille système vs feuille in-app dessinée (parcours inchangeable) |
| P10 | Dashboard (synchrone/bas/suite/EN/hors-ligne/formule) | 24, 32 | `DashboardScreen` (§9.3 intégral : header avatar, carte héro, CTA, Reprendre, Derniers exports, tab bar) | ✅×3 / ◐×3 | ✅ 94,0–95,8 % ; **AVANT émulateur D42.32 disponible** (corrige le « AVANT NON DISPONIBLE » v1) |
| P10 | Réglages FR/EN | 29 | `SettingsScreen` + `LigneListe` | ✅ FR / ◐ EN | ✅ 94,6 % |
| P10 | Mes vidéos | 25 | — (ligne « Derniers exports ») | — | ⚠ écran dédié absent (inventer = interdit) |
| P10 | Conditions / CGU | 30 | — (aucune ressource) | — | ⚠ contenu légal inexistant au dépôt (créer = inventer) |
| P10 | Aide & contact | 31, 34 | REFUSÉ | — | ⛔ décision fondateur prioritaire (§9.7 non implémenté) |
| P11 | Formules/paywall (quota, l10n FR/EN, bas) | 26 | `PaywallScreen` | ✅×3 / ◐ | ✅ 86,8 % (halos + dégradé légitimes) |
| P11 | Parrainage (FR/EN) | 28 | `ReferralScreen` | ✅×2 | ✅ 97,4 % |
| P12 | fontScale 1,3 (bienvenue/langue/catalogue/dashboard/parrainage/réglages) | §12.1 | tous écrans | ✅×3 / ◐×3 | ✅ pour les v1 |
| P12 | Petit écran 360×640 (base/bienvenue/catalogue/paywall/dashboard) | §12.2 | tous écrans | ✅×2 / ◐×3 | ✅ pour les v1 |
| P12 | Rotation (dashboard/bienvenue/carrousel) | §12.3 | tous écrans | ✅×1 / ◐×2 | ✅ pour la v1 |
| P12 | Hors connexion (langue/bienvenue/carrousel/redémarrage/retour réseau) | 22 | états §10 | ✐ partiel / ◐×4 | bandeau + point ambre prouvés (capture EN) |
| P12 | l10n ES/JA générées par les tests | — | `l10n-paywall-es` etc. | artefacts CI | DOCUMENTÉ (hors règle galerie FR/EN) |

## C. Écarts avérés et decisions (récapitulatif)

**Écarts vs maquette ASSUMÉS (parcours préservé — le fondateur tranche)** :
1. **§9.5 Export prêt** : l'écran signature (aplat orange 52 %, feuille blanche r30 chevauchante)
   n'existe pas ; l'état « terminé » repeint l'écran E8 existant. Motif : interdiction de changer
   le parcours / d'ajouter un écran. — *Seul écart deComposition majeur vs maquettes.*
2. **Feuille de partage** : feuille SYSTÈME Android (WhatsApp officiel) au lieu d'une feuille
   in-app dessinée (maquette 21).
3. **Consentement client** (maquette 16) : AlertDialog système à la porte légale R4.
4. **Détail gabarit** (maquette 09), **Revue des prises** (17), **Mes vidéos** (25),
   **Conditions** (30) : écrans dédiés absents du parcours réel (créer = changer le parcours ou
   inventer des données/textes). L'information est portée par les écrans existants repeints.
5. **Code parrain** (06) : deep-link détecté, pas de saisie manuelle (décision D41).

**Écarts de conformité spec documentés (mesurés — WCAG, vérifiés par calcul, non bloquants)** :
6. Contraste **Muted #6C7C99 = 4,22:1 sur blanc** et **3,97:1 sur Bg #F7F8FC** (< 4,5 exigé §3
   pour le texte ; ≥ 3:1 ok pour icônes) — usage limité aux méta/libellés 12,5 sp. Non corrigé :
   toucher #6C7C99 changerait la teinte validée des maquettes. **À trancher par le fondateur.**
7. **Blanc sur OrangeStore = 3,20:1** dans le badge « EXPORTS RESTANTS » 11 sp (§3 : texte sur
   orange = blanc ≥ 15 dp). Le libellé héros est passé en blanc 60 % sur navy (pas sur orange) —
   résiduel mesuré sur badge 11 sp. Non corrigé (teinte de marque intangible).
7bis. **Constats de mesure sur les tokens eux-mêmes (spec §3, pas des écarts d'implémentation —
   le code suit les tokens à la lettre)** : OrangeDeep #D34905 sur blanc = **4,44:1** (juste sous
   le seuil AA 4,5 pour du texte normal ; conforme pour les liens 13/700 en texte large seul) ;
   AmbreAlerte #B26A00 sur OrangeVoile #FFF1E8 = **3,83:1** (bandeau hors-ligne §7.14, titre
   14/700) ; VertSucces #0E9F6E sur blanc = 3,39:1 (point de synchro = icône, seuil 3:1 ✓).
   Ces combinaisons viennent de la spec validée ; les corriger reviendrait à modifier les tokens
   intangibles. Mesures ajoutées au rapport pour transparence — décision fondateur.
8. **Prix des formules en 24 sp** (§4 prévoit ≤ 21 pour H2) : dérogation anti-troncature validée
   en revue (les montants FCFA ne tenaient pas en 21 sp sur 360 dp).
9. **Pas d'icône notifications** dans le header dashboard (§9.3.1 : avatar + 2 boutons icône ;
   réglages seul présent). Motif : aucune notification n'existe dans le moteur — afficher une
   cloche morte = faux bouton (§13). À trancher par le fondateur.
10. **Splash §9.1** : barre de chargement non rendue (l'API SplashScreen 12+ ne dessine pas de
    ProgressBar custom) — temps de marque ≤ 1,2 s respecté par le système.
11. **Clavier logiciel** : non rendu par Robolectric — l'AVANT émulateur (10_formulaires) montre
    le clavier, l'APRÈS Robolectric montrera le champ focalisé sans clavier (limite honnête).

**Décisions fondateur intégrées** : §9.7 Aide & contact **non implémenté** (⛔ prioritaire) ;
aucune donnée inventée (compteurs absents plutôt que faux) ; copie du dépôt inchangée.

## D. Conclusion de l'audit

- **Fidélité chromatique et typographique : PROUVÉE** (analyse de pixels + code) sur toutes les
  captures v1 ; aucun token détourné, aucune couleur inventée dans la peinture UI.
- **Fidélité de composition : CONFORME** sur les écrans existants (§9.3 dashboard, §9.4 bienvenue,
  §9.6 préparation caméra, familles A–J) ; **5 écarts assumés** listés ci-dessus, tous motivés par
  l'interdiction de changer le parcours ou d'inventer — aucun ne dégrade la direction artistique.
- **Preuve visuelle : incomplète** — la galerie v1 couvre 24 états sur 90 inventoriés (57 à
  capturer, cf. `SCREEN_INVENTORY.csv` statut ◐) → **Lot 2** (nouvelles captures Robolectric),
  puis **Lot 3** (README galerie défilante AVANT/APRÈS + BEFORE_AFTER.csv + MANIFEST.tsv).
- Doublons v1 identifiés (4 fichiers identiques avec virgules + 1 variante) : seront éliminés au
  Lot 3 (règle : aucun doublon pour gonfler).

*Audit produit au Lot 1 de la mission v2. Outil : `visual-review/tools/audit_tokens.py`
(reproductible : `python3 tools/audit_tokens.py AFTER`).*
