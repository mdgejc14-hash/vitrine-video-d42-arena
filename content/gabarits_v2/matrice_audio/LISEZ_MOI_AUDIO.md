# Matrice audio V2.0 — repères proposés, médias absents

## 30 musiques : ne pas inventer les pistes

`matrice_audio_30_reperes_proposes.csv` contient une ligne par gabarit. `genre_source`, `bpm_min_source`, `bpm_max_source`, `riser_role_source` et `drop_scene_source` reprennent les JSON. La direction et l’énergie sont des propositions d’écoute, non les caractéristiques mesurées d’une piste. Les fenêtres de scène et les points candidats sont à 30 images/s ; leur fin est exclusive. Quand montée et drop sont dans la même scène, les deux points candidats sont distincts, dans le premier et le dernier quart de cette scène.

| Secteur | T1 | T2 | T3 | T4 | T5 |
|---|---:|---:|---:|---:|---:|
| Vêtements & mode | 100–112 | 94–108 | 88–104 | 110–126 | 76–94 |
| Restaurants & maquis | 102–114 | 96–110 | 90–106 | 112–128 | 78–96 |
| Immobilier & auto | 101–113 | 95–109 | 89–105 | 111–127 | 77–95 |
| Coiffure & beauté | 101–113 | 95–109 | 89–105 | 111–127 | 77–95 |
| Shops & petits commerces | 102–114 | 96–110 | 90–106 | 112–128 | 78–96 |
| Bâtiment & travaux | 100–112 | 94–108 | 88–104 | 110–126 | 76–94 |

Ces limites de BPM viennent **uniquement des JSON** et priment sur les anciennes fenêtres sectorielles. Ne change pas l’étiquette BPM ni la vitesse d’une piste en silence pour la rendre admissible.

Pour chaque vraie piste : vérifier l’origine, la licence CC0 ou le domaine public applicable, le caractère instrumental et humain, les preuves, le hash et le BPM réel, puis écouter la piste avec la voix et la durée du format. Mesurer ses repères réels de montée et de drop. Choisir un décalage de lecture qui place les deux repères dans leurs fenêtres respectives, sans déplacer les images ; les points de la matrice sont des **cibles candidates**, pas des données mesurées ni une garantie qu’une piste existe. Si aucun décalage ne convient, choisir une autre piste admissible ou proposer un repli explicitement accepté. Une boucle doit être vérifiée et approuvée à l’écoute ; le temps des scènes reste inchangé. Le mode sans musique, s’il est proposé, requiert aussi l’accord et ne reproduit pas la signature musicale.

Le plan reste de 600 masters humains distincts : 100 par secteur, dont un Starter Pack fixe de 60 pistes (10 par secteur) et 18 packs cloud de 30 pistes. Ces chiffres sont une cible d’acquisition, **pas un inventaire livré**. Deux pistes starter admissibles par gabarit sont un objectif/gate à vérifier avant publication.

## 280 indications SFX, neuf catégories

`evenements_sfx_280_reperes_proposes.csv` contient un événement candidat pour chacune des 280 indications `scene.sfx` non nulles, à raison d’un seul événement par scène concernée. L’absence de SFX dans les 168 autres scènes est respectée. Les six caisses des T5 scène 10 sont conditionnelles : si `prix_est_saisi` est faux, ne les joue pas ; si la condition est vraie, l’arbitrage T5 reste nécessaire. Ne joue jamais les 280 événements dans une seule vidéo.

| Catégorie d’origine | Occurrences | Cible de durée proposée | État |
|---|---:|---:|---|
| `whoosh_soft` | 85 | 350 ms | À acquérir |
| `whoosh_fast` | 15 | 220 ms | À acquérir |
| `caisse_enregistreuse` | 50 | 550 ms | À acquérir |
| `clic_appareil` | 40 | 120 ms | À acquérir |
| `impact_drop` | 31 | 220 ms | À acquérir |
| `pop_badge` | 28 | 160 ms | À acquérir |
| `amb_chantier` | 17 | 2 500 ms | À acquérir |
| `sizzle_grill` | 8 | 1 000 ms | À acquérir |
| `vapeur_plat` | 6 | 1 000 ms | À acquérir |

`banque_9_sfx_v2_0_proposition.json` donne les noms de fichiers cibles et les gains initiaux proposés. Ce ne sont ni des fichiers ni des licences acquises. WAV PCM mono 48 kHz/16 bits et budget inférieur à 2 000 000 octets sont des objectifs à mesurer sur les vrais actifs. Les CSV historiques sont conservés en plus des nouvelles matrices.

Pour un impact visuel proposé à l’image `F` : `K = F × 1 600`. Après acquisition, mesurer `sample_impact` depuis le début du vrai fichier ; commencer la lecture à `K − sample_impact`. Pour une ambiance, l’ancre peut correspondre au début réellement audible plutôt qu’à un choc. Vérifie les offsets, la durée, les gains, les droits et la coïncidence image/son à l’écoute. Si le départ calculé est négatif ou si la fin serait coupée, utilise un autre actif ou un repli approuvé ; ne tronque pas le son en silence. **Exemple :** `restaurants_maquis_T1` scène 1 propose une vapeur à l’image 0. Si son attaque réelle est après le début du fichier, elle ne peut pas être centrée sur 0 sans ajustement approuvé ou autre fichier.

## Mix à tester

Voix prioritaire à 1× ; atténuation de la musique de **14 dB sous la voix**, avec attaque proposée de 75 ms et relâchement de 325 ms. Viser **−14 LUFS intégrés** pour le mix complet et un plafond de **−1 dBTP**, à contrôler après l’encodage AAC. Les gains SFX indiqués ne sont que des points de départ ; adapte-les après écoute sans masquer la voix. Ne normalise pas chaque très court SFX à −14 LUFS. Aucune mesure LUFS, true peak ou synchronisation n’a été faite ici : aucun média ou rendu n’est présent.
