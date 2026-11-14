# D42.32 — Audit UX : 7 constats et statut de correction

> Statuts finaux réalignés sur les preuves du **commit candidat `a799c50`**.
> « CORRIGÉ + CAPTURÉ » = code poussé ET capture authentique du candidat
> dans cette galerie. La décision finale appartient au fondateur (porte §12).

| # | Constat (audit initial) | Écrans | Correction | Statut final |
|---|---|---|---|---|
| 1 | Le dashboard ne dit pas ce que le commerçant a (crédits, état sync honnête) — pas de hiérarchie pro | DashboardScreen | Lot 5 : en-tête pro, carte crédits, action principale, état sync réel | **CORRIGÉ + CAPTURÉ** — `captures/17_historique/dashboard_fr.png` (dump : « Bonjour », « Exports restants », « Voir les formules », « Créer une vidéo », « Cadeaux de parrainage ») |
| 2 | Catalogue : filtre intégré confus, on ne voit pas les 5 gabarits de SON secteur, cartes inégales | CatalogScreen, VignetteCatalogue | Lot 1 : secteur ⇒ 5 gabarits, retour = sélection ; Lot 2 : cartes premium | **CORRIGÉ + CAPTURÉ** — `captures/07_catalogue/` (FR/EN/offline/petit écran) |
| 3 | Tarifs flous (« illimité », limites non affichées) — confiance tarifaire absente | PaywallScreen | Lot 7 : 3 formules exactes ; §4 : Pro 90/30 j RÉELLEMENT appliqué serveur | **CORRIGÉ + CAPTURÉ + TESTÉ** — `captures/05_credits/paywall_fr.png` ; quota 21/21 (CI) + Room CONFIRMED balanceAfter=2 + auth-local 22/22 |
| 4 | Formulaires : WhatsApp refusé, prix sauté au clavier, tutoiement incohérent | GabaritBriefScreen | Lot 8 : WhatsApp E.164, prix stable, conjugaison, ImeAction, erreur 130 % | **CORRIGÉ + CAPTURÉ** — `captures/10_formulaires/whatsapp_clavier_fr.png` (clavier ouvert) |
| 5 | Caméra : mosaïque inquiétante, pas de repères de confiance pendant le tournage | PriseGuideScreen | Lot 3 : diagnostic 4 sources ; §5 v4 : preuves complètes (2 rapports, 10 PNG, 2 MP4, emulateur=true) | **DIAGNOSTIQUÉ + CAPTURÉ** — `camera-preuves/` : écart luminance Preview/MP4 0,1/1,0 → mosaïque = **scène virtuelle AVD**, aucune modif CameraX ; **capteur physique = fondateur** (réserves honnête) |
| 6 | Bienvenue : pas de confirmation des crédits, bouton d'appui incertain | WelcomeScreen | Lot 9 : crédits confirmés, bouton épinglé 56 dp ; Lot 10 : PiedContinuer 52 dp | **CORRIGÉ + CAPTURÉ** — `captures/05_credits/credits_bienvenue_fr.png` + `21_conditions/font130_bienvenue.png` + `09_brief/brief_final_fr.png` |
| 7 | Parcours uniquement FR : anglophones exclus du parcours commercial | tout le parcours | Lot 4 : FR/EN complet (376 chaînes par IDs stables) | **CORRIGÉ + CAPTURÉ** — run EN intégral 50 captures 0 gap de navigation (`02_langues/langue_en.png` … `19_profil/profil_reglages_en.png`) |

## Conditions de vérification (captures présentes)

FR base/suite · **EN complet** · petit écran 540×960 · police 130 % · rotation
paysage · clavier ouvert · hors connexion (+ retour réseau) · caméra émulée
(viseur, compte à rebours, REC, avant/arrière, refaire) · brouillons repris ·
dashboard/paywall/parrainage/réglages · export (dumps + MP4 réel, FLAG_SECURE
documenté) · partage (dump) · diagnostic caméra (preuves 4 sources).

## Réserves explicitement portées à l'attention du fondateur

1. **Capteur physique** : toutes les captures caméra sont ÉMULÉES — la
   validation du vrai capteur est faite par le fondateur sur son téléphone
   (après approbation, Phase C).
2. **FLAG_SECURE** : les écrans d'export/aperçu/partage ne sont pas
   capturables par conception — preuves par dumps + MP4 réellement exporté.
3. **PNG vides sous charge swiftshader** : listés dans README (gaps), jamais
   présentés comme captures.

