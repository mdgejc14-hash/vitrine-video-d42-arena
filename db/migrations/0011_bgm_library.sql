-- 0011 : bibliothèque BGM (variations par gabarit) — Phase C.
-- Générée par scripts/audio/ingest_bgm.py --emit-sql (déterministe).
-- origine='synthese_procedurale_v1' : pistes de synthèse CC0 (pas des masters
-- humains — cf. content/gabarits_v2/matrice_audio/LISEZ_MOI_AUDIO.md).
-- Un master humain déposé sur le chemin titulaire prend la priorité au runtime.

CREATE TABLE IF NOT EXISTS bgm_library (
  piste_id        TEXT PRIMARY KEY,
  categorie_audio TEXT NOT NULL,
  gabarit_id      TEXT NOT NULL,
  secteur         TEXT NOT NULL,
  format          TEXT NOT NULL,
  variation       INTEGER NOT NULL,
  bpm             INTEGER NOT NULL,
  genre           TEXT NOT NULL,
  origine         TEXT NOT NULL,
  licence         TEXT NOT NULL,
  object_key      TEXT NOT NULL,
  sha256          TEXT NOT NULL,
  taille_octets   INTEGER NOT NULL,
  duree_s         REAL NOT NULL,
  preuve_sha256   TEXT,
  statut          TEXT NOT NULL DEFAULT 'EN_LIGNE',
  updated_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE INDEX IF NOT EXISTS idx_bgm_lib_categorie ON bgm_library(categorie_audio);
CREATE INDEX IF NOT EXISTS idx_bgm_lib_secteur ON bgm_library(secteur, format);

INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v01', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 1, 107, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v01.mp3', 'da77060add90edf78aedf9ba9e24a09177a76079fe747b93792a891127b2facc', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v02', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 2, 111, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v02.mp3', '863b538f6ec55778f5b2a080bcba4050ae672d31a70e46fa6ec86cae2162131a', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v03', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 3, 104, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v03.mp3', 'ed6be68fd110bc9996f0460b4af7af4bd285c5d6479bb773f1a5866fddaffef6', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v04', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 4, 109, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v04.mp3', '781fbe0bd7f9974dec175632d7893a0abd41d61acb71e5b5906b01d1d669d84a', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v05', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 5, 106, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v05.mp3', '203e7709204e7cb56ddfee141081861a6f7fafdd47b54937a3b5a428f84ab822', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v06', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 6, 103, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v06.mp3', 'f3dad82e9ef785ab7a03e8f416afe921ce4b6bd17425708cf5f1ed5ce95e084d', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v07', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 7, 107, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v07.mp3', 'a36818458e1b0b6daf7abfd858401d88f40cc85b1f2d6a418e0f353c6398ca85', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v08', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 8, 111, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v08.mp3', '534340ba9481ae3d8871a2b470a5386231ee576b2a7396854a87086735496116', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v09', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 9, 111, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v09.mp3', '27b2fbb9fa521b346820528d652f48cc75e4125544fa7938811cd826ba249d1c', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v10', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 10, 111, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v10.mp3', '94d600520b69d711006c3d32af30339acfe72e3d55021f54b4cb3c7f9dd11184', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v11', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 11, 109, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v11.mp3', '3439ea0f77d9cbf85d13a6aa337a4069c106d1800f52b9287ee35c80716a22b5', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v12', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 12, 111, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v12.mp3', '2f8beb168a14782ee3acc07140eedcb4825a986769bd38b673881f89accb929f', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v13', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 13, 101, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v13.mp3', 'c811305255c8a7602c8eb876f6038521c1fd659f10d9cf39cd2850b1417320c6', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v14', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 14, 100, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v14.mp3', 'aba955658fbcc8ccdb81fd57201abf4ae9261217f2974691a580b0e96d4bf94d', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v15', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 15, 100, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v15.mp3', '3cbd9ca50bd5d481a9738d3f06312e8e8f3494bc7baff18d7b8f971761480d7d', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v16', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 16, 108, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v16.mp3', 'd019b28e6b76113680b23d0bc331ad8e822c8ee4d6b4a6eb0db6ceacc3b220fa', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v17', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 17, 112, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v17.mp3', '015db4454e1a55dd12cbdc69a2d6b3908bcb968e30c11fa782dd172314e71a31', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v18', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 18, 109, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v18.mp3', 'fc65e91e2b23a33df7559d6da41a9bb912ed4242dfcc9abf39ba1d0d7db63e0f', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v19', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 19, 104, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v19.mp3', '3ca01b0ff4a6f5353120b043550205ea245df290a860297b7b31da2777aab3c6', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_batiment_travaux_v20', 'musique_t1_batiment_travaux', 'batiment_travaux_T1', 'batiment_travaux',
        'T1', 20, 101, 'afro-house percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v20.mp3', 'a87850c32cd09bb03f8353bb93d1448660cd291445ee50d812b58cd162588fb5', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v01', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 1, 104, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v01.mp3', 'a39f7eb08bd90c701e380d2f94b8e97bf691c8ed05a10dc14223961f9ec5aff4', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v02', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 2, 108, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v02.mp3', '819ee34fcd7fedc29e4afc739a42b1e5cd544c9c7a1ebbc12e76c8d7f40ac142', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v03', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 3, 104, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v03.mp3', 'ac62c784e7e28c3ce70eddbaa19216325cdd9895142bb85763c851b77cdfab42', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v04', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 4, 94, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v04.mp3', 'dd30ac7b38d9357f60edd171c022c390ed809573f948ff5ad6df40c4e2ef2db9', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v05', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 5, 105, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v05.mp3', '86040f5feecab7b9fbd041889519b177ecc20325bae6a474a9be59bfa2c782ab', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v06', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 6, 97, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v06.mp3', '03aa9f5d87fd22c24a2208e6b27e37aaea83b192dac109e5885b78bf2d5a8688', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v07', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 7, 104, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v07.mp3', 'ded937fae5eca31cc3b1014321712b30b7b8a34dc7790e5c2b27ec943d380ef8', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v08', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 8, 106, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v08.mp3', '9dc37c19a223b7d3ec9912b37ae676d54ab22cda4938b4caa4c7c7dd7910720a', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v09', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 9, 95, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v09.mp3', '3c16aa50e2321643f1c09608d1031c34abef97e8aa368d5542e06777814aad6e', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v10', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 10, 97, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v10.mp3', 'd433a43f02f60713679664716acd7023787af58763ac7d8450fd38402dcbc1a4', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v11', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 11, 105, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v11.mp3', '76f4efd119f4ac870522adb641a2e7bbbe41ed153ae966ab42f59e7373aa41b5', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v12', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 12, 106, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v12.mp3', '85daa0b2883046a4934ce9aff94b9c275152907b42b0280ef275c9e3bd51f47f', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v13', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 13, 104, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v13.mp3', '4796d1fa60560d13f5cef10a21563f427e2ba17b836e052350cdaaabd3899c92', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v14', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 14, 94, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v14.mp3', 'd7f40aebae1791b9989995f0b6c748ac4fee26344f5336499fa3207c6d4bc7d5', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v15', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 15, 95, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v15.mp3', '1b2c9f499a1b3e0d47fc444e3c92a9bcd7e3c995f1ff76e72c57bff479d0fb1e', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v16', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 16, 105, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v16.mp3', 'e998c6094114bec578272d735169c3547fdd1e5cadb4809e473124ee968e784d', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v17', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 17, 105, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v17.mp3', '0b38621306ed558d52cb36986c53c46d073c0438c0542fb97eb8ff8b29a452b4', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v18', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 18, 94, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v18.mp3', '013ff2a5d30770eb4bac3d7c4f56734f698d01a91f3ad07fed39e465c2d21e95', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v19', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 19, 101, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v19.mp3', '3e208cb81cc16a9e0f34002cc365517e747fe11ecc5080931667fc1c4f506da1', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_batiment_travaux_v20', 'musique_t2_batiment_travaux', 'batiment_travaux_T2', 'batiment_travaux',
        'T2', 20, 103, 'afrobeats chantier instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v20.mp3', 'd610fe2f8f3d9aa1ca444be458edf98f4c29fbfdb735d5978315d37eea3217eb', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v01', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 1, 98, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v01.mp3', 'c98923763b0e862ba5356724220c39238624f2794150d7f140b223a517c99220', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v02', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 2, 102, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v02.mp3', 'c8e7184d0951324a5543ceaf7d90766fefe584b169593ea4733b1e4b00fe9e32', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v03', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 3, 91, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v03.mp3', 'af077e2b36bede032703ed3d9f0cc1e508b658f68b989ec55cd2775f1eada949', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v04', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 4, 88, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v04.mp3', 'da24559f0c4432f8173cf7a380bde83ab01389b2784ae53d924e22ea0983328c', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v05', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 5, 94, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v05.mp3', '86aa4e45dedf9d72a9e1a8e6e42fc66424186173e9e773aabf19d59a382be274', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v06', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 6, 88, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v06.mp3', '3eb5b901f4c7278baa8c22fe7a63ed5da9ba46c43f5988f092d14d2129535c5a', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v07', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 7, 97, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v07.mp3', 'fb74410a02c2c79185ca773b2f9154c3ab527fe1314c37c95ccd863dfbb34fe2', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v08', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 8, 103, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v08.mp3', '8400148a6572e5c70192e600370f614312bb409c7766af17e3b287216398dd06', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v09', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 9, 96, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v09.mp3', '9606f9e9f7e4c53709c7555699b8f7c93998820fea272b2e663be44f33dc374b', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v10', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 10, 103, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v10.mp3', 'b2feb483f6c0d819b4fd7113fd009f63f6d2afab8f7ffd8e4657d6d683a6ccfc', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v11', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 11, 91, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v11.mp3', 'd25ff4f0ce58b216fd1bdbfb4777373a03119a4d73de35eec158a3823aa51d5e', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v12', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 12, 93, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v12.mp3', '1338c6d6a2d605550a7c8b3fa442ec32a21ad1ef88628db86ad72c433e5d6a3b', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v13', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 13, 97, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v13.mp3', '59dadaae85bfcec084da6c87146ec5febc89d982b4c95b4f35d7260eb2580f23', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v14', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 14, 89, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v14.mp3', '5b4cc0897b969c9b5e1a9f206b18cbf178fb6dd4f045e14123ffe6ff6f38d61f', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v15', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 15, 98, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v15.mp3', 'bcd6bfebb84bb5d32d09e959c4c9b45491393836e233715677e0e7442c738b06', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v16', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 16, 90, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v16.mp3', '07ab3d1fe8db9f9acc0e7dd8b0ee2937a9a34e88721733852fe7211618ec1e8f', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v17', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 17, 95, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v17.mp3', '345ce35035683d6697d2589912daf35ffb220b98b5d2fb4bbba2c2200a5fdd8d', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v18', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 18, 94, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v18.mp3', '7035718d8377a4f7b382d401cc2fc9cb082e6f6028825d6666a22eff86ac9e9b', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v19', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 19, 92, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v19.mp3', '8d54a30ee470f5435cac54953f5b80890f4e7e6002f7985855bf84e375401e81', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_batiment_travaux_v20', 'musique_t3_batiment_travaux', 'batiment_travaux_T3', 'batiment_travaux',
        'T3', 20, 88, 'percussions afro industrielles', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v20.mp3', 'dbe199375f2a83bb045cedb1fe0c0ca5fb488f3ac939b5587a7138762c1dadb7', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v01', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 1, 124, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v01.mp3', 'e3db2a0161f3d02dcf0de67bfe1dbc04c3e74943290dd576a3ad1cc5bd59b250', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v02', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 2, 126, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v02.mp3', '4273c5cef45399d4156bd7c2d0118e5371fe4e7159a3a6518a747cf5e7151282', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v03', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 3, 126, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v03.mp3', '2199ec2474eb88a0dd0a1d8a764dd22423065114e9cd0075ba86e6d94872b6d8', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v04', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 4, 114, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v04.mp3', 'e33f95403316b8f7d762e74b673164ffd02dda996a06328f7da01902f7506777', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v05', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 5, 111, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v05.mp3', '88cf5ae2635570d1b7e35ac21cfe0520ff848f2d9e6556804fea7316664a368a', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v06', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 6, 115, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v06.mp3', 'd79c4b5f11dff305f1d990b06c056c1da251b9a75ed48547f409331d5ba3b411', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v07', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 7, 122, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v07.mp3', '9d92033ecf87027a6092c185e121298fdc8412fb9581aad198773ce85bc1014a', 630282,
        39.344, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v08', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 8, 111, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v08.mp3', 'e820f3de9c66b513bfd814937b48773719174e3c1da209c1f293b1b86336d897', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v09', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 9, 116, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v09.mp3', 'ceaa2ab6aaa25a8cf5693b6e15afb33229ed3dd8fa47bfba5c2eaa49d9643423', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v10', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 10, 115, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v10.mp3', 'd862afb28ac7a8f83365b35b9703972eacd9f1a6be0b68b112160f2ad8f1467a', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v11', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 11, 115, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v11.mp3', '51dd85baf1e9d84853c0cbc1fe926c47674cc4ad6375b3e7a3568f3c374d4f4a', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v12', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 12, 114, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v12.mp3', '5d81101b7687bca81f03ded118ef64b335845df82baef6c6bb4f163125b5a22c', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v13', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 13, 123, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v13.mp3', '4375015b3a6c133ddd0695e75d2353bf86c53adb6624a72c014ddc284ad4c91b', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v14', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 14, 117, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v14.mp3', 'bf7f76025cd0609b2fce44c811425d3012c283102d17adde35fdfe44280f2062', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v15', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 15, 115, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v15.mp3', '51473821c34656c4422e6d0db94e3b76748ee51689e3a406dd94d3223e4556be', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v16', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 16, 121, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v16.mp3', '71f214813fa15c35d226b19f0d9cfbdfb2cc224711a212e7832a5f0be39b724a', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v17', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 17, 113, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v17.mp3', '922d0338195cf770bbea8817692f78965c473da104c63c6c8db140e79f4dd734', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v18', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 18, 112, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v18.mp3', '44673444d615679d94c3bed15da50da8aedf6b0e2e6ac07a263d0da9205132c1', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v19', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 19, 123, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v19.mp3', '8fedce3b29f07ab75a61f52b9d87fd7a7ce144cf523c75d9e56feb9b5c3a7e04', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_batiment_travaux_v20', 'musique_t4_batiment_travaux', 'batiment_travaux_T4', 'batiment_travaux',
        'T4', 20, 115, 'highlife énergique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v20.mp3', '088f7a42f8eaa590420f07331308908382fe92d6e25ec962742fa6fac5679f7d', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v01', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 1, 78, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v01.mp3', '812c41905efef14ab974ea4fed2566d13f9c05c5b0eb40fff6925daa7e9fa588', 985129,
        61.538, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v02', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 2, 92, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v02.mp3', 'bdaba53c05b7580b41f7f0de26ee0307d0350908e48c564c90969e6a3d60e069', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v03', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 3, 93, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v03.mp3', '48071a9b73ecca09141527477a7b733e04dc3d5053c9d87a235d4e22220e933b', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v04', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 4, 82, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v04.mp3', '2db52e7d477a1fc5d28d9695b8e7b1d2740deaa104512bdc4f7419960eb2cab8', 937064,
        58.537, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v05', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 5, 78, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v05.mp3', '7450f9d4c9762694e26ba3f8df4a533c797801c94cef4bb85b4e77e2816fb6ba', 985129,
        61.538, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v06', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 6, 94, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v06.mp3', 'd64a2fa5a63a0200a112f00839867a1a7f09fe851093fc10cf6545aad2daacb8', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v07', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 7, 92, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v07.mp3', '011c891e2a06fdbff662a33834517a9160e919edf2cbc6f9aa236c0d07e83e7c', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v08', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 8, 87, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v08.mp3', '36e0a9298fd77110762db6716f318fa0030f949bc37a96dcd4db2fbb20fa9cee', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v09', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 9, 94, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v09.mp3', '900ff567b295be8363de399e305432bc5494f8a6153c23cf6333dbd40c015add', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v10', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 10, 85, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v10.mp3', '90be3b20d451bbf4c2300a0641107afcd1bfec58fe5ffee92c201b1912991084', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v11', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 11, 94, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v11.mp3', 'dc34c848639eb6af3ba1863b5cb20711f9fd3a4597da8d0ff15689d82cbfc235', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v12', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 12, 91, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v12.mp3', '98cc28c4475190777eab425fdc790a8273d6350b5a288d34a5c0f788f5a0f462', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v13', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 13, 81, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v13.mp3', '7c2f11e13b32df78f19f1e28ab9ed1cf7a244bebde6dbb07ac1d7c99c3e6104e', 948767,
        59.259, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v14', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 14, 91, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v14.mp3', 'fe1055f271be851be84f250b610db2a1d101ec549bf67d213c779a75fabc4f5a', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v15', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 15, 93, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v15.mp3', '9c78352d268bbea9383f092dbc639e1b8d3248bffe40ca8a455c996cd1efd259', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v16', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 16, 92, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v16.mp3', '25cd74abba1e50472612ab716d365dd3320a2858a50e4f5bbea32384951e019e', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v17', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 17, 81, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v17.mp3', '4e8ed98118daed4d1a1a091e14ea9d4e1c3182a567830e410a98295158839377', 948767,
        59.259, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v18', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 18, 83, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v18.mp3', '181623db6c2495dde4be1e698eebf86d3a37027881680b8d4d930c67d01ec99a', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v19', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 19, 82, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v19.mp3', '3a200f9ae69d533fa326942ff82f56924d5a8a22f29ec2d238fc3bf1f8e048c2', 937064,
        58.537, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_batiment_travaux_v20', 'musique_t5_batiment_travaux', 'batiment_travaux_T5', 'batiment_travaux',
        'T5', 20, 79, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v20.mp3', '7d52b8e33bcc11677ac4924ed117694cd51f7c6102125f9359a93b2f2724a553', 972591,
        60.759, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v01', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 1, 102, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v01.mp3', 'b7a883b3750a58114e038d8a3f8d652e46f288c01cb856b3995a7efa4b0f2ab9', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v02', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 2, 109, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v02.mp3', 'ae41212d5c0e8260651a1f2ae8673341b10d293537e5dc3709533dbcbe78369e', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v03', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 3, 107, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v03.mp3', '06564249dd8a097adef113d60a27b302d9be99f7adba36ce5751a111d4ff5cbf', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v04', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 4, 106, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v04.mp3', '85c7ae3798b127a70ca237e05aa9f1bc3ac6ccb73461a04875c212d07607a170', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v05', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 5, 111, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v05.mp3', '532b4dca3586797fe5b39835505f4891ad63bad226907fe23c61750f655be716', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v06', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 6, 101, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v06.mp3', 'ba491ad99042889d5b09346f8f2cadd97c6b23ecc8eb1f58a538325e9dd547f5', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v07', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 7, 106, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v07.mp3', '2d644e15b3a8b3a379306142245b12489881bea9f9d9a9a862d00bdfdfb2c6ec', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v08', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 8, 112, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v08.mp3', '741214df3147202d0daeb2300ad756b9b20173f13c9f0981d680bff4cbf9d86b', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v09', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 9, 113, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v09.mp3', 'b1d05bfe653a485164e200f0b9834cac7f8eeed008d5b7057b653d61f8e7cf02', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v10', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 10, 106, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v10.mp3', 'fa8e21f96be0f19c08041d590496f3993b3228122252253110899592fdd20c36', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v11', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 11, 109, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v11.mp3', '000bfa75e1dc2f9a3552477843f2080ab2c64aa775816e74f6653ca616009e20', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v12', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 12, 112, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v12.mp3', 'd3e906f47b9280c4122b872903398a41caff249fa7d378614468c2bff655d8e5', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v13', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 13, 105, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v13.mp3', '3c77cfc57fd0c24e511d8b2a220d55d06fd5daa9dbe703fec4e626e00477fc19', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v14', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 14, 112, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v14.mp3', '4e6e7ada673e688968bd5860cb5b01a0e4cd942f34ed1733ff5bd4732a31f3b7', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v15', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 15, 101, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v15.mp3', 'dbaf08a3cd7b6a4e2c1a7d8fad1199fdd4c2199f0eee96174ba020119a4a514d', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v16', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 16, 112, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v16.mp3', 'ca801bc1674fdabd88f85d41165cae053ef9c7e2aa66f8ec3f4d0c3cd9073795', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v17', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 17, 112, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v17.mp3', 'cdaa689f44530e761e403bedf559e5bfeaa05637dbd910c486fd377de465a18d', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v18', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 18, 110, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v18.mp3', '6b0c55dea3829f433eff34813e6d44bd84e9b8cbd5d909cc648d03383cae093a', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v19', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 19, 104, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v19.mp3', '4bf5d37a22d67665dd901ec218e8a85526ce29df71ad7e7d84a698f0e953f2c6', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_coiffure_beaute_v20', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1', 'coiffure_beaute',
        'T1', 20, 109, 'afro-R&B doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v20.mp3', '16df11743dac1c3fd53db6cabf81d2c15e55295ef3df51c017c5eea701762e3c', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v01', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 1, 95, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v01.mp3', '3c3ef7a55619bbbb93c42063c8f583cb4e83b17ac8e4633ad5c50e35ce06d758', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v02', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 2, 109, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v02.mp3', 'ab184d741bcfc25a74cb64b5b8bc168f2729ac7cf0354fddff7843286e0ac1c0', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v03', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 3, 102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v03.mp3', '2f8d8303d56c7cede427982840a8f809936c1c53332a3f7b8bbb76468c44436c', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v04', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 4, 109, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v04.mp3', 'c54f73236f381dfc5949c543e9e48a3959cdc6cf703d17b93aeca59a0a5a06fc', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v05', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 5, 96, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v05.mp3', '219df7d3a4a5866e36404a857ec55bf5579745a63887c24f22e9c5e30d0b8f3b', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v06', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 6, 106, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v06.mp3', '3335c71691420ec070b1cc3159d527b991379df1ea1709ad87430d87736830f7', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v07', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 7, 103, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v07.mp3', 'a4512552411508fad5e994e5a5f60e80c2b4330dc3ea63d75237063cedf4e24a', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v08', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 8, 101, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v08.mp3', '8238044831813184190d9488e762b15b87f760570eca1f49dc0b39eaa5b53846', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v09', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 9, 101, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v09.mp3', 'c96f225cb3361c42b877c4a8c33536a05a41c51c664f12779b5d0e461fd7592f', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v10', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 10, 107, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v10.mp3', 'b516f345cd52515edd2ccf151fcdaae2fe81c175aaf894dd429ceaa6d51cf426', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v11', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 11, 105, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v11.mp3', '4e1288a63102f234214fc33aecac7aae82c95461089003eb08bc870f7f0c9ae1', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v12', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 12, 102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v12.mp3', 'f49b00c8c062f5e883f81d1f723d376a7e12448eec40939f0aa28e1b4b5b4dab', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v13', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 13, 107, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v13.mp3', '7b5274fd7db6c2d1b3a4356174b813ea7b89bd67fdf5932cb91654405db4aa1a', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v14', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 14, 100, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v14.mp3', '810f656bcfa05cdc84dea8e78e5e626a29f1f50143ea424a7b49dc9dc6533eed', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v15', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 15, 102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v15.mp3', 'a5dd9f539f52deae0afe714b51f1d3bb1e061b2a2d1d4f2455f1685bab4ab970', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v16', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 16, 98, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v16.mp3', '5f275bb144e36b8d0e69f256cfdf38aad084dce9cbe8a6dc2ae0ed821523fa62', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v17', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 17, 105, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v17.mp3', 'de2ccbff1d0c70a54461d699fc42d59b9886041f51f8c343dd5cf4f2d7ce915a', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v18', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 18, 99, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v18.mp3', '97175ffd952c54b526c301c842b74d0e603c9b86960f2374dbd03675ee9013ef', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v19', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 19, 105, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v19.mp3', 'c90ac3ccb24509ef4e431eea0893a3c7a061d5a7cedc53eb0317ff12da553f8d', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_coiffure_beaute_v20', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2', 'coiffure_beaute',
        'T2', 20, 107, 'afrobeats lumineux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v20.mp3', 'ca9313f5ac9395d336974693af397a4336d35f387b951cc20a70cb1f4fa3b428', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v01', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 1, 100, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v01.mp3', '680a47fc07584b1062a8d9fc17ff90a0445c05f7de67571e28cc4b5854b3f6d9', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v02', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 2, 95, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v02.mp3', 'b446afdde9818dcb7e1eadf1b821a6baa514c21146959ac8263fb79bd858249f', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v03', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 3, 93, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v03.mp3', 'a61223def067f93768cf76379a65675a1481d9bcb53e6bbe6879174292008ab8', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v04', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 4, 99, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v04.mp3', '259ad5f7cf447fe9b852b692220a44be4aca0a0e301d191a1b1b6cd9bb37af80', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v05', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 5, 102, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v05.mp3', 'ac0d2a9221d02c089cdfe647dfd12557b98b97e364fcceacd48557244908669b', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v06', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 6, 99, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v06.mp3', 'a9b12bb91679ed6b78b41f76db8a5a4b7c5ae326addcf232d86dff167a3502a7', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v07', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 7, 98, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v07.mp3', 'e60dcaea2e546a81aba94f9122d2276cf6afbb2fc2fc5a72c1f2ab939a2cc846', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v08', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 8, 103, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v08.mp3', '97786dfc71d09e60838a824875a9c58dfe7c4119e260125fb0907d86d7485cf2', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v09', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 9, 101, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v09.mp3', '9b8a89d58c70c6a987e86f98bc32a4c3ce5ccf8b840e77b04fd1921f7f8aa40c', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v10', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 10, 105, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v10.mp3', '4ebac1daeb9abdbf973f4c8c15bb8f692337ab702a192da1139ab479af3f9e89', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v11', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 11, 97, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v11.mp3', '35aa238e5b4ee675727e85ce480d239ee21d9747cd131e4463761c0829c9e913', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v12', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 12, 105, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v12.mp3', '95383d886c4ac04fe60bda2bf27067e698cb473401e00fbf00cb0563d9776b0f', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v13', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 13, 96, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v13.mp3', '63a814c6e450a2b772d6605f89df8f413e4838fa81bb0768399f3953d7dd18dd', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v14', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 14, 94, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v14.mp3', '925d51ac1d4ba8902c3e785b4a00ac621dbc8ba2ccaa293dcca9403622d51a72', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v15', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 15, 103, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v15.mp3', '9b0b9445ef959cb6e90117a743c277c77bf229a8e2ece156959da964efb4da0e', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v16', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 16, 92, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v16.mp3', '93c6a7b2ba2f6e7e2c40a5eddd2bb5e3d7427585a98478872f77b9009e21aa0a', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v17', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 17, 89, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v17.mp3', '2d1078cc74adc314f43ebd458788ae1b7d73f77487eeafe65b44fe39cf3da75e', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v18', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 18, 93, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v18.mp3', 'e56e0ead4735fa120d6441638fb1c62e2268c0352510e73aabe1f20e3fd49eec', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v19', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 19, 103, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v19.mp3', '10f908ebc86d64880b58a5efd4730212493d5ded95cbf18da477be6c24257546', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_coiffure_beaute_v20', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3', 'coiffure_beaute',
        'T3', 20, 101, 'afro-house minimal instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v20.mp3', 'bab942383da3359b12a50ebecac4ce2420b5a206863e7352997d6fac1269108f', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v01', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 1, 123, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v01.mp3', 'f0fe85ffa0938e19c156191db1d536c5c506d364ac4b057a6e7d9db25c0b8310', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v02', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 2, 123, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v02.mp3', '220bc0d795478d399c3df87e1e7e569fdd0eecc1551e863cf1740501258389aa', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v03', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 3, 115, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v03.mp3', '18fd9dbfe2981ba37fc7655753678b83f3a95e974be6356e336f28feefca4aa3', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v04', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 4, 127, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v04.mp3', '9edc24f021216038c3af9eafcfcee8a816afb20dec97b6fa1da626997d3dd2c2', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v05', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 5, 126, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v05.mp3', '73cd91f77df291fe4b99a61cd57c0387dea8a66241f0df31d4f2f0ee62b9cd23', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v06', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 6, 121, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v06.mp3', '74b146a97655d43a0e72c8d94c7d3079539cf38206a2251064e63a85f5c39eaf', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v07', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 7, 125, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v07.mp3', 'e6142c3723e5620584f2803071e85447ebaa5140d0424886b7d82825331a312d', 614817,
        38.4, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v08', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 8, 127, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v08.mp3', 'd6aecbcb2195bec6b3823ee9f4c3cb5a70fa3e2eb8b14f230aa230d7c0c876cd', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v09', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 9, 126, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v09.mp3', '808a14f499bc67e9f30f50600c4e787505ce34705e99b42c9547b244ea9efabe', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v10', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 10, 111, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v10.mp3', '7918e68b34841cbdb5675ce0220ebbc27f736dd17227b8336e77f129bfb0d528', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v11', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 11, 125, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v11.mp3', '4336e872443f988918b615e69e50bbf04ac517a5cc1439c58c285a4c22f20541', 614817,
        38.4, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v12', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 12, 124, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v12.mp3', 'a078724e983dd60bb54c8219862ecd9f5f68344573f2443ae8a025634610706f', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v13', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 13, 117, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v13.mp3', '3e1a01b4da260baa5739ff6533a112a7a9ae0813cb3a152fa4bb2408b0b30665', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v14', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 14, 113, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v14.mp3', 'e89a39a36771d755f0dc9cac9d73a0233dbf4e38c8597c3e7f80c122219e5bc1', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v15', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 15, 127, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v15.mp3', '8dbc557867ec91b482e8965d06ac33b8ae07ce26ed6eb89591b353ace9757a04', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v16', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 16, 120, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v16.mp3', '748dd08d3533f6be90f37eac1081e4ac6aadbba418cd01a5d09ea44c9ddeefb3', 640731,
        40.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v17', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 17, 116, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v17.mp3', '1f2e4f3e2225f879c833d86f8d49819bae7ef1c3878df0bce71f78edfc20346a', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v18', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 18, 126, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v18.mp3', 'b4f6b6ec6012344eb7637e801a4f54cc6ac56aae1843684859c83eb049730236', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v19', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 19, 124, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v19.mp3', '1d2b13861fa0a51d2a4460446186f4a4952d0ebbadd6d8177604e37046ff862c', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_coiffure_beaute_v20', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4', 'coiffure_beaute',
        'T4', 20, 116, 'highlife doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v20.mp3', '18289cf8606a69a7dc75307d20f81040885f1175c04e491759017e21f8eec474', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v01', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 1, 91, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v01.mp3', '51ea8a385d927b5e22c720e84a74616f6a64b34088f12b5d1ed745b7fa58a5a4', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v02', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 2, 86, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v02.mp3', '064f4ab0e35b4de796d58f2e1b1e5dfa72b1ca3919d012c18cde678ba6d7ac6c', 893596,
        55.814, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v03', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 3, 77, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v03.mp3', '8110b81e2392d07349a061cb8a5bb3a29a023b62ed4aa50fced0c4ab13a75243', 998086,
        62.338, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v04', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 4, 88, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v04.mp3', 'be75399fea4ef0cfe24766914245d50b3de9330cb0d12fc9fde14ec5a72c993d', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v05', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 5, 80, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v05.mp3', 'e7ce2bb1cb68b02df1e16bfb1989635a74a49e8d989d0e98d29d69e8a6f3286c', 960470,
        60.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v06', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 6, 87, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v06.mp3', 'e19340a45ed81fe2e984374d8025329e16b861a413f506e34bafd1d94d43dc5d', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v07', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 7, 80, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v07.mp3', '3a31de1852e1b31b2c46363057ccfb72e2c2840ac0c0365e8d3f727d976e4a2b', 960470,
        60.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v08', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 8, 95, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v08.mp3', 'ee0c7f1e82a23ad81a2077119dbf9f4e269053148e3b9c60ce0df3ba3b60d841', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v09', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 9, 94, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v09.mp3', 'a52bab8ff130f1a2cb620cee6af9c3b782fbade55ddacf8662a754bdc7021ec1', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v10', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 10, 81, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v10.mp3', '290b1e6b11a9c1b506a67d786b1f1cfb4df6cc998c9ef4096100ea08f4e1e9fe', 948767,
        59.259, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v11', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 11, 87, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v11.mp3', '2dba62e450585fd36f35300deceb08ef17a34d84909902f3ee46d5ef5cf9a740', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v12', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 12, 95, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v12.mp3', 'd362dab49d1e07467c431b12b6ffd9c1c9de93eae55c9eead72f6062a0b4dd11', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v13', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 13, 88, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v13.mp3', '8d5133b1059f2d97096665058755843c58443f026e950ecdba954471b1eda527', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v14', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 14, 94, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v14.mp3', '5e59cf019535007aeb2299f56ba97cedd00f5984835f9bd9812aacf127c0f375', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v15', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 15, 81, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v15.mp3', '384beb2931bf4dd5b9ed5d478aa669e352e07508d93a4d84d6ce19daa446bd4a', 948767,
        59.259, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v16', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 16, 88, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v16.mp3', '7dca69ec3fa3e96edce1e8dd03a9ec2f6be5c116270f210c0d5346b13e34b133', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v17', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 17, 91, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v17.mp3', 'df1913dbb6791957ac4f33f38ddac7aba808b4d81ff5ed6eb3b677222692e146', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v18', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 18, 77, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v18.mp3', '3bef5580776c12e4148e5df5a2e92aa62a8199a5338928f08818713611052d56', 998086,
        62.338, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v19', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 19, 95, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v19.mp3', 'f7a4e7ea336b4fd4d6efb3bbcfe204f1906e6a2211ff0634f79db66ebf1c1b37', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_coiffure_beaute_v20', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5', 'coiffure_beaute',
        'T5', 20, 77, 'percussions afro feutrées', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v20.mp3', '450374c031504c93385ec087948ca5d4a4e022114cfac9226c884e9cce133b8f', 998086,
        62.338, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v01', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 1, 111, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v01.mp3', '21126f76d53eb33195ae138486cb4b084dbffecab0bdb0ed443225024865ec83', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v02', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 2, 112, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v02.mp3', '8919096fb5135de31badf31a6d0d38aece5ccdd85a9a3c585965d967a2cc33d6', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v03', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 3, 108, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v03.mp3', 'c6c1e3759772ec0c261dfc91d5a5b97c8ee39cc26a9a3b4ca21d191c3ba2fb8e', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v04', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 4, 113, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v04.mp3', '084288b114f922784708209b178c1737011202b1dd47b144a90d4322ad7f09a1', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v05', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 5, 104, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v05.mp3', '342ba3915984baeaeec41c904c94e3b87bb33f6363395a1b81182754c5ec596d', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v06', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 6, 113, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v06.mp3', '0fc76a157e72ae3d84f5c198ddf1668bb3e46f2698e00e1799c0e80b57eaa1ab', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v07', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 7, 103, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v07.mp3', 'bdd7690ab53e9a98800194e67449b3ccb5c4cd17f831d8fb2c5952ec44fcc074', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v08', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 8, 110, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v08.mp3', '85bce87ac1ecb5f13cd46119b84aac539fbe5b5479330d04a0eb884cc6a9d867', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v09', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 9, 103, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v09.mp3', 'b51a9c8ad9fc04677fe279131eda6587aaf5d00c1ba4b07bfa800721ff56dc1c', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v10', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 10, 108, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v10.mp3', '780eb0e138f1d8b7dbbd6420a3a3155a1c1e6077c815971ce5b526b06fda040f', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v11', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 11, 102, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v11.mp3', '040ab895cb43e2c6e2c2f1d7e0955c0c6dae58c1666258e836ff65dbd23a7dbc', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v12', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 12, 111, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v12.mp3', '77c7316f4299a3ed36d1cc7e14db7545c95ca1ccb1152df5e9cbf475052cbd38', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v13', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 13, 112, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v13.mp3', '919341d28d4248b96b21805a901395368838a24fac7a7949c154c3d8bb99634d', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v14', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 14, 101, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v14.mp3', '2d97df87b65e77f0013286a59a76a20ef06549658e6df456b8e2e4222241a53e', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v15', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 15, 104, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v15.mp3', '530d4183e168834ec0d14d6dee84d4f8e6f9fdcc73fc2536c21387442686a4b3', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v16', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 16, 105, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v16.mp3', 'a3da657453daad1f16cd859b282bb928612c83d17f95b5cbb8433035085ea7db', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v17', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 17, 102, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v17.mp3', 'aada58671cf88962c1a63c5ba019d590b3845cd104d29946c28d6d3e664aecb6', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v18', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 18, 101, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v18.mp3', '48384a2a257c27e86330629972cc45b5f9bb054c24145cbb3c118a6a83266685', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v19', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 19, 113, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v19.mp3', 'c7baa90f9fae338df937f2582621fecb5b46a717861a79b4430ca3781468c76f', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_immo_auto_v20', 'musique_t1_immo_auto', 'immo_auto_T1', 'immo_auto',
        'T1', 20, 102, 'afro-house premium instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v20.mp3', 'a422f9b4748d567b002ae2af9a4db4739b75373faf1100ae855776ed39d80ca7', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v01', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 1, 107, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v01.mp3', '9dc19740f0f5c09962fa78ae1d0d19e47c2451dd6d3487d8586cd71492dd06fc', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v02', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 2, 106, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v02.mp3', '32b675fa742532162bee7115d85163be7219c2109b59411a859b093fc17182ca', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v03', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 3, 102, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v03.mp3', 'ddb2c3491741bebfe1d22c7b1dd516304248489131e29543c99aee9de3b55589', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v04', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 4, 106, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v04.mp3', '70604dc8ca25e610fc6fd3622dbce2f925ff41c2dfd329d114a361fbcd39f47d', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v05', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 5, 107, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v05.mp3', '3a3a3c010a36ea57fd943052b92c4c96741098c74f01f197133eceeefcb85eb3', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v06', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 6, 95, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v06.mp3', 'a3824942928aacbe0ef618751bf8cdd5c6002ddff194fc3b511c4b4307111928', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v07', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 7, 109, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v07.mp3', '6f5097954b8fad4106b12705fb027acb17aa16986fdd3cac2af8f4c34c7ec103', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v08', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 8, 103, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v08.mp3', '6343461ebc0a2e17b3aa339762277735ca9f361c4644d31296deb727b08174f7', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v09', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 9, 99, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v09.mp3', 'd7ec690e4f4855bb28917883284f4981f3899e9dece6f23b81d1887aff5c71b1', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v10', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 10, 102, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v10.mp3', '35f46fe4155600b61250b86b3f562cb86ce433c9d541b0e3099e4140ed7fa173', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v11', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 11, 108, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v11.mp3', '1d11273a0cd6568fef9c1772afa5d161aea4fdb5509d18003f3db1b1cc4d3cfc', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v12', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 12, 108, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v12.mp3', '9f34504e8f354f8e9861b6bbb2da8c5f8a449a9913d6e18707b28aad3923a4d4', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v13', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 13, 95, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v13.mp3', '6a3efee2c91902ba06f61a02d83d63f29fd1f4e792cfec2703696faa6efaa968', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v14', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 14, 108, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v14.mp3', '0174200282970614684f37675ee881fbd7cf76f9fabd3ce8bc78431aa40acd1f', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v15', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 15, 108, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v15.mp3', 'eed1a3448ad454751342822cc44f4c4f8a89fe08776f785487e6e969e7dc4a5b', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v16', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 16, 100, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v16.mp3', 'bc37d210630693c06e951e0392c642524aea187493f16671131a2dadbd25f1cf', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v17', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 17, 102, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v17.mp3', '9622fb54c68567d034259ef76426914c2b67711bfc8bbe3a55b0e9f43b150b86', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v18', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 18, 104, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v18.mp3', '42ed02b4401e729ff95ce6957a44f8484031daa818b81d32b2ee53e631e4251f', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v19', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 19, 99, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v19.mp3', 'ab219eae90e6aac69e0d791eb01cda867bce2ff6fae25856b568c9d6db278442', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_immo_auto_v20', 'musique_t2_immo_auto', 'immo_auto_T2', 'immo_auto',
        'T2', 20, 104, 'afrobeats sobre instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v20.mp3', 'c6a610363161948f312a9a9e5647de3500b2170e275d28c2c085c6403eb5cb6d', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v01', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 1, 94, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v01.mp3', '45647102c1ccc06fd5dd61c937fc8aedc4a036eb04fafc293abd747c04aa5089', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v02', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 2, 102, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v02.mp3', '75a415160a0c1391c6a0af1996e3bf1a0320624d25664a9d99170c269a2163b2', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v03', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 3, 105, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v03.mp3', '6c33ca04d213f0603145ebc07b8166577e2f7b827e2f4e4a406f65ca29128269', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v04', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 4, 92, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v04.mp3', 'b5a9d40987016d3cf92296c2bc41cd1e10fb5b3555a864e738c9ddb3c656c435', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v05', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 5, 98, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v05.mp3', '5de72a904f26827f8d12dd3090e64a910da35c715d1ac3235a01a980317de540', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v06', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 6, 101, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v06.mp3', '9b8a6401a602ebae6018593a274e2bb60ba470056c6560e0ca8cdc5d4e10126d', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v07', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 7, 104, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v07.mp3', '544a0ece146a4a1b255d75f325f70b9141f111d9d5fe7d603626c032b518d972', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v08', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 8, 92, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v08.mp3', '0e4df2e6e9be4bddc3c61afe81feec04c2bce63393e542bad5d6e366e7152fdd', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v09', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 9, 102, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v09.mp3', 'ac0f81c4dbe8f53093027d8d4d662908986b7564fc80aa24506a6131752c31be', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v10', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 10, 91, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v10.mp3', 'a82a96f4438c2e0e31e160131676ebcc293a58f33d2174dfd4ee63820eea3dd9', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v11', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 11, 92, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v11.mp3', 'dcac8a9422b518753e68d5f1932ffd6675b689602b4b827532a4832306936c9e', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v12', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 12, 100, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v12.mp3', '49d6a824388f8491d686e2a6585af839669c87e6ade754c196ada78849a870f5', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v13', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 13, 102, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v13.mp3', '845a3b28b93a0f0f1685cd9271ea721a0054fd44cbeddb9d9e40d641f4fcbd75', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v14', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 14, 94, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v14.mp3', '1bc9c8e87395993ed5223f6f90eb52ad50c65619e480d471b83b137f031ba42c', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v15', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 15, 103, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v15.mp3', '28e8de8521299a15c44c7c127100a9481a8622d4b57c70cd1bc7fc5ad85e0339', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v16', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 16, 96, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v16.mp3', '54e8ad0759f097794dc91c2b87086636006be9a8d8dde7e8e15e3f37bf233115', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v17', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 17, 92, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v17.mp3', '8cc8fa4796f8d4360614fa1733e51bbfc40d40bf8d2fa4a28bb66851684525e5', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v18', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 18, 91, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v18.mp3', 'aa2ea62d48a86692d56fad6b1917ab68d25f26bc61723bd47a752bf702a87c5c', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v19', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 19, 93, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v19.mp3', 'ce2b1a48027724fc735f0a694537e816acc34f7df254ed443686c3f2fd0d7e27', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_immo_auto_v20', 'musique_t3_immo_auto', 'immo_auto_T3', 'immo_auto',
        'T3', 20, 104, 'amapiano instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v20.mp3', 'bf770be9f6313f24dd897e08f90802ca765dee61e67e5fda2aebc3d64f6732ac', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v01', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 1, 121, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v01.mp3', 'b2433624910cf50877373b717d022851cd40ea972384240a69a99f0ef91f2ec9', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v02', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 2, 124, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v02.mp3', '90c9596831fb48629e7f9c99be27c711718d37e2017b586590f2212cc614e30e', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v03', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 3, 124, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v03.mp3', '0e27c2f65921cad1c6cc663e248f34acffe219fa57feb56db6c12e7d6314d6f1', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v04', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 4, 127, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v04.mp3', 'c2db51320161198b28e1b4f151aa64a5bebd3920243f1e555944cce93262977e', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v05', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 5, 124, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v05.mp3', '28f2bc3ee6107cacb21eabbfdd6ef6f39f1e46b675cfe3f230dacb3b322aa006', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v06', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 6, 112, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v06.mp3', 'f31174d26838734c8c36bc30407d1a559adb19dd826c57fb0806b9de8fad6bc0', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v07', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 7, 127, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v07.mp3', '314ac7aaf9554a512ff08ad14d6e4462ef5197e7553bb2abac3d3f0b1534ca00', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v08', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 8, 127, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v08.mp3', '2d08337b143515324155b40530810dce30a9620208a54973ea54938f2308c16b', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v09', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 9, 112, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v09.mp3', '4f66814d7df653d2fd6bc8d6a6b2562190c58ffb0b97c67b30b6afebfc36441b', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v10', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 10, 117, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v10.mp3', 'eee76c2a7abdf09b63c9944520b50e901e270476d5008d64dc1213a5ce08463b', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v11', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 11, 126, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v11.mp3', '2cd7c7cfa93edde352ac8626779c708a71c3a55eee31114e9048eee0e79301bc', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v12', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 12, 120, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v12.mp3', '1922f69e0b83b965fef7255d16883f38a6197d4da5121dae9a908540e7ba6f2f', 640731,
        40.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v13', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 13, 122, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v13.mp3', 'dd1d8824fcca8a8b5ffaabd6aa1ad54eeb987cb9b094b456a2eb84676ef37230', 630282,
        39.344, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v14', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 14, 123, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v14.mp3', 'c96b90b7410996073718ad57c6715d1a5695839c3e3ba47f320328977184c3d9', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v15', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 15, 118, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v15.mp3', 'a3fec71ec858e6045eb7840b3c09ffd911ad48f0c4f58e7e1a54c754f53aea5e', 651598,
        40.678, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v16', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 16, 111, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v16.mp3', '535e6c6a5a7b0e22fa2b8742b1651621090361861e52eca531866c339f71e9c4', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v17', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 17, 114, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v17.mp3', 'b989a96f6f9c1074b1405230857a636a1946ebb0e60af46a892e3e6968171868', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v18', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 18, 121, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v18.mp3', '717220075119f054ae0c3862d99b319835833486f61c31683b223988f3e00cdf', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v19', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 19, 120, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v19.mp3', '72527938cad3ebb1843b900c429d12380ed3e5c962bc49fd6538da74ca14eb8d', 640731,
        40.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_immo_auto_v20', 'musique_t4_immo_auto', 'immo_auto_T4', 'immo_auto',
        'T4', 20, 114, 'highlife calme instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v20.mp3', '58321556203cf2b8b9eb6f2eb3236c3f3821faadc75cef587d30442809cd6cc6', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v01', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 1, 95, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v01.mp3', '39aa23f8251e66b4c68f8f59b3a96bc35b733a6c607ecc97505a98d709e583c1', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v02', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 2, 83, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v02.mp3', '891142f9d4c858f36b9437e6b639b9f54a3565e2eb86064f5a9e4dab7f45b885', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v03', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 3, 82, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v03.mp3', '2343c73501524ab46ebbefcc94ca257995d1c6989253afe467e191040dbb4dfb', 937064,
        58.537, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v04', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 4, 77, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v04.mp3', '326fc4b4b6eaaf06b0315235833c35db44cd0532e096a9ebe79c51de78e83e16', 998086,
        62.338, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v05', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 5, 78, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v05.mp3', '4934e4431f8ce5e0602409a9b7ceb0533bf8a99f092f2e5b5fa3941116fd66ab', 985129,
        61.538, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v06', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 6, 91, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v06.mp3', '2b4ae56a40330b4342f69ca916813eb0533217031bc1a9c3b3fb2379aa93878d', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v07', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 7, 89, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v07.mp3', '882ae5582926ee5ce2f3d70bc9ef3c6babeb187d546b5dc48384ec10ea388723', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v08', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 8, 86, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v08.mp3', '2b878f89588d3b2376c40808e2ab9a7b442d1b28cfcb6f108f5649f2ae821bd1', 893596,
        55.814, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v09', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 9, 85, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v09.mp3', '87d6744e2356623b0fbb31806aba86ad74ae1c52aa1d38780823a0d2024595be', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v10', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 10, 88, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v10.mp3', '6357388bf897e352356001a30641e566566d2315989b4501f04fc7c7824b6c42', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v11', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 11, 93, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v11.mp3', '926fc96ccd05e0bd1addbe491cd9914f055f220797a4c6d0e040ff67650cae9a', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v12', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 12, 79, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v12.mp3', '04dca6d7ebbb9197cb39ab3bd617dc7ab43e0f92f1eadec400d88220a324b73d', 972591,
        60.759, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v13', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 13, 87, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v13.mp3', '09a0b6dcba5bcb4400fc3043e7c6356ea1cd7a226c7c352c519c3e355ccb8142', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v14', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 14, 91, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v14.mp3', '0b91bafac5de20890c784c93f0481e9567901107500bd0eb6d2962c42a3e9884', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v15', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 15, 93, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v15.mp3', '989c1b03b1a27d16a3da04d67010247dbef39868ceb375addfea37fbb296d69b', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v16', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 16, 94, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v16.mp3', '246b4079e67614074625ce1881ad7fec0934a87c0194ff1bc264e3702a51f846', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v17', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 17, 88, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v17.mp3', '772162a77c408dea0d404e55960d5612e9417eb7e531700319359510b5e257e7', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v18', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 18, 90, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v18.mp3', '78c3df224e47439b1c59aff16292676286533d8a9f5d312c064cddfdb173d205', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v19', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 19, 77, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v19.mp3', '47ea8782323418945dea84d46fa8b74ebd6f2339135e1346c55e890b3321b527', 998086,
        62.338, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_immo_auto_v20', 'musique_t5_immo_auto', 'immo_auto_T5', 'immo_auto',
        'T5', 20, 89, 'afro-soul confiance instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v20.mp3', '888a56c5a4af0936c53503d42af25df190db7cdd0e70fa28378e174538a89f06', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v01', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 1, 102, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v01.mp3', 'f36c4931468aed0e638953331594018556bf1e8527b5cf9356d01ef2df98c548', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v02', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 2, 105, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v02.mp3', 'ea442dcac880f37538aafddceccab3967d03684b1b5313680e093077f7aeb02d', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v03', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 3, 106, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v03.mp3', '5b70c0f9c375dda7aef0e80341a29736c2152861d37508b6c5d081f88536743d', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v04', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 4, 107, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v04.mp3', '1cb9ab51e9f9eb767793235b17d3530f8eb1e44fc82a1c499e5360684b7c4d06', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v05', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 5, 110, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v05.mp3', 'b7415c35eccd95b31551d850a69f92d82b7f67c5b0e44f34e5b11fb4621165b2', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v06', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 6, 105, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v06.mp3', '50b2d34a96c1f4e9b0c8c6d7886b7e5f92b65edf2ea108fdb201a8424028a01f', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v07', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 7, 114, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v07.mp3', '91af4898240e535bcb4bee12edbbb219ec2df243e7c4564c8194955ffd8bfad7', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v08', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 8, 103, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v08.mp3', '2f354875c933c81511d7e44a08c65a481ddc30bacca3ed621ba0abedf4cbca0f', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v09', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 9, 105, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v09.mp3', 'e9bbc6c5cc6b1f08f3de318b7a0ba614a1a63bf9666677ce687aed8c1ce6d4f6', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v10', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 10, 111, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v10.mp3', 'e7b41cf9e4e72daa15c97709b1d8ff4ea24c8aba86aecadbfbcfb519cb4ee07e', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v11', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 11, 113, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v11.mp3', 'c323d3b952ee6e973937c67378e70504d9d0508a29baa59d7dff8516706d2fac', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v12', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 12, 103, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v12.mp3', '72b241e8bc45acd146bdb9914a29c478c21966472cedf02d0c58384d834326a8', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v13', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 13, 112, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v13.mp3', '5f3bd1e0b2691ad845eff1ae9a57840ea9f83bd6c277823a574bfc4b7730b8b8', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v14', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 14, 111, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v14.mp3', 'f98c340361b0937b1e06e7333cf1e2c1bf768e704acd76013171bc964bfde2a2', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v15', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 15, 112, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v15.mp3', 'b61a4eabc8e061d3626628aa7092917f5ac972dab51296871b9a552bdbfef82c', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v16', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 16, 102, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v16.mp3', 'be05d34555c5da2add2bc2501befb2ed5ca5c0ab1a3e275c7efe8cf06664c746', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v17', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 17, 111, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v17.mp3', 'df96f8545eb006e653e0fcb6b0b4b18140912e18888321e3aa9e54adad31bf23', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v18', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 18, 110, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v18.mp3', '523f504b541ead9659d2e219d2706053fbccd419afb9bba854dc3659189ff4e1', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v19', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 19, 102, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v19.mp3', '38bd75f1b14805a40b5c7890d5f5c8d41702cae13782833adec23f01d6b1d1f3', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_restaurants_maquis_v20', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1', 'restaurants_maquis',
        'T1', 20, 103, 'afrobeats percussif instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v20.mp3', '262b1a208d15a110614e0654ad4e1080250102f74e53165d8039de2507371eb7', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v01', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 1, 99, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v01.mp3', 'ba6edf58dda449d1408abf2c50b7e3e8f5c98142f9b3ee6ced26089792cfff4e', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v02', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 2, 108, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v02.mp3', 'dbd25f749c8aad2927c560de737adcabf00042becf8f99025166e98b88665c3f', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v03', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 3, 97, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v03.mp3', '75dd43d2d9be52ec1266a28abad7f68ee987a91de0f6749cb241be3a57045ef1', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v04', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 4, 110, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v04.mp3', '12ca36341c207e48489b95948bd9889c813345290215146f0c5ee821ee62a445', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v05', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 5, 103, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v05.mp3', '244aac87047076fc93905f136be2360b70fbc145c614880145a5ee0cee8678ea', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v06', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 6, 96, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v06.mp3', 'c1475ca9de60b217aa833ec550ec550701bfe17ab7a8efdc84b323e621be53cd', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v07', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 7, 97, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v07.mp3', '715259ee3019246a3731eb7e3c59c4ce3ba5cbdfa6709c70a18d127111adc209', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v08', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 8, 107, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v08.mp3', '5b210cd08e545c4a930bf37812ac7a205d1ec0b3f17f6eedaff4608cd808b613', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v09', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 9, 96, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v09.mp3', '0176bd6cae6c51e54afb4ce33a24c48b9c14e95c4b627e9b83a4b041dec01738', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v10', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 10, 107, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v10.mp3', 'de804140326ec2206fc57cb0ac93bdcc698225fd08c49f1bc8d840da87b91ea2', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v11', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 11, 99, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v11.mp3', '98d20605553055003c502f76325b5ef09235813a96fffae911ab4ca93a496462', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v12', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 12, 107, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v12.mp3', '4b58f3b3f9ea0bf3da3498d78a3b4722380b3012ed5b0835f7047ecc6e8f7808', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v13', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 13, 109, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v13.mp3', '3542afb5e7af2f63414a53797fbf677d566819e0c36d7df539e0b407e24ca233', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v14', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 14, 106, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v14.mp3', 'b604a1e1293b8f3f361aa02f24146501c39912e10e8e920bef8d09755888b2c7', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v15', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 15, 108, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v15.mp3', '86feb220d1a95bfae795f2bc2b44416a1049cb7970f998ebf431f583620e8177', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v16', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 16, 103, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v16.mp3', '95bfe3d17906f737530eedf5c57ea06c00b03d5c27f8e950d68a53d200570684', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v17', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 17, 98, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v17.mp3', 'e87468a28be90d0fbb9d49baaf06e373a4c9cf11ca29267abdc35c8db47ee505', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v18', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 18, 97, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v18.mp3', 'c9cc33a7d6208f0966b61100287ef1ccef72e4b3297be5ef027204421faed6cb', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v19', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 19, 101, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v19.mp3', '2d4a127c9540dec7ef6211484494339224770e88829c11a4d69560fbeeea8372', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_restaurants_maquis_v20', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2', 'restaurants_maquis',
        'T2', 20, 101, 'highlife chaleureux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v20.mp3', '223d473359dc62df7100f8856ef47de3dad5680a6a57f48c3cfa2bb0f0d7b869', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v01', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 1, 90, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v01.mp3', '2b2fb4654d14e741382114f87e2cb4c6a586008fd2811d5bd85eab29e0cd5fa1', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v02', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 2, 94, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v02.mp3', 'f0aba859351c544cdba2ea92cec100ad26b9987cd01d3d92878f380563c268b7', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v03', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 3, 101, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v03.mp3', '37c649cd1863805bab51c05f25b8c81d69433130c7436bae9b86189f5d2415d1', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v04', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 4, 93, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v04.mp3', '7bdd74dee2f4109862a4d6a721d78638ae49852fa04cea0f76855898c6e95664', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v05', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 5, 90, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v05.mp3', 'f06d0d7de48501d4b51b92d473ea0f79493d75fe90cfa32d16a48e2012ab22fd', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v06', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 6, 102, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v06.mp3', 'c1efc21dcd3aa5bfa6521f00ec0d20e4c2d7eed20a6dde81da051cfb6b4f1fae', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v07', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 7, 103, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v07.mp3', 'b2adc35f8821c79b7237b7530edfcb71b8d66d303846997e942c97f8983bef1a', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v08', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 8, 97, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v08.mp3', '38f8f7480616382fa2b7013f8b6fb313670ee90e61576c42719861efbc9ec3b2', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v09', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 9, 92, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v09.mp3', '648f03aa83f070912a8952d3c22e32a16e2e74ada4c573a428693e13fb804c93', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v10', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 10, 98, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v10.mp3', 'ed0cac49823149f979f47479c55d527082c8212c417de38708a25f480022ce90', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v11', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 11, 91, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v11.mp3', 'e69e2f00c371b377ec51789642ba90d19414c37a532ed0e2e443e76d21d9feac', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v12', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 12, 103, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v12.mp3', '7ac379df6ed3742a41b3107e212ffdadd9749e2201e0433610ab6b0f883defb2', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v13', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 13, 97, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v13.mp3', '4e7a35c37c1c82cdfa17a1cc3c156dd68f8f2b4745dea7a65378ab62339618b7', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v14', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 14, 104, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v14.mp3', '0dda7d382dba6e3b1f4f2ece92d86765e677f15d42994a8f4aaad737b5f122b2', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v15', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 15, 102, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v15.mp3', '5cb4040c8c3eb5afa610d64a2f9fae402abf5ffb5c792b423febfb8463dda117', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v16', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 16, 98, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v16.mp3', '41fd371ce8fee6a550354fc952a88b2dda01dc0d972dc7a6153fd990c8871920', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v17', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 17, 90, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v17.mp3', '74ca58d9c4d104784da06266e5371309e50f2f8d4e844ecdbb4e20d0335f4132', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v18', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 18, 92, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v18.mp3', '822714758f290c7ac7ce28e18e79171df65964f351af32cd98db38044e4b036a', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v19', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 19, 100, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v19.mp3', '0169ac32ab36870eb22f0edb4c3a57c4a8f33f283690f7f6a3299ef386b07bcc', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_restaurants_maquis_v20', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3', 'restaurants_maquis',
        'T3', 20, 101, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v20.mp3', 'e9f13db61cebce8ea07379ab0fae43d843296a48961af812a21d4fb0eb27aa27', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v01', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 1, 124, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v01.mp3', 'dc0ee7aa4eee8d47f7485358511329256695fcede9608cd2d5fb152d1a50b802', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v02', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 2, 116, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v02.mp3', '6e8eff6fc319300edd550ddae68245c741feca0924c9cd70da420d2b1c8dd8a7', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v03', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 3, 118, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v03.mp3', '2193f315acd3056d100250c1638ff4ae21f11fadac23b764bf9c828fc9926c66', 651598,
        40.678, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v04', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 4, 118, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v04.mp3', '75e6bba94db62304d1cd201bad95df525327d9be639f7b317e85b54f1ad19acf', 651598,
        40.678, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v05', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 5, 122, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v05.mp3', 'dc662c62636617a97aa5f3b62ade0bebf29595ec19d474613820263ff8888eca', 630282,
        39.344, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v06', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 6, 121, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v06.mp3', 'f4d934ac8da2115e5d9e32aec50cd08147df13e26961f6bc93529a462033824c', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v07', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 7, 114, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v07.mp3', 'fcd9521a2e8c94acc21eadb944344ad9ff106ede280814d4c6ed8eb5680bc22e', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v08', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 8, 120, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v08.mp3', '9a11decfa6e7ae32bdde37576cb78fbc37e0b228d1c67117e66ec87c91a7ef83', 640731,
        40.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v09', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 9, 115, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v09.mp3', 'f3df642d207130e6093e67122cbc14034ba5bcff1e2290fb92630eb39590c07a', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v10', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 10, 122, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v10.mp3', 'a9280572a05446f6af64eeae83aaaa86faa3a51a5fd658497f087f8a24d6aea0', 630282,
        39.344, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v11', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 11, 123, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v11.mp3', '66a07cc6cab038b5a9d9b981f7f19ee9d692e7b0c135080eec2b922eda6f4435', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v12', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 12, 115, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v12.mp3', '34ae5b679e254f86d036cd5164713c4c82c16fc201c71da3a5ecafd06efb7f53', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v13', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 13, 119, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v13.mp3', 'f836dc1e164d327f58dfccab9f6744b6f868212e9372385340cf14ac118a96ab', 646164,
        40.336, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v14', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 14, 112, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v14.mp3', '319371943f104dc37f8b005c5dc7df051cdb71a48822971fd436e33bfdb833bf', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v15', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 15, 113, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v15.mp3', '337dbbe65cd8fb6ec07a8675443455e3adbd4315c3ba43b99515a7392a36dd3f', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v16', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 16, 122, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v16.mp3', '8319e512fd4aeee7e578981ac94b08358a1c98c221be5f5072c0ee2f7e7760a7', 630282,
        39.344, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v17', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 17, 124, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v17.mp3', 'bca3d2bad9abda99176a6154dca461d577a9179e161e608320b2cd1c134089d9', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v18', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 18, 117, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v18.mp3', '35bae59e3aabd7773669f2c54490caf78cec35f12b82861b152da42bcec770f2', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v19', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 19, 120, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v19.mp3', 'dbb454a4dff5f3921a83ad68bede450ea0244245d37373c5c40b17013ec052e2', 640731,
        40.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_restaurants_maquis_v20', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4', 'restaurants_maquis',
        'T4', 20, 125, 'afro-house cuisine groove', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v20.mp3', 'bb10d22924b27e678cea3891051d60363935fa65714940a5f38c24c2c6ba2eda', 614817,
        38.4, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v01', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 1, 83, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v01.mp3', '002ffe8d648835b709e02dee634ada0eea8e02d8df9bb18e1c7a45c5a90e3721', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v02', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 2, 89, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v02.mp3', 'dce786ef3eacadd8a394fd165588864a7569965b4bdaccede2c5b83eec72d531', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v03', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 3, 87, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v03.mp3', '7f3c1b90b34f132d61b99b4ba91baa8867f0dbf684e2bdbe24e70d66b32ad2d7', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v04', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 4, 88, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v04.mp3', '324fa30e9b184bf91af8dfacfa3e3b4af2e92b6637d264451656d5124a5db4a0', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v05', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 5, 85, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v05.mp3', '49e3cc24d3292e35fc7ab5e9678cb2f8b73c93f55f444ef48995a8d7371ee3bd', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v06', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 6, 80, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v06.mp3', '86c342cd9bb5298f1394a89c9b51efcbcfdcd848fdea829a7f8e1346fd3b1f95', 960470,
        60.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v07', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 7, 89, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v07.mp3', 'c7862ef70c8c7f3e8b2a8c36a354cf1be6136175f575afb868db8ef94c2b8457', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v08', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 8, 83, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v08.mp3', 'e2761d18bdd9827c9e4c1483edbe255abc2bef8e7b0aed787b7a7cfe2abc6c2c', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v09', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 9, 96, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v09.mp3', 'c29bcb9090dd59011ce4d3f1792161544319748182a573760605db3604420f3a', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v10', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 10, 83, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v10.mp3', 'fc3d1c7ce3e6e77b2866f42e6af3fca81ea1284940d2c2a4ee3e2ee38e18be3e', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v11', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 11, 86, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v11.mp3', 'ad273c80a4cde1248b72e6a0f4b2d4906f16399c8f20684f7ada47918fece5a9', 893596,
        55.814, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v12', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 12, 79, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v12.mp3', '1b8493db5c1224919e7277ee14da35430ec082698ddef484abce5b032a1bd322', 972591,
        60.759, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v13', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 13, 81, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v13.mp3', 'f3e9b2b09126b3e9ea2afd4eb25856804ba4668be618f469ff8c9ad213a43922', 948767,
        59.259, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v14', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 14, 96, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v14.mp3', '07cb8a8d966bf52e328bfb3c0135fada4ee0b153b9b0c546e6c933a8cf64bbd3', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v15', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 15, 82, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v15.mp3', '5e89687c3f64fff08be3260cf72a65d1dd9fa969c52146268f6e8bddf1ac4003', 937064,
        58.537, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v16', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 16, 84, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v16.mp3', '0bc914ac853ca1598bc34b6106092c22d2357a8fcad0f128a8240b27975c818a', 914912,
        57.143, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v17', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 17, 95, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v17.mp3', 'e392046aae4daf09612d8efa154d3dda9f66ff9b2852944e853d98b8eaebee1b', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v18', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 18, 79, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v18.mp3', '6074726fe42751eb92c94b839e5e6e5ca022adfc38f82420950288c7ce746842', 972591,
        60.759, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v19', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 19, 92, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v19.mp3', '5dc4bd13886257d11deff6bcc4899d223803163a98376a260faf4f46aeaea72f', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_restaurants_maquis_v20', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5', 'restaurants_maquis',
        'T5', 20, 96, 'afro-soul maquis instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v20.mp3', 'aaf93342bf1b900c94825442cce5655752d83b235ea1f58820a60a1b41ec3a9e', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v01', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 1, 114, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v01.mp3', 'd1e9680e9c466f687566c192b2c73cf2c34f3ee2c53c66678c5e67edbdbfd827', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v02', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 2, 108, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v02.mp3', 'bc941811e4cfba7fea01a7c246767da5aaa9720de4fafcd3d9d9514b5200b165', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v03', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 3, 104, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v03.mp3', '5fe7d2ee19617cb9bf8fd41f8a9ca10ba9dc196842c402fb082721fca339218f', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v04', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 4, 102, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v04.mp3', '8195b91b2563007cbf5bd94d31f87b8bdad3d7dc15da4af12c1b8a5c92af9d24', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v05', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 5, 111, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v05.mp3', '3ab498c72bfdf99c31b92cad319b84b9c41084abededdf72ceca075093ff06fe', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v06', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 6, 105, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v06.mp3', 'ab0e4ec0a8dfc7f57e17ca9f8cba7e0bfc4ed91ce4857d2d4aa21d5e56128bbd', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v07', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 7, 102, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v07.mp3', '810bff936f1b93b35e49a2a4eb868c49a3362157a06e460432893667e32e7fde', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v08', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 8, 102, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v08.mp3', '75792d7ab43ffb1b0e89b2a873b79df57785aa3db92cb91b408f3afc8704b7e6', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v09', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 9, 109, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v09.mp3', 'b71b64876c48f936c7053ddd597baa37fa9423680966306097e9aaa73fe34895', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v10', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 10, 103, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v10.mp3', '5b1495806e53601d7e848032b2d8c43dca2f050480d8feb5ba2833f0569c7a73', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v11', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 11, 103, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v11.mp3', 'f4ffa13b1376f73f6fc4e48d5b32c5b7b90dcc6016bab066d27ef64baf921ff3', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v12', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 12, 112, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v12.mp3', '1c6c5e868517c36aa992f982caafcfbf9bddeb6c9b05eae1aa97be4dc6110b5a', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v13', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 13, 103, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v13.mp3', '22f918cf0fd237c28b296fd22aa8b4e9693af31fe25b276fb57c74b12ef00487', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v14', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 14, 109, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v14.mp3', 'a70a9db97d399a7e652920c2755921f83e6cd743959ae068429a292b7b2cfa59', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v15', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 15, 107, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v15.mp3', '41bd3e77a6f44dce06f26926fbbbea46da430978bb01820eb0c0793629715819', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v16', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 16, 106, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v16.mp3', '526b5309d59816c6091ee24a78407c3dcbaee5dff4833939db14fab5f37e7491', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v17', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 17, 102, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v17.mp3', '6a4386c401549c243bdd58c1362324590f69cca9fd23175c38c0103a82fa15ef', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v18', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 18, 102, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v18.mp3', 'c95c742f41756d35e87f6bebf5ff860447bd0a6f4e7ad6aeb5fb399ce80c8872', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v19', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 19, 107, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v19.mp3', 'b68d025291c8a194d452161a78e83fdf41f3f8ff0a586e85835460fa9b5a63aa', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_shops_small_business_v20', 'musique_t1_shops_small_business', 'shops_small_business_T1', 'shops_small_business',
        'T1', 20, 108, 'afrobeats commercial instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v20.mp3', '834cfd846abe9841a5a0083ea8656856b8cf7147f2d3a4c5ba242380bcc95bdc', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v01', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 1, 103, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v01.mp3', '02a73adff16fb627103ff0598183e4336b96a2cd80376f7cbc86a1f465fe9b18', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v02', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 2, 108, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v02.mp3', 'ffed754936e40d582b048d5a06d5daf608a9df22b65b82555aae1908fccbefc9', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v03', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 3, 101, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v03.mp3', '280c6f2f3124e052610c434408c750008fc598ca037a40289c1ba5c4dc7662fc', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v04', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 4, 102, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v04.mp3', '103d25dae072230553649be72aa50f11f33395179a31f3e3921e3399d4f2f51a', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v05', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 5, 100, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v05.mp3', 'b00c1956063df61a2f5913681b951352b645d86036d3c2cc925bfc8dcf1aca30', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v06', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 6, 99, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v06.mp3', '8d78bb81a084e7335ac22938d8db8bdd206e17bddfea831987115f3999d01f3f', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v07', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 7, 104, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v07.mp3', 'd3080ecc0870bf9e6e955b235c309495da338537c91c52b7b4b10f34a72cda45', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v08', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 8, 105, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v08.mp3', '3ba973fb2a3f8cbcd901c3890cbc0e1eb987d570bc68222860fcd2500e44b1f6', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v09', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 9, 103, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v09.mp3', '4ee5d20f255fb9e645f4e0257baff04bb88527d5b7f2d9aa42e092111f31d84a', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v10', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 10, 107, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v10.mp3', '8da43770ab5bc480bbc70a2f37ac4df3b514b2e0f3dae46cc00dae4ca8ee2c62', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v11', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 11, 99, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v11.mp3', 'e60602ddea71419f6b869c80abda4adefd24645eb75aec307277c6900deee376', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v12', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 12, 107, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v12.mp3', 'ca024076663b54d316912c279ea4c70b805109c57625d21e7632125d607abd79', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v13', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 13, 101, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v13.mp3', '066b608aa8daff831803626c6f00469c76a2001fe9550ec63682c3903b7c21a4', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v14', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 14, 104, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v14.mp3', '93835c960630276c74e302a15add03ac8ff73752b61eee9d58325839a498e612', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v15', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 15, 98, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v15.mp3', '0b74667b0e2d69c74607efc293bc7e78f518880ab7a3ef77ff5c40e5b73912ed', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v16', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 16, 109, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v16.mp3', '9862055f61d84edc5f01c821a52e45e3aba3065f706ca942f0f8c8a47c48e178', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v17', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 17, 96, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v17.mp3', '2b7f1e91f8824cd20c70fb6a67c858f9faf39bb01da6b4a58ae557e1a6442971', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v18', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 18, 97, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v18.mp3', '7f0ab7ba65c6601ed38acf42b0b7c8f2cc18618721fadaaf04ace5e7bcf9ea44', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v19', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 19, 96, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v19.mp3', '9c4900b1b02326bbf3b8cc5a7b8fadcdd385513df18eb48456cd6876552de74d', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_shops_small_business_v20', 'musique_t2_shops_small_business', 'shops_small_business_T2', 'shops_small_business',
        'T2', 20, 96, 'coupé-décalé instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v20.mp3', '87f6469dfc245bd6c1c810ca82a3e483366bc23bbab555ad6b3b73530779a1c9', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v01', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 1, 90, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v01.mp3', '09a86c953dfaa98b724462753ee044079939ee373ff8bde36a4a68b6e78271be', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v02', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 2, 101, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v02.mp3', '01dd0d6ffd350bf2de5002badee6e3d4edda86279b97a73db6ab09c37f9f904f', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v03', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 3, 94, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v03.mp3', '6b0ab2a10f332eb721fc4622f3e085cac417a6503065545048a108b8a779a8a3', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v04', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 4, 106, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v04.mp3', 'ccd382eb7db0e714980dfe92be074f1b308d451f1f9b733d1d37e53ac37eb960', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v05', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 5, 99, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v05.mp3', '06a55a0f071ba162a52de538369c50d1d718aa051f309c5bce177cd81634d56e', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v06', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 6, 96, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v06.mp3', '44912df4f6ba0e74b910ff07f72a7f246baeda862d2f39676e87632e89f05f20', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v07', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 7, 98, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v07.mp3', '28f566924fe951ff6ebeb24d579e529fa817fbd41b444c9eb5054bedbf00257e', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v08', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 8, 102, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v08.mp3', '476ff5c504dc2c308ef613a6c57bc2c8b8719267b045a8d055dfedeb0d863654', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v09', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 9, 99, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v09.mp3', '4d563e430507b3abc0a8f2beb28bbb0b5ebea95ceb0875e210c19a95dd510a8f', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v10', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 10, 96, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v10.mp3', '98a89d17d4a681354c1d5398d08ac9d4f0843ab1f6bf2273acfb12cacb83dbba', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v11', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 11, 106, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v11.mp3', '77dc2509fc5cfa84cf04ebeb89d5f520b36f2c66c27b6e9813ea26fd19a2f0e7', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v12', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 12, 94, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v12.mp3', 'bcc5217c1cc7bc54f1c8444700a1ee86224e5423a71881477074a803b50f27b3', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v13', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 13, 101, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v13.mp3', '1d216500653de95e067d713df986f471b21eba8293448faca2affdbfb14473bf', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v14', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 14, 104, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v14.mp3', 'eefcb237df191e6f92b597e6fa295d7269d24be1fc8948a54d90aca1f6300a09', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v15', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 15, 99, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v15.mp3', '6845adf1cf27e3b1dc9704cec3b5755c0ff49d3d1bedf47537c6ab271ad69cac', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v16', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 16, 96, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v16.mp3', 'cf6ef74836646cbf10dcd5b1f38e68b21ebff3293619099bc8ce696b559025aa', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v17', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 17, 90, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v17.mp3', 'c670c3f5ff30b2c20bbdcc7b5292b5f1f8c45e6a23cde6ed2fbf48c1ff6aadc0', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v18', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 18, 90, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v18.mp3', '21c22c2f78bd9fec4f5347b6f7d82dbc706c0101f5e2ff5a4c470f24d8a29e26', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v19', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 19, 104, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v19.mp3', 'de4b79886b6da1bb5cc816b01204646ef3cfc3e1a0d6ed5a5d8318199aaf3659', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_shops_small_business_v20', 'musique_t3_shops_small_business', 'shops_small_business_T3', 'shops_small_business',
        'T3', 20, 93, 'amapiano groove instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v20.mp3', 'd5f57ca52e6597cf6cdcd4aeb94b55f4bd9e4d236854c44e94f47de1f136483e', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v01', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 1, 127, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v01.mp3', 'b90939e942338cc54dffe1151c4d50e9d39d7d348b3dc356b2d733b73c35653f', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v02', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 2, 113, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v02.mp3', '52ef224e15d25602447f27c72d2829998b9c28b7cc2cc7939b91e50559b2bc40', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v03', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 3, 114, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v03.mp3', '0552204dcfd396ea01792257d5edc0466621712c88ed3759231a293da1b481aa', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v04', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 4, 125, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v04.mp3', 'cb3e8c9c4d77fe3a1a2c06bdb60615e18e67e4ad79933002198d2bdd4ce4e4c2', 614817,
        38.4, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v05', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 5, 112, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v05.mp3', '5dcafbb4221ac1af1d368e333dbc6bf193344d8ae95b8c43cd64732d5be8a253', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v06', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 6, 117, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v06.mp3', 'c478de08c6cae63a1f2c90ae4f8113f0321c84908abc794d84b7d36c3a38b522', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v07', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 7, 123, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v07.mp3', '59791beed91d7a0a235d878c58eabcced733148c8401f857f7a0b1399f7f035e', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v08', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 8, 118, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v08.mp3', '72d0822c2d0c99d845b999232e929c6809c4ac9079e4b010432df51f3d6ca059', 651598,
        40.678, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v09', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 9, 127, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v09.mp3', '03fc171e09df83b244268636625c8e475f2aa1ed1f54a31e01ebe4ef3845aef0', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v10', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 10, 116, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v10.mp3', 'f26e2fa85346dc6f628f054f556fdc088e802da872bcf1ea5af13acfe7988bba', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v11', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 11, 121, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v11.mp3', '9678da5fe38988d5cd9c1d5d60b8b34e992fda71c77b94d945032630aec083c4', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v12', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 12, 126, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v12.mp3', '39f09789baea4cb3c974c3840e87ba6bfc1168bdd3196f6f2b760cf9aa449487', 610220,
        38.095, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v13', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 13, 117, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v13.mp3', '2b83d4bb102124420a8c1ef354a490dc18d8b27525c2e8ff1f411178f27cd840', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v14', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 14, 123, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v14.mp3', '4ac699c3544d977dafeead013c02afddaa60139682b6385406a219e8d0564c0a', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v15', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 15, 119, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v15.mp3', '7873e583ca093e338da22eb3f1d15b4141275e6dcdd59f765103c2c74498ab75', 646164,
        40.336, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v16', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 16, 124, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v16.mp3', '64d51602fc63b26e4c9945041861e6d666a5d53db50d82ebc36564f4d42b1bd1', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v17', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 17, 124, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v17.mp3', '1776802259b21e36bf76d48101013f9743c022d6ac8dfb35fdaa94c66396c932', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v18', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 18, 113, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v18.mp3', '686645cbb2665ce3c063fb53960230e9e3facc6f22c4838dd7b634c57e53fd2f', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v19', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 19, 127, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v19.mp3', 'ab76baef1dc662a7604ca6df03b92d3d2c38376dea30c4523529b37751468669', 605204,
        37.795, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_shops_small_business_v20', 'musique_t4_shops_small_business', 'shops_small_business_T4', 'shops_small_business',
        'T4', 20, 112, 'highlife léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v20.mp3', '7bceb18a8e729315a60cd9823e4cc2f31a04b8f75ddbca911492e38a130d50aa', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v01', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 1, 84, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v01.mp3', 'd4e66bea58096ceec816a2db69e6042aec8ddb7b0a8ed9ef82ba2d6c6d73d042', 914912,
        57.143, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v02', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 2, 80, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v02.mp3', '99a5028808dc2990e00be121730b1e44dedde31adfaf322268a584227639e298', 960470,
        60.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v03', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 3, 93, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v03.mp3', 'c5581072102a429cd45eada2574929d3ca7f3c73510c9071bfb90540fa9404b9', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v04', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 4, 85, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v04.mp3', '8fa28b039ab96ff2afef969f41580f526654d99a6fbb69c02cd85c60260247ea', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v05', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 5, 86, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v05.mp3', 'b2bc30b173e4a7f8ab53b56a8326f8dff207e0d40a1588fa07ca6747107473e4', 893596,
        55.814, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v06', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 6, 79, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v06.mp3', 'a864e9ddb0449d177ca68b7924382a642492a038613c6fcd32ff2f97b9365691', 972591,
        60.759, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v07', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 7, 85, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v07.mp3', '0ca2decdb5b3bbe16041b8ea89d36bdd2ea8b847f894c3107fec867bb97e1e66', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v08', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 8, 85, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v08.mp3', 'bfe18b932c2ae3ea291ffbaf7befdfd2fe2ca9b278312c0e7da8f422cf803319', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v09', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 9, 90, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v09.mp3', '3ecdc39e306c0390d63f742fd9c8b8d8b4c316fdc18c1bea87fe4644cb058de6', 853890,
        53.333, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v10', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 10, 87, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v10.mp3', 'cc10debb9fe0daf03c2aa31ca30a757b2620a5dd807b945578aa111aff0c52a0', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v11', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 11, 85, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v11.mp3', '1a1a023d889d94b5eca1ef9e2ae5f42f8903cf45d5f30a16582889ed6ceee3e3', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v12', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 12, 82, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v12.mp3', 'f8cac46b7137066fbf97fbe8a779d07a04c1bb8e72276926088abfb1573e4dca', 937064,
        58.537, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v13', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 13, 92, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v13.mp3', '201d256697fe8cda28f1456172e5e57775c041623bbbf184db493bc3b3c73b36', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v14', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 14, 86, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v14.mp3', '951f4741cba8d00e97b8f11c6e2f59d6057507b4058d00d8b8033b6f3a16c797', 893596,
        55.814, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v15', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 15, 88, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v15.mp3', 'c5888e31bf2634e2030d11d26d1d2f06a99c657c14a8a4d81a91c6c080eb6fbe', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v16', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 16, 84, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v16.mp3', '52b16542b6dff8f204fc85640650fae8e801dc1140116676b719ced91d4dbc36', 914912,
        57.143, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v17', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 17, 95, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v17.mp3', '31410120eccb676a21b08a76a93d1774a0a0a59ea8cb07c83fcaf57b395ee26b', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v18', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 18, 80, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v18.mp3', '9e43c45dac963b42493ccc273d8109ca68baac4760dc7c530334ffe3ad887446', 960470,
        60.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v19', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 19, 80, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v19.mp3', '3f81d945b999295f43786a571ee11057f466e700f2a3df62fcbb1bc47fc2b955', 960470,
        60.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_shops_small_business_v20', 'musique_t5_shops_small_business', 'shops_small_business_T5', 'shops_small_business',
        'T5', 20, 85, 'afro-house dynamique instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v20.mp3', 'e94ff04333074af844cb60c8186f1b55992b097a5e862eccf126109b65e369de', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v01', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 1, 110, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v01.mp3', '7d3e269d4665c099f1902b439d907fae3039721e71f151260657312d7f44cfd8', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v02', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 2, 108, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v02.mp3', 'c4effc54227f7edd77cac38e17f8ea85f6e851113099e57ff3c9ce553ddd7810', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v03', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 3, 106, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v03.mp3', 'd023436ace9c220e12b57f12a4d1617750b331edeb57cad6f65b43c03c437a80', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v04', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 4, 103, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v04.mp3', '11b7fd7aac1a98a7d0aec502a44ec54d546a39732729a691012d7e14a45f8333', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v05', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 5, 105, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v05.mp3', '42e910d6a0dba08a48e8effa5a90632f7d329b77e9742ea057f13946c080b629', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v06', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 6, 109, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v06.mp3', '47b007be895657ea84adfaf08aa5d30e8f327d988b9640f9d138c5be50dc2fcf', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v07', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 7, 104, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v07.mp3', '4b03943490d87e26a771690bf547cb60b7bfe8f467117efd7f5a75d3a2891bdf', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v08', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 8, 109, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v08.mp3', 'a06a090ad413c754ec19e71946034e0b9315a160d2c04a62b139929508603819', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v09', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 9, 102, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v09.mp3', '94b47e3a891fcffcdbe5d3d92a2a50ea07447f3ded51f16dd67f2a67fdd194dd', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v10', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 10, 104, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v10.mp3', 'fe5cda07e7b579e292e71f0d20dae88eb084bf93ec94a39d18a2a01033b7ba30', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v11', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 11, 109, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v11.mp3', '15fa8ad0250234621b81862ee4a4ba8eb71b35775f738a267d012c7db8b2a28e', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v12', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 12, 105, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v12.mp3', '2c34f23f016c0e3c1b7111ad24f07db6e098e98cdec3bc90c7ad6d7ac31188f8', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v13', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 13, 107, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v13.mp3', 'b92cc36bd581425c69958aee831154786fc286ae9e25087498a2df196c612ea5', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v14', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 14, 100, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v14.mp3', 'f623610181f58eba92c91ab5652046216cbba8a024d6e818ad89ec4b99c3a826', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v15', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 15, 104, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v15.mp3', 'd3d81f6aab74440e4a89b84786290afec680f5ea9312a8d5c9fd1668bda4fdfa', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v16', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 16, 106, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v16.mp3', 'c718e8bf5b17f2e2b777903fdd494fe1cbc1734db38ab3a392b884eb0c5bc52a', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v17', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 17, 109, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v17.mp3', '6af31901cd02fa03f0945293e5111894db03101679bf00aff207ac4f15237607', 705097,
        44.037, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v18', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 18, 101, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v18.mp3', '7ccfa87cd050d6523594fdb0c462b6ff2492acaafd9689a38f18726fd0271c6d', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v19', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 19, 112, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v19.mp3', '07896d06ce8ea3ee41759893c3d80d47054dda1a3fe9b246dfeaef26f0b39d01', 686289,
        42.857, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t1_vetements_mode_v20', 'musique_t1_vetements_mode', 'vetements_mode_T1', 'vetements_mode',
        'T1', 20, 102, 'afrobeats élégant instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v20.mp3', 'a1d3d95f402f688f387c018afb6dd8e90f61074a27a3e0b885fc05ccb95b09e0', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v01', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 1, 97, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v01.mp3', '0d5bca3c3bc10027aee74d89bb004bb31dcb5e6d04bfcb5638496af6a2497812', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v02', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 2, 102, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v02.mp3', 'df02f6735d97d33f83e60ce44bae7c44ebec14f06fcd66c28640a7f76cd672ca', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v03', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 3, 105, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v03.mp3', '972b6b575306e275acf169644fa26669cdf04f20b694cfaf1addf9a0610f0fdd', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v04', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 4, 104, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v04.mp3', 'a4c5bedace467e5af8725efda474246668af3ca469ab5ecb9700430de4b47b8e', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v05', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 5, 106, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v05.mp3', 'f10d297709b08db822596856e6eefa1804c90e935cb38b7779ad5f0172d82f13', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v06', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 6, 103, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v06.mp3', '26558b82ea26f1ebca6157975b9ee43fdae6e7f523933f7e0c0a34018251e668', 746057,
        46.602, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v07', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 7, 108, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v07.mp3', '6a78b4518aabf358595d99ccb2e379a839ab2b320fd01e960baa60896b8dc9b4', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v08', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 8, 107, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v08.mp3', 'aae3c42904635c16b50a02895ba3f0527e950f2a3ebea6b3e07de2361ac8b0d7', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v09', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 9, 108, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v09.mp3', 'e6ba6f379e1c89a968764f60d720b221da02823f5ef59f226b417fcb59c4f050', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v10', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 10, 106, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v10.mp3', '2449e6bfa65eaffc549b6c63fa46e9390c8de1bf78091262b5ceabbe5f7eadc3', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v11', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 11, 106, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v11.mp3', '044c55df19462af9cab3c308d7151fd14443c1436d343e5d7f0f5d56b527aac8', 725159,
        45.283, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v12', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 12, 101, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v12.mp3', 'c8d173fbcff80c519d080c3c896445d4f50b932adb8718954cf40ad319cf87c8', 761103,
        47.525, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v13', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 13, 100, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v13.mp3', 'c4ec702e8991e6db4bd7a98c992bc8f3a122cd861d34e342d31510d736e1a596', 768626,
        48.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v14', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 14, 99, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v14.mp3', '29f9a2a04d29718d9dccf7f3f3a8ee286586a05508fb6e1d363e4bcdf073dbc2', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v15', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 15, 107, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v15.mp3', 'f53c6e9db63bb46c07a4150e258f23ba58c34106b82eb7c15eb42823600a97d2', 718471,
        44.86, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v16', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 16, 99, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v16.mp3', '76893ed020d674fc5ccacefcc15347bd1ea9934986407987c857e2272cf5bd3a', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v17', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 17, 105, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v17.mp3', '48c31912d4c12984742792de38bf66f33b9bd45f75aedae43edc6c8919005d8b', 731846,
        45.714, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v18', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 18, 108, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v18.mp3', 'cbc33a6a3bd7bd37760e264919cd5ee15014f1691943d82b660abed7f48046b2', 711784,
        44.444, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v19', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 19, 95, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v19.mp3', 'b2726fa309972a7af7a0fc118e30d77d4f6474ba687048c7a2600e65e79c5f33', 809169,
        50.526, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t2_vetements_mode_v20', 'musique_t2_vetements_mode', 'vetements_mode_T2', 'vetements_mode',
        'T2', 20, 99, 'afro-house runway instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v20.mp3', '2e54b259c81f1c077f26f9f8868fbeb62a4760b593834f4f9be180a490371603', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v01', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 1, 94, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v01.mp3', '50b527afdf422acbf6d8f4a1b9c710a975c295c2eb98085d0612982c50bb46e8', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v02', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 2, 88, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v02.mp3', 'b24ac401ef910cb4ee3f3b3693e35580bb573c5137466df7a17a941ba90b40cb', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v03', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 3, 88, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v03.mp3', '86fcaba21edc80664db37b933306de6b7734074765549fcd6befc3a6be9f0060', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v04', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 4, 98, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v04.mp3', 'f9369eb60421ec5fbe24b10563ff74a56eda764f276d548e42df86d8e6afafba', 784091,
        48.98, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v05', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 5, 99, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v05.mp3', '70c92c1bba754ed23706b25934973a941cc3f45271248a70330b942ce2bebfb5', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v06', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 6, 102, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v06.mp3', '5c5a5f8b55cdb583071be708a640d8b335168844b6c45b6d94e499c723a5afb7', 753580,
        47.059, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v07', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 7, 89, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v07.mp3', '91723587d6980815a873ef4a46ee6d23234810e493a75a5db229cfacc2a7705b', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v08', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 8, 104, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v08.mp3', '9abfaee7d4eef03ba0b5faf1101550aa91822e277dd0fe550d2fb5cf3fdcb967', 738951,
        46.154, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v09', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 9, 91, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v09.mp3', 'a08bd352f88e02887c01b9b99717bd6bd0b9452c304af81262e671691cb6828d', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v10', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 10, 99, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v10.mp3', 'ce7f9720953249b5eb3fbfc419a5cbc68a3640c3746a3d8f95bed21b2a4feeed', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v11', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 11, 91, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v11.mp3', '80920168fd8acdae0b9c9475f72e9b569f293c414888f69d946d8fc7df9630e9', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v12', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 12, 97, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v12.mp3', 'd8d13fa9fb54eb121bc81bcc1cbefadf5b55e1b4c043c0db3acf90adafbf0fe4', 792450,
        49.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v13', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 13, 91, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v13.mp3', '4460b7c949a9ea5ac3d5556785867259cf962eac40fd7413ddf70a73c33b9150', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v14', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 14, 89, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v14.mp3', 'd41196b80f72d2e8368da7983da5a180bda6467ac751d10c3839b51eba15721e', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v15', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 15, 96, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v15.mp3', '20a88a4ddbdd57daf2b8a360becfb50720351e817d067984615af18e4173a032', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v16', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 16, 96, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v16.mp3', '22457d5c0304261e57a35e07a3a3b89bc3f9253217cfc532c99abf3bfe2af895', 800809,
        50.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v17', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 17, 91, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v17.mp3', '7dd6697bccd70eaa8eec4099358f3fc0a158e44ce94895757b05e2cbf7f5014d', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v18', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 18, 88, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v18.mp3', 'b196cfe119feb154fd7fcf287ad0060d58dedbfd8b4ad5171d6a7abc54d36be5', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v19', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 19, 99, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v19.mp3', '036806716daaee67bdac55004f75c9703b50ae4c541bf5045956d673b6b03ae2', 776568,
        48.485, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t3_vetements_mode_v20', 'musique_t3_vetements_mode', 'vetements_mode_T3', 'vetements_mode',
        'T3', 20, 92, 'highlife moderne instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v20.mp3', '84471efa3fd08174ef2af6d17fd338403254dc14b2cf28fdb689403a9880bcb5', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v01', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 1, 113, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v01.mp3', '86ef6b09b621c86eb54359fbd4b69c17c2a04bf7d06177d5bfdb5666619f9b60', 680437,
        42.478, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v02', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 2, 114, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v02.mp3', 'fabd9afac062c349e1a513646c2524897023288f6cdf8ec0173bb59151034b37', 674168,
        42.105, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v03', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 3, 116, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v03.mp3', 'cd210bef67b74fffa478e8aef7f0e2027b46d5706813989777000e49ba01a27d', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v04', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 4, 115, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v04.mp3', '42b7434f8640ad7e7810d65310365f717de38c612772df2ce6176b5e004679b4', 668316,
        41.739, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v05', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 5, 110, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v05.mp3', 'f7d7e09f8f179eaf44e724159efb1eebdc9b3023cd631f3c1926ec6d81f14d22', 698827,
        43.636, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v06', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 6, 111, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v06.mp3', 'b287a2c20d7590f7d057eb744270cc92a445eccaea63917840d6e897c20d1ba0', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v07', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 7, 120, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v07.mp3', '4d07c32ed8197d7478b27c7f09d20dcef97b3614df0f52d6592d95e1b0aba8eb', 640731,
        40.0, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v08', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 8, 123, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v08.mp3', 'aa151dc530d77a66da447d9d08d483114c729e2ea5dbf8b6a768eaa1bf709bdd', 624849,
        39.024, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v09', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 9, 116, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v09.mp3', '244e95b9084dd20c731515cc75618f064e2a671ea2e2de3495ef5b5d35549949', 662883,
        41.379, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v10', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 10, 119, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v10.mp3', '4d2a19e63cfc6b02e5328b501c4ebe9e7759d27fed0234a48c1393d5f73c9779', 646164,
        40.336, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v11', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 11, 119, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v11.mp3', 'a3040eaaaf8750f2f8f8917fd34fa33b0a29fc226b859909323562a58774412a', 646164,
        40.336, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v12', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 12, 121, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v12.mp3', 'c4eb02b66ec80264ff3f6e50c8d6a1d9f008ad82e82ba0f6264a06816d973f8d', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v13', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 13, 124, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v13.mp3', 'f982c04ea6574c71110ea0196bc1498878c1dc9698383f7db993a425fe73a469', 619833,
        38.71, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v14', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 14, 111, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v14.mp3', '25d47dacc2ea017439e6872837c6ca8757b7821809ba75a009a6651c015dd3ca', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v15', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 15, 111, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v15.mp3', '184acf802480775ec7d114cce4ede3cceacd6489e6b20c5e02dd6ba3bacf6630', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v16', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 16, 122, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v16.mp3', '0b4772fdd74de6eea8a18331a60d91da9e75f3b1ab0171b493d83dc756618bb5', 630282,
        39.344, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v17', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 17, 119, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v17.mp3', '60477974a9654d85cf7dd5b378f7e59604a802ee71eae0c4cc8bb5e6addb485e', 646164,
        40.336, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v18', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 18, 121, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v18.mp3', 'df5c55d742b204f589ccdb5a2c245b214dc1db1a824e2ef5119f94db82b93079', 635297,
        39.669, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v19', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 19, 111, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v19.mp3', '418b2b13f5696d1710201488443508504736dd8d99be50ed887c993cd39a7f18', 692558,
        43.243, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t4_vetements_mode_v20', 'musique_t4_vetements_mode', 'vetements_mode_T4', 'vetements_mode',
        'T4', 20, 117, 'afro-soul doux instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v20.mp3', '6d57d81aa507cba6ca2a32034cbddbfc319e189a5b9db69abe96537fc5df6568', 657031,
        41.026, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v01', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 1, 93, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v01.mp3', '93fa20e5e31f5df5abf23c64bd745da3cf44398145067384934a41cb52ed98d3', 826305,
        51.613, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v02', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 2, 91, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v02.mp3', '79693c4d48b947496e2c1b33e6a292c61be7de5c330e4759fab6cf36b3616d72', 844695,
        52.747, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v03', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 3, 83, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v03.mp3', '9fef354fd80e9607f116ac216d850a80987cfc5fd9ac1004323efb4202058f01', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v04', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 4, 83, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v04.mp3', 'a49cc80d26f99e967a598d72e374539940e594812fd33af1adb71f639fd0ad42', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v05', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 5, 85, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v05.mp3', '2ec17500b708a0e100e8867e1e7b2ff2a931bc450a7c8d0c891eb3cb7b4beb01', 904045,
        56.471, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v06', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 6, 94, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v06.mp3', 'e34dd0b27e853f623bfaa067fa7fea893c82f94f36b942f5ff8a599c4aceaea1', 817528,
        51.064, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v07', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 7, 86, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v07.mp3', '3c71648a164279de0556dce46c56719dfdd9565f5ca00ba77af6e2a76d80fc98', 893596,
        55.814, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v08', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 8, 78, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v08.mp3', 'd9fee018ee46ba5275d1cbdeaad3f65d61bda7cb4506b0dc47249291b1eef1b8', 985129,
        61.538, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v09', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 9, 84, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v09.mp3', '7768440748e12632d194833fa9ef4fce138cb1a04f62f010d9605d3e86cb7d99', 914912,
        57.143, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v10', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 10, 87, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v10.mp3', 'f02a8a5a48911ebe9ca4de3cb9e7c728dd4cf57b0d820545913898f42d4472eb', 883565,
        55.172, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v11', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 11, 78, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v11.mp3', 'b5cb709b70a5566bab872f64ae3cc3508ee6027882d78d4e932d9d67dcb7d534', 985129,
        61.538, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v12', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 12, 79, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v12.mp3', '781733e0d6257916a676729c53b86a240fd54d3e2c4b848d9e927720fca0d7ca', 972591,
        60.759, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v13', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 13, 83, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v13.mp3', 'd5ad495da2aa15f997fe4c04071b6ea858a5ab7de54ed8d94fc1352ec65392b3', 925779,
        57.831, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v14', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 14, 89, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v14.mp3', 'b1024ffe926334b70ea4323b37bb0b64a38f414ec2453a80f91e5f9b39bc0d79', 863503,
        53.933, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v15', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 15, 82, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v15.mp3', '11fd82c5175213a823e42dfebbdfb23ba1f38d145c7b7c280429183ca1924091', 937064,
        58.537, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v16', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 16, 92, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v16.mp3', 'edb2b9c86b4534d7db6e56e293d2ba77d2bed1143fb5840b70b0f7d181e34ab3', 835500,
        52.174, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v17', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 17, 88, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v17.mp3', 'b81ccf3cda5835c30f763560dbd0ec1c5922d548735601314344f3f023471e73', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v18', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 18, 88, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v18.mp3', '7a723864e4e6dca7e7404f67ed6d7889ce480bd997cc2c2ce2cd93378e8bd3f4', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v19', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 19, 88, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v19.mp3', '434d0acbd77c5dce8f473d4b393d7f01a4ae43d2ad6143a174b244ae77f9f99c', 873534,
        54.545, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
INSERT OR IGNORE INTO bgm_library
  (piste_id, categorie_audio, gabarit_id, secteur, format, variation, bpm,
   genre, origine, licence, object_key, sha256, taille_octets, duree_s, preuve_sha256)
VALUES ('musique_t5_vetements_mode_v20', 'musique_t5_vetements_mode', 'vetements_mode_T5', 'vetements_mode',
        'T5', 20, 81, 'amapiano léger instrumental', 'synthese_procedurale_v1',
        'CC0-1.0', 'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v20.mp3', 'b4d224646c4224c2d9fb6c00d9b01d76ce502157e011fde90fc4f5269a998d23', 948767,
        59.259, 'af60497ff1cbeabfa8a80d05948ae22244e8681c87d35883c583a155aa2db243');
