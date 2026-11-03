-- 0012 : régénération v2 de la bibliothèque BGM — 600 pistes UNIQUES.
-- Correctif audit qualité client (01/11/2026) : signatures musicales
-- distinctes 600/600 (bpm_exact x tonalité x gabarit), loudness intégrée
-- -16.0 LUFS +/-0.15 mesurée APRES encodage (BS.1770-4), true peak <= -1.0
-- dBTP, MP3 CBR 128 kbps 44.1 kHz stéréo, origine='synthese_procedurale_v2'.
-- Générée par audio_v2/finalize_audio_v2.py depuis les preuves jsonl du
-- batch (sha256 = octets téléversés sur B2, bucket vitrine-video-media).
-- Manifeste de référence : scripts/audio/bgm_lib_manifest_v2.json
-- Preuve générateur : 4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270

INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v01', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 1,
        107, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v01.mp3', '55f5cfa2324b660de0934db437ed3b03a6d86fb3d49f27807002f3f53f791a25', 639895,
        39.99, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v02', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 2,
        101, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v02.mp3', 'b42fb993b48687cc41ce40bff3a002fd7ad6e41631374844caf86393ce495ede', 621505,
        38.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v03', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 3,
        109, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v03.mp3', '023948c1b94931bb8409e44d57b83a9baa767006e6fbb4da2c53f17bf1d5f0f0', 631954,
        39.5, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v04', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 4,
        108, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v04.mp3', '39ab8520c5dc36ed2f8a8c668fc427c32d2e225fff55c7af22fa0ad1064dccbf', 682945,
        42.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v05', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 5,
        106, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v05.mp3', 'df1502c9193724522f979a02b906c02eaaf65ef0439ada72f515411bdcf169e9', 685453,
        42.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v06', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 6,
        110, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v06.mp3', 'd6ca1c673a5ee53b1270bddce38406a045e876a0819222b4d5e81a8a858874ca', 631536,
        39.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v07', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 7,
        105, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v07.mp3', 'fe136f654c41c0f478773eeda00e8ecefe81d48cd016202f4c8d9ba16b07b5e2', 692558,
        43.28, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v08', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 8,
        103, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v08.mp3', 'c18dafd35d04a6edd17e64193f1bbd3ff1e31e1416d65f2542974f8b320dcd90', 725577,
        45.35, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v09', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 9,
        108, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v09.mp3', 'be6c9c1782f31d8d773210167492c99094087b663c2c3a54823e663ffb312c67', 692976,
        43.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v10', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 10,
        100, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v10.mp3', 'af48d21ddda5c29de114d925e3417055ed52f1ca4ade7417885aa20ba55d3c61', 713038,
        44.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v11', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 11,
        100, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v11.mp3', '9acb864c6d3711183ed3b1af83ba5703647e4c75810bd8eda8d7a40d934e7414', 710530,
        44.41, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v12', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 12,
        107, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v12.mp3', 'b9fc37f6a6da661209520f21d36c0ca3bb40d2a701348741c6fe9e828c1a9f3c', 682109,
        42.63, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v13', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 13,
        104, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v13.mp3', '688ef318e524f1e708b35bfd66f0ea339306e38ee3d1e5024115855f5b1a0521', 718471,
        44.9, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v14', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 14,
        108, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v14.mp3', '47dcb7ad1befa4f1bdcb279aac28c65c86d836cb77504d84bc4c24bfd26375f2', 725995,
        45.37, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v15', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 15,
        106, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v15.mp3', '398268c88a20530b4ad5dedf2ebc48d284d5523b20e1b23e0ead37c2f38fdc29', 657449,
        41.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v16', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 16,
        103, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v16.mp3', 'b52f8d1b9259d4b2f57eb71529f8450061526c149a4bfa910dcd978176ae899e', 694648,
        43.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v17', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 17,
        110, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v17.mp3', '088557b3d082ad59bf7992bbde73e2624f31a56c8ef243588a1d3a799c21b6af', 700081,
        43.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v18', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 18,
        107, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v18.mp3', 'd38f102643ec3acf887273ec4668eb1e37e74c62fb896407d7698d28281bc07f', 660793,
        41.3, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v19', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 19,
        100, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v19.mp3', 'b402d4eb26d9b2311602eb797c84f3cc18665a85cad0fe1a922cddd740b2d410', 664555,
        41.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v20', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 20,
        101, 'afro-house percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T1/musique_t1_batiment_travaux_v20.mp3', '5b3e145cf5ff7590cacee31e85d3e45b4f0f0581537c28c3d335844480de4d44', 674168,
        42.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v01', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 1,
        100, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v01.mp3', '1921f148421067ecfde2c99b65c6bffbf2ec52b480126c7a2b7c0eb618e4b5b0', 690886,
        43.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v02', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 2,
        98, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v02.mp3', 'e3efc69fa9f33ebad463550bf848ee8f94131e073b9a67f3203feb50220bd037', 713874,
        44.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v03', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 3,
        104, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v03.mp3', 'a678fe169a2b080a1547512d7cb402c6a20a57c977cc0560621c74cc62f55af1', 690886,
        43.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v04', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 4,
        101, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v04.mp3', '82e716fe9284e66273263a0985fe6a986570cd1fc8514d8d98210a228da36edf', 668734,
        41.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v05', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 5,
        103, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v05.mp3', 'b8d6741d3766439e5f33f68174103041d651161ea229278ac8e780906d7589a6', 626938,
        39.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v06', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 6,
        108, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v06.mp3', '3f97e5bbcdf0c0af0081ca7669603cb327433b574f3b3b12e4e9aa0e3ec3c929', 706769,
        44.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v07', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 7,
        105, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v07.mp3', '4936e03d2d99638624d51a9c93ea0c232a74081febe3952d4ad4329616346597', 680437,
        42.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v08', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 8,
        102, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v08.mp3', 'dd4ab259cec347766e600c091c6a614ef91d4d7bd22c3767056c39cde6325e12', 635297,
        39.71, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v09', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 9,
        95, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v09.mp3', '5b60e19a70b5fbb813ef506d60e204a03641bd34eb2b83ddbae3ad41cd02d141', 656195,
        41.01, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v10', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 10,
        107, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v10.mp3', 'cd382906f9fbc5876b8ce24dd7900ad1827c68f0946d4d4b84cfa5a7d99e1647', 705515,
        44.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v11', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 11,
        106, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v11.mp3', '40df15b72b73b5a26e4a0a3b1394b1355b43b17710754e4de5bb22eeebbf15ba', 620669,
        38.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v12', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 12,
        100, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v12.mp3', 'cb5bf10be5780a1498fb3a473683417b9efe7478b534f0bfda5d4db6a723963f', 632372,
        39.52, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v13', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 13,
        95, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v13.mp3', '099194ea7d085520e7699d50fdbe5ca87263113ca066a220febca72cc547b90e', 685871,
        42.87, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v14', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 14,
        107, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v14.mp3', 'e5990db73b6133157f0904a5944dc36f244c0731ba7df5852f5b16097b60dd3c', 680855,
        42.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v15', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 15,
        101, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v15.mp3', '75168566eabfd23b31f7a7f57c2c1102d51aa13d5b14af0294a063ac72e541da', 671660,
        41.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v16', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 16,
        94, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v16.mp3', '87149722d889081237b0a3b7f8ea5a233de4862a66146e2e12c7dfa902ddbce6', 637387,
        39.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v17', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 17,
        94, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v17.mp3', '36d82aae734ba34e88602b511d1041bca90566e6a349fbb4b32850471521cb02', 636969,
        39.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v18', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 18,
        98, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v18.mp3', 'a02ca5f1ce3df77eb9a7276862a7b7ed1a045e2c4f751cd5d369e355f7507c85', 647418,
        40.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v19', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 19,
        104, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v19.mp3', '23086cac15150ad8a3b1183d1df7b041422f4ba2945a9c991c7ac3d5ec80fd3f', 718053,
        44.88, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v20', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 20,
        99, 'afrobeats chantier instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T2/musique_t2_batiment_travaux_v20.mp3', '89d54e7e0318939a152738c22b5e0df6cd57d422232b2c9db340e5de08953295', 720561,
        45.04, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v01', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 1,
        104, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v01.mp3', '11ae62ec0268caf5d57d9a62b4fb7561bc74df8638efab07e1a979db0e83dcef', 776150,
        48.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v02', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 2,
        92, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v02.mp3', '01a1d0cc5058d7aaf7aa02e23a34e6713254237ef37954e04ffc40f35a034cf7', 697573,
        43.6, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v03', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 3,
        91, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v03.mp3', 'acfd320ae8fc52802414f4eb93eb86bee35552ab53ec9b169d8543d33d411a56', 770716,
        48.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v04', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 4,
        90, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v04.mp3', '54ca3e66dc4c2710fa94d87cdabb28319373af2880ab3e27d47c79fb7a186724', 695902,
        43.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v05', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 5,
        93, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v05.mp3', 'ef3e4ec50aba68355675131e7b20f7dac3782b9596800ef490e3ffed54fbeb45', 731010,
        45.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v06', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 6,
        98, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v06.mp3', '6d12f7ebc9abbcd6fa98d7025e1772dfe722448c087c54f0b28921636e7313f0', 695902,
        43.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v07', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 7,
        97, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v07.mp3', 'a5c0a6a6fc5d9a0a0b494ebc8077bf78c1d6a61c23466c5f3ed66cd5d8319905', 723487,
        45.22, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v08', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 8,
        88, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v08.mp3', '83298dcfa477b3c8e648b899122af47f5851808ea855a28ccd1b9a51325d2471', 806243,
        50.39, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v09', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 9,
        98, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v09.mp3', '6464d4449f04ce27ad71a725bff809a11709c76c34206dc77839c31f2799033c', 802063,
        50.13, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v10', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 10,
        97, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v10.mp3', 'ccdeb5ba43310f9c6ed5edee6c1b3f2646e2671c7f423bc7138626578b24df23', 717217,
        44.83, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v11', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 11,
        103, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v11.mp3', '30c8e10979ab90398a9ce94eddcd81c107749d1824970361a41c6c2c2e331317', 728920,
        45.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v12', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 12,
        101, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v12.mp3', '58d84e598f09cb1ce0455dbe53b04ef4ae41e1638ee76283d85d2b12aa78d786', 737697,
        46.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v13', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 13,
        94, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v13.mp3', '2abc1b44b832dd5faef3ed69359676145c82fe26ac3c61e5661444f3583e36b3', 760267,
        47.52, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v14', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 14,
        98, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v14.mp3', '45b754d52451d9f014d93364aabaae46fe6bd3ac8eb0a29ba59fbb7ad714f24c', 712202,
        44.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v15', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 15,
        100, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v15.mp3', '141ddcd1472b2d139883eb2eb89fcb4f866f91053b477a08c5fe435f673e2a35', 776568,
        48.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v16', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 16,
        96, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v16.mp3', '343bcdf9bb46fc9982ad063dc97048d7b778b63b448fb3ff478544135ecd90c7', 768209,
        48.01, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v17', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 17,
        104, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v17.mp3', 'd6d8f579c55aedd3b1552b333d80b3f8f456c4f9bc9a5739448ae641f81114b0', 736862,
        46.05, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v18', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 18,
        88, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v18.mp3', '821a0e051d16c8f4f1bd552567b12e9582cf0a535248d9e96691342c2983a866', 716800,
        44.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v19', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 19,
        100, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v19.mp3', 'e536ec19bc451ce198b9e20605ce1c47b975c46d38938212f820e5d46b17d150', 765283,
        47.83, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v20', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 20,
        94, 'percussions afro industrielles', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T3/musique_t3_batiment_travaux_v20.mp3', '4c61339fe6e3728d3145ede6eac3e08f28c04dc608a508a478696b2ae906c73e', 781165,
        48.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v01', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 1,
        117, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v01.mp3', '5954e28d52078596478ad639d49412291add687d29c80ee43bf6f1b2eb0d2369', 651180,
        40.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v02', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 2,
        125, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v02.mp3', '266f2d3e34ae8066db1eaea60ad9af40af6c8cc3a6d13eb33be97869be34219d', 598517,
        37.41, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v03', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 3,
        116, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v03.mp3', 'e21d2e444a7f305d717903465aeee7aa487fcdf53df18cbfa3d8b1fe4ae340a4', 689214,
        43.08, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v04', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 4,
        124, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v04.mp3', '05373c331c1a9f569b4223a1bc0047fd620fd89be618ded49cd2a568e82eee92', 658285,
        41.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v05', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 5,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v05.mp3', '184593528a24c7b757e6e36f814aa80a4618fdd728d29f1b7a97719f93a9d864', 585142,
        36.57, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v06', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 6,
        124, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v06.mp3', '0db7ce65e1703c1ee601898aad0ad974947ef40850ce89631a8cf26c29dfbc71', 617743,
        38.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v07', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 7,
        120, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v07.mp3', '42a3c2c75a0f596c906c00410f4f928c6ca262390f77fc1ba4344fa32259b76a', 634880,
        39.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v08', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 8,
        126, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v08.mp3', 'eb908909d20b8d25ed7b9c76c9921e24d9bc0a3cb3608d7048cfe582c8e41600', 599353,
        37.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v09', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 9,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v09.mp3', 'b45526862681342919a8f000aa1b4f1504f343132a303b3cd58f16aa804ae58f', 623177,
        38.95, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v10', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 10,
        110, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v10.mp3', '6b3a0d9f7f5621b540a0f5a2bef9183d6a57508cb8d7a0d7e534d8f43e41da1f', 678347,
        42.4, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v11', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 11,
        124, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v11.mp3', '61239acfa1c70ae517ad60270e8820b4328899d1bbd1a7b558d8099894514f7e', 597263,
        37.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v12', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 12,
        118, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v12.mp3', '0dbdf050cb3cf9466f6c433b4cf834f05f3ac482866895454ca511f7f7d73709', 623595,
        38.97, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v13', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 13,
        111, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v13.mp3', '5a3f88b58689d02ce49f6f9dedeed26c2965bafd1d4b6f6c5e453ed056721890', 691304,
        43.21, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v14', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 14,
        115, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v14.mp3', '9d42c7238b4505448c03ddf8bf7c27e5e0e53ade2ef7300c7f6132947e1e8df3', 685035,
        42.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v15', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 15,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v15.mp3', '25fcf6f93f0cc73c9f99f0e8c5ad86d96fbbd1830d566182f3e488a691f6d87e', 632790,
        39.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v16', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 16,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v16.mp3', 'e034e4d15d900e88f54642ba65f2e7ad13e26d7e1bad8e0e60c509985a0b1a40', 601025,
        37.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v17', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 17,
        121, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v17.mp3', 'ed2bf65876eb3442d47ab0baf892c0eacd7b5abd964d6c85ffae9ad1406d6785', 690886,
        43.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v18', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 18,
        121, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v18.mp3', '485ce4f17ecfcc02baf46f4247c696dd25e48275cb12d70f7d0c1e2dcc6b026f', 677093,
        42.32, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v19', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 19,
        110, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v19.mp3', 'f1728e4ae43260f530479e6abf945682a8bae3b691c4e2a3c183bb60b6ffd615', 646582,
        40.41, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v20', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 20,
        117, 'highlife énergique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T4/musique_t4_batiment_travaux_v20.mp3', 'c177e4865a093071d6182ae680b42f453421a1b967b6db2c3949aebc7e767607', 619833,
        38.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v01', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 1,
        79, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v01.mp3', 'e570b11f7647406040faa0f62f973466fefcc9dea744cfd3a7c0a176b2621e79', 921600,
        57.6, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v02', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 2,
        81, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v02.mp3', 'f7dd9401f8cc9d39504f31bfd3ac406f4c88f06efc3e8642a7a4b3824ec4e8a1', 957962,
        59.87, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v03', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 3,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v03.mp3', 'dc8d4d3960bfdb3e2cbf8e6b97f42d5492dd0c7c755a979f777151f5357c97f9', 893596,
        55.85, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v04', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 4,
        80, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v04.mp3', '7f3295101d06180d705fd19a844439d85838281c9fd4d9916e771f520fcfcc15', 911986,
        57.0, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v05', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 5,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v05.mp3', '8e56a78518bfc44d8c6cfd4e3aeb9cc31f54e559e927810d27cfcf1c3231d5e3', 862667,
        53.92, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v06', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 6,
        90, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v06.mp3', '64dea7bdef18a21c932088c06bf8423eece6e9a6d4fbaca39d487d8b571a7fbb', 907389,
        56.71, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v07', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 7,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v07.mp3', '565f83b3b1d0dae7883d64be6e1b1eaa423145c5134d913261d3a48136cf1f6c', 868101,
        54.26, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v08', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 8,
        87, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v08.mp3', '4074d2cde52d0a375153970ec561f0b592959a6d11f95d7ad8bf53df4d292210', 864339,
        54.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v09', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 9,
        79, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v09.mp3', 'c409c021429285757558a4ed4bf80ab33ee3b8a90f2242c472333cbab140e9fc', 855562,
        53.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v10', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 10,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v10.mp3', 'd2f3c289b83fd8d3eebf38516655b3a3cf62a476a58505e6c23a5205e9937627', 949603,
        59.35, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v11', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 11,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v11.mp3', '42ac7f060ee21778da27de870eeccd6ea270cd6c1285a172e21b36cc9634a832', 923689,
        57.73, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v12', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 12,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v12.mp3', 'c2b5afb68a48e46c7c8cbf0c8eaf1dfa8fe25f34a58b1ff14d955b5ac01e7530', 906971,
        56.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v13', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 13,
        80, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v13.mp3', 'b8ac7a96b56b5849c90ab1d54cf94da41c3639baffa4d589194e9b48fbd3c5bb', 869355,
        54.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v14', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 14,
        88, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v14.mp3', 'd32135caac7a20cdd5acbf239bd55a7d517d3293ae8294314a8011924e2c8d35', 939990,
        58.75, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v15', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 15,
        88, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v15.mp3', 'be4832eff59f37b7fb6ee32aadd53645b33083e4c48e412119aa360aacd338b3', 854726,
        53.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v16', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 16,
        87, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v16.mp3', 'a2c011488e69ae872f02c04b6a2de3ce81e12134d8551c46ce87281ed0a0da81', 887327,
        55.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v17', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 17,
        90, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v17.mp3', 'ee215a857dfb29440949025cdfbe46f651e66b2fc22afe0ff0ad7dbe914ff6f4', 963395,
        60.21, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v18', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 18,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v18.mp3', '646c0da12a2230f1f952621a9730b5569e74b83bd1742d28f714d61a64ff69ff', 885655,
        55.35, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v19', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 19,
        84, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v19.mp3', 'e908c9efa7d0a411f02e3561e4fadd67ffd8cbe9af915f0d06c95c23383f926d', 918256,
        57.39, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v20', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 20,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/batiment_travaux/T5/musique_t5_batiment_travaux_v20.mp3', '49db289e90b3e3ec687d580fe333bc66217d55ee45fc8d6d606f29f35c9123f6', 946259,
        59.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v01', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 1,
        110, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v01.mp3', '57fc8a2258a5f1130ec751af496deff092338af35546ed432b090478335d1ac6', 717635,
        44.85, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v02', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 2,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v02.mp3', '6c2e60b3ef3c5fbf4795e7174e27320426b4a858cbecd332e08c42ab45d813f3', 686289,
        42.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v03', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 3,
        110, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v03.mp3', 'f1ad65da3cb782b8977b37ad6f388b83575bf2cb66a0fcc7387a40969e2785ed', 618579,
        38.66, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v04', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 4,
        105, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v04.mp3', 'cdf4248e4569e6656268e55aadb18a4fc49ecb800a4574a695e62cb3071acdd7', 695484,
        43.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v05', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 5,
        107, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v05.mp3', '7bbb0f1becbfe1bc6bb0c667fb611cfb6ef472863851a8e4a7e7c76a377464f2', 616907,
        38.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v06', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 6,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v06.mp3', '70903a8f326324fd562c6e190866843bccdb61d1b9217668aa4c49954706d290', 684199,
        42.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v07', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 7,
        108, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v07.mp3', '68f68a904d39a9e885dc85475252c32b13db4f1cc6012438fb47dba3d38e31c7', 674168,
        42.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v08', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 8,
        106, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v08.mp3', '345f480e123f31c457920d5a0c6602a59c4219296d12047b6e4f3bfd2e20cd2e', 682109,
        42.63, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v09', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 9,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v09.mp3', '67f152790418214aacc3e84dc15fbe4eb410530cf73bdd8f47dc56f9e626cba0', 665809,
        41.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v10', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 10,
        102, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v10.mp3', 'd60e8a9b06a62dc93a26b2170d665d5463ffd93c994cb08be643df16f4ec38be', 626938,
        39.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v11', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 11,
        111, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v11.mp3', '9fd4327b5b701ba962f64879639f69e530c8475d02f24a4f198837cf2663fbd1', 721815,
        45.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v12', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 12,
        108, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v12.mp3', '88eb931be795843ca15aa8f52be107ddce0c508339229b88feae80b3cafb50ee', 666226,
        41.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v13', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 13,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v13.mp3', '38e25ad0f305312feb6eed6b9cddaed4877817175eae77fd5a182869649edbfd', 704261,
        44.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v14', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 14,
        106, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v14.mp3', '2c65b3e9f90f477eff8acb0942ee5ddb422aeecc3e27a6c54e9743685eac8465', 687124,
        42.95, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v15', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 15,
        104, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v15.mp3', '85cc1ec28151dd11e17741855dbf9c9d73b22c630b1a8b19bf2076ca8571caba', 719725,
        44.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v16', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 16,
        103, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v16.mp3', 'bc999156f1914b02b660c48a132e5690d16ca1bdf20eb66bcadce76313f1a9ff', 652852,
        40.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v17', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 17,
        106, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v17.mp3', '65dfca3434d76d6b14c0f67af9aa5f41e6ee90777add42a9261eb43b67c2e958', 705097,
        44.07, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v18', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 18,
        109, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v18.mp3', 'fd07eb75857334ba6d9bf60a9baf76ca383f1d0d46bd02130adb87a06feb0051', 618579,
        38.66, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v19', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 19,
        101, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v19.mp3', 'fa0127a3c786a32c4516ddb8627c7aa07006ae8a4cacf5d6ad82e28dc19ee513', 695902,
        43.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v20', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 20,
        109, 'afro-R&B doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T1/musique_t1_coiffure_beaute_v20.mp3', '3bbb4c97a3f6519b7e20fa38acdbc4b27b88b7f60f8823a891a281b29f3f82ce', 711366,
        44.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v01', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 1,
        103, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v01.mp3', '6bf4231bb41607355f265dbc909b7438c172db2a8e86df9fb558a9be3069ca64', 686706,
        42.92, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v02', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 2,
        102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v02.mp3', '2a16b1b0e2ff66ba429e97928376bd6f22d0e743b0d4b045d4b49fbf714b3d08', 678347,
        42.4, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v03', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 3,
        98, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v03.mp3', '629800e3ed4ce4921598f2890137025a77afab963e9f9e951437b4d23c6ee77a', 684617,
        42.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v04', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 4,
        101, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v04.mp3', 'b69c6164802a3677df6fd22815966cb9ae374cf9d4939e167a95d3e098218c7e', 678765,
        42.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v05', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 5,
        97, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v05.mp3', 'a270c2a70630bdf43459da0c5d30e2f9ae986df28c0a5355e474104966d96b9c', 703007,
        43.94, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v06', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 6,
        109, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v06.mp3', '8b82ec1ea76cd919e8c1afb7a9c0f7a8b273cb3c9c83651ae864b83b2ba3bc0e', 683781,
        42.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v07', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 7,
        107, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v07.mp3', '1cee9f64971de106579f23a0a56a86337c1d5e8b7bc9137b7a2345f00943ddcd', 675840,
        42.24, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v08', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 8,
        106, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v08.mp3', 'caa61ca4f4789e6343f8dd921af2196d1d36ed73b854a21005223650499d63eb', 696737,
        43.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v09', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 9,
        99, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v09.mp3', '7e314711b5543b88e94554621608d95641526d9a2d9dd23ead121820a50a0975', 713874,
        44.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v10', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 10,
        100, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v10.mp3', 'f262538e87c31519d7d4d93864002a53300344f065eb87471383c750708aaa48', 719725,
        44.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v11', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 11,
        104, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v11.mp3', 'e194ee00523fe68d9e59d1879879ae8a522728272b5d01ac3873c185f7d658ca', 710948,
        44.43, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v12', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 12,
        101, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v12.mp3', '6b2d01b89eccc1be88d04d380d0b21549594ad5bc60781bf0ab47bef38bb01df', 631536,
        39.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v13', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 13,
        96, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v13.mp3', '888ce8b9f5f63e3b36d36eeccac75750433f9436deeea705901033531b8232de', 695484,
        43.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v14', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 14,
        102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v14.mp3', 'eae17cafd6168ea87735dbe79733b850569834389496448429cb862b03d37c95', 695902,
        43.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v15', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 15,
        104, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v15.mp3', '8f699755ff782ce80357fe928e746aa8551f7027150f5ecfc9086fbff98cdd66', 636969,
        39.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v16', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 16,
        108, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v16.mp3', 'a654b2d55123a243d6d78fe580daa0e79b4e10c059c35f88ae326479304ea099', 681691,
        42.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v17', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 17,
        108, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v17.mp3', '5339d346082dca75fb6e0dce4e9b7bcd46208f5f3b33013f710341fe477efb87', 693812,
        43.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v18', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 18,
        108, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v18.mp3', '099860aa17667d079c9c595b4e0dc45d0d6cbd7014f820e8f63e09c45503b524', 691722,
        43.23, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v19', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 19,
        106, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v19.mp3', '2e8e231ff96d2f8f66665a7479c9be5d74aff037cc762584b7cf3bb8859cd519', 639059,
        39.94, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v20', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 20,
        103, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T2/musique_t2_coiffure_beaute_v20.mp3', 'df24b8ce169411dfd15d10a8b346d6416f4a2915f772d27b1b61bd62d90844ac', 631118,
        39.44, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v01', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 1,
        103, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v01.mp3', 'cec27704539104a7931ac716cf13561175e58bf4b232e9e530d6b6b37e8641fd', 712620,
        44.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v02', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 2,
        97, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v02.mp3', '112a8f0f7520f98b0038ecc1f191017ef35fb3afdbbfd00af282b0e56500ca8b', 793286,
        49.58, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v03', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 3,
        104, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v03.mp3', '6dd739e841c203c76b0bc610ef1296dc4e244f0afa38792c6a0837f0578dee91', 768209,
        48.01, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v04', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 4,
        89, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v04.mp3', '5f4d45446b15b6eecc10ec857fd33c4965fe8117d35cfcea284a560dd0b67b5e', 696320,
        43.52, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v05', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 5,
        96, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v05.mp3', 'b2a8915e8580eefe0fc6f815bc2c6684d334d329d840466974f8c45b152de728', 789942,
        49.37, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v06', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 6,
        99, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v06.mp3', '9a20df11660be230ea9f8a86c2ac0bae7ae006f2089e39dd5c3d0b1067fe9be2', 776568,
        48.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v07', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 7,
        99, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v07.mp3', '0c682452724415ecee67079b1ae7ee5ac774262e42ac220df0fc73327ff22d98', 704679,
        44.04, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v08', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 8,
        94, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v08.mp3', '081f7fa34b8be2b6c6141949b42466c9fd81c86ffd5e60d1e18a907eb7bbf8a5', 714710,
        44.67, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v09', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 9,
        90, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v09.mp3', '8074bf35148256071684d3a42cc5e1934a7799ebc1cdff89734d174f78a7cfb7', 710530,
        44.41, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v10', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 10,
        102, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v10.mp3', 'bdf844bc2130c34fe8354f4b44c365a5fff12d59524b057904493c3d2edfe975', 782837,
        48.93, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v11', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 11,
        91, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v11.mp3', 'd593fbbdb7253c37c3a7a241bd09724322a91d3b0dd56df03716942f586e8fee', 794958,
        49.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v12', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 12,
        89, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v12.mp3', '16312ab90c234cb87b0c3879d93fdb6f8d0644808001c33bb761439059ae4900', 714292,
        44.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v13', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 13,
        92, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v13.mp3', '043159c4e8f095175c22dbdaea2993a700a4aa5d5563447379b037afd0672dc1', 798720,
        49.92, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v14', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 14,
        96, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v14.mp3', '5ecd05b9b39d32e2782396c37c29737f30805c922ae26e1279542a91a8453a4d', 699663,
        43.73, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v15', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 15,
        93, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v15.mp3', 'ec1866f297738f695212a3463bdb5b1bed6a88ae6dc7bfd1cc259615c3f647be', 762357,
        47.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v16', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 16,
        90, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v16.mp3', '78b0b42e719055a00e7bf3a13cf27fd1a756c2d1028ba2dd554665bb4dbd904f', 710112,
        44.38, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v17', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 17,
        98, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v17.mp3', '86466cb5c3a62aa881587cd4979d79c6250948f19b728ee1e6aa891ad33ad859', 700917,
        43.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v18', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 18,
        92, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v18.mp3', 'e5272e0527610ca27b01ab79e94f50473fc2182e9579de88b02a3245d743cc07', 771970,
        48.25, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v19', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 19,
        98, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v19.mp3', '6e1b20dffe58e2870f4266865ead540eb39af328f5d51e68e9aa4cc6dfe9a151', 771134,
        48.2, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v20', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 20,
        101, 'afro-house minimal instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T3/musique_t3_coiffure_beaute_v20.mp3', '773abf4de7893d5e7e3f60353c39a7ba6296e8ff5f3dfb60909d93e2e163a55e', 703007,
        43.94, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v01', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 1,
        114, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v01.mp3', 'e2049c4dba1b3aeb28e4c6d4ac4668fae9a495c162165943967518e05d769c1c', 646164,
        40.39, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v02', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 2,
        125, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v02.mp3', '6b877cb527abff8836cc00f07af0f3d481aa68ca56e6b79d4ac1fe356c1d7ca4', 678765,
        42.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v03', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 3,
        122, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v03.mp3', '59a1e528ee80ea264185cd90a5d6bc1f3cb97f4ab157a2b6f6dec123de10fdfa', 669988,
        41.87, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v04', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 4,
        120, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v04.mp3', 'f9df0b705a15d8db8e6065b9c835698b3721447053c40da64c62f8f99e9d65ae', 679183,
        42.45, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v05', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 5,
        124, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v05.mp3', 'ebf35d6fac29d4e836c6d1b7753c115acffa3cfa169dbbef25101497cb955ac5', 670824,
        41.93, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v06', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 6,
        121, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v06.mp3', '40a41b5a41c181985d67641ec8669398719a13ff818e912e54e4b1bdd8c17bf6', 594337,
        37.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v07', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 7,
        125, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v07.mp3', '86798dd1289699826877c862aeb3eb5f5dffd3c460c48c2c0ddbac3d71b4c895', 650344,
        40.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v08', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 8,
        124, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v08.mp3', 'd7795031fa9b886d7ec9882a9cb84c83362952feccddb894cdd09f96e98ff1fc', 688378,
        43.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v09', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 9,
        112, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v09.mp3', '66fa2e1ae72c34b882e7bdd2fe63de9db329c21127dfdd13b7615c9be607accc', 662465,
        41.4, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v10', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 10,
        125, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v10.mp3', '9779c26fcf2ffe19390f2b566f71038eda62702482ce72901764c1d90764b6d0', 594755,
        37.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v11', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 11,
        114, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v11.mp3', '88ef0eb4163cd57512c9e1fc371fc3070a880f9db618fb8cbaba642ec2c6501e', 622759,
        38.92, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v12', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 12,
        118, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v12.mp3', '3980970d92c42b3a8d3ceb56e2adfd048ca37ff3c73ce5a49a675564370b4d36', 652016,
        40.75, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v13', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 13,
        115, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v13.mp3', 'dc6c1c0a063e11b46bfe413aa91cfc6f532308b1fc5a70562695b92980e8a722', 679601,
        42.48, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v14', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 14,
        118, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v14.mp3', '74eb5ab3a9f674f9a1eb35cbcf6841b77d4e0b5636502b4338b79118e26ceeca', 624849,
        39.05, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v15', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 15,
        119, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v15.mp3', '7ba5dbe7ee9e4cdf9e1a3341e16c790031cdf7a4018452e0c3ac68a37eee9fa6', 585978,
        36.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v16', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 16,
        122, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v16.mp3', 'be810523c56c9c82ba63c990f86d358614eca3f30c047ed1370ddb50743a5c7a', 664137,
        41.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v17', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 17,
        112, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v17.mp3', 'cced233bb83b14d7e1f67449e70abef052f102abfc33321f4615158abedea9da', 644911,
        40.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v18', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 18,
        116, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v18.mp3', '42ae08efc729a51e5b1ba031876d0fbbd35ad657e3310c5fd944aa0f46d5bdf1', 680855,
        42.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v19', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 19,
        112, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v19.mp3', '4f3702581ac88150fa5de02240f4dad9e9abc9322c023b3e264609fc86935a0a', 637387,
        39.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v20', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 20,
        121, 'highlife doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T4/musique_t4_coiffure_beaute_v20.mp3', 'b9b2be7494b64d4e3f792da8e378a2548acdfb46c1cf3c4d50f3fa804ca88538', 663301,
        41.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v01', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 1,
        80, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v01.mp3', '86eaf72ed17f0b09585702430f18da7daba7f9a2d2379c17e5d4a4a82eea41f6', 926197,
        57.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v02', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 2,
        80, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v02.mp3', '6087551d30546571eeab3dd84c64b90e9c1fcc969cde6d1eed3741ff8ccb30a8', 909479,
        56.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v03', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 3,
        78, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v03.mp3', '7d50eed9536667686c7b9fb169029f8419948afcc582655cb5ee5b977398ca64', 939990,
        58.75, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v04', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 4,
        94, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v04.mp3', '20c528a150352a89328a7e8d6484a63dbf8cbe58223bd46a38394ae820dd8069', 876042,
        54.75, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v05', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 5,
        84, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v05.mp3', '3d3110fd962861016f20b060d50a99cb818e90e70d19b1a6682ca28b34f92b0a', 921600,
        57.6, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v06', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 6,
        78, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v06.mp3', '1dafe3cd00136887ac7151c0aebace2d67c568ce4c39ba7d5cd6ddb7804dfd33', 892760,
        55.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v07', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 7,
        82, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v07.mp3', '702dd9bbb4894cfdd4df0b96ac0c466ac21ed1190b68919c91a29b199903f874', 869773,
        54.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v08', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 8,
        80, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v08.mp3', '7894847d03a88e7fc39f03568805a2798e4de803e6d62caeb700092efbce7d0c', 906971,
        56.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v09', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 9,
        91, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v09.mp3', '21c8e3c7b15474ad3e18051e91da8f499eeb591c82756efa084732a50e59b62d', 959216,
        59.95, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v10', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 10,
        82, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v10.mp3', '55b7d22157a99ad448708ef2c24b2f5c820de735c9290f1570dc28bf7a770048', 881893,
        55.12, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v11', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 11,
        84, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v11.mp3', 'f17643569fb51ffd4e5c64753c20ce6caff340d892a86a515e03d3fc9a9bd5b5', 942497,
        58.91, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v12', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 12,
        90, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v12.mp3', '9c5c653b69a05b35c230d215d172aa7f70f66526d669d1a9c0bbbc3850940916', 870609,
        54.41, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v13', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 13,
        86, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v13.mp3', '941e4734b486e3ccfb54db383153ecbdd70c3683f3469d4dd8d029885f7ae8e0', 937064,
        58.57, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v14', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 14,
        95, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v14.mp3', '00645c393669b40d8a371ac717f88ee4c1c2d3107a06ce9d25493e9cb850fa41', 961724,
        60.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v15', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 15,
        94, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v15.mp3', 'a227cea02dd028f2e1fdd455c0b12a33185cb02edc81b5dab25a45259ce88c07', 957126,
        59.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v16', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 16,
        79, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v16.mp3', '9f7af51aa836dc853bf52c61f30242fea30c070e109c07126fd17284b897bbe3', 926615,
        57.91, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v17', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 17,
        90, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v17.mp3', 'fdbd6161a7a193e46c515790d7c8ba918f86f98ea86391d28a378fdc5e873e40', 903627,
        56.48, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v18', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 18,
        78, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v18.mp3', '44d5a13b756144b1806b63b8178d758fdb1ebdbcdd94f9b3b8eac1ac2b4285ab', 876878,
        54.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v19', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 19,
        87, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v19.mp3', '29f5a07b6c6e6b440a71083fe31fa7f666897d8ada89b16a6676672e412e8793', 892342,
        55.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v20', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 20,
        93, 'percussions afro feutrées', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/coiffure_beaute/T5/musique_t5_coiffure_beaute_v20.mp3', '8e1ada8e312b96558813cb68d72e715f886a95a606514b16aebae0be395f8a39', 947095,
        59.19, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v01', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 1,
        108, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v01.mp3', '3e1f0feef873bd9b12860d6cb833e96576c2f7ffc5dcf57593eb216dda1727e4', 723905,
        45.24, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v02', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 2,
        112, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v02.mp3', 'bf6d5d21a84f47ad55cfcfea480489b0a7978f5ad0d79ac83743ac1e50d598d6', 667898,
        41.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v03', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 3,
        102, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v03.mp3', 'f123687d3b112dd89ef985302ba02a434a6023b880c0670370a75cb2b474f205', 722651,
        45.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v04', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 4,
        105, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v04.mp3', 'f88abeed01e838358bcca44129bb1f2fb21e90b8324e89c6ecc696a1181c321e', 684199,
        42.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v05', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 5,
        112, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v05.mp3', 'aa104e5db633a4cc1143c0ed1babe0028b0434a4f6709dc30b9a698a873321cc', 721815,
        45.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v06', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 6,
        109, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v06.mp3', '4b5df26fd74b6be4845a9f53876d9cab20b45fd335f471ddbd3844936ed2bbad', 695484,
        43.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v07', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 7,
        113, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v07.mp3', '09124de84e797c23f76064a71cdbe38ff028409837191b6c8f297aeb5795b7e5', 645329,
        40.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v08', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 8,
        104, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v08.mp3', 'd7fcb0207d6395f29825c7a81f71e8591b42a93ae8d3e3d54794012c9e410654', 626102,
        39.13, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v09', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 9,
        104, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v09.mp3', 'b8450db6e344310685501fdcfea95364c1331d8a841f91ff39aa85a4f11e03cf', 665391,
        41.59, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v10', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 10,
        106, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v10.mp3', 'd20a76eca80e53f62546f8b88762e6a93b2f2874461b9df73a63bd9b9f7956e5', 709694,
        44.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v11', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 11,
        102, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v11.mp3', '05c6f8ae8ed2b570f46e607aa765d2845bdd5b660f400c99353e476a07659c70', 629864,
        39.37, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v12', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 12,
        102, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v12.mp3', 'af62316b80ff1331807bd930948e30765053648f8aa2b3217bd4c362154dd92a', 667062,
        41.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v13', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 13,
        112, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v13.mp3', 'b60c7cbe8a6880a0a8e9786cb82b7a5f1de6cff78ed5f83d1ebdb9d6d076b471', 659539,
        41.22, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v14', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 14,
        103, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v14.mp3', '8c6d7900397d6444ebcdb52ca8036ac46c2939ec00590228aec0a516d254bfb9', 724323,
        45.27, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v15', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 15,
        104, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v15.mp3', '15d54c425fce55f9f41ff8606bfe18af8465490ce7e71760654f81d501c036da', 643239,
        40.2, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v16', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 16,
        106, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v16.mp3', '31994cccecd7070e282d2c8e570b3c68647c142bc96539b568a0100d364e154c', 641985,
        40.12, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v17', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 17,
        110, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v17.mp3', 'ce5af0d71f129275411b03425f648e014203f6c583a04dd7815ee93baecdb827', 686289,
        42.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v18', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 18,
        106, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v18.mp3', '2c9ecdd5a464f5e29378095218404799050b7c15e00395b95a5ed5fe9d9eb4a5', 673332,
        42.08, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v19', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 19,
        101, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v19.mp3', '52e0b62fb51b6cccf89c3039270bd241b7ab92d75129214ef6ac3b90b14d7717', 711366,
        44.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v20', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 20,
        103, 'afro-house premium instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T1/musique_t1_immo_auto_v20.mp3', '1927eb81eedd35adf44be07c6bbab342554e08ae1f870e88c3085acabd71af2f', 679601,
        42.48, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v01', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 1,
        104, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v01.mp3', 'be1eca1a6ad3399853c119230e833f46b025da839d3ad8fee9fc30954904daf5', 724741,
        45.3, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v02', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 2,
        103, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v02.mp3', 'a65397a1f3e00d6e0652c187c00269a963f86a5d0f23aef3aaaabb98ceee4464', 614400,
        38.4, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v03', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 3,
        96, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v03.mp3', '7f140cc6493c87271c523f97b6568edcc5b2e540f62852b0073f4687d0b73df9', 718053,
        44.88, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v04', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 4,
        107, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v04.mp3', '81b17cfdc94bdb37e60d2324271e3c0aa208abf574c5499a627035c8f9dcdd8d', 715128,
        44.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v05', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 5,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v05.mp3', 'd8a315958458adde7c59fcda686c3b50e140c6a6b6d33f9b7b85cb25aff65f32', 622341,
        38.9, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v06', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 6,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v06.mp3', 'ed04094d7944f7da597e0e599e4abfe557f29aacb9a6944c1dbf7954027cec99', 648254,
        40.52, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v07', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 7,
        97, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v07.mp3', '9997291f3eb51930c614ea5f0bc795022346b6eed7d4f29c56ac912a82fce72d', 697573,
        43.6, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v08', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 8,
        98, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v08.mp3', '8eccb4bf2a177aa4b565c1a3f163cb1128d3660ac6e3da8293ceb1e2b5eeaad9', 639059,
        39.94, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v09', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 9,
        104, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v09.mp3', '952c6e7f4be4ecd5e35418e56945a96ed9e247c5664df426180594ebe49564b4', 714292,
        44.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v10', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 10,
        102, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v10.mp3', 'c64f0e922ec28c80587cdbf4af45a72016ad8550f014034e0d9d1097dfc3ac8d', 683781,
        42.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v11', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 11,
        99, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v11.mp3', '1fe5ff216f842c58fc2b5853b5b8e892f16b0410f61f14cc3e43a78c526dccbb', 670406,
        41.9, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v12', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 12,
        106, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v12.mp3', '91666652db4a57f954dcb44248fd274099fd9a89b6fa2e7d8b65f123a66dfbd0', 686289,
        42.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v13', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 13,
        104, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v13.mp3', '8514537de1f39db2cdf994d5ea4d3ec931ccd2dc9671252c337452c8ce2d7b9f', 643239,
        40.2, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v14', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 14,
        96, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v14.mp3', '09e8085e40b7e41e0bbd4804ebfefcbdac6e64f12603339378ba9dbc146dde35', 694230,
        43.39, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v15', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 15,
        96, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v15.mp3', '7272f4fe49f483655973bcff6f94dd44a4c0e4325557f22194eb3d4300880945', 636133,
        39.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v16', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 16,
        102, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v16.mp3', 'f7a61ef8860a1590874fb896467c1fd1e2d27b0e16cc581ef570a78c98ad6404', 698409,
        43.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v17', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 17,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v17.mp3', 'b1280496f17747aa6f6cf3af2cda4a3fb9c442f7664f200d47a73ef3c174e3f8', 654524,
        40.91, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v18', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 18,
        106, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v18.mp3', 'eba5824b3310a286d2d684948e08a0cd32791a61d64896778df74d15ed1f74c2', 634880,
        39.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v19', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 19,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v19.mp3', 'ea9bbdb29a642ecb579836a7ed0c86e90ad3335634ce7d2ea9985c1d7b5c9411', 680437,
        42.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v20', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 20,
        106, 'afrobeats sobre instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T2/musique_t2_immo_auto_v20.mp3', '007b0f7e828084492591a68f5d712247351512424b780b9d7bbf2f2af706ff67', 714710,
        44.67, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v01', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 1,
        92, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v01.mp3', 'f97c1b22f345b204316803512c8fc86636ad1d70dfc73d6f650e824aa33959c4', 804989,
        50.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v02', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 2,
        104, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v02.mp3', '3e495a79d89bcdd6ae78a50b6986212277b22dac74559accda6e47ac30866f4d', 770716,
        48.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v03', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 3,
        97, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v03.mp3', '64d8630a5cb3aecd4a8f14483817f2142357a83353592eaf416d27227b4c0f5a', 748982,
        46.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v04', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 4,
        100, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v04.mp3', 'ddd46a2885901646b0c071191c1c3cebc4c894a7920643ac8df4ce2af69444c3', 698409,
        43.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v05', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 5,
        104, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v05.mp3', 'e31c0de4846c56a3bfeff7d6374f01e06a8132f5a6e77eed262bd2617b344234', 725577,
        45.35, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v06', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 6,
        93, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v06.mp3', '69b950b92d394a1dc37d6b4d0bffc02bd7131ff0ce65d3d5c9d085c012bbf454', 728084,
        45.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v07', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 7,
        91, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v07.mp3', 'a5fea925619c8bc75a3a9ca8e53d8e4bfd31de8e259445b9fa3999a16f63375d', 749818,
        46.86, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v08', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 8,
        105, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v08.mp3', 'add10027076b3e872fff4e114b4f122e8c43fc12e8e9d2d8a88f89272f081891', 741459,
        46.34, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v09', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 9,
        89, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v09.mp3', '991dec23eaf22957b94697d4d46e6777158efd114afcafeeee4fa974768505bd', 695902,
        43.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v10', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 10,
        100, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v10.mp3', '78dff3981ae72af62827e73b80ddd86846ac8af77896c1c1ce5e23cbdb8a763a', 779493,
        48.72, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v11', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 11,
        96, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v11.mp3', '37ecfcbc8915ee322bcbea0eacc672491cd13b776e29c5c9cbf4daf6444b665f', 774060,
        48.38, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v12', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 12,
        102, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v12.mp3', 'de9765b7845f68627a54fa0abfc178f5d4aa717d2f52d8c063a375119d1848b5', 791196,
        49.45, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v13', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 13,
        94, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v13.mp3', 'e93ffce64fb09e12f206b84ddcc49cee362768ae76c00f61ad133a92d30f708f', 753162,
        47.07, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v14', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 14,
        92, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v14.mp3', '3e00e603248016d069e38da211b9eb1d69be7898d1728d6f023982dce334548b', 721397,
        45.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v15', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 15,
        101, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v15.mp3', 'd05d92dfd19e0c3c4293068770c1e357d14244af597cd5870a9b174a4412b181', 798302,
        49.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v16', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 16,
        104, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v16.mp3', 'd8874b62856815668fe25e0160f45af538114add18dc1994809cfab0b702ce1e', 804989,
        50.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v17', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 17,
        94, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v17.mp3', '7ae94e5a6d405d4ff28654f01e0a86bd121846b106a513684ee656daf038ae15', 702171,
        43.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v18', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 18,
        99, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v18.mp3', '7c3a5c45d55ad7aee3f8beb9bb8ee098ef2ffdacc089155dc9268ba927c1b9c8', 760685,
        47.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v19', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 19,
        98, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v19.mp3', '37c1a15135dc359baba697318b0f48bdc6b96011df6d3a5caa9cf5337a654a46', 718471,
        44.9, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v20', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 20,
        96, 'amapiano instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T3/musique_t3_immo_auto_v20.mp3', '55657b23ab7382bc660b7411847d209b6007320e15cee2714389c0edf4e87df1', 730174,
        45.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v01', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 1,
        115, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v01.mp3', '2e942f6e27b37132a8324bb328311cc20cf150c3e2c499a13b8ba4e25e191e73', 673332,
        42.08, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v02', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 2,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v02.mp3', 'd980241c28f3fac003a2d498c5ba5e2c0846299dd7932f86c0ac420295c44b41', 690468,
        43.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v03', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 3,
        126, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v03.mp3', '8132d3a36cbccbc18e0e59f45387999b0f48b85f90ab007cde87cae6ee46dd39', 608548,
        38.03, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v04', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 4,
        114, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v04.mp3', '00fb8608897c155867b7c8248929e5c551178f580896da676aab9b26c6254818', 600607,
        37.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v05', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 5,
        126, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v05.mp3', '0f36b2ae2ca57cf85cc2eac32452e5121f57d057b6b44a4c579533b6c90495ee', 594755,
        37.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v06', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 6,
        117, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v06.mp3', '6d89901ac3201fe504b62c1976464cba9cb8afa02b7bc77b69ef5a95056f415b', 591412,
        36.96, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v07', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 7,
        120, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v07.mp3', '31d56eeb58cc420ee9344544fc232ccbf9efaed2ee35591caf49254a8f53fb01', 652434,
        40.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v08', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 8,
        122, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v08.mp3', 'dd47c3fd87ee2c2ab63ba8fffbbe259072fd55357a02a548f6154ed2a337411c', 649926,
        40.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v09', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 9,
        123, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v09.mp3', '2c662f33b86b16dbc8db6ed6de42726ee878b8670d7bb805dcc7aa8706eda17f', 636969,
        39.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v10', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 10,
        115, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v10.mp3', 'f33c06f93eef69bf848a4a336f3b76a480a15d0106089bbc5f9ed8c238152efc', 628192,
        39.26, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v11', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 11,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v11.mp3', 'd175af8675f6d5c17f79edf21dac76d70ddd88255d6de21619ab583f10d26075', 656195,
        41.01, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v12', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 12,
        127, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v12.mp3', '0326920fa7a872336ad8a54fad40dceb3c212f9aac538e0060aaee35fde6963d', 651598,
        40.72, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v13', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 13,
        120, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v13.mp3', 'cfa9561ddc7c61ced36baf49cdd654bcd8d5dcdc8f15a79b9edc652d8b1fb977', 677511,
        42.34, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v14', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 14,
        124, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v14.mp3', 'bc4c8bc44fcfbe888d871a93a406b7db0a86c73bac47d5009add488408daf0ee', 651180,
        40.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v15', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 15,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v15.mp3', '45f8a1b217162374a96195ef573378c6cd6cf9ff49f17f297e4ffed702b6767c', 668734,
        41.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v16', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 16,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v16.mp3', '2acd50d4098661bd87930184dc40ebc7e9eab5af806f792c0319df2df5d1420e', 589740,
        36.86, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v17', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 17,
        111, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v17.mp3', '925811fd07aaecbeff94e77b46ea64533d983ded3bd74c4e463a0ebc5c898f1b', 664137,
        41.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v18', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 18,
        117, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v18.mp3', 'cf35e9708b833355bc22e600a2c4d9a01ad857a831b56cf40012283a98f43fff', 603533,
        37.72, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v19', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 19,
        124, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v19.mp3', 'd51d9c7c8cf03be66da401efeca1fd7a3a1bdbe042018c1490c3a1cbffb0f7ce', 588486,
        36.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v20', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 20,
        123, 'highlife calme instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T4/musique_t4_immo_auto_v20.mp3', 'c5839804377b5e0f61d3944b2ba09a2da67788dfe812cb09f7b464a3f4d16131', 613564,
        38.35, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v01', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 1,
        90, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v01.mp3', '424a421d8e03d26111b1b1ab9daac27d9dc381c9ebaafa80cc7f75ec4a371375', 924525,
        57.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v02', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 2,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v02.mp3', 'b257ee06d919d082727a3cffc7c2159c54d3a7b47b40e4b941f68b9a7c5b6cf4', 943333,
        58.96, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v03', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 3,
        95, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v03.mp3', '568ca6db9178cf342bbc6685963c29d53ad27fb39f785fc9dd6e30e971aaa71b', 878550,
        54.91, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v04', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 4,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v04.mp3', 'dc93374b622ea1d3bdabc4f827272fb8f450700d8e7c9a1eac488b762fbc0835', 905717,
        56.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v05', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 5,
        94, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v05.mp3', 'ae2742150f068cff48858888b35603d79546f0b8c9399900bd9f38a35ce2ac5c', 889835,
        55.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v06', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 6,
        83, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v06.mp3', '78bde180c41f05739575dcefbc5f1de20c4471404343df8add9dd593db070a8e', 887745,
        55.48, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v07', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 7,
        86, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v07.mp3', '4e9272ed37eb33fd0855515c1ae301bfef1db7b7cb04657a61506284185eac24', 908643,
        56.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v08', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 8,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v08.mp3', 'b1792d157478f03c7ef50ebeac423190d94cd5fa6588783b550f1fdf84ff9bc0', 866429,
        54.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v09', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 9,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v09.mp3', '41e1821c4860e65b59d46d015c34feb7e2f897d3e6466ce8476eb48d85e8db1a', 904463,
        56.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v10', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 10,
        95, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v10.mp3', '97b0a14a305960185194306a76b816fa9d1c40f70ab54c47372f7b27a37d9290', 927451,
        57.97, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v11', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 11,
        80, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v11.mp3', 'bee5b246c2461fc38544c39cbe97ea7075a237a84b65bfe8b3c4c0fa42b86378', 854726,
        53.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v12', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 12,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v12.mp3', '8923e89778fa3d76c1371cc7d82e73ec85a5f63a1ea77cd45f8832b308e8d8be', 952529,
        59.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v13', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 13,
        79, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v13.mp3', '447f63dff09b92add798e0abce6f138869d1c60da46ed0e56e9fe8682e3b90e2', 903627,
        56.48, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v14', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 14,
        88, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v14.mp3', '294d3b71dc1662d7105961e0956ff071b83191ad07f0e2c82ec9cbb091364ebb', 907807,
        56.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v15', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 15,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v15.mp3', '3a21602710bd18a9dfd1d306727b5a7498ddb307ca2c1ad19f6dd2959dca7a13', 923689,
        57.73, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v16', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 16,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v16.mp3', '262a93e73981e0cfd651121dc741109406ce7892b15321be0d78b55afa29e4db', 897776,
        56.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v17', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 17,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v17.mp3', '398593e2105f8c777223bd71fe177b09d502be0145ad8b5464f1f3c43c2a1af1', 875206,
        54.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v18', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 18,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v18.mp3', '8ad2f8f64f99f29e36115f4221bde67ec6dfde5b64c3ddb8cd75dd3a7bd096d3', 917002,
        57.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v19', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 19,
        84, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v19.mp3', '114fbb8b0fd2d2df36cd1fa4aba0acb5e020b2cb4ac8666544f418920066234b', 862249,
        53.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v20', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 20,
        91, 'afro-soul confiance instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/immo_auto/T5/musique_t5_immo_auto_v20.mp3', '77048092c1e0275fc670ed0f2df2424eb19c11a944b2dab4b32de2c44ff8472a', 953782,
        59.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v01', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 1,
        113, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v01.mp3', 'fe6e115e7f3ac7702552919aab720c404d7173b8ec5ec658adddc80f24201095', 712202,
        44.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v02', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 2,
        114, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v02.mp3', '9d74254e0c1f62b0f3b29cf026e53681a07fe42d449f49e1fe5f581855f2a183', 691722,
        43.23, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v03', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 3,
        104, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v03.mp3', 'ebbe8222be0f0906b6ece5de280cd584954c10f3c8aff9c3c7d7de5151c9683d', 635297,
        39.71, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v04', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 4,
        103, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v04.mp3', '4b5b2155ea0c1637dc81a9ed6f68b7809c2d50fd447511eae822ed0a783669e3', 704261,
        44.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v05', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 5,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v05.mp3', '0efa41c96fc6f6cd053268d712f18fecbb972263a02b6539c7419db5e64f8133', 654524,
        40.91, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v06', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 6,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v06.mp3', 'ca3a5b789cf397b861fc0ac7a903c5eebebb19c89127463d247a22d9c500a51c', 693394,
        43.34, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v07', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 7,
        106, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v07.mp3', '0e7960f5ed06621c3d8f79c72a18b05a88b20f7134360f26e43c01dc394abd94', 662883,
        41.43, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v08', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 8,
        108, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v08.mp3', '5f4aecf0cce8e9fcbc4307ecdb562f0290088c8d90dd0f6a49c2a44b8b83415b', 653270,
        40.83, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v09', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 9,
        112, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v09.mp3', '53e1f450d6156df3e3f02fa6edfc6aa12c82e3b105c20c57de245c849af7761f', 675840,
        42.24, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v10', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 10,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v10.mp3', '79bcad8355fa170e9af26afb0792aa64d19589f95643a8dd0b0026852258ef43', 655360,
        40.96, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v11', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 11,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v11.mp3', '48b77088eb001f5220b9df4bcdb4e14ddc481f52e726e92c78b038b770cbf6d5', 652434,
        40.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v12', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 12,
        111, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v12.mp3', 'ef64f6b016770da13502d956a509571c98721315bdd51b2d5626ca210d18cc05', 691722,
        43.23, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v13', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 13,
        114, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v13.mp3', '73eb5ae8acf25414ca645029e8cc5912a5c743d2defd0e306d9d38ff274ed724', 671660,
        41.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v14', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 14,
        105, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v14.mp3', '0a6ab1d6393e5caebd5f3245a41a41d6eb38e2bd9ed7e19a658c346b3ede412b', 654942,
        40.93, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v15', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 15,
        108, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v15.mp3', 'efbe1babaaa25b003844ca158c2e6644551db10d4463a67d7dc2fbf23e078855', 646164,
        40.39, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v16', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 16,
        107, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v16.mp3', '7e1593bfa1d03ffbbeaf8da37ed238a5b53f4066fe6a956a9539d714f108e36a', 699245,
        43.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v17', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 17,
        103, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v17.mp3', '3d9c4d08a6e62bf5912f1b8a3b1c2a74e838ee47bce50de4184893f7872fbb3e', 698409,
        43.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v18', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 18,
        112, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v18.mp3', '3057ca1a0d9c175574d835ab54a8c6731a0738fe2f075a4e74117ea0a2c87f66', 647000,
        40.44, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v19', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 19,
        108, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v19.mp3', '3f7d2e404d7aa9c80a366d9ac606248af81d2e40f37eb53f43f552dc0c27cf62', 711784,
        44.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v20', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 20,
        111, 'afrobeats percussif instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T1/musique_t1_restaurants_maquis_v20.mp3', '04bcc1e8c8ca189c501c2947d911bffb0c45fd0b082825359b5723bdbd0576b8', 664973,
        41.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v01', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 1,
        100, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v01.mp3', '1b8f37f0ee89c045f037d643170655995759a8c107193fb280cd5c97b8ffe90b', 634880,
        39.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v02', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 2,
        98, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v02.mp3', '734a4731ca4ac8c163fdff15cf46ba334b3f0f23163bf2555fddc5f2f954ace4', 623595,
        38.97, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v03', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 3,
        98, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v03.mp3', '5afb7c4d602532d2892396b2771fc3bb0a739f706f785325a0655be429cd0341', 625266,
        39.08, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v04', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 4,
        103, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v04.mp3', 'd211197110eba171b7a62f7187b7b9b060002b9d401b60a478e4a05302a3026c', 666644,
        41.67, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v05', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 5,
        100, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v05.mp3', '111d93d76faac7d50a029486fd863ccd3b69bd1d6afd4c5c9dc7bc5451aab6fc', 635715,
        39.73, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v06', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 6,
        107, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v06.mp3', 'd74f25a0927b549f7ca8522635dc83b2b19d835ddd7bb2af046dc9d0b5e674ac', 664137,
        41.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v07', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 7,
        105, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v07.mp3', 'df4d6ce7b0c8d8c51a0d371dc7b396c2dff08ceed538c39f01af799ecc5c6f77', 670406,
        41.9, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v08', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 8,
        106, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v08.mp3', '325f1667b5a44ced2da261ede01afcc77cbd1e1c4d0e1c8cb97727d15039a231', 634462,
        39.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v09', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 9,
        106, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v09.mp3', '2e3a9973e66d040a1c818e925487cc4420894030bcc5460aa9aa102d04220f50', 644493,
        40.28, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v10', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 10,
        109, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v10.mp3', 'ca73cd8e67def6ab7e99d6cbd84b89dfc626a88340df089e9f4c9b49231acfec', 669152,
        41.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v11', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 11,
        104, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v11.mp3', '6c30cecf383b2dacea1843980296c3891636b080a7525a7ad07e7268a7368643', 688378,
        43.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v12', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 12,
        105, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v12.mp3', 'adc1afddee00160ca12ad7c969cfcfb4540d12223bb98a6632fd69b66fb2749d', 701753,
        43.86, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v13', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 13,
        108, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v13.mp3', '2703aa1c393fcd32e6a03eabc0641260aa2afb0eb1e060544d606571c0b7c6e6', 671242,
        41.95, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v14', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 14,
        109, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v14.mp3', '6622e5cdfe87f5fc8e6a11b4016be3ec34ff43c218f2eb388233339d96a8f788', 632790,
        39.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v15', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 15,
        98, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v15.mp3', '100b9a310927d742956ddac167ddcc5d59594272105ed6fa2c0f1d6f6a7ea3ac', 621087,
        38.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v16', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 16,
        97, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v16.mp3', 'be1add62b1e06fd130e421cc21576035f6f97e8a36ca7b75f981c571a2852613', 693394,
        43.34, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v17', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 17,
        102, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v17.mp3', '9eef81290a4158e144eb1fd668cd1bade421b63152e4a99155bb97d6820a3468', 623595,
        38.97, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v18', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 18,
        110, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v18.mp3', 'bb976d81f2fab5f6706cbfe372dcd6d5d75f591bc923d0006d41add760c2c2f7', 724323,
        45.27, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v19', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 19,
        104, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v19.mp3', '1679b55517bfed5125ccca0881f12726b4cfc6927e5afafc7b5e9f90929ea8e1', 674586,
        42.16, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v20', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 20,
        102, 'highlife chaleureux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T2/musique_t2_restaurants_maquis_v20.mp3', '84298a55eec2859ffc41ecde070594c660254e87024f6df21cbd91bd77a34ffa', 620669,
        38.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v01', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 1,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v01.mp3', '871f1562a09a421c5514fc1be3fdd6742d359571537eac6c7d1070d84b14e424', 788689,
        49.29, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v02', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 2,
        91, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v02.mp3', '5ef317fd91174322753a98c5db39e916b280714dd62d3ae33b8b77588edae665', 774896,
        48.43, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v03', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 3,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v03.mp3', '291e8d41099607c94931c68f681ab631e8fc977cae2d078c35ea847656985883', 752326,
        47.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v04', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 4,
        97, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v04.mp3', '460db10c29a24ea02d05af16536817d2f11095d01b7d2c3e1166d40b49703c6d', 722233,
        45.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v05', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 5,
        105, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v05.mp3', 'b26869f24ee8500618c1c379b1aa0aac254bbe6e5a85bfcee4f9ff39ad13f49f', 766119,
        47.88, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v06', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 6,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v06.mp3', '425063435c708caf036dbdd620644681e50ae894314b9ee0f9df02cedd784e64', 768626,
        48.04, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v07', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 7,
        98, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v07.mp3', 'ee55d698947bad679cc4cee89b77a07acf6ea30fdce1aaf550b186d9a8478e79', 726413,
        45.4, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v08', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 8,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v08.mp3', '35b9af3ba9d8d64ae48b6d0acc9e871e89753b0a04c521d6a6dee5c0adf90e36', 744803,
        46.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v09', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 9,
        91, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v09.mp3', '40cf0c1bd535a44e530e313075d5ac43d72e9ac3b33a21ad889f184e750fcf8e', 793704,
        49.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v10', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 10,
        98, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v10.mp3', '0ce12f9d6a3e70f4fd69126be064ec6a63d3115d8439f5d0f52c5c10b373ce55', 805825,
        50.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v11', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 11,
        103, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v11.mp3', 'deea95258512100a527680bf7120d84b880aa7ec887e53531b5b38b52a636de0', 723905,
        45.24, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v12', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 12,
        100, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v12.mp3', 'e274dc2926f5aa44e9d0dc9af78f5f7fa6c33b61d3d87216b81e2639e4ffc9a1', 776986,
        48.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v13', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 13,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v13.mp3', 'd0dac4af1449d20bc0ef85ba5f47ec49ad75607567e5a214f4c79b33f30ec3c2', 803735,
        50.23, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v14', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 14,
        97, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v14.mp3', '82f4991873cde7b666964db719bf1567526092ce2ca197f35d1be423ef42df88', 704261,
        44.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v15', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 15,
        92, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v15.mp3', '3f903dcf865c4785e4f89e4e60069e49bc410aa98e55518ce72c2b9ad17df532', 804153,
        50.26, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v16', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 16,
        104, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v16.mp3', '4be7ef7d79804227a18d9acbec775b09236c3a95a932689e320280a6682816d3', 763193,
        47.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v17', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 17,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v17.mp3', '59f803cfa8dfd9ac5700de6f26ee4f7083e49cb63d753aee57e257438e3aa68d', 733100,
        45.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v18', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 18,
        90, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v18.mp3', '8269d6b4df6fa594827bcd6cfcfede75ee23ae92ec1d1e21f17491fe87ed407b', 757760,
        47.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v19', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 19,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v19.mp3', '3c9c71fd3b872144aee0a882f148259dae856f5eeff5875b9e41bcd389cef47a', 719307,
        44.96, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v20', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 20,
        94, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T3/musique_t3_restaurants_maquis_v20.mp3', 'c71d9ab3a5e93644cd4233b2de897f763be0097599ab532c308ada99e881d4ac', 707186,
        44.2, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v01', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 1,
        115, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v01.mp3', 'c773a0551bb8e9567ae2ae462ac5e7d952dcfbca710f60b3ec6fd70a33a5876b', 639895,
        39.99, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v02', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 2,
        123, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v02.mp3', '6e7a0622bafeaa1664d7bb5445669ede8cab32c445ac72cd819441a3817e6809', 692976,
        43.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v03', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 3,
        128, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v03.mp3', '1ccde1a1f7d6c4f1dd55e4e77bcb15571177e7ec33c26f3826e5e5d9fb6c4dc1', 669570,
        41.85, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v04', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 4,
        125, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v04.mp3', 'cac49a26db8b012f51540f7de49c87c0b856490675a936129dfe0d6674782014', 690468,
        43.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v05', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 5,
        122, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v05.mp3', 'b804e42ae7eff4297c3001ea07652b3807e999321d7b96c4a6f540aa77fcde6b', 652852,
        40.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v06', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 6,
        126, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v06.mp3', '33254c1c3505f2cd2e2e9f067c305669cdfa27950a89f04d6cb94156c4e6fd4a', 690886,
        43.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v07', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 7,
        114, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v07.mp3', 'b7672bd45937e95fce77fd3042b5a28c97ad42e4d1cbbbc8465c4aac86e166a3', 641567,
        40.1, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v08', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 8,
        118, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v08.mp3', '737c2a84655d6a6a006787b7b42fcb5a9bc64036a6517eec42b0f11ff38b0bd9', 683363,
        42.71, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v09', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 9,
        114, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v09.mp3', '56eb8469a1620e54e6c7f55f4e330f66b2e88c0e34f36c5c877401ce1adca152', 690468,
        43.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v10', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 10,
        113, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v10.mp3', 'f13249e24cddd1d523558be6a505e35fc7f6b69dbe81c53b470cce238d7e1368', 647000,
        40.44, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v11', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 11,
        128, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v11.mp3', 'd199262df0067ef8f3fdf32309a5cbd044687234456ffa67dd266290caedd282', 685871,
        42.87, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v12', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 12,
        122, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v12.mp3', '1b419bf9405fac6968bebd5c68c102e89e2d06c620f302cc6b25c58979820c0e', 587232,
        36.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v13', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 13,
        115, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v13.mp3', '7a5dc62fa4bfcc98da6c712708852752201f369091dc65e4d27c954a5b13bbc1', 688378,
        43.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v14', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 14,
        119, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v14.mp3', '87619d9d32dfa5c414a3323dd4be472fa2c4fa3719cdd7108c4b850630624477', 621505,
        38.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v15', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 15,
        118, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v15.mp3', 'af99ea81d43afa3b1e0105c4d9a029d4f6fdde07fd86029af82266226ea267e0', 600189,
        37.51, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v16', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 16,
        114, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v16.mp3', 'e22973e4aa34358b807357c690086511a0af1e67573dc5e1575661a1cf7dd696', 679601,
        42.48, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v17', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 17,
        125, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v17.mp3', 'e8eaec15179e7e451e4c91a0aec92353987f056422a392cb8760266bed8c68bc', 683363,
        42.71, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v18', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 18,
        115, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v18.mp3', '331a3fb74805102b266281ee57f1313549b2c89cd935cb295fcb23de51d0125a', 583053,
        36.44, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v19', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 19,
        112, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v19.mp3', 'ce4fecded43b3033211cba981f4529b3497a9f2c5ec16fc9904c1d67d901bace', 610220,
        38.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v20', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 20,
        124, 'afro-house cuisine groove', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T4/musique_t4_restaurants_maquis_v20.mp3', '17b7d3b7feb23d5334c936254274de9cf0b44237f317ac00d151109d2a2c2eed', 631954,
        39.5, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v01', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 1,
        92, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v01.mp3', '0273a6fff53919ec64b347a7d60541513bd20678799b491c51a308dcb2ab40f6', 933302,
        58.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v02', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 2,
        79, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v02.mp3', 'f8033ba235e2e22257548df6961c586e11e095433339e6d71b9b975fd756fd6e', 868937,
        54.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v03', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 3,
        81, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v03.mp3', '754eaca79d3911de0068ef70b1791838411a8ecc8517b94ef95370530add41b1', 866429,
        54.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v04', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 4,
        90, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v04.mp3', '812fd6d509356047f8447cd2c5c49287c954cd5a5cfd70217deeceb26a9fe9f0', 949185,
        59.32, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v05', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 5,
        81, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v05.mp3', 'e7fd6678c9a36e46b1cd5ba73131ec390e91f98da15aa96cd6a3ebf6b09bc700', 937900,
        58.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v06', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 6,
        92, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v06.mp3', '35b8b65100b69f7abe8df840eb97003e7b5d0b834bb90f8e03247a84af990028', 925361,
        57.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v07', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 7,
        88, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v07.mp3', 'e21116e795f97bb90007cea7aac56ffe786b366441dbde5795bce3daaa842c58', 956290,
        59.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v08', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 8,
        86, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v08.mp3', 'a5c06b75c7ad1fc40d0109e7e2dc4a78f2a42fb38327f51c44268d2e5688e189', 901120,
        56.32, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v09', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 9,
        92, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v09.mp3', 'b90501ab6e2fc62200091ad9527f61c6c7c26a7d322e9877ac35c4a59e79d481', 863921,
        54.0, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v10', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 10,
        96, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v10.mp3', 'b545fee3a0771cd0939f57caffa29bba10520b266f2600156cee1036ed7b534e', 881475,
        55.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v11', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 11,
        85, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v11.mp3', '6686ca459c20b0eacabaf6291e68e0921a0804d97845b8172bde32e6b5e979c1', 937900,
        58.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v12', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 12,
        78, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v12.mp3', 'a4972c89598d98e6edee6d4b210cf4b5a0ce93b88098b38d5026db2cef61e272', 858070,
        53.63, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v13', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 13,
        94, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v13.mp3', '73cb968efaa2a1632fd3da1eac5fb37774fb59b8d40fa8d7c6fbb37f8bff54a1', 954618,
        59.66, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v14', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 14,
        95, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v14.mp3', '8fc3258942105e3992ea59ad457f2f1ff5ca986d6698b063624841b2b62bb842', 875206,
        54.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v15', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 15,
        83, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v15.mp3', '3727aaf19fe8f9792feec62e67186a48d2b0db1893d239fcaad1e47493cd90e7', 940826,
        58.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v16', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 16,
        96, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v16.mp3', '667625b56682a287c5cec792ee33c7eaa2a45d7bc51487c423eb9155a16cc4e1', 931631,
        58.23, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v17', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 17,
        81, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v17.mp3', '3db52e108faa804de9ecadc142eb59acf149c9bcc6dc1196de76f7ab3ab4e32c', 891089,
        55.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v18', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 18,
        82, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v18.mp3', 'b0e4e6a7b7ab69c48e6f0719bdd485f1800f5bcc51da9b4c4873ae6114131843', 951275,
        59.45, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v19', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 19,
        84, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v19.mp3', '4d1a5b23baa6638d59f1141c9b514e4a902307e84754e297fb733b487e166745', 909061,
        56.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v20', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 20,
        87, 'afro-soul maquis instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/restaurants_maquis/T5/musique_t5_restaurants_maquis_v20.mp3', 'e2ba20bbfe441f4b88fd872566b2c1bde5d1bfa5677b23a53fe0e0558e05a587', 858906,
        53.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v01', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 1,
        103, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v01.mp3', '34008723de029b41e2fad20a190c94c2ef0edca5716134f9e1e8163777634be4', 645329,
        40.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v02', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 2,
        112, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v02.mp3', 'e4f624d96ba380dddb0082e8901bea455026b828fb960427607c8f87cae89da1', 703425,
        43.96, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v03', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 3,
        104, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v03.mp3', 'b1ab5a4f3c4295aebbfa0e6335c67ae74ce9267669053e7bae97f8a5246e9b5a', 644911,
        40.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v04', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 4,
        103, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v04.mp3', 'f8b9e2a2a18c120bfdb3c2221debba7d2dfac980417bed9aba13ea071bb2d9e3', 695484,
        43.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v05', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 5,
        112, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v05.mp3', '4d2db1996ca3b0c834658688a95e34c84f320fb70f7dbdeb8038b028b4cfaa23', 701335,
        43.83, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v06', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 6,
        108, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v06.mp3', '8e8cc2d2fda9e7550a9162cbd6927a7b2459b04ec1208caa3bd3ac3ee4950358', 698409,
        43.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v07', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 7,
        108, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v07.mp3', 'bb8bc88ac884d6728b2638eade99a3909985f70abcb2459f570f73d7b4a2a77c', 622341,
        38.9, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v08', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 8,
        106, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v08.mp3', '0bbec66c656335e55e496b30125474fb59ca1a3c097b3b41520139f858882508', 651180,
        40.7, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v09', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 9,
        111, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v09.mp3', 'fef68a02510984fa9cb1af93346ca4e56c79e2b2c069b87d9b6533128cad3e89', 683781,
        42.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v10', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 10,
        114, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v10.mp3', '3b6ef65590506267e4dff6abd1952c611615fadae1518b5b5cbe0495dd49f900', 710530,
        44.41, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v11', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 11,
        109, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v11.mp3', '40f4206dd059c4760920ee60bc25e92f0de116041ed1dbec60b0a2518242d833', 712620,
        44.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v12', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 12,
        102, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v12.mp3', '53687012c974348745cf654ddff1bda8d386cd1dc802ec28373de14d49781a6e', 645746,
        40.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v13', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 13,
        110, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v13.mp3', '0acf0bf1707035c88984a2795b61392be266e141ef10e298a03ef6faa09d5030', 648672,
        40.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v14', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 14,
        110, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v14.mp3', '3b60aaa162d03f7cb5e5645a264b413cabcda743d3bacbbc007dc268e47fad7b', 680019,
        42.5, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v15', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 15,
        104, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v15.mp3', '365f12c481f8253379a9461f9610f2834e8dacb824b5f58f0a4952b56487054b', 688796,
        43.05, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v16', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 16,
        106, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v16.mp3', 'cee3b7dd3a8a284e25b0533eb07cfd92b02cffc8516d84c25ce7bf3b8d1e4241', 639895,
        39.99, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v17', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 17,
        112, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v17.mp3', 'd6ece6d0a21c8b67604042b24893e8e3e9283176aca2ccc13fd6b0f74c87c0dd', 632790,
        39.55, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v18', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 18,
        111, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v18.mp3', '1b5a090659b99a95f2c0e5d5566c692d63973d6deffebbff5394114fc0e9ebd1', 626520,
        39.16, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v19', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 19,
        104, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v19.mp3', '30bdc0d4241af481c3c1265340f2663281f44a494b00b6a35baeb363dc86326a', 614817,
        38.43, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v20', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 20,
        106, 'afrobeats commercial instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T1/musique_t1_shops_small_business_v20.mp3', '4f4128b65ab679bd0137df55d699d4ebac8d07016198ef6939350253b2185ee9', 672914,
        42.06, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v01', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 1,
        105, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v01.mp3', 'f45e9eee1d146ff760fa9780fc9b12a6e6b207d72aafe63750817e79a56ec3a9', 630282,
        39.39, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v02', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 2,
        109, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v02.mp3', '7f92bb2df4a43ea4fd87110d5d4b34a27f478b2615ce95c0a89676a5b61b1481', 716382,
        44.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v03', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 3,
        99, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v03.mp3', '5a8b08cb3a423dce26bb87fdd413729a3bda6a372cd980c365f16aac73c25461', 709694,
        44.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v04', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 4,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v04.mp3', 'aeba2854564719f65359e927edb836e5be6b04e41b70ac3e493093c2093768fc', 620251,
        38.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v05', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 5,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v05.mp3', 'f90deb4cef72b83334f5ca98ce2e4ee7738efa3d9e569769037c7e903debd661', 705515,
        44.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v06', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 6,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v06.mp3', 'ad65da88eb7027ba9d010cdc981728ce8ed21e47ec21fa05158ee8195a97d1b0', 716800,
        44.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v07', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 7,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v07.mp3', '3824f93324018c6910758353e828e9f4a6a1067c15a08bafe0c9830bf46c40c0', 615235,
        38.45, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v08', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 8,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v08.mp3', '8262ed614685fccf39df4bd47de2147b4929e632b6ce9d68137801a05c9c936c', 690050,
        43.13, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v09', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 9,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v09.mp3', 'd23344a520809671f4b92948a06655e7c30f1212946834b424dcf595954787a0', 660793,
        41.3, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v10', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 10,
        109, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v10.mp3', 'b4566bc98f04f7802a6ba74ae1c08b0b6086bd168f8708d9d2094ef084ea94b7', 679183,
        42.45, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v11', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 11,
        100, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v11.mp3', '8c423eb6ea403df07865647b7e6f7418a16d64c577c95056ec9b12c37e4eb4b8', 655360,
        40.96, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v12', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 12,
        97, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v12.mp3', '0991cf4598fe82e36492c674c5f539857b2f9b7ab83994a8a784e5a05c34bbc7', 649508,
        40.59, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v13', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 13,
        107, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v13.mp3', '6b334ebd69b41cb0b22890ecd3c33f900f821993a97e3c41c43bcdd3ee0ebe0b', 619833,
        38.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v14', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 14,
        106, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v14.mp3', '0f8e7353f6507449d9bbe3d2d8447aa352398f957ac0916cfd930a08b85e9ed1', 702589,
        43.91, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v15', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 15,
        106, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v15.mp3', '07ae15863fbc390faa3d05b8c6fafe6fbc83eac6adfad646458ab3047398d7e3', 688796,
        43.05, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v16', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 16,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v16.mp3', '96e25886913ed60933826d7ef373200f0fb2b5925b02de959b6b4efec0e92d79', 662883,
        41.43, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v17', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 17,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v17.mp3', '1bb83cb8b1bf7480aa11820337c71cda6b7e9185f698e3dc0b02ef3b423a19f7', 631954,
        39.5, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v18', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 18,
        109, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v18.mp3', '731a88653d67e398246cc34676c2165fe340e637280e305112eb7fb9573d360f', 648672,
        40.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v19', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 19,
        110, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v19.mp3', 'ab9def208eeb7f295fd793ed0efff5780f8689e417b21debc6d0bf5daf75fd41', 720979,
        45.06, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v20', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 20,
        107, 'coupé-décalé instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T2/musique_t2_shops_small_business_v20.mp3', '9da240b9d0a167ac54415e3bd205476d71a1af8d54572836d70a34bfcf047074', 617743,
        38.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v01', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 1,
        99, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v01.mp3', 'e4b85797b2c637f61c6bfc81d943bda65d35e57e31066f88805378c5d082fa61', 737280,
        46.08, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v02', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 2,
        105, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v02.mp3', 'f731cb658155362d438408b37b261275cc3bf1e8883f66b2f99865f18cd8728a', 735608,
        45.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v03', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 3,
        102, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v03.mp3', '710af3fc0fb198fcf054de80cea8928bf034fbdaf637af195972536a9f059dc3', 779911,
        48.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v04', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 4,
        95, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v04.mp3', 'bcc0d9648d92b162e2645ea1e8596a3d9a59ea82befa1672b60129d506685bb7', 782837,
        48.93, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v05', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 5,
        90, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v05.mp3', '5ddfd316e1b859c087dc555b70ef2a43ee7d5d479def2919813376594a40b78e', 782001,
        48.88, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v06', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 6,
        96, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v06.mp3', 'f1aefd3d770942b16c5b815ffb3c04b9cefd6dca4834642459dfa1fe608cd0c2', 799555,
        49.97, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v07', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 7,
        100, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v07.mp3', 'b99b8b9e6c374ee389868171798c95a8650d178c45e31e8b34bc7f62a8953993', 756088,
        47.26, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v08', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 8,
        92, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v08.mp3', '880287fc1465ff9e8e02d8873033635877966eb1eeeb2459e31b8920902cdcc1', 731846,
        45.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v09', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 9,
        91, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v09.mp3', '32b793d7edfbbc3535065da0570701e96b296c2383d2acdbb242573dc7721c36', 706769,
        44.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v10', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 10,
        97, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v10.mp3', 'd897cde2c001248dcfdbb1ddeba3e273cd22125735ae3638f20cfe589fdee21d', 766119,
        47.88, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v11', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 11,
        104, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v11.mp3', 'af02a89b0d0ab5025885f5d0bbf2bbccb9bc85106afc21c9b684587e6e965609', 759431,
        47.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v12', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 12,
        96, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v12.mp3', 'f58bc77b597ac5e9e8a922c49a4083b2426207f03e7c89329a29f726646c3cec', 802063,
        50.13, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v13', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 13,
        92, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v13.mp3', '219fa795d8460a42a4c11946c814979a720c95b1a7aa9de739591edcf6b0d7bc', 803735,
        50.23, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v14', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 14,
        100, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v14.mp3', '80e11286eb36d83071dadb105e920491be161f22ba607e233d7d15c1e84adbab', 763611,
        47.73, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v15', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 15,
        103, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v15.mp3', '025100f0fdc47e37b61bf1d917019fadfe00a640bbac4a94341a64c76293dfe9', 708440,
        44.28, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v16', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 16,
        91, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v16.mp3', '10476ca8038dec10f36fa73b79585f7145d3de9add2447fd4a1ea172de791642', 716800,
        44.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v17', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 17,
        106, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v17.mp3', 'ca9ada8e6019806d1a67fe1ef75c401ff8ef90de81d6d8df97f14c9634dbb73a', 779493,
        48.72, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v18', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 18,
        101, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v18.mp3', '66e74687a4453819925e683040c4d3fbb2b962fdaa24c06437704be8d2f904ea', 770298,
        48.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v19', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 19,
        106, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v19.mp3', 'd2da2df69b4c1e88682225d29d614f640047e2eff5e27d85976b701144a5e55d', 738115,
        46.13, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v20', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 20,
        97, 'amapiano groove instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T3/musique_t3_shops_small_business_v20.mp3', '7bd0a7d770aa03b26e74a3037f347a95bdf89dc8069d75c70b71c75d29470e2b', 787017,
        49.19, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v01', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 1,
        113, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v01.mp3', '1ad2deeb1dd5f3e03e18db8c1c924cddf2d2f479262f800db510e500ad291805', 585560,
        36.6, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v02', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 2,
        118, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v02.mp3', 'a17e8da35d4f07863a544f2ddb10c01bf27ecdb0ad61f13f2f0b3eb119771655', 618161,
        38.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v03', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 3,
        122, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v03.mp3', '39aaa19bc747c905645c099af9204801afc4eed6d5ab949c71a5344d66eacd86', 647836,
        40.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v04', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 4,
        120, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v04.mp3', 'a7bf33e963c0b5940252425dba58d691447927abd1f720411ded39b949aa5981', 648254,
        40.52, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v05', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 5,
        114, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v05.mp3', '0d36b7653f1b65ca6e974212ad7da3b7da19d579f269f33b25770b7d54feedc5', 604369,
        37.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v06', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 6,
        113, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v06.mp3', '699198c97c9dec0a1d03368eb0e09a59dac531e38c58edb7c2598b93bf0f5cd9', 592666,
        37.04, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v07', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 7,
        118, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v07.mp3', '6c0c97c58c653f804c2e591f8aeda104482761a61865fc7c04658cae59742ddf', 662883,
        41.43, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v08', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 8,
        127, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v08.mp3', '93feb2bc97650fc888f2c2d3e103ee955885e8d1fdbac7fc52053dee58c3e2d7', 621087,
        38.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v09', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 9,
        124, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v09.mp3', 'eba8906028c546e4c5c76fc06ba80473c13a0e59c63729e28b212c62c2e32665', 684617,
        42.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v10', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 10,
        120, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v10.mp3', 'c9e62d50bf0108922b1570910806688f98b048c3970433e1f3643cfa5246a545', 637387,
        39.84, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v11', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 11,
        126, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v11.mp3', '7ad4056751cb028dacad9ed69a9b66d7e68b96aa942d18ce0b438fd027fe06bf', 680437,
        42.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v12', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 12,
        112, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v12.mp3', 'c76a7a8b420759fad59903d4f74cdb6fad26c86594900e01e125784b16764116', 625684,
        39.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v13', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 13,
        113, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v13.mp3', '9451763d2925d82ba663cb8b35d919ee24ca86cbc90c16b563973c9187199e70', 637805,
        39.86, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v14', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 14,
        119, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v14.mp3', '13ebcbe7168adad4c96a50eb623147e6fcf833e8440c11d81a991c39e3ddc756', 652434,
        40.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v15', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 15,
        118, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v15.mp3', 'db0b7284469f0c140612bf7f68af323f4b648eca64f84f0de0757c413f3814f0', 599771,
        37.49, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v16', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 16,
        115, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v16.mp3', '16e3239d96aabc80ffe819d5fc30a6ef52c1a9f3b7f0376c75ff32dc7a57a3f9', 667062,
        41.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v17', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 17,
        124, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v17.mp3', '1f7487958f2023ed1bc9f64f45b3dfc3e5782121d4bf8727eb85e86bd92db9ce', 585978,
        36.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v18', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 18,
        126, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v18.mp3', '66fce5047d213d45a7658940bcf9db4de502e0347bc4a9ac30300556f02340d4', 590994,
        36.94, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v19', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 19,
        115, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v19.mp3', '438cea91645f8c74dfe95f5e9ded5f82192d57bb5177855bd226f577830e05f4', 607712,
        37.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v20', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 20,
        125, 'highlife léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T4/musique_t4_shops_small_business_v20.mp3', '93c90ad61971d22dbab4d69c0053f3d74e81c3ca16d6358fceb5f16d23292f69', 684199,
        42.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v01', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 1,
        91, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v01.mp3', '24d50d8478e5c910dd00f258fa8ecd8885bdcce35379db34d260b5ebbf38ebb7', 900284,
        56.27, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v02', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 2,
        83, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v02.mp3', 'e0c37c4485400feb98ea77c9673e08139b7d0fcd90224eb05afbe10de438f02e', 902791,
        56.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v03', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 3,
        93, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v03.mp3', '1901b8021149db7a2c352e35ab81da63ff60e985bb8c48f347b0edfe656a0295', 930377,
        58.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v04', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 4,
        84, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v04.mp3', '226948c9787a63200c2b678aa8a3dd8628327bccbff03b99d577f2134fc532ca', 929123,
        58.07, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v05', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 5,
        92, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v05.mp3', '006d25ec7a2480b7270e328df02497307927088dd2c31a72142c303019cc53c4', 930795,
        58.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v06', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 6,
        95, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v06.mp3', '0d862230f3cc44272c4b25a9b737a9150afc9a61025e90f19ad07d465b598296', 914494,
        57.16, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v07', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 7,
        90, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v07.mp3', 'ff21cb9af755903a9cba104ddf2fe6fc88bf6cd9e379f2118a2056b9e67bec99', 943751,
        58.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v08', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 8,
        79, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v08.mp3', '7967dbabbed3c4e5f914ec31eef1a428cde7b5d32854efbcc6f8926ecf22d7f0', 906135,
        56.63, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v09', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 9,
        83, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v09.mp3', '5f9dd99eeea692d8f6d927598350382ce5d92b5f558cab31f811afa9cdbc1c1a', 948767,
        59.3, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v10', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 10,
        85, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v10.mp3', '1613a5be5ff8467f98352bce422dfe5a6ebcaec12b080ad5135ea08a52c65eb9', 866847,
        54.18, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v11', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 11,
        82, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v11.mp3', '14441ea190da47e42ecd8a3fcd8f610d32e7f9617f21ce75de97d699385d7caf', 883565,
        55.22, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v12', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 12,
        92, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v12.mp3', '1b6841ef0275bcc33570474130e8c33c005bb7274e770831e8ef966e2d0b81f5', 876460,
        54.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v13', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 13,
        79, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v13.mp3', '8db716a8e967971d9d1a7f2ef50e44ea58f432981687e150b748e314dc8f1e59', 889417,
        55.59, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v14', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 14,
        93, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v14.mp3', '48f4407bb5a2d8b6ae02e69c6522518a90fe12d6fc0e58b4f81033e9e18e8c1e', 885237,
        55.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v15', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 15,
        94, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v15.mp3', '73b852850c43ecd256ca6dc789a75ea9097362215ce38db3c9e9b074071ad7fb', 956290,
        59.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v16', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 16,
        80, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v16.mp3', 'c2dae72977f04840360bbb80b7fb03ea3f9919d6b42b0fcc31bc0e7ba293f7e1', 868101,
        54.26, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v17', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 17,
        86, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v17.mp3', '5079760039a287e42ad7c97d3e46dd225f7ef86874ecbc998b0fdc52d98bb6f1', 905299,
        56.58, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v18', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 18,
        88, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v18.mp3', 'd1d11d0131edcd995ae374fc04baf60decc42c5e9e4373d3c42c5fa6fb05b356', 931213,
        58.2, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v19', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 19,
        81, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v19.mp3', '97a3c4f965a56357107ca421b618bbe9780dcc2046a275d6f384cb274b9b3ca4', 880222,
        55.01, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v20', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 20,
        95, 'afro-house dynamique instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/shops_small_business/T5/musique_t5_shops_small_business_v20.mp3', '6132e76bb4adde009c290a79b501a7193782759e448a1a269b80a91368bf7440', 939990,
        58.75, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v01', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 1,
        110, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v01.mp3', 'e7695fb26b98e7b323f8ceb7bf952a93198cfcd190231e28c16f7e9196e090ea', 687124,
        42.95, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v02', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 2,
        112, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v02.mp3', '7ea45b0a9131a9931fdb351c70da8d52dfb4e8155fd79578ab2e214a65551ec1', 638223,
        39.89, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v03', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 3,
        106, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v03.mp3', '5f5874bca7ba42a1d7c26f7179ace4ccffbd5dcf5a98cc59b2404322b041b2aa', 640313,
        40.02, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v04', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 4,
        111, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v04.mp3', '950880ab7e9bffac4b174db6de14f0731bf365e96f796d1dfb61738dd1c66a74', 631954,
        39.5, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v05', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 5,
        101, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v05.mp3', '2e4a69363e23cf570a866698d8467be0b067de37b64b7d5eb3b45a64ff8c714e', 697991,
        43.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v06', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 6,
        112, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v06.mp3', 'e84a2c9790b1c8aa2e6ee14963e84e57a0836427546ee9ae0da4f12adb35ae30', 666226,
        41.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v07', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 7,
        107, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v07.mp3', '82fc35c8b6666593cb3c92b8cf7aa51ff256fce74c711609dc2d1968f32476ad', 713874,
        44.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v08', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 8,
        109, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v08.mp3', 'c9576400a1b20b205f575f8d6be83dfcee5deb55dff313a1ae2bf832d3ed8f9f', 650344,
        40.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v09', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 9,
        100, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v09.mp3', 'fbc0df1c0575953951ab47816907ba24f3d94fa27a583fa2ed9696e01703babc', 677929,
        42.37, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v10', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 10,
        106, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v10.mp3', 'd7af496be73ba61be0fe0b9781e4ae1c50a092c85581885cc1e786231be21661', 692558,
        43.28, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v11', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 11,
        102, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v11.mp3', '418c12e33323dac98a1c7caa5026c8e54d91ac7749eb20d78d82e2185b61c3e8', 667480,
        41.72, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v12', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 12,
        103, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v12.mp3', '3ea9ba499beed09bcb4ee80334fb4258c8bcbafcd519d10f227c28326019428e', 621087,
        38.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v13', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 13,
        111, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v13.mp3', '56cfa43d1cce04d022c7bba0c75da97dc6e3dcc92175c463a5b20824188a255e', 697991,
        43.62, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v14', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 14,
        105, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v14.mp3', 'd05c3063a345842ac2fb12f346e77534ce4f009d518a82a1bdbdbd15c6c48ef7', 657449,
        41.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v15', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 15,
        105, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v15.mp3', '6e87e4f3dd38f63bbab2bfeaea7b40e242cb2e8cb19117642e09a1adf29c1015', 652852,
        40.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v16', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 16,
        104, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v16.mp3', '74248113e5e810847c324e0ec87e05c405a58b9443b17ff634c1c6f217fdf81a', 692976,
        43.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v17', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 17,
        110, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v17.mp3', '6fbe6417865ebffdd5a33917bb657094dfd5125f826521e3a882d042b8fd9eed', 652852,
        40.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v18', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 18,
        108, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v18.mp3', '53bd9de95dac0a4f19a5e73ce31a9145cdf72456776e88e1c0944ddec22be4aa', 624849,
        39.05, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v19', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 19,
        109, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v19.mp3', '9b2d5bd9e7ecbd0ccfccbf325e8667c7b48af58fa49f363184974b5994604a63', 710112,
        44.38, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v20', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 20,
        105, 'afrobeats élégant instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T1/musique_t1_vetements_mode_v20.mp3', '296d6f6d355a46c93a1a5961cf3ba317a8a0c9625a5d0d0d2a9c97b57e222392', 664555,
        41.53, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v01', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 1,
        94, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v01.mp3', 'b7969679a4abfd8bc3b43cfd52f0c96ace800b6dbb73b2ac13228a4a21871603', 684617,
        42.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v02', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 2,
        106, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v02.mp3', 'a5af667af4f6293c77c53c480a1d2cdf2189c3df0e206a0ca14109be4e657785', 667898,
        41.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v03', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 3,
        102, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v03.mp3', 'be6781887f93ce8e92bc9be64fa45eb0556f2c2cf256317f89589ccde12cb469', 677929,
        42.37, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v04', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 4,
        104, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v04.mp3', 'abfd79a20286cb68bbdba6dae48b17128217aa596c86535e091b62a1f6863033', 617325,
        38.58, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v05', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 5,
        103, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v05.mp3', '9e7d1d71043917ed9c7ec438d28bb08d0c77cb974f418decd8cc39a7911101da', 721815,
        45.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v06', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 6,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v06.mp3', '5284ef6327e23b4cd0d9b919187a95eedf3c8b2fdda650dd88a11ff4d18e8abc', 634462,
        39.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v07', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 7,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v07.mp3', 'e6008c82390c9b7aa00834690525a53700e759b60d9d55200dc2ac3321bb1eba', 624013,
        39.0, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v08', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 8,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v08.mp3', '47cf97a2f1498031e48f31e149eb941292174f16d4d213a57d381ad4d79b2f49', 685871,
        42.87, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v09', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 9,
        102, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v09.mp3', '61c39c1a678430dcbc56fe680151c17ac9126611e5d4e90310dec4d500f4bf52', 614400,
        38.4, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v10', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 10,
        100, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v10.mp3', 'af18e76698e07ffc682bceadb468b41dadb380388b96f64048ab2bfaf72feaf0', 615235,
        38.45, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v11', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 11,
        104, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v11.mp3', 'd9dd8c117a0afa20c4582ac23ffce9e875049126ed5771798a103739dd2f1184', 659957,
        41.25, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v12', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 12,
        107, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v12.mp3', '460b145d8d62a7dbfabd3773809c3da73db840c163b68c8b886154385b0c10c4', 703007,
        43.94, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v13', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 13,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v13.mp3', '7fd6f52bf4792db8c066528b8c49c85b052bdc072fa0d0421d89606ac3e555fc', 709694,
        44.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v14', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 14,
        99, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v14.mp3', 'd7eba2e9a921088fa2ebcf52c54808c08765ef8b22b052813ee560f143c9c56a', 678765,
        42.42, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v15', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 15,
        103, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v15.mp3', '2132c13fa9073d5f86c8b1d835fa02ee44988a2d96fa648625b42798584a1ae3', 700081,
        43.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v16', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 16,
        108, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v16.mp3', '1fcf6923f380bf3ea51c189d561567bc0e7b61c7ef7c5ed1898dc7b9d3376751', 695066,
        43.44, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v17', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 17,
        96, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v17.mp3', 'b70ee22390e210d0eba1f72c07a81dc1f2016772089a70bd178928a9ac09c773', 684199,
        42.76, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v18', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 18,
        101, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v18.mp3', '2d9d16f241decde1aa6b7b6886d43b250905e96da8ec0892a6c8e7a2279b07b6', 721397,
        45.09, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v19', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 19,
        97, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v19.mp3', '8d88af6f54055174259a670bc6e138340e1ea66b7dc4beea5c0cb3e66bf179fe', 648254,
        40.52, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v20', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 20,
        105, 'afro-house runway instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T2/musique_t2_vetements_mode_v20.mp3', '862b0fae75b031eaed38e7eee5b7e8dd642c97e4750861f34c21afeed3514085', 700917,
        43.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v01', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 1,
        102, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v01.mp3', 'f3b7525c6afd8e2f860682b64a4062eda21dbec3057a3d241d186a7f414f5515', 700917,
        43.81, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v02', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 2,
        92, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v02.mp3', 'cefbd13ad8c2d8afdd0e5e5604b19c738d08a1e6bde2a1b8869936349771402b', 709276,
        44.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v03', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 3,
        102, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v03.mp3', 'a7c151f6b0109e529e4d4419e6ca6201d8ef8d754bc02c65008ffdc648b7e731', 703843,
        43.99, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v04', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 4,
        93, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v04.mp3', 'e750bec2eaf1b36e8fd7f31ff477705d15b5807798edb596d9e1f9d5754802bc', 777822,
        48.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v05', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 5,
        99, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v05.mp3', 'e2824d5acc99543c98b47a8c17829d49dea23b092b8e3a3bbe49c627d5d913ef', 720561,
        45.04, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v06', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 6,
        90, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v06.mp3', '27399fc05aadb2405df389dbbd5b4d682d185931db161830a7ddcbbcd7efc8b9', 757342,
        47.33, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v07', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 7,
        104, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v07.mp3', '26c55dae9b23a46abb7fe3b1bbbe83cf82d571660d2504028f5ee2cec492d3a3', 730174,
        45.64, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v08', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 8,
        88, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v08.mp3', '9fc657ecc943fba5e26ce7e7b2b28031d077bd5331294540e282c9d11aade0ee', 748564,
        46.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v09', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 9,
        102, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v09.mp3', '3c62e80f810067fd3aa36647e2d22056806ee4bcae12e72865f6c2fb2389c75a', 801645,
        50.1, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v10', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 10,
        94, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v10.mp3', '34f270b00984f88a23ce8c4a7e5bfd0d9bb3c673f41c3f10cf917b41ee9b14ee', 737697,
        46.11, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v11', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 11,
        97, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v11.mp3', 'c27539c230e95b9c4327e5844691744048b139c9a28191d4c54fe2c27ec3b86e', 709694,
        44.36, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v12', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 12,
        100, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v12.mp3', '5282c39e319af0616cfced05e29e9d4537d14f755a7f3b44e81a249611da2432', 725577,
        45.35, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v13', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 13,
        99, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v13.mp3', 'ab41efbf297401f399b98dcfb3bc11ce4f9e337d54addefba0b01f849e77a54a', 728920,
        45.56, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v14', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 14,
        88, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v14.mp3', '4dba9040cded20ccfd998fd994af091011509e7d301dc734f9ea192781fc4c32', 739369,
        46.21, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v15', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 15,
        90, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v15.mp3', 'dccc42c3274250587b32056eb9f70720896f5eb06b1daf89d412fcc9ce36a5bd', 731846,
        45.74, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v16', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 16,
        95, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v16.mp3', 'af6c81410843b0229ad2e825a245b067bbea14f739b572889f986e621da6455d', 797048,
        49.82, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v17', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 17,
        103, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v17.mp3', '521220f81869cb4ce59636761e8fa9a991f0f9eee1ec89af487623f42a88e79c', 771552,
        48.22, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v18', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 18,
        96, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v18.mp3', '83cb8eaae32c18ca703a674e73676d5826ac5e7371cf3b22ba02c74e11d48ff4', 781583,
        48.85, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v19', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 19,
        94, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v19.mp3', '76de9a2362d0d1a668852d6a11301b56f4482ecd42aa4f3aadba609ffc1c6b21', 780329,
        48.77, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v20', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 20,
        91, 'highlife moderne instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T3/musique_t3_vetements_mode_v20.mp3', '638feecc30984322820b8c7431971eeefc521f3b64fd267c21a48d22299c0590', 777822,
        48.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v01', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 1,
        112, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v01.mp3', 'fa4f2b944d3bbd2d43885aa660f45db1b02d422523776284f43afddbc64ee12e', 687960,
        43.0, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v02', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 2,
        119, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v02.mp3', '1173dfc1a4e178df976ed128a364fa0c500c9dcbc0799839d9cb482b17384f01', 600607,
        37.54, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v03', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 3,
        121, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v03.mp3', '08bc4d2081b399ef9b90ccf78e417aa6624098c8c8c1db0be36206a448b8e916', 583471,
        36.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v04', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 4,
        114, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v04.mp3', 'ff788cab54b3a3e9eb994099eda65988fbae36903ad25aa3797c9da28ec735fd', 610220,
        38.14, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v05', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 5,
        115, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v05.mp3', '291671ff0821b25e348b45c99aa460d910fb9020e7000b3a4a470e4052aa3d2b', 688796,
        43.05, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v06', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 6,
        116, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v06.mp3', '9ffedb75e6942ccc6dee065b3bfd12d76938eeae1c03b8722090feb8d37da891', 667062,
        41.69, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v07', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 7,
        120, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v07.mp3', '954d0822a5edace16e8383a113b921dc07c5abce2ba1112cd1a31e559601055f', 583471,
        36.47, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v08', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 8,
        110, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v08.mp3', '5b84573a918dcd59d73968666c27805a439f93e590f77649a0b6aa99dac18cab', 672914,
        42.06, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v09', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 9,
        110, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v09.mp3', '8725f1b6a42c1b27263ecba19d2d24e3314a1971241600e92922361860b90c89', 620669,
        38.79, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v10', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 10,
        120, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v10.mp3', '74a2121bdc9a9185d000a0e9495a35f54a77d1b44685b9a2d324f5f853886f87', 671242,
        41.95, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v11', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 11,
        117, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v11.mp3', 'a36ed6585d5469872ec3f20cece0bd022e788c2ea80ab69b211d54bd78172c7c', 606040,
        37.88, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v12', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 12,
        112, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v12.mp3', '8425635f6d7eb4936b2c9ab98fcfaa56c92f0c8391cb83e8f431819fa492bafa', 617743,
        38.61, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v13', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 13,
        126, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v13.mp3', '15ac72f2ac35e2b0029d55ae267813ca58a8c75327c863d4dc983134c9847bfe', 596427,
        37.28, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v14', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 14,
        117, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v14.mp3', 'e7e1947178d37058d8df0f7c5f402c6b5094aac49da061580fc32b7e200770eb', 627774,
        39.24, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v15', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 15,
        111, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v15.mp3', 'a7d9eecb097306f366a40b44a55b512bc349d722a7f42378d13011b962a903f9', 682945,
        42.68, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v16', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 16,
        122, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v16.mp3', '7c425a8611561ed12209ffce0a4e1801fc1b0c63c299280645b977a2e19954b0', 658703,
        41.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v17', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 17,
        118, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v17.mp3', 'b09380f1e209b6af4439e9065e66e75eb60f51ba396156ef6b9932eed6624385', 626102,
        39.13, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v18', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 18,
        126, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v18.mp3', '7250b1b7956517804fe5d6f5a49a1427f25b5da5c4d9f0e4485a73682ee470d9', 629446,
        39.34, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v19', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 19,
        116, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v19.mp3', '81d95919e3f475f948580066dd567666806106714bfbf4bee5b5730438d3d5ad', 608130,
        38.01, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v20', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 20,
        125, 'afro-soul doux instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T4/musique_t4_vetements_mode_v20.mp3', 'c3c838923e51b8fdd5adf2d773d09f50ce4f93f8a89d6827f84f0b863ed3f27c', 687960,
        43.0, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v01', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 1,
        82, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v01.mp3', 'e430ec0fb114cddabdb6898250aaa1a76f26fb97389adb4872a10a722905871e', 862667,
        53.92, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v02', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 2,
        89, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v02.mp3', '39f6fdd030b77999617a2c336ae15b67441abef4a5b6360e096054f5aa6c488b', 881893,
        55.12, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v03', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 3,
        88, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v03.mp3', '1734c9f830fa02250205b65c4f84dd973399f7912d30d9fd0cbf87befd1b2ddb', 910733,
        56.92, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v04', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 4,
        79, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v04.mp3', '076a6b69b9d4a48c8dc7017a790c6a3fe81bc0734b5916b9b19f4c09d85a218b', 894850,
        55.93, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v05', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 5,
        76, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v05.mp3', '569d9dac968056f0a1d5f5a28668c7f699163c261111f6a909ae801aa215b1da', 943751,
        58.98, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v06', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 6,
        82, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v06.mp3', '9b381127afd5d58029877dd6b1bc1c2fb23c3484f95f6ad4993ecca91e82e21e', 906135,
        56.63, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v07', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 7,
        91, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v07.mp3', '083e9a4c9b1eebf96f29e24f2ddfe66ed64c75cda677355d5fba8b3f9d87abe9', 874370,
        54.65, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v08', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 8,
        86, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v08.mp3', 'c8b59dfabfe6b53d09dc6b3d871ae2d60fc878316a3bc819e5deb58b70ffba09', 892760,
        55.8, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v09', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 9,
        92, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v09.mp3', '5aba1bdba74cf45ea9824b965f059fed7fa3684aa089a5c8895ca9ecf002da82', 876460,
        54.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v10', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 10,
        90, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v10.mp3', 'be1b500eb69c955845fb3a236f9c0f543e1e5a93e70148eaa4eb47aeaddeea7c', 924525,
        57.78, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v11', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 11,
        89, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v11.mp3', 'fa94cbcd16a99ac130a989e1521bfc773614efdcab24141af8e9e76995795d0b', 917002,
        57.31, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v12', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 12,
        94, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v12.mp3', '64d62709b19b27e51c79f4e7fbbc7b9ade49468d72385bdaa5c86e1402abc82c', 923689,
        57.73, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v13', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 13,
        90, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v13.mp3', '085ae7fb5564fb204f067d1fc2c92cccae08429b95be74e1f937f581ea18439b', 914494,
        57.16, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v14', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 14,
        86, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v14.mp3', '4dc5813cd656edb026c8aa243503ee6fb60ba6d71854737505e36dec954d1af0', 930377,
        58.15, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v15', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 15,
        78, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v15.mp3', '51c318b3a0f59c5777a4ce951044f4e324ecc5286911f7c82a77368182004b9d', 863503,
        53.97, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v16', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 16,
        82, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v16.mp3', '8b2587b8e972dbe62d7418b311d45ddc45c2e0b9bc25e462cc37dde76fb01c1c', 946677,
        59.17, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v17', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 17,
        80, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v17.mp3', 'c0d17e3c5587feeb42eec8c15edc0d4a85b59c1100b9c9614ba7fb96edee6254', 891506,
        55.72, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v18', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 18,
        89, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v18.mp3', '7ecdd2a7d5477efe37ff7ad7744dccf018200b8c07375669afdef19e0808550c', 961306,
        60.08, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v19', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 19,
        86, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v19.mp3', 'bb5fe7bba64b9246c0d3fa5687347f8732b29291e945562583116144ee56f837', 887327,
        55.46, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v20', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 20,
        84, 'amapiano léger instrumental', 'synthese_procedurale_v2', 'CC0-1.0',
        'audio/bgm/vetements_mode/T5/musique_t5_vetements_mode_v20.mp3', 'fdfd50448d41aa743b288fbda17d7bf21fd0355573263b37125b28e7b93b2e71', 883147,
        55.2, '4268779a8c85657ce256d6b1b7c8cd8a04cff9b41714652803bbb44350bfb270', 'EN_LIGNE', '2026-11-01T13:30:21.000Z');
