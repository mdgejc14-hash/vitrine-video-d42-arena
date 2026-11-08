# D42.22 — 04. QUALITÉ MUSICALE (analyse sur données réelles du dépôt)

## Mesures D42.20/21 (classement600.jsonl, 600/600 — recalculé D42.22 depuis le dépôt)
- Décisions : **526 IMPROVE / 74 REGENERATE / 0 KEEP**.
- REGENERATE par secteur : shops 19, restaurants 15, vetements 15, batiment 12,
  coiffure 8, immo 5.
- Moyennes /10 par critère : mix_technique 10,0 ; dynamique 9,7 ; spectre 9,2 ;
  intégrité 9,3 ; conclusion 9,0 ; progression 8,3 ; place_voix 7,0 ;
  **pulsation 4,9 ; hook 0,3 (514/600 pistes à 0 — attaque > 2 s) ;
  remplissage_intro 0,0 (fenêtre 0-3 s en retrait > 20 dB)**.

## Diagnostic (défaut des premières secondes — confirmé)
L'introduction est le défaut SYSTÉMIQUE : hook quasi nul (0,3/10) et remplissage
d'intro nul (0,0/10) partout, alors que le reste de la chaîne est solide
(mix 10/10, dynamique 9,7). Les 20 variations par gabarit partagent ce défaut
(mesures par piste, pas par gabarit).

## Congruence musique ↔ gabarit (méthode, timelines_30_gabarits.json)
Chaque gabarit documente : durée totale, nb de scènes, rythme moyen de coupe,
intention éditoriale, actes par scène (hook, produit, révélation, CTA,
témoignage…). La musique a été composée PAR gabarit (600 = 30 gabarits × 20
variations) : durée alignée sur le gabarit, pulsation étiquetée (BPM min/max
dans bgm_library), place de la voix réservée (critère place_voix 7/10 :
l'espace spectral médian reste disponible pour la voix du commerçant).
Exemple T1 batiment : 35 s, 15 scènes, coupe moyenne 2,15 s, acte 1 =
hook_materiaux_arrives — la mesure « attaque 2,26 s » de la piste v01 signifie
que la musique démarre ~2,3 s après le hook visuel : c'est LE décalage à corriger.

## Traitement (NON EXÉCUTÉ en D42.22 — règles fondateur)
- Interdiction de relancer les 600 générations ; aucun original supprimé ;
- plan v3 (intros ≤ 0,3 s + pulsation + progressions) documenté D42.21 :
  à exécuter ULTÉRIEUREMENT par briefs et mesures objectives par piste ;
- les 74 REGENERATE doivent être traitées en priorité (mesures détaillées par
  piste dans classement600.jsonl : chaque note < 5 a son explication).

## Méthodes professionnelles appliquées
Music-Content Congruity (structure par acte du gabarit ↔ énergie musicale),
Loudness Management (mix 10/10, LUFS mesurés preuve B : −21,8), Audio Post
(ducking voix/musique vérifié preuves B + E2E), écoute aveugle (protocole du
test physique fondateur). AUCUNE promesse de conversion dérivée des corrélations.
