# Réglages proposés pour les 448 scènes

Ces règles expliquent les nombres des fiches. Ce sont des **propositions d’ingénierie et de direction visuelle à approuver**, pas une restitution mesurée d’un film existant. Les 30 JSON originaux et leur découpage restent prioritaires. Ne transforme pas une divergence en succès silencieux.

## 1. Base de temps

- Sortie proposée : verticale 9:16, 720 × 1 280, 30/1 images par seconde ; audio 48 000 Hz. Une autre résolution peut être validée, en conservant le ratio et les positions relatives.
- Pour les durées décimales exactes `d_i`, `F_0 = 0` et `F_i = floor(30 × (d_1 + … + d_i) + 0,5)`. Scène `i = [F_(i-1), F_i)` ; la fin est exclusive. **N’arrondis pas chaque durée séparément.** Un repère image `F` correspond à `F × 1 600` échantillons à 48 kHz.
- Le nombre source de millisecondes est conservé dans chaque fiche. La quantification peut faire varier une scène de moins d’une image, sans changer l’ordre ni la durée totale quantifiée. Les transitions ne retirent aucune durée aux scènes.
- Les points `in`/`out` des vraies prises ne sont pas inventés. Mesure et sélectionne les portions réelles ; calcule le besoin de rush à partir de la vitesse physique et des marges, hors gel explicite. Si la prise ou les marges sont trop courtes, demande une reprise ou un repli expliqué et accepté.
- Le minuteur du guide donne un repère, pas un arrêt forcé. La parole reste entière et à 1× ; elle peut continuer sur l’image suivante compatible sans changer le découpage. Le texte d’exemple aide à comprendre : il n’est pas à réciter. Si la voix ne tient pas de manière compatible, demande une reprise ou une adaptation approuvée.

## 2. Toile, texte et cartes

Les coordonnées des fiches sont des fractions de la toile, origine en haut à gauche, `x` vers la droite, `y` vers le bas ; `x0 < x1`, `y0 < y1`. La zone sûre proposée est `[0,06 ; 0,07 ; 0,94 ; 0,85]` : 6 % sur les côtés, 7 % en haut et 15 % en bas. Les cinq boîtes correspondent aux positions originales `centre_haut`, `centre`, `centre_bas`, `tiers_gauche`, `tiers_droit`. Base typographique 54 px à 720 de large, minimum 28 px, interligne 1,0 et contraste visé au moins 4,5:1. Recalcule les pixels à l’échelle ; teste en situation réelle. Si le texte ne tient pas, demande un texte plus court ou une adaptation validée : ne coupe jamais un prix ou un numéro.

La palette, les couleurs, la typographie, les éventuels badges et l’étalonnage viennent du JSON et du socle. Les badges facultatifs restent désactivés tant que le commerçant ne les active pas et ne confirme pas leur vérité. Les coordonnées des cartes sont des dispositions **candidates**, pas des données utilisateur. Les valeurs affichées viennent des champs réels, pas de leurs exemples. Si une carte décrit plusieurs éléments mais que leur relation à la scène n’est pas claire, fais valider la composition ; n’ajoute pas automatiquement un prix ou une date sans instruction approuvée.

- `carte_avant_apres_split` : les quatre cas utilisent réellement `prise_1` pour l’avant et `prise_3` pour l’après ; deux panneaux proposés de part et d’autre de `x = 0,5`. Ne transforme jamais une seule image en faux avant/après.
- Douze cartes générées possèdent une voix active : leur image de fond requise vient de la prise du guide vocal indiquée dans la fiche, pas d’un décor de substitution. Si un visage parlant est visible, image et voix viennent de la même prise et restent synchronisées à 1×. Ne couvre pas sa bouche ou son visage : en cas de conflit avec le texte, demande une disposition ou une reprise approuvée.
- La carte finale utilise les vrais nom, lieu et numéro WhatsApp. Les boîtes supplémentaires des cartes détaillent une proposition de mise en page ; elles n’autorisent pas à créer de nouvelles données.
- Le texte est composé dans la scène nominale ; le fondu de deux images ne doit pas superposer deux prix ou deux numéros. Garde un texte plein, lisible, pendant le maintien indiqué, puis applique sa sortie ; contrôle les transitions séparément. La mesure de temps de maintien n’est pas une preuve de lisibilité d’un texte long.

## 3. Animation et masque

Chaque fiche contient le nom source, les durées d’entrée et de sortie en images, la boîte et les keyframes. `t` est normalisé entre 0 et 1. Les translations `dx`, `dy` sont des fractions de la toile ; `scale` s’applique au centre de la boîte ; opacité et masque vont de 0 à 1. Entre deux keyframes, normalise le temps local en `u` et utilise `E(u) = 3u² − 2u³`. La sortie est une opacité linéaire de 1 à 0. Quand `entree_frames = 0`, applique tout de suite la dernière keyframe.

Pour une carte avec effet de vitesse, le facteur `k` règle initialement les durées `borne(240/k, 100, 600) ms` pour l’entrée et `borne(160/k, 80, 400) ms` pour la sortie ; sur une prise, `k = 1` pour le texte. Convertis en images par plafond. Si entrée + sortie dépassent la place restante après maintien de `min(30, durée_en_images)` images, réduis-les proportionnellement ; si besoin, désactive-les. Dans ce jeu, une scène dure 29 images : tout son texte est prévu visible immédiatement pendant ces 29 images.

Le dictionnaire JSON donne les keyframes de chacun des **16 noms d’animation**. Pour les animations de pulsation : `scale = 1 + amplitude × sin²(π × (frame modulo période)/période)` pendant le maintien. Le masque de révélation est local à la boîte ; le bord est adouci sur 2 px à 720 de large. `line_draw_spec` anime le trait, `rayure_animee` anime la rayure sur l’ancien prix réel, pas le texte entier. Pour les chiffres et prix, la proposition révèle la **valeur finale complète d’un coup** : aucune valeur intermédiaire ou partielle ne doit pouvoir être prise pour un prix réel. Cette interprétation prudente de `compteur_countup` et `typing_price_roll` reste à valider ; elle ne prouve pas une identité visuelle avec une référence absente.

## 4. Transitions proposées

Les durées en millisecondes sont celles de la table du kit V2.0 ; elles ne sont pas inscrites dans les sources. Le champ `duree_frames_proposee` est l’arrondi à 30 i/s, moitié vers le haut. Pour une frontière `F`, `N` images, `L = floor(N/2)`, `R = N−L`, la fenêtre est `[F−L,F+R)`. A doit disposer de `R` images après sa fin nominale et B de `L` avant son début. La durée des deux scènes ne change pas. Les cartes/photos peuvent rester affichées ; les rushs doivent avoir les vraies marges nécessaires, calculées à leur vitesse.

Conventions proposées : pour `N > 1`, `u = k/(N−1)`, `k = 0 … N−1` ; `E = 3u²−2u³`. Les transformations sont sur l’image, le texte étant composé séparément.

| Famille | Réalisation candidate |
|---|---|
| `cut_sec`, `cut_sur_action`, `hard_cut_rythmique`, `match_cut_mouvement`, `raccord_forme` | Coupe à F. Pour action, rythme, mouvement ou forme, utiliser des repères réels si disponibles ; sinon signaler et faire approuver le repli, sans inventer de geste ni de battement. |
| `fondu_enchaine`, `fondu_croise_temps` | Poids `A = 1−u`, `B = u`. Sur la dernière scène, B est le fond noir **proposé** et le fondu se déroule dans la scène finale ; rien n’est ajouté après la fin. |
| `fondu_noir` | Sur fond noir, `poids_A = max(1−2u,0)` et `poids_B = max(2u−1,0)`. |
| `slide_doux`, `slide_specifications`, `panoramique_raccord`, `raccord_panorama`, `whip_pan`, `whip_pan_directionnel` | Proposition légère : mouvement horizontal de A vers −0,12 × `E` largeur ; B part de +0,12 × `(1−E)` ; mélange A/B de `1−u` à `u`. Sens par défaut gauche-vers-droite tant qu’aucun sens réel n’a été fourni. Le whip est bref, sans prétendre analyser le mouvement filmé. |
| `swipe_gauche`, `wipe_lateral_produit` | Masque de B : gauche→droite `x ≤ E`, ou droite→gauche `x ≥ 1−E` pour `swipe_gauche` ; A occupe le reste. |
| `wipe_rideau_vertical` | Masque de B `y ≤ E` de haut en bas ; A occupe le reste. |
| `split_screen_glissant` | Révéler B depuis les deux bords : sur la moitié gauche `x/0,5 ≤ E`, sur la moitié droite `(1−x)/0,5 ≤ E`. A occupe le reste. |
| `zoom_snap`, `zoom_through` | Sur le centre de l’image, zoom de A `1 + 0,18E`, B `1,18 − 0,18E`, mélange linéaire A/B. Vérifier qu’aucun bord vide ne paraît. |
| `flash_blanc`, `flash_chaleur` | Coupe A→B à `u = 0,5`, puis superposition d’un triangle d’opacité `0,35 × (1−abs(2u−1))`, couleur blanche ou `#FFD6A0`. Prévoir la désactivation du flash avec repli approuvé. |

Le sens précis, les textures et les raccords restent à approuver. Si N ne tient pas dans les deux scènes ou si les marges manquent, réduire N ; pour moins de deux images, proposer une coupe. Si deux décodeurs ne sont pas disponibles, proposer un fondu par couleur ou une coupe ; demander un accord lorsque la signature change. Ne fige pas un visage pendant sa parole pour cacher un manque de marge. Le plan de rendu enregistre la transition demandée, celle appliquée, la raison et l’accord.

## 5. Effets et une seule vitesse physique

Les **23 effets** portent chacun des paramètres dans `effet_parametres`. Les zooms ont un centre et des valeurs de début/fin ; les gels ont une durée ; les mouvements ont des déplacements. Ne multiplie pas un `recadrage` source par un second zoom identique sous prétexte qu’un effet répète son nom.

Sur une prise, la vitesse effective est `source.vitesse`, sauf visage parlant synchronisé : image et voix à 1×. Ne multiplie pas deux fois une vitesse d’effet. Un gel est distinct de la vitesse : ne gèle pas un visage qui parle. Les effets avancés de stabilisation demandent un vrai algorithme et des essais sur appareil ; leur état dans la fiche n’affirme pas qu’ils fonctionnent. Si l’algorithme ou les images nécessaires manquent, demande une reprise ou un repli approuvé.

La courbe `speed_ramp_x5` proposée utilise les points `(u,v) = (0,1), (0,2;5), (0,8;5), (1;1)` avec `E` entre les points et une intégrale normalisée de 4,2. Sur une **prise**, elle n’est pas exécutée silencieusement : la vitesse source constante prime et le repli `rampe_non_definie` est déclaré. Une vraie rampe sur vidéo exigerait une décision explicite compatible avec le contrat source et assez de rush. Sur une **carte**, cette courbe est une proposition alternative de retiming graphique, sans modifier la vidéo de fond ni la voix. Ne cumule pas deux fois un facteur de vitesse ; l’interprétation définitive et ses durées sont à approuver.

## 6. Conditions et vigilance sur les prix

Évalue les deux conditions connues sans `eval` arbitraire : `citation_client_est_saisie` signifie texte réellement saisi et autorisé ; `prix_est_saisi` signifie prix fourni et validé, pas simplement différent de zéro. Respecte le consentement du client pour sa voix et son image. Quand une condition est fausse, ni donnée ni SFX de la scène absente ; conserve le créneau avec un repli neutre **approuvé**, sinon bloque.

Les six T5 ont une contradiction à arbitrer : condition `prix_est_saisi`, texte `Prix sur demande`, action demandant le vrai prix. Tant que ce choix produit n’est pas pris, ne décide pas à la place de l’équipe et ne modifie pas les JSON. Les fiches signalent aussi les sept points T4 décrits dans le fichier d’accueil : quatre incohérences possibles entre rôle et texte, et trois cibles de rayure à confirmer. Ne barre jamais un prix actuel par déduction ; ne fournis aucune donnée inventée.

Pour T4, anciens et nouveaux prix et vraie date de fin doivent être renseignés selon la source. Le pourcentage n’est calculé que si `ancien_prix > 0`, `prix ≥ 0` et `prix < ancien_prix`, avec nombres décimaux exacts. L’arrondi moitié vers le haut est une proposition à faire approuver. La devise réelle choisie remplace FCFA hors zone concernée.
