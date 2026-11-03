-- 0010 : catalogue des musiques de fond (BGM) par gabarit.
-- Source unique : les 30 gabarits embarqués (data/src/main/assets/gabarits/) croisés
-- avec content/gabarits_v2/matrice_audio/matrice_30_gabarits_bpm_styles_sfx.csv.
-- Régénérée par scripts/audio/build_bgm_catalog.py --emit-sql (déterministe).
-- Les objets audio vivent sur B2 : audio/bgm/<secteur>/<T1..T5>/<categorie_audio>.m4a|mp3
-- (contrat publié : audio/bgm/STRUCTURE.json sur le bucket vitrine-video-media).

CREATE TABLE IF NOT EXISTS audio_catalog (
  categorie_audio TEXT PRIMARY KEY,
  gabarit_id      TEXT NOT NULL,
  secteur         TEXT NOT NULL,
  format          TEXT NOT NULL,
  genre           TEXT NOT NULL,
  style           TEXT NOT NULL,
  texture         TEXT NOT NULL DEFAULT '',
  energie         TEXT NOT NULL DEFAULT '',
  bpm_min         INTEGER NOT NULL,
  bpm_max         INTEGER NOT NULL,
  duree_gabarit_s REAL NOT NULL,
  object_key      TEXT NOT NULL,
  object_key_mp3  TEXT NOT NULL,
  statut          TEXT NOT NULL DEFAULT 'NON_APPROVISIONNE',
  etag            TEXT,
  taille_octets   INTEGER,
  en_ligne_at     TEXT,
  updated_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE INDEX IF NOT EXISTS idx_audio_catalog_secteur ON audio_catalog(secteur);
CREATE INDEX IF NOT EXISTS idx_audio_catalog_gabarit ON audio_catalog(gabarit_id);

INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux', 'T1',
        'afro-house percussif instrumental', 'Afro-house percussive stable', 'percussions franches, montrer chantier et matériaux réels', '3–4',
        100, 112, 35, 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux.m4a', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux', 'T2',
        'afrobeats chantier instrumental', 'Afrobeats chantier instrumental', 'progression de la première étape au résultat livré', '2→4',
        94, 108, 35, 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux.m4a', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux', 'T3',
        'percussions afro industrielles', 'Percussions afro industrielles mesurées', 'rythme régulier, détails d’outils audibles sans dureté', '3',
        88, 104, 40, 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux.m4a', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux', 'T4',
        'highlife énergique instrumental', 'Highlife énergique instrumental', 'accent maîtrisé sur le devis ou le prix réel', '4',
        110, 126, 33, 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux.m4a', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux', 'T5',
        'afro-soul confiance instrumental', 'Afro-soul de confiance', 'harmonies sobres, espace au client et à la réalité du chantier', '1–2',
        76, 94, 50, 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux.m4a', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute', 'T1',
        'afro-R&B doux instrumental', 'Afro-R&B doux instrumental', 'texture soignée, pulsation ronde, résultat bien visible', '2–3',
        101, 113, 35, 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute.m4a', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute', 'T2',
        'afrobeats lumineux instrumental', 'Afrobeats lumineux sans voix', 'rythme propre et montée douce vers le résultat', '2→3',
        95, 109, 35, 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute.m4a', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute', 'T3',
        'afro-house minimal instrumental', 'Afro-house minimale', 'percussions fines et espace autour des gestes du soin', '2–3',
        89, 105, 40, 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute.m4a', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute', 'T4',
        'highlife doux instrumental', 'Highlife doux à tempo vivant', 'guitare claire et accent modéré, prix bien lisible', '3',
        111, 127, 33, 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute.m4a', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute', 'T5',
        'percussions afro feutrées', 'Percussions afro feutrées', 'peu de médiums et de coups forts pendant la parole', '1–2',
        77, 95, 50, 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute.m4a', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto', 'T1',
        'afro-house premium instrumental', 'Afro-house sobre et premium', 'basse stable, sons aérés ; montrer le bien sans précipiter', '2–3',
        101, 113, 35, 'audio/bgm/immo_auto/T1/musique_t1_immo_auto.m4a', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto', 'T2',
        'afrobeats sobre instrumental', 'Afrobeats sobre instrumental', 'progression discrète jusqu’à la révélation du bien', '2→3',
        95, 109, 35, 'audio/bgm/immo_auto/T2/musique_t2_immo_auto.m4a', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto', 'T3',
        'amapiano instrumental', 'Amapiano instrumental épuré', 'clavier discret, peu d’ornements pour les détails', '2–3',
        89, 105, 40, 'audio/bgm/immo_auto/T3/musique_t3_immo_auto.m4a', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto', 'T4',
        'highlife calme instrumental', 'Highlife calme à pulsation claire', 'guitare légère, offre lisible, pas de fausse urgence', '3',
        111, 127, 33, 'audio/bgm/immo_auto/T4/musique_t4_immo_auto.m4a', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto', 'T5',
        'afro-soul confiance instrumental', 'Afro-soul de confiance', 'accords espacés, accompagnement discret du témoignage', '1–2',
        77, 95, 50, 'audio/bgm/immo_auto/T5/musique_t5_immo_auto.m4a', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis', 'T1',
        'afrobeats percussif instrumental', 'Afrobeats chaud et percussif', 'percussions et basse rondes ; chaleur sans couvrir le plat', '3–4',
        102, 114, 35, 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis.m4a', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis', 'T2',
        'highlife chaleureux instrumental', 'Highlife chaleureux instrumental', 'guitare claire, progression de la préparation au service', '2→4',
        96, 110, 35, 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis.m4a', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis', 'T3',
        'coupé-décalé instrumental', 'Coupé-décalé instrumental mesuré', 'rythme dansant léger, texture claire autour du plat', '3',
        90, 106, 40, 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis.m4a', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis', 'T4',
        'afro-house cuisine groove', 'Afro-house cuisine festive', 'pulsation entraînante, accents courts sur l’offre réelle', '4',
        112, 128, 33, 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis.m4a', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis', 'T5',
        'afro-soul maquis instrumental', 'Afro-soul chaleureuse de maquis', 'harmonies douces et peu chargées sous le client', '1–2',
        78, 96, 50, 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis.m4a', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business', 'T1',
        'afrobeats commercial instrumental', 'Afrobeats commercial instrumental', 'rythme urbain chaleureux, produit et rayon au premier plan', '3–4',
        102, 114, 35, 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business.m4a', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business', 'T2',
        'coupé-décalé instrumental', 'Coupé-décalé instrumental souple', 'mouvement progressif pour emballage et présentation', '2→4',
        96, 110, 35, 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business.m4a', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business', 'T3',
        'amapiano groove instrumental', 'Amapiano groove léger', 'basse arrondie et détails discrets, produit bien lisible', '2–3',
        90, 106, 40, 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business.m4a', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business', 'T4',
        'highlife léger instrumental', 'Highlife léger et rythmé', 'accent court sur le vrai prix, ne pas saturer le message', '3–4',
        112, 128, 33, 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business.m4a', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business', 'T5',
        'afro-house dynamique instrumental', 'Afro-house dynamique et aérée', 'groove vivant, arrangement aéré et ducking sous le client', '3–4',
        78, 96, 50, 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business.m4a', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode', 'T1',
        'afrobeats élégant instrumental', 'Afrobeats élégant, léger rebond amapiano', 'percussions nettes, basse souple ; nouveautés mises en valeur', '3–4',
        100, 112, 35, 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode.m4a', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode', 'T2',
        'afro-house runway instrumental', 'Afro-house runway instrumentale', 'rythme fluide, montée courte pour le changement de tenue', '2→4',
        94, 108, 35, 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode.m4a', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode', 'T3',
        'highlife moderne instrumental', 'Highlife moderne minimal', 'guitare propre, battement discret pour regarder le tissu', '2–3',
        88, 104, 40, 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode.m4a', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode', 'T4',
        'afro-soul doux instrumental', 'Afro-soul doux à pulsation vive', 'texture douce, pulsation claire et impact bref sur le prix', '2–3',
        110, 126, 33, 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode.m4a', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode.mp3');
INSERT OR IGNORE INTO audio_catalog
  (categorie_audio, gabarit_id, secteur, format, genre, style, texture, energie,
   bpm_min, bpm_max, duree_gabarit_s, object_key, object_key_mp3)
VALUES ('musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode', 'T5',
        'amapiano léger instrumental', 'Amapiano léger et feutré', 'piano espacé et basse douce, laisser de la place au récit', '1–2',
        76, 94, 50, 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode.m4a', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode.mp3');
