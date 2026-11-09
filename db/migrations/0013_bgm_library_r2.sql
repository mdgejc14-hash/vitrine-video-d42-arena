-- 0013 : correction du silence initial (D42.28 P1).
-- Nouvelles clés audio/bgm_r2/** — les originaux audio/bgm/** restent
-- en B2 (jamais écrasés, règle fondateur). sha256 = octets téléversés.
-- Mesures avant/après et journal complet : artefact du workflow
-- audio-fix-silence + scripts/audio/bgm_r2_manifest.json (commité).

INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v01', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 1,
        107, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v01.mp3', 'd643019de79d89e2f68e942669449c96a8129287e88a8f3304df8653bbe8be43', 606501,
        37.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v02', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 2,
        101, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v02.mp3', 'bcfceb00362332ad2822575b26953b765e8c51be3206f9062005d6e503a752df', 586021,
        36.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v03', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 3,
        109, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v03.mp3', 'fe195892b698ed42c4158fd1f610f3294b3ed0df2aad7f6be8fcb0ef859673ad', 599396,
        37.4, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v04', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 4,
        108, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v04.mp3', 'e0fee5ab839d8cc21fa6ed607ded8a243f80b7954b1ad277be1f478bffe93b0d', 649969,
        40.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v05', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 5,
        106, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v05.mp3', '9af9835e7ff31354d94e316866828e5faf742e70330b3cc9cec7be2eb602ee39', 652059,
        40.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v06', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 6,
        110, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v06.mp3', '1c5bb735a5205ebb975d4669e127091b7d684c46c4128d163baad7d09363f81b', 598978,
        37.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v07', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 7,
        105, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v07.mp3', '24fce21aa064bad6dfded8309cc61ca45aa4d9cc58b5f5a1d6b5fb2345c10930', 658746,
        41.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v08', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 8,
        103, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v08.mp3', '03bdf8c4deaccb0d213562f00b2dbd0d01c98d9eb1a6be0733925f4f88648c0a', 690929,
        43.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v09', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 9,
        108, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v09.mp3', 'ed5fc8596d3eaa05c5c8899d1e5e69a856c6c1111e94f9c4e5019c9b8a5cbdac', 660000,
        41.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v10', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 10,
        100, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v10.mp3', '256e5a79c97f648c868a5bf3da6fbe3ecd4a1778eeda00bc7725bbdfa3265c1a', 677136,
        42.26, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v11', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 11,
        100, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v11.mp3', 'c6543e9339279f7bc9999f11a40a4dc33fe2b742414aae3fcce86afa8d0bdaaa', 675047,
        42.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v12', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 12,
        107, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v12.mp3', '0149ca3898ecd93d65b7b4d57867c91c1edc58cf37145f93e8dd4fb9c291a79e', 648715,
        40.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v13', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 13,
        104, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v13.mp3', '64bf8b15070ea6a7005c1ad611193da438fc0b6317ae6208b8170aa770191836', 683824,
        42.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v14', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 14,
        108, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v14.mp3', '616a1c92f9d9e1f44fe3df94141b7a32e3ae96d584caab8d732d6087f630f0ea', 693019,
        43.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v15', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 15,
        106, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v15.mp3', '5b78ba6edd815199f31e5055d82d485876d68eac2d58d842e92207e9e644c5be', 624056,
        38.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v16', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 16,
        103, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v16.mp3', '16f33eb474efe60f320c65f34b6b02da9c00e0b7aab826aa2de2b5179a0b335e', 660000,
        41.18, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v17', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 17,
        110, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v17.mp3', '8fea0ed9c0c673defae811ada7a75d6b82eb4bb4a28c61a0f260f8090266523b', 667941,
        41.67, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v18', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 18,
        107, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v18.mp3', '8b0081baca100ae8cd576d868945b0245e10ce66fe28855e1677cc44b0fc38dc', 627817,
        39.16, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v19', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 19,
        100, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v19.mp3', '43a2272e9eb2e6972107fb5d18e14aa778da1365dbc41d7764f87f1375433b7f', 629071,
        39.24, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_batiment_travaux_v20', 'musique_t1_batiment_travaux', 'batiment_travaux_T1',
        'batiment_travaux', 'T1', 20,
        101, 'afro-house percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T1/musique_t1_batiment_travaux_v20.mp3', 'c2fa26061a6d1622356eb780791f62f461d245aa83fefeba0cc3d03b4bb90bfa', 639102,
        39.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v01', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 1,
        100, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v01.mp3', 'cd74c428e98f34c10b190663b20120e8628d6aaac8548bae626c0b9f684c4392', 654985,
        40.87, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v02', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 2,
        98, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v02.mp3', 'fbb3ff99afa4eed749e23d67c8b83f4562e812771daffd5b8359bd9dd73094cb', 677136,
        42.26, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v03', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 3,
        104, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v03.mp3', '12c7f28dfc9e22d8567063a1bc0d0292771c67e4002196d837b1d59e5c53704f', 656656,
        40.96, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v04', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 4,
        101, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v04.mp3', 'd85b092b2eb37793454f4e70a03b88eb438904299aab648efd4d4d3c813a21c4', 633669,
        39.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v05', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 5,
        103, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v05.mp3', 'b55dc6f9f0eb484730daf2789119673dfaff465b18a8a4f125cdcd9c24dfa3b6', 592291,
        36.95, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v06', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 6,
        108, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v06.mp3', '0504eda6ded5ca30ccceedf5f254741ba79220da90fda322d62819e469f37ab4', 673793,
        42.04, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v07', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 7,
        105, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v07.mp3', '9aa83007fe9c680b61d63f99e158f3fa3c73d67a2ac4c9c875d571dfcb0858fb', 646625,
        40.34, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v08', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 8,
        102, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v08.mp3', 'f122f72b9e0ac0d9403c9c691677353219632820481f8755fe42c64cb45d1f3a', 600232,
        37.44, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v09', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 9,
        95, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v09.mp3', 'ea9f52755f43a04385a6d01124595851db23c5512c05f401228a70e92999d737', 618622,
        38.59, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v10', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 10,
        107, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v10.mp3', 'a469ae2ec4f91705279e5397850a34379a4d1ef32bf16d3d0d1b56d34bb71d68', 672121,
        41.95, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v11', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 11,
        106, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v11.mp3', 'c3081e51e7a9d19111b93fd9b8239f72cbce4497f5b342cb940a2f68f1ed65ae', 587275,
        36.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v12', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 12,
        100, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v12.mp3', 'de3d538bc541d590bc9c2b139c20be00262d18d86fe14f90c51ed9b61c39b994', 596470,
        37.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v13', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 13,
        95, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v13.mp3', '2f5546568f3e4141c96c61fb6bfeac2f22f21f08cf6a7189f19e9eb4042028fd', 647879,
        40.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v14', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 14,
        107, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v14.mp3', 'ddcc4c97279701fe5389953e27e458e0ea0ca4bc21648f9d65889887b5ac4b0e', 647461,
        40.4, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v15', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 15,
        101, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v15.mp3', '7f6d681405d31cbf3149d5edd783818800ebbc6df861a0cc61c8656037b084e6', 636176,
        39.69, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v16', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 16,
        94, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v16.mp3', '5b4957ad7ed0e623f7094a47afc33f65a65d6e8539e03fa2f3a055faaf68cc95', 599396,
        37.38, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v17', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 17,
        94, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v17.mp3', '4d61c31151bbeda46e2305b2607ee4fe792f471d4b3dc265781c72e71b8cbabd', 598978,
        37.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v18', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 18,
        98, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v18.mp3', '45affb3de8987c1d0be0e659996ee381091e43a52ebd96cf43615606cc447d5c', 611099,
        38.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v19', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 19,
        104, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v19.mp3', '5d9eeb2495971dd87bb0cf84c872a33150dbf328497fbdcf82b7d1fbabe90d35', 683824,
        42.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_batiment_travaux_v20', 'musique_t2_batiment_travaux', 'batiment_travaux_T2',
        'batiment_travaux', 'T2', 20,
        99, 'afrobeats chantier instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T2/musique_t2_batiment_travaux_v20.mp3', '4f3b9fbdfc53225bcb911e3dbd21fa1fa103f5fa5ee4cee5e4f58154b4958e18', 684242,
        42.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v01', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 1,
        104, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v01.mp3', '11ca8b5fd6fd2bb008350ac83b2a0ce70ecae6d00065653456a09b59a972c20b', 741920,
        46.3, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v02', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 2,
        92, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v02.mp3', 'c7cc49f3938a39ed8a82b167a2edb08e8ea746f05b6c8b725ee9abac0204a6d8', 658746,
        41.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v03', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 3,
        91, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v03.mp3', '29b85f2a41ffdc88019fbb6f3eb9f7988336b528da54e8f784e90d6cacaa46f3', 731053,
        45.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v04', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 4,
        90, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v04.mp3', 'e4c92eb5a0bc4cb353d2e7e5da03d677ff32299bf2e0c249f1892cafa22cf5c4', 655821,
        40.92, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v05', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 5,
        93, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v05.mp3', '271502abbe0e444125796eab5771d96e95e1fc464bb4b708864a05d859d0bf98', 692183,
        43.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v06', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 6,
        98, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v06.mp3', 'bc1a26c710351590dd72429bcbe4c92bbefa23c317a27253429c83143277f95d', 659164,
        41.13, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v07', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 7,
        97, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v07.mp3', 'f79e0ac09de50f20a472206cd8e5070cd792b12eef65fca17b8ae2dd5528a78c', 686750,
        42.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v08', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 8,
        88, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v08.mp3', '5fef825b746c877cf0a175140fa32e31a771380bddf6538c2a1a9d0b1b777afd', 765326,
        47.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v09', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 9,
        98, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v09.mp3', '323bcbad6ec6f607c3fe9fd1212e82d9e5bfd42c60879eb2f8a97f9cd82b704d', 765326,
        47.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v10', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 10,
        97, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v10.mp3', '07b7534b0547310d57f6a3d129bd3ced6fa630e79b7fea0b3d211ad39d1ce0ba', 680062,
        42.45, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v11', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 11,
        103, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v11.mp3', 'b1d0cf9a3c678b2498b5a0ba25fe720b5cc4149f1fa6615b00ca2f43a9bcc878', 694273,
        43.32, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v12', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 12,
        101, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v12.mp3', '885c9518fb710fc7a1192a94460f21722d1de9c35eb2f5dec6a0a4af22aab461', 702214,
        43.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v13', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 13,
        94, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v13.mp3', 'a797fae4535e55b59a6793f04b8ad22ab370cbfbe9af3cf864ebda4c80f02c24', 721858,
        45.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v14', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 14,
        98, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v14.mp3', '22bff88cbaa3c478693b3df16f86ff66cb1fe8b709dab90ea2ed36f20a63e970', 675883,
        42.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v15', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 15,
        100, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v15.mp3', '2079ad3b2760597f2b574173b6fa1590390350725b285678c7b1083011b60a94', 740666,
        46.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v16', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 16,
        96, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v16.mp3', '8cfb2747a6dc922d6477847654d388cc1181b8819c1253882a16c8b202de056b', 731053,
        45.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v17', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 17,
        104, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v17.mp3', 'f6bf6d20db5d57b7e382a6323a41e5207fab3733dff99d19400133fe7a9c2fa4', 702632,
        43.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v18', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 18,
        88, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v18.mp3', '7ec93e79e333f57a538cdba877af94631aafc3dc41b055867db1ad448ddf73e5', 675883,
        42.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v19', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 19,
        100, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v19.mp3', 'bb71a9a3633a88c3ecff585321cd8c5b802b0172defc0fe532fef44ab837be63', 729381,
        45.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_batiment_travaux_v20', 'musique_t3_batiment_travaux', 'batiment_travaux_T3',
        'batiment_travaux', 'T3', 20,
        94, 'percussions afro industrielles', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T3/musique_t3_batiment_travaux_v20.mp3', '5e3afae481ff8d1f70c15358cfc67f9d49ccbc5907f8d7f7eda04037fea2c6b0', 742756,
        46.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v01', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 1,
        117, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v01.mp3', '1de11233d5661558d4aaa65b261b79eb0725f12ec7b01c32558a5613d8a75dd2', 623638,
        38.9, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v02', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 2,
        125, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v02.mp3', 'f5f401734a7d06af24957f865554a1698413dd629fc5b090d77219464aac8932', 570975,
        35.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v03', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 3,
        116, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v03.mp3', '25918eff61a115f030ad2733656081f9765b8f87fdcda257666a84918666b5d2', 662090,
        41.3, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v04', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 4,
        124, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v04.mp3', '09c2eff27fbab8c0feb4204d82eb3188e496569eb804f9d8dca784ee832e3b5e', 630325,
        39.32, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v05', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 5,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v05.mp3', 'd686770f24e67d718ad4b7337e67da254be22b8b7582e148e8aebd9e579a2794', 558018,
        34.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v06', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 6,
        124, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v06.mp3', 'e506da008801ee860b2c07e779e63a2b1d3201cb07d34ad636750f6d0460ae1e', 589783,
        36.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v07', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 7,
        120, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v07.mp3', 'fb2e5552a752aa25848d33dc67a3c4f3221b21cf6aca9141cf513f7ee11cff35', 607755,
        37.92, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v08', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 8,
        126, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v08.mp3', 'a21629cc473c222facef0a88529d7f6dfb373cc6dc9df2ff97a63e2540293298', 571393,
        35.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v09', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 9,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v09.mp3', '534651e7f5adc2b9d54a95cc093b149953d225f9c67980ea7b1843fd73b22152', 595634,
        37.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v10', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 10,
        110, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v10.mp3', 'a339cfe90d7dd86df81ef36fb0f5458d25848a4b30511c7c735d362e0eea634d', 650805,
        40.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v11', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 11,
        124, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v11.mp3', 'c389469171d182cf82c27bb7a844548b5ff1f116729439cb6ec2db1ee41ef8f1', 569721,
        35.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v12', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 12,
        118, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v12.mp3', 'f6458a5256fa7d7241459652ae46c53c854d382a59eb8544dfde4e9b2667fa6d', 595634,
        37.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v13', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 13,
        111, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v13.mp3', '20689e37c6eccb8ed34a6781811c803f52a1b10b9fb684713d9ba5dbb90bd81a', 663762,
        41.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v14', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 14,
        115, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v14.mp3', '9f72da2e9468fe82613799f9bb70975694f0519b407eba6544df907132c4a1bf', 657910,
        41.04, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v15', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 15,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v15.mp3', '5f34c2c972bbeeb2dbc0de05bd205933aba9d65abccde37360ae30abfcd672e6', 605247,
        37.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v16', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 16,
        114, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v16.mp3', '26ace3a18a07ad2618e7fe529d7717aa812812e1282c3b089a9e5444f7f1554c', 573901,
        35.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v17', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 17,
        121, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v17.mp3', '48ddd8a4945ba5c2d451feef2f4fe0068a3746c4c45a4457efdbed5fb8f85bb6', 663344,
        41.38, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v18', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 18,
        121, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v18.mp3', 'a64cc544343c13709131cb46990d19e4e67f9efa8ce98f01b3a9ab2c27366531', 649551,
        40.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v19', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 19,
        110, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v19.mp3', '2506a382f08496095e26c80b75967c4ab628897a3bc194910801cd841ab08ea6', 618622,
        38.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_batiment_travaux_v20', 'musique_t4_batiment_travaux', 'batiment_travaux_T4',
        'batiment_travaux', 'T4', 20,
        117, 'highlife énergique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T4/musique_t4_batiment_travaux_v20.mp3', '979ca6d90d5324f36abab642a30b6076cbcb0e01fdf985d5952894b875061823', 591873,
        36.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v01', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 1,
        79, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v01.mp3', '8c8e080d75afb9491ddaece48e373655b52fbf7bc87f850e0c1c16a33b4e671f', 875249,
        54.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v02', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 2,
        81, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v02.mp3', 'bd71216dcb3e838f9de6483773cd081b50e016bf55e1143d22c67d7c6d028dc1', 912865,
        57.0, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v03', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 3,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v03.mp3', '54532908d1c9bc4dcc43bfaff8e6c4b6e61362226e13edf9fca389370359965b', 846828,
        52.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v04', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 4,
        80, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v04.mp3', '4fdcbec094e37861c7d26d5cb1e1436056a08f6d50940c544a81385574242d6c', 866472,
        54.08, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v05', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 5,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v05.mp3', 'c5e25414a74926c7d4cd25f727ea91ddec350a2192ca8242f5cc6002c62ca4d3', 818407,
        51.08, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v06', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 6,
        90, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v06.mp3', 'e3731367fcdc14b8c42592fe87c4d8e39280aa8469cb418e196492caf1cd02bc', 867308,
        54.13, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v07', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 7,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v07.mp3', 'ffa18cd9567cd7b827c6b385ab8f8f581dab0ce4a9e9512f896dc6b342c10adc', 829274,
        51.75, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v08', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 8,
        87, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v08.mp3', '2899e30c120c33a36ec6baa83dbbe63f23b49274078c8a01bc48545e583d861d', 823004,
        51.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v09', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 9,
        79, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v09.mp3', '494ec5ba551d1f657a75e1a22a6619add27ff8cc545e16dedc8ad2aaa2001809', 809630,
        50.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v10', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 10,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v10.mp3', '7d3c850d74c975e5c7e4ce01a5772f29e769bf8006803d01e1c38637b80ec61e', 909104,
        56.74, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v11', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 11,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v11.mp3', 'eacdf48730175f6916323c9aeea437705b1110d8b1f5d938a843f0cc85068a74', 876921,
        54.73, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v12', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 12,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v12.mp3', '9ea7973b03cd9918c28226f15001c6aa16aa1922320981cc42b2581b8cfa78c6', 866472,
        54.09, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v13', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 13,
        80, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v13.mp3', 'f4bb6afc9079c22e0181c5d9d2483571a9f4fbdfb83cd55eab732f21606d007c', 823840,
        51.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v14', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 14,
        88, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v14.mp3', '514159f204f8a23861f3b45b74db44934d7fdf29f33f58dc63d87e52a77eaa30', 899073,
        56.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v15', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 15,
        88, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v15.mp3', 'b4127d3ea9b2d868d5a460207c3d84de6d186a7d1cb3a3f6c4ce3a941d52bdf4', 813809,
        50.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v16', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 16,
        87, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v16.mp3', '4e1b7d4253b4f7a27d3e807d446ea4f99e55a1911aeab48279a1489a9d1b9222', 845574,
        52.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v17', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 17,
        90, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v17.mp3', '8f09d351ee66ee284a11c52ceb1fa05e708fd2d85c307b97633542acd583c300', 923314,
        57.64, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v18', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 18,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v18.mp3', '57441feb4bec6b8b2b028b8003a643fe9b2dbfba38d4957c0b1421bb4a6b90a6', 841394,
        52.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v19', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 19,
        84, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v19.mp3', '476c2a0da418fa070fc5b4b90632630455b05635b32523213bd4e5bcd50f3563', 875249,
        54.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_batiment_travaux_v20', 'musique_t5_batiment_travaux', 'batiment_travaux_T5',
        'batiment_travaux', 'T5', 20,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/batiment_travaux/T5/musique_t5_batiment_travaux_v20.mp3', '6de964599385acaec5f548976693c8b352b4b17868771b7e2f4bee7df0faf1b7', 907014,
        56.63, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v01', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 1,
        110, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v01.mp3', 'a448dbd979d5b0264926d012e1eb572dd5cd7dfa9178c8cfbce940c712717c65', 685496,
        42.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v02', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 2,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v02.mp3', 'd8c4427396d3ce86d1762a8ea9a5df25b792aa1ca0ff5671906250a439acf671', 654567,
        40.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v03', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 3,
        110, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v03.mp3', '23ddf0bbc435b2b0ea548a52f46d9da137ed9859051f6817911fb2a270d10c16', 586021,
        36.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v04', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 4,
        105, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v04.mp3', '9d26874f33d3e78cf2630224edda59c99af5501aba05a60d32ba29922c7db570', 661672,
        41.28, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v05', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 5,
        107, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v05.mp3', '9739ca13bb08ac019faff9eae658192cda1e3debc90bb58eb07866ef7eca73a7', 583514,
        36.41, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v06', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 6,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v06.mp3', '49db94c2c7375c786ff6fc60deaf6c8f28abae0d993293d9660535c241f69ea1', 652477,
        40.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v07', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 7,
        108, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v07.mp3', 'f40fb4be1994bc09927a748863b41435d56e863487eac6b011b08fb582a4f3dc', 641192,
        40.0, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v08', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 8,
        106, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v08.mp3', '42e1b3866bd42d5484f86df50625931979a66acab28b438a74f51d44dd2ede56', 648297,
        40.46, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v09', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 9,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v09.mp3', 'd5bc07b856a8b599435f4ef2e6a3d2a8b20e0dbf220100a8eeffe29fbe26faac', 634087,
        39.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v10', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 10,
        102, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v10.mp3', '3769db5fdf1f70c33bd511bc3661257f01c40882c4fc9961c6068f766e72af9e', 591873,
        36.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v11', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 11,
        111, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v11.mp3', 'e1304988dfdad5396aa9211419806fc0cfc176481bbb2bffd03a02cf31923914', 689675,
        43.04, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v12', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 12,
        108, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v12.mp3', 'b29d03a358b29e4fb5a3457b6880738cdc668744b5fff2ae1f804f67275d0e88', 633251,
        39.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v13', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 13,
        112, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v13.mp3', '3cde99f073028cc1d6fca5460bcdd4a6d7f2f2aaca46b2c7d321236d97e4c0fa', 672539,
        41.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v14', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 14,
        106, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v14.mp3', 'b7cc83ef1b2a995c398a963032ad9d205a6142a976dd9a45b254b5b73a809cb2', 653313,
        40.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v15', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 15,
        104, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v15.mp3', '714a8ab2dd797edbed106975b6c931a9a083fee0adcf891fc3023252f568ffd1', 685496,
        42.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v16', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 16,
        103, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v16.mp3', 'bb2c937f642d11f5a9b8fb229a4d4fe10faa5e7717f75b7bb5bc071a20d8eff8', 618204,
        38.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v17', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 17,
        106, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v17.mp3', '47e48184a369ed06578f8121732df7f6adf70edd2a9b6ce8d4721dbc95149fe4', 671703,
        41.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v18', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 18,
        109, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v18.mp3', '3bcf071d4ae5e17c241b15cbadc7e548f8a76fb7d9c64dd0d6cc72a5b0c2a366', 586021,
        36.55, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v19', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 19,
        101, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v19.mp3', '57ba30ed25d1e4aff5dfd6f58e8bca0143c6b6613f82a1575ec68b93b8da7a7a', 660418,
        41.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_coiffure_beaute_v20', 'musique_t1_coiffure_beaute', 'coiffure_beaute_T1',
        'coiffure_beaute', 'T1', 20,
        109, 'afro-R&B doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T1/musique_t1_coiffure_beaute_v20.mp3', '17b80b42bf4d0878d1d5c64f9d8fdbde36a93568f382d5b64077cebfe2d353a3', 678808,
        42.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v01', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 1,
        103, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v01.mp3', '060b7fba9b3e1aa77804e4a2835b967a3fd4be3f57b0bcf690ee39b4ecb30374', 652059,
        40.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v02', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 2,
        102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v02.mp3', '992447c74aae9bd733d5f58523f359f95a20935178734316881d1d790f72c81c', 643700,
        40.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v03', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 3,
        98, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v03.mp3', '7ec4c903e31fcbfc807078f6519e492780b2648279ff2b4b089ef822cdfb8b6d', 647879,
        40.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v04', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 4,
        101, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v04.mp3', '9431d22b344353e9d0e6ffd7e3204538b6fae86b204f3a68c3aa44b648b3dea6', 643700,
        40.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v05', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 5,
        97, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v05.mp3', 'c27d22c9c6179bf1e949d3bd79e2eefaacc0776e9987b3954356e115ba9fea69', 666270,
        41.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v06', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 6,
        109, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v06.mp3', 'b8989554659f638744ca9c2472665c0a2bc5b424b68e2f5fbe02a4331b2ff887', 651223,
        40.63, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v07', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 7,
        107, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v07.mp3', '5e4a7467c788dd8c9333d25c3cee625e8f3cfe3d5a749b8439c1bd78ff734861', 642864,
        40.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v08', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 8,
        106, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v08.mp3', 'e50372884e0012cbe878e1408f8cf24d53192c7fdcc1c34363bcaab839b5a12f', 662926,
        41.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v09', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 9,
        99, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v09.mp3', '3677abb9797ed7abfc2cf396a17529040bee155ab3c41cc3bf977734cb1a2db9', 677554,
        42.29, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v10', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 10,
        100, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v10.mp3', 'ad6054dfbef6a72f9e6652cb71c00429994820ce47615bce69c7df8f5494d41b', 684242,
        42.69, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v11', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 11,
        104, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v11.mp3', '427bffdc18840c166e2d9052cfb342182ecf1acf577dbbda0b2f2c2cda11c3a6', 676718,
        42.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v12', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 12,
        101, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v12.mp3', 'c06ab1da051d5eff59c4ef66c8cf1067fc9d421dd9546abb6ac312a1bf068ad7', 596052,
        37.19, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v13', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 13,
        96, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v13.mp3', 'e710d40e69c5e5422009509e4345e9b3b48a548aaed3775910c559db75c932cd', 658328,
        41.08, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v14', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 14,
        102, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v14.mp3', 'db28facb494106fb2b736e9d6ef6b27fe32fc243f513550bd907a67719297986', 660836,
        41.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v15', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 15,
        104, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v15.mp3', '590f3e46cc66f69125b4c9fb69cf47f36bed60caa0d570f23709900ab897d8d8', 602740,
        37.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v16', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 16,
        108, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v16.mp3', '372fe02dc87c3548e04238e77696ccd46bb6cce0391a3108db6c19828a5f8f32', 648715,
        40.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v17', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 17,
        108, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v17.mp3', '140e50218469929c22fa9905885b8f3d572dc7a9e1515755c1fad5cba1dd0220', 661254,
        41.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v18', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 18,
        108, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v18.mp3', '91600b83a9b244fddca5aa26dcee3f9796316c7c03e640bb9a149a2d3e8ba2ae', 658746,
        41.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v19', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 19,
        106, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v19.mp3', 'f6ffcc1469cdda28cbc63f768ec50cdf06d7649d666750997992bed2c9ce62d3', 605665,
        37.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_coiffure_beaute_v20', 'musique_t2_coiffure_beaute', 'coiffure_beaute_T2',
        'coiffure_beaute', 'T2', 20,
        103, 'afrobeats lumineux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T2/musique_t2_coiffure_beaute_v20.mp3', '46050dda7b37eb7ea2cd20c30a0a40e035fa61f0165ab85100e635b9a3f3e182', 596470,
        37.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v01', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 1,
        103, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v01.mp3', '9ca2ab9c29cc3f91c937e34a2d53b32b0077936e4ad81b036bab55d6af971859', 677972,
        42.3, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v02', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 2,
        97, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v02.mp3', '69d9554c652ce650dfae8b6c1629a3576c26ded8570d1cf44f9d388691105467', 756549,
        47.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v03', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 3,
        104, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v03.mp3', '9db217c9d75b38566c67b554138fcafb57f7715ce830def53093ad3c776af722', 733561,
        45.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v04', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 4,
        89, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v04.mp3', '36cb078ddc71f3611c64603a2d15ab995b45a22b0860094f6248597070ea2320', 655821,
        40.92, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v05', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 5,
        96, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v05.mp3', '751ad42fff1dbf6b93792794b855b19f68ce73f15494cdb13e41cfeaf757f9d0', 752787,
        46.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v06', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 6,
        99, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v06.mp3', '8d0a95b8a64382105e76dc3f55b671dbdc13f14990cf5b73b84c69a56150dcad', 740666,
        46.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v07', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 7,
        99, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v07.mp3', '5a0f54d050d9e1603b7d6154be089ffa54779f883e12ab82c3f1c96dc18d29f5', 668359,
        41.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v08', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 8,
        94, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v08.mp3', 'eafe0487f7078b79325c3e3103fabdd4daa8e1edcf439bb23e5313ae5348c7f4', 676301,
        42.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v09', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 9,
        90, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v09.mp3', 'e3f01245cda43add05ef669c6af58039dd7b1f9ba9c94989f511a0fef7a94237', 670449,
        41.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v10', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 10,
        102, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v10.mp3', '5330f4e93e54077ed04d286d158bfa88687051031ddaa9c268f53017f6895e76', 747772,
        46.67, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v11', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 11,
        91, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v11.mp3', '1762445421a2cca86eba8480daab2c2eed3e74ec42638a6ec516860b1209977a', 755295,
        47.14, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v12', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 12,
        89, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v12.mp3', 'b99b71609297e37888264b4e3da09c55c07043f3d466c7683f8b6efac87e5302', 673793,
        42.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v13', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 13,
        92, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v13.mp3', '771a4a3c9a4af19171887a54fed3dc1bc5fab2683925fca1406349db4efed864', 759892,
        47.41, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v14', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 14,
        96, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v14.mp3', 'c58feb3b6fdcd3df929cab0d2ce7f96e286ab45d4dfeee60a35cb8285ab7d87b', 662090,
        41.31, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v15', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 15,
        93, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v15.mp3', '244fdfa7cdd331d74e96811f92dfb867489f869ca0e7034ac08cd5ba7355ed0f', 723948,
        45.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v16', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 16,
        90, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v16.mp3', '1b2964c39edcbc1cf14d146c4a1d7517cd31841a328f55500da857b818c3e352', 670031,
        41.82, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v17', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 17,
        98, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v17.mp3', '7696b8bc122a3c392d215480b6c198a71062c39e860c859d37f34526b3a37eca', 664598,
        41.46, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v18', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 18,
        92, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v18.mp3', 'a5a179d1d326a10b0ef41ee85f1e7c01f76c1d02941905b5e8aa33cd1208c93b', 733143,
        45.75, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v19', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 19,
        98, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v19.mp3', '55fd72057e6b9c27eb30549f3052bd705966334a5a357ca5c0e4f04a1e978476', 734397,
        45.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_coiffure_beaute_v20', 'musique_t3_coiffure_beaute', 'coiffure_beaute_T3',
        'coiffure_beaute', 'T3', 20,
        101, 'afro-house minimal instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T3/musique_t3_coiffure_beaute_v20.mp3', 'fa1f6c8f23ad2bf34c8c97150949f0e16a9783b45dce057380fd93f5d5d39e8b', 667523,
        41.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v01', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 1,
        114, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v01.mp3', '453dee77f2b3babdb93f56eb887fb569e2d02f2e6b0ff47ef4a50ede4b2d63f3', 614861,
        38.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v02', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 2,
        125, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v02.mp3', 'b1fdb603ce5dec512dffd6eb7a8b22c61a78907786411573f8195d4d0fbf48d5', 650805,
        40.6, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v03', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 3,
        122, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v03.mp3', '350ae4abccb7a83d24b19a27ec9bd04368fd5b5c8155b74e3c6ca223db93fb10', 641192,
        40.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v04', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 4,
        120, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v04.mp3', '3e2b99253f089f4a894ce8bc65685566167532f8277a36b18af688450d1812fa', 649969,
        40.55, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v05', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 5,
        124, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v05.mp3', 'a65dbe4cb8baaf877df682114766905bcba4d31953855661adf4503249d84d04', 642446,
        40.09, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v06', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 6,
        121, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v06.mp3', '897748fb3be9a5a01d9120ce493af73fb42ab96afbc4a86684a1728a08e5bfd4', 565123,
        35.26, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v07', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 7,
        125, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v07.mp3', '2995fb21267e789fec52a9d9267d99cef41cfbc5375189de89784e0bb40288a3', 622384,
        38.82, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v08', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 8,
        124, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v08.mp3', 'e34ed2185526f25fcb4f5971586919c36ef40595d403dfc5406fe206c18288bf', 660000,
        41.19, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v09', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 9,
        112, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v09.mp3', '8296dd80d84a0715226e5ee5672690aa3c2a3620f31198e2ae067d2bcd200d61', 630743,
        39.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v10', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 10,
        125, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v10.mp3', 'ab6ab1a000c6b0fa440d81dbbe0f3a2f237ab0700f0482daf872b3bd2920d5d4', 566795,
        35.35, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v11', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 11,
        114, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v11.mp3', '2906126e96d434ac7d5b07a7bab40435788682242e48b972fea142d49e30cd45', 591873,
        36.92, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v12', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 12,
        118, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v12.mp3', 'b929ae072cb75f6ad1f45f008f50833c1eff5838ac58d48191e80a22f98dab58', 622384,
        38.82, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v13', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 13,
        115, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v13.mp3', '3a0dfae26bb0d9f365f5db1e323e25945fa654eb64117de43197280bb2521e5a', 648715,
        40.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v14', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 14,
        118, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v14.mp3', 'bcf5d4dc2c9e39a23eb370b7cab5be57f5e95244e0e743efc55ea2debb05871a', 594798,
        37.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v15', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 15,
        119, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v15.mp3', 'ae9280d14d6ace34d92cc7d7aaa6fd3a3ae21747c2be2e05391213a2f8ef5044', 556346,
        34.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v16', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 16,
        122, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v16.mp3', '80c2e9b898a74054aeb7470ea6e2a40df1c32800115658641e0640a31d8a7c02', 635341,
        39.64, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v17', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 17,
        112, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v17.mp3', '8b7c935f0532252013757442ee413d077894c02a4cce6b3f26b480459718b2d5', 613189,
        38.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v18', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 18,
        116, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v18.mp3', '70e12ebfddd52dfe45559e1c1f94c04329a9cf5f0faaa64215b9f694f431c37d', 650387,
        40.59, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v19', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 19,
        112, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v19.mp3', 'cb95d57bc5e821387678feb769bf517cf08737887557aa8fe3c77bf5816d3e6e', 605665,
        37.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_coiffure_beaute_v20', 'musique_t4_coiffure_beaute', 'coiffure_beaute_T4',
        'coiffure_beaute', 'T4', 20,
        121, 'highlife doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T4/musique_t4_coiffure_beaute_v20.mp3', 'd839a96831157583c33d72c104bbab7bee2ba941b9cba7936762c00cde5ae092', 634087,
        39.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v01', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 1,
        80, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v01.mp3', 'c521d72d55c43f25f067597f5449d9b8c2d04ee1bceadd64356d5338ac136f3a', 880683,
        54.99, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v02', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 2,
        80, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v02.mp3', '98488457b5e12cc5c109b423f81460b14223ece3210a59b7fbdc5ea39155305e', 864382,
        53.96, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v03', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 3,
        78, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v03.mp3', '081875c148c87871d4302124f13d89f51474755aeb64cba0547ee0624cf168c5', 893221,
        55.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v04', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 4,
        94, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v04.mp3', 'e7bfea2c72dea0a503cbf4b0f4765ff73482f8198a25c074d0a739e2977479db', 837633,
        52.28, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v05', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 5,
        84, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v05.mp3', '9ca228c67c80e4fb2c2c0e9c26d11c5fe0b7fae95a09208b6b940e705288a6f4', 879011,
        54.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v06', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 6,
        78, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v06.mp3', 'fcfc55f44297fa50d4b74ae74e408cb335bf14453fe8328a3b3da77ee1a28d4a', 845992,
        52.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v07', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 7,
        82, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v07.mp3', 'd139e9913cdb274fb24557aa9d6069c10c5f18e4e324ddaec1d52019882d0f0c', 825930,
        51.54, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v08', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 8,
        80, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v08.mp3', '52a2a53773b6e2283166ee5d4680cd4ef6eb79ad3221199966f032ba5c06dab9', 861456,
        53.76, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v09', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 9,
        91, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v09.mp3', 'e41cf0ab70a3c2f316a4f3129119fad8ee8c6af2c643164cffafdfa169f6e396', 919971,
        57.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v10', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 10,
        82, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v10.mp3', 'd38d98bae20716014250bf13373a8fb49073930ff42f11cabaa8abdf406f9a0b', 837633,
        52.29, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v11', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 11,
        84, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v11.mp3', '807f319bcbc181c67f0bb808c5e61e455a5ca873298d95e14b41c12701be76db', 899491,
        56.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v12', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 12,
        90, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v12.mp3', 'd84f9f996e416d3059bb2ed83f5550a172b5aaf2b64af44cecefca629aa807a8', 830527,
        51.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v13', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 13,
        86, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v13.mp3', '63aedd5a4cb28403f23924c40f02f1bbe41e144cde865998d0883bf25ed4f356', 895311,
        55.88, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v14', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 14,
        95, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v14.mp3', '455dbdd7039dcb25c3b32ded2d1157af7506a4a770b59f0621f2f96033c35844', 923732,
        57.67, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v15', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 15,
        94, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v15.mp3', 'b359493cd2217e5bc085050f0d0c9442e33ace7ff928cb82c340042938e4e09a', 919135,
        57.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v16', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 16,
        79, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v16.mp3', '52cca41661da34dbc4fd4f9415cbc2731da28c58e6f993834f5df766e86f55cb', 880683,
        54.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v17', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 17,
        90, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v17.mp3', 'd0f04eb18059047a0a178839dd0b0b1f877a9b0b2c18a7854fcf7e4cb520498f', 863546,
        53.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v18', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 18,
        78, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v18.mp3', '3cc796659f747b883b5abc8daae49969d33f4770cd1911f7b529fa77f33a5f5a', 830527,
        51.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v19', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 19,
        87, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v19.mp3', '7be76075d2b4ebce54381be018b9c641659db6dcd260e5e19677ce2828de9e4a', 850590,
        53.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_coiffure_beaute_v20', 'musique_t5_coiffure_beaute', 'coiffure_beaute_T5',
        'coiffure_beaute', 'T5', 20,
        93, 'percussions afro feutrées', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/coiffure_beaute/T5/musique_t5_coiffure_beaute_v20.mp3', 'cc6d5f132a70d82dd5ef5962cb624068b8484f6dfb72b0eed17a1fdcf2f97d10', 908686,
        56.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v01', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 1,
        108, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v01.mp3', '62c9677ce944baa2d5a955557dde97c64e7a05707ce1844c09eb8217729b89ba', 690929,
        43.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v02', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 2,
        112, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v02.mp3', '43b3d2818d31d469c401148af66ae1f078535e57f9a92192691970c04758799f', 636594,
        39.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v03', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 3,
        102, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v03.mp3', '76ceac74cc6305b0e0362ef361490e6f41d43700c1297846262bad8ade2826cf', 687585,
        42.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v04', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 4,
        105, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v04.mp3', 'acde3a7bcc3d879c53975de325d16afa3ce4a0f5a9f1c3b2e0418a3f8ba2d9ac', 650387,
        40.58, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v05', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 5,
        112, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v05.mp3', '88fca32f3ecd1ba8659b548fa97bedf7d99be7fe77c5690e2a1324da3a63c5e5', 690093,
        43.07, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v06', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 6,
        109, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v06.mp3', 'e6595995a4186b77b77ab07d939b1c897b8d45b8829c452d3aa688976f07eace', 662926,
        41.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v07', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 7,
        113, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v07.mp3', 'cb16bff0b20690a7653a182e79106ac5f9a192c2d52da917fe3a2129f9f24664', 614025,
        38.3, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v08', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 8,
        104, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v08.mp3', '2b06cd3b5752a4e1ff49239f8b1b89baae20688aa6b39eee9c13e6e03dce18b7', 591873,
        36.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v09', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 9,
        104, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v09.mp3', 'a40c29990dc5db5b7348d5e1b54e319296b24d324b7b381abf77d738d5ba8b39', 631161,
        39.38, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v10', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 10,
        106, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v10.mp3', 'f5e871ea145dbdc75f0baeb2f44d0be4b85124e783e86e9dacae81b4f9616c90', 676301,
        42.19, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v11', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 11,
        102, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v11.mp3', '8743cc89b96b8fde129af3e4a702900743f5f84a29ba29c8628d5ce14a2d8abc', 594798,
        37.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v12', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 12,
        102, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v12.mp3', 'b55568a10253ba81f074206c2ce6394906cb8ad8df4eb518a4f3c154ed83ddb1', 631997,
        39.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v13', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 13,
        112, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v13.mp3', '7760c0f8a90cbf3ddbb078eb51fab0a975e74e3144b3c2597f2a162c275fddaf', 627817,
        39.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v14', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 14,
        103, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v14.mp3', 'ab443bde45f541ebc45af734258eac2e472862863b4ce677674c33082ae24c68', 689675,
        43.03, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v15', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 15,
        104, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v15.mp3', '160345231efe16aa936065fb1491adfa275e9f56b5d4ae19e0a116a9739d0e17', 608591,
        37.98, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v16', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 16,
        106, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v16.mp3', 'f70f57960b301032be8c6b7ea08406395843ae4d584797bc0e9c4df69189f4d9', 608591,
        37.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v17', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 17,
        110, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v17.mp3', '5b60a028a14e59b310d22b90dc58da4cc9d4904369ef501faedc8750dab44eef', 654149,
        40.81, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v18', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 18,
        106, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v18.mp3', 'd5ca5943e1731bd615563022093c0df6acbb3d46f3319cde9a64dfe4b0fe58f5', 639520,
        39.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v19', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 19,
        101, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v19.mp3', '1ccf2e39daf2fdaed95fa3d2dc82b208ac91fcd13a75132eaae1fedcff560c49', 675883,
        42.18, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_immo_auto_v20', 'musique_t1_immo_auto', 'immo_auto_T1',
        'immo_auto', 'T1', 20,
        103, 'afro-house premium instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T1/musique_t1_immo_auto_v20.mp3', 'd45e8abbb352565cd23257ef8b835aec2b3968071ea2db332b14e1b3086f414c', 644954,
        40.24, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v01', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 1,
        104, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v01.mp3', '8f5e144e8375f858a0e581f2644eb420efe330fde76506fcf3510dc0a27efde2', 690511,
        43.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v02', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 2,
        103, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v02.mp3', '4892e91f5bb25d5cdfce4630f2b31b23b16e3b14145f7dcacbb0eb0fe2ac7b69', 579752,
        36.16, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v03', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 3,
        96, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v03.mp3', 'ac1677f26a04db035eb1f8535d2e5f5dd16edd0fd500632b32d5df6fa7578341', 680480,
        42.46, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v04', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 4,
        107, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v04.mp3', '30a4f9208bb43abcad000228cbda870d8fcea89940df1af45d41f80a104160e2', 681734,
        42.55, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v05', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 5,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v05.mp3', '0ce3a67cdff775504b3822485f45f858e6e36e5afe751a92718c430b613bcc0f', 589783,
        36.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v06', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 6,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v06.mp3', '6b4bb1f7c756294132a32b0811edeb57a1ab519b5eb4b7e9d175b06601932d0f', 615278,
        38.38, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v07', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 7,
        97, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v07.mp3', '32a3e35e753d6caa6cbf322c23e0041a436edaeb5914fb1f8f152c0d80cd8e3b', 660418,
        41.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v08', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 8,
        98, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v08.mp3', '3be6d7eb88d3d6c23cec22ce392ccb821f8e29301dc60e9272b6b02608930d40', 602740,
        37.59, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v09', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 9,
        104, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v09.mp3', 'a410e69f04785a1ade4b1840c4f5952a7bba304ffde039345810fb18b65c6191', 679644,
        42.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v10', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 10,
        102, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v10.mp3', '94ba13119f4c37775a2d282dff9f9c6b167bc7aaa0e9393e1a0f6a121b2ae035', 648715,
        40.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v11', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 11,
        99, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v11.mp3', 'bcbccadb39dbb8b9e150c8caf6fdbd37694190e85cd065db134da5c8a3ca0766', 634087,
        39.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v12', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 12,
        106, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v12.mp3', '443ec32f99df57bcf5a4308e070c779d088c7ef87b054e26e629f801356089d7', 652477,
        40.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v13', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 13,
        104, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v13.mp3', '414950545aecfc570e05d59fcfd9e959cccd0daefc58acf8a628ac7667a3f5f9', 609009,
        37.98, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v14', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 14,
        96, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v14.mp3', '13048bb16925df73a93a6c15e13150326a32d8d169387caec0cced7c690cc173', 657074,
        40.99, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v15', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 15,
        96, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v15.mp3', '6805ca75c5b3c164d7984871da91951b3aac71d1c099b0ac041d36245a133d55', 598978,
        37.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v16', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 16,
        102, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v16.mp3', 'f6c5dbc0a3755889cbd9b47f74f09c79a6d306b0c3e9284ef8bfdb9a30a50aec', 663344,
        41.4, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v17', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 17,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v17.mp3', 'c2fa6c1f212377f928fb5182917da92ba6d832bfdfe19d10c773c44c1f95ed3b', 621548,
        38.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v18', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 18,
        106, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v18.mp3', 'a0469c026fb6b6e972df84bd894e4dbf07f10fe35127ed92d20597737a72b7c0', 601486,
        37.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v19', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 19,
        108, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v19.mp3', '7526b4231d607163567f25f630e0dc7670ba1c44a96033f79ce48be5e9770a3a', 647461,
        40.4, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_immo_auto_v20', 'musique_t2_immo_auto', 'immo_auto_T2',
        'immo_auto', 'T2', 20,
        106, 'afrobeats sobre instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T2/musique_t2_immo_auto_v20.mp3', 'cbd18d183942808fd4e78a04a3ddb760977168d42b8a9e4d8107d9f7ee5cbf02', 680898,
        42.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v01', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 1,
        92, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v01.mp3', '258fc59fb203c4a95bad7fb1f6cbe92d119dfe4249214ce4929c6a125d532433', 766162,
        47.81, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v02', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 2,
        104, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v02.mp3', 'f1aaca090e9615c20c4790d95d31d8fb1d63cb0d4f3eb43f30813e4298513091', 736487,
        45.96, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v03', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 3,
        97, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v03.mp3', 'd4b52a10a681882fa932dcbfbc0b961f646b52300d6e04043e10dec2d0d6f4ba', 711827,
        44.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v04', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 4,
        100, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v04.mp3', 'e4910750183e40048b0d36694fe724c09b272c603a41fe3b289c280a9a3a4b96', 662926,
        41.35, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v05', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 5,
        104, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v05.mp3', 'a47572893afabdc6e93057e7d5d29849afeb0de495f22809f6de630a88ebde89', 691347,
        43.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v06', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 6,
        93, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v06.mp3', 'ae13782edb8991c8f418b19525061d3b218ee011c9754ed5b9ff399fe4fba1d4', 689257,
        43.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v07', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 7,
        91, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v07.mp3', 'bca6351a0219064c16ef64a9c06a3dd6d5a7c7e8894000f3196157e1946fa3fe', 710573,
        44.33, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v08', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 8,
        105, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v08.mp3', 'e0af03c8ca20a169d14e53b1273fce06aaf8ec9e837e6ba64b24c8221674dfea', 707647,
        44.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v09', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 9,
        89, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v09.mp3', 'c923314fa440480620684e3047e002e9fecde63526ee74e687292093c817a90c', 655403,
        40.9, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v10', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 10,
        100, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v10.mp3', 'd3c83bbc47d1f6371f50323f63a74ca9468ae4cd1c341ec70a6d86219d31d741', 743592,
        46.41, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v11', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 11,
        96, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v11.mp3', 'f5295afcf8d9f154d7c1aaa0de48a8406a3857d6487fd6dc924ccaf161c0fc59', 736487,
        45.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v12', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 12,
        102, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v12.mp3', '5e5a945a7bbe1ce986d00ee2edb27fbb180138dae846ae3f1933df13b68b1fe8', 756131,
        47.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v13', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 13,
        94, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v13.mp3', 'f3457222ef84aad8d593676e2505906374afc0da8361559b961a0b48cbb06ed7', 715171,
        44.63, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v14', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 14,
        92, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v14.mp3', 'fcd35d867e83d6b84bbfcffb6e94cbe4bb04de22af865dbb5860d1e20010b2d4', 682152,
        42.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v15', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 15,
        101, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v15.mp3', '875614bc7bd2f436356d58eea62fe08ca2e43f66addd3106af8ec5f65bbdf291', 762818,
        47.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v16', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 16,
        104, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v16.mp3', 'af95d848d1d3e921b8e63c6a7c0b2af6e45043e1c382ec571a3b9be8b139871e', 770759,
        48.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v17', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 17,
        94, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v17.mp3', '636184bc543aa4621aab0dcd1b9a65c82ebce62371f419d442594031599667b8', 664180,
        41.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v18', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 18,
        99, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v18.mp3', '5880f658e171b5749926f72ac3a40b52f6e446d60e65b05a66b2382208cda4c8', 724784,
        45.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v19', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 19,
        98, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v19.mp3', '03cd7eade6c9096f4c9b6b929be0f06cacf9f929bcecdf25673980bb9e6b8198', 682152,
        42.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_immo_auto_v20', 'musique_t3_immo_auto', 'immo_auto_T3',
        'immo_auto', 'T3', 20,
        96, 'amapiano instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T3/musique_t3_immo_auto_v20.mp3', 'da7516a7e7e9003b02f1bdfee731afc29c18abaa6e8109d65684f87f531f20e9', 693019,
        43.23, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v01', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 1,
        115, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v01.mp3', 'a9587ab3a32dbf96bf6027b023ab84324ae07453793abd17bd2a8b4dfb76eb73', 659164,
        41.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v02', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 2,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v02.mp3', '8571d6883e3226cd0645d1bfc9683526d8dfd99e990b117f0d043d27b369574e', 676301,
        42.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v03', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 3,
        126, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v03.mp3', '3c3fd9dc9ba02c3bb0f2b161fdf5dfea3e5efbf69f63f8e86cac263f48a7a1e8', 594798,
        37.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v04', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 4,
        114, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v04.mp3', '437b3001ca315027df644e8fc01f02499041dccb9e0b8daddfd92d336294aad9', 586439,
        36.58, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v05', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 5,
        126, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v05.mp3', 'd83a7b0e89830b7d934b64670131baae15c597e4dfbb28fa1e3f8c5d762be166', 580170,
        36.2, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v06', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 6,
        117, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v06.mp3', 'ca5e0f38432438ca64ae9e5f16a27881c6da381ae8c25d52ff751b73f2008962', 577244,
        36.02, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v07', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 7,
        120, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v07.mp3', '8cc38018cea7860b1f4dd0d27475caeef6f76935b9941264b958b0b7d18af1c2', 637848,
        39.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v08', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 8,
        122, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v08.mp3', 'd32bc3101572a96ed001e9286f26bd803e4ed9cbd16d5a7725b6eadf7ad58ea3', 635758,
        39.67, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v09', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 9,
        123, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v09.mp3', 'd8a1d343a014039388fd6b5c1515bd61a4c075d1398edc98a7ce578028793e26', 623220,
        38.88, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v10', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 10,
        115, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v10.mp3', 'a08662a748c03691d49f1710053c1541f037acd4c2b24b0d38e250f097b7d2d7', 614025,
        38.3, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v11', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 11,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v11.mp3', '2e7cfae35d3004034a606c3a034d1d2d802d4c8e929213fd199e40c5f5721965', 642028,
        40.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v12', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 12,
        127, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v12.mp3', '74f66433c2f3e248bcf4bd8f9794fa22bd8def5b66dc3e597b7cd02775a211a2', 637012,
        39.74, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v13', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 13,
        120, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v13.mp3', '9bccaa22146867cc3d75b1dfd343a60c47af5d7f6271ce5a4b532dee8aee7b55', 662926,
        41.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v14', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 14,
        124, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v14.mp3', 'bf2f3ba926f99728e83b19dbdc62155676f1892309cd3cb56beea74e2efde33a', 637430,
        39.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v15', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 15,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v15.mp3', '40daf6db469413723fe86e6f15db1064bad0c9ca7ea37e4531616e6498fdb167', 654985,
        40.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v16', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 16,
        116, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v16.mp3', '06c6097fbae8e5cfb3d1a1b2a7d6925b0ec9926c6ae17425f070eba356d5a1b5', 575572,
        35.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v17', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 17,
        111, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v17.mp3', 'c6d64794ee1bb0fec467f4ab9a9f03ac443a41d0808f548dad6eb266e1ef0cd4', 649969,
        40.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v18', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 18,
        117, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v18.mp3', '1d5567aa6bcac591cac0b5feffa16efa81824fec005442ae933fa1e4da527c72', 588947,
        36.73, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v19', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 19,
        124, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v19.mp3', 'c80651bc2a13637553233696b30d4d5740b943bdfa9183b1f311c64db4f9b0ba', 573483,
        35.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_immo_auto_v20', 'musique_t4_immo_auto', 'immo_auto_T4',
        'immo_auto', 'T4', 20,
        123, 'highlife calme instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T4/musique_t4_immo_auto_v20.mp3', '869002e3d3fe35c41dd6d6dcf9987f080613b36a81d11b22737bf7d76e7716c5', 600232,
        37.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v01', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 1,
        90, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v01.mp3', '9394237fad59fafbaedc8faf8cc4d3bd9dfcb5884e7b8c80a355c4d655e0f469', 884444,
        55.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v02', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 2,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v02.mp3', '63bc6cde95ccf08c5a2c043289f19afc0bb619f37c601d03b36cb828065a3d24', 898655,
        56.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v03', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 3,
        95, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v03.mp3', 'b5ea51a50189acc77d54b3bb79102512fbb930b14f177f5b477ce4b635985669', 840558,
        52.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v04', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 4,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v04.mp3', '0cfb057c69a256a4ec12a4d244b2c31efddf552fd8108ff3abc737a31f1b17c9', 859367,
        53.64, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v05', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 5,
        94, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v05.mp3', 'da381e62bae41af0930db2998cf9ac0cbd1cc1a2b49822b76d4cbc45f731ccb9', 851425,
        53.16, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v06', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 6,
        83, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v06.mp3', 'b929c0929e47efcffc9bf441cbce59e495754d6618881007d317ec26c63662ce', 844320,
        52.69, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v07', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 7,
        86, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v07.mp3', '338fc0538bc03acfc0f8d865f9498379201eb505368887a5b89b83110afd94c2', 866472,
        54.08, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v08', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 8,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v08.mp3', '395601153c79ece02493463dd8b9eddb652e2f98801edae8f1e68040e07cefc8', 822586,
        51.34, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v09', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 9,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v09.mp3', 'ac3ccaa75b4e515fba9cfe6396857db55a29dbefbbf6f41ee8fd9e5d932f2111', 863964,
        53.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v10', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 10,
        95, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v10.mp3', 'cb29d1bfbe51147681edb23a5a8f4fa4c2dee011d5f49a817a49c7a1de3155ec', 889460,
        55.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v11', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 11,
        80, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v11.mp3', '6db59fb0d4229048d49e37c695f48e578280431ba9fbc6214220e1044ec593c7', 809630,
        50.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v12', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 12,
        78, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v12.mp3', '55bd21784b3b732fd75ef5c40664d182ae3ef82e4906a70bde6f8940d1c5f47b', 905760,
        56.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v13', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 13,
        79, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v13.mp3', 'a7cf24a3147ddc6a7c897cb729993334a6ab9ab46a87b7fdf438256a28803e3f', 857695,
        53.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v14', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 14,
        88, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v14.mp3', 'eaadf294b601e70ddd066e11a44892e05bb7f41f4004114ed19f8e5ab7bf4509', 866890,
        54.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v15', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 15,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v15.mp3', 'dd3d3de4bfce2c8b8d8b868d9e0610158554c01bdf26f026d69f5db4e5c3f6e7', 884444,
        55.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v16', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 16,
        92, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v16.mp3', 'ed41ec716a411929fc7dbd0137be1d8fd44da04102c3f9750463d278f01f41b3', 858531,
        53.59, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v17', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 17,
        82, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v17.mp3', '5cb7ed3c3e7bc684403e395bb53fe8c419b3143725814d73bd060ca90bf55b27', 830945,
        51.87, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v18', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 18,
        89, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v18.mp3', 'aa3b6bbc086012357b8972a3348e04d41b9f9466c969b97bf19969992fb1dae4', 876503,
        54.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v19', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 19,
        84, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v19.mp3', '42d004e3ad73ca74c310edeb1faa6680cf0208f3d31fde2c902d1484f419a886', 818825,
        51.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_immo_auto_v20', 'musique_t5_immo_auto', 'immo_auto_T5',
        'immo_auto', 'T5', 20,
        91, 'afro-soul confiance instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/immo_auto/T5/musique_t5_immo_auto_v20.mp3', '9a09492ecac56157a533eb32ae69a5219b55a323378b1d27a31e0a220daf0852', 914119,
        57.06, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v01', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 1,
        113, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v01.mp3', 'd5a51e290eb0ddf27f3b77f47e0b3f57334871a6d14a6624d0eb1edf08f44459', 680898,
        42.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v02', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 2,
        114, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v02.mp3', 'f0de4b8e0be6a63b9b80df27d6be40041605522254922f35f997b7d6e86584df', 660418,
        41.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v03', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 3,
        104, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v03.mp3', 'c0043dbaf8ba4db23418f02d483f7c64cecc3938900fbe31f355d9bc61cc2159', 601068,
        37.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v04', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 4,
        103, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v04.mp3', '8ae836b20d97274f8a8fc80bffcdeda3c70298bb6fc509941de39e91b2974e8d', 669613,
        41.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v05', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 5,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v05.mp3', 'bd23337f1831f8744a680e4a4dd463938efc883cd93513c204adaf4555071b49', 622384,
        38.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v06', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 6,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v06.mp3', '73bdc6d82795658489cd618f3d7707df77a2b0860d4dd5bca5624e464f545172', 661254,
        41.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v07', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 7,
        106, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v07.mp3', '2c1e520a9d6251de55a75ed13195946760e82507549304ccdb47a1210f7fca7e', 629071,
        39.26, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v08', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 8,
        108, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v08.mp3', '21beb8e7526cbfe85916220c4bbb95fba143fee5bb200a0cee1c9de8483376ab', 620294,
        38.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v09', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 9,
        112, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v09.mp3', 'ff57c275403e8ff011fd2944a147364fa71e231db84064b9028bb0b3d1050cd8', 644118,
        40.19, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v10', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 10,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v10.mp3', '3979cd0f61980f14cf313cf143b28c36f60216cbdd1d6002403ee8cdfbb0af38', 622802,
        38.87, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v11', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 11,
        110, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v11.mp3', '540208f301f967b3e45a45f1a8a4dc45033603d88d04b259fdda445593c547ad', 620294,
        38.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v12', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 12,
        111, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v12.mp3', 'b1f892278bba4c8e2f32fd318fa73a924997bbf61b06c498b865c0adca0393ba', 659582,
        41.16, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v13', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 13,
        114, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v13.mp3', 'd2c86c7aecdac2f9ac4c684fa7b5dadfab77afc9f3f9eea206ad72a914f60b75', 640774,
        39.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v14', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 14,
        105, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v14.mp3', '503dd6817b9a0eaf09ba73bdec0b49e82a715f9c534466163530b02de6e06d7f', 621130,
        38.75, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v15', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 15,
        108, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v15.mp3', 'be3f3bbcdad7c3312598ed4eaf200564d03c439749ef08422ee2a9d9c20e82b9', 613189,
        38.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v16', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 16,
        107, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v16.mp3', 'e4a3864f0e862ad2a920737280d1d0ad3329dab50a7712b915b9361e76425c5b', 665852,
        41.55, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v17', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 17,
        103, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v17.mp3', '6889d06e87b881fa209e73efbbc8f8f371cf9ec54c8246997b49ef372bf9b701', 663762,
        41.41, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v18', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 18,
        112, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v18.mp3', '942d58b5bf926d460d0a0922014d0794a9feee53be19552fbe8d4257d502acfd', 615278,
        38.39, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v19', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 19,
        108, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v19.mp3', '036e2d29677832970c98fcf7809807d4bfc4347995e454fe58af1e5af27eff11', 678808,
        42.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_restaurants_maquis_v20', 'musique_t1_restaurants_maquis', 'restaurants_maquis_T1',
        'restaurants_maquis', 'T1', 20,
        111, 'afrobeats percussif instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T1/musique_t1_restaurants_maquis_v20.mp3', 'a35f22a672997dff4e57aa4d2f61158f8b247ca0a6c2b2b32098e2b20cb0acfb', 632833,
        39.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v01', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 1,
        100, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v01.mp3', '4b18f75e7fb54b8ccd254c6093199c14ce99529c854bd40ac581a2fa876422c4', 598978,
        37.38, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v02', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 2,
        98, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v02.mp3', 'abde774f3e59418b38165c882086971f61b1aa90617503d3fec15ea4a84527ca', 586857,
        36.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v03', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 3,
        98, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v03.mp3', '3926bf0e3812866c1f322f6a76cf07c4578a360724156301d1bca5e0a27d55f5', 588947,
        36.74, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v04', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 4,
        103, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v04.mp3', 'fe94544e723177e563044a227914cfaed764d6edd85b88df940c8ee6772db975', 631997,
        39.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v05', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 5,
        100, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v05.mp3', 'bf42e2e124647e7f0f15f85974e550ad8663ad9965433ff927218a8eeac7bf7c', 599814,
        37.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v06', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 6,
        107, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v06.mp3', 'ec4b7837dead309b65f3a7a29bbd82a6d98ad3a3d2d479467aa5d88866fdb6db', 630743,
        39.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v07', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 7,
        105, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v07.mp3', '3ffbaaf2212d4e21d987f579b73ded85275c6a6bc707402c2df0c2957f0aa9d6', 636594,
        39.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v08', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 8,
        106, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v08.mp3', '5a56dbdf4a754d09a086ea5634ada47ec9f35c676bef675ec5a74f01fe42989a', 600650,
        37.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v09', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 9,
        106, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v09.mp3', '9fd204f8131e38f32f8a47f18b2f9038485969c7432b319ac4b57b12d11a65e1', 611099,
        38.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v10', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 10,
        109, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v10.mp3', '44eb84df239c2991ae8cc514f8207f298e7dcd8e3b6425c127fedf30363f4b96', 636594,
        39.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v11', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 11,
        104, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v11.mp3', '9d87976cc2108ef30dc713c6892a212bbd602fb5cb9f2f5c37631ba011e5e9eb', 654149,
        40.81, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v12', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 12,
        105, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v12.mp3', 'b5c4daaf785c3d1014b291db946ab0422cc0cc8742c1c927d0e52f44fb77ebd7', 667523,
        41.66, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v13', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 13,
        108, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v13.mp3', 'ce3c88746f5c0ececb421fd9c36e95ae449e3fd5f4d0eee6e63560f648d2c560', 638266,
        39.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v14', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 14,
        109, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v14.mp3', '53b29522fc6fc3ac9e372677e7e6becfe9b2b547dc56c307542806407d5d70b6', 600232,
        37.44, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v15', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 15,
        98, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v15.mp3', '6eab5fd366a0d59840357183214926dca965159dd63ee9bc1d3b8e094537e9a8', 584767,
        36.47, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v16', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 16,
        97, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v16.mp3', '422084202f9d749d2011990de72701d4dfe3f57942e070dbacdbce044fa9fb84', 656238,
        40.96, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v17', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 17,
        102, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v17.mp3', 'c9b6401bd76821aeeb299db67a0273efaabb1a91d5ba6ea8babe195130677513', 588529,
        36.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v18', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 18,
        110, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v18.mp3', 'fb8004ca4a96caf2d89d3d822aa4d4260a254c47626866c027eb88d5f3ce3e37', 691765,
        43.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v19', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 19,
        104, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v19.mp3', '11ef137b6bb50b72dd7147cbb16e241d1d1946146516e914afc3cc8e1f68dfc8', 640356,
        39.95, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_restaurants_maquis_v20', 'musique_t2_restaurants_maquis', 'restaurants_maquis_T2',
        'restaurants_maquis', 'T2', 20,
        102, 'highlife chaleureux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T2/musique_t2_restaurants_maquis_v20.mp3', '494ae599469dc895f87092555bf3d604c423dceb5c3e0f4827a16cb73656a3bf', 585603,
        36.54, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v01', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 1,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v01.mp3', 'f8935dee8202e60e3e770babe9f55fbef6900fc8f36bc7bbd4ed3f246dcc8b56', 754041,
        47.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v02', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 2,
        91, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v02.mp3', '31098de159aa0aecb77c68fce60cf23cfd7b2db656dc747fc128b68dd695aaa1', 735651,
        45.9, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v03', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 3,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v03.mp3', '8d0f5463789faebecdd8102acc30e42098850c4ceefac03d2a70ed2619edb35d', 715171,
        44.63, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v04', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 4,
        97, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v04.mp3', '42959b67a5f9d18f1cacf4c249a07b1194f4117a424070d2c8e566a1189433e3', 685496,
        42.76, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v05', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 5,
        105, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v05.mp3', 'fbafba2fb050a6a98267ff9a66762644d0b7c44080a76be01ec7cb61b3e8cbc4', 732307,
        45.69, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v06', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 6,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v06.mp3', '03a7ef7a6f8f0911124a6d9a6fbdee4b4c2b81f573426684fc87c02d6a33a7be', 731471,
        45.64, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v07', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 7,
        98, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v07.mp3', '36509917aa0b828d54987699faccdf103421a93a12e9f92b1eef841cf861681e', 689675,
        43.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v08', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 8,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v08.mp3', '126af4af79f56c3fe042a20978015a4a4f0e82959336e8a1ad578c8aa9857abb', 709319,
        44.27, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v09', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 9,
        91, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v09.mp3', '72e7ba7600dac740151819b687228fe262958bd467be30eac72cc307101aa457', 754041,
        47.06, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v10', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 10,
        98, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v10.mp3', 'c6c2d38087c39da21375c99375d0e1c25f3206ed6693a87cc9404b2bd86b80ab', 769505,
        48.02, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v11', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 11,
        103, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v11.mp3', '146e4c346d8ec58c09a6e91a135a1b7c364286048544b3105f84f9e0d9e1145d', 689257,
        43.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v12', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 12,
        100, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v12.mp3', 'c4b4dc17b65ff1f17de9ed115e273afc6efd620b6dfb00a68208de315e63ea96', 741084,
        46.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v13', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 13,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v13.mp3', '14945b2d377c69000b0aa2c4d7a66cd7e71f27d78c7b57cbbbd59a316795cd84', 766162,
        47.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v14', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 14,
        97, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v14.mp3', '123aa8cb410f20fc7c9c6119ef37b66123efd94f0462d839c24886a4121f3af5', 667523,
        41.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v15', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 15,
        92, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v15.mp3', '912e65bcbbbe6d527349549af4f7b3045fffc06e75d1d3fb4f3b0c1f6efa91cc', 764908,
        47.73, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v16', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 16,
        104, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v16.mp3', '6b6066122bb2e28617322ce60001c5da56270f98200784efb340cb851bb5d73c', 728545,
        45.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v17', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 17,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v17.mp3', 'a6e9118e5a2bd457f750e09539b68e5473ab2a3660255e4d7aa2c72c088255ee', 698034,
        43.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v18', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 18,
        90, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v18.mp3', 'b2b0ece19d3581240abf5d5c9eac78b1ba12a7d397d04ce63229abd953cc03bb', 717678,
        44.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v19', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 19,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v19.mp3', '839fb2c1c7f52b9658f39aa89aa9ebf41423d4ae71c1b2ffd4e85dfa3cd7025c', 683824,
        42.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_restaurants_maquis_v20', 'musique_t3_restaurants_maquis', 'restaurants_maquis_T3',
        'restaurants_maquis', 'T3', 20,
        94, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T3/musique_t3_restaurants_maquis_v20.mp3', 'e15b0c339701e3934f2a21eef9a756a1f37769059844f08482c74ca365107574', 669195,
        41.75, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v01', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 1,
        115, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v01.mp3', '92c73bb90980188a97b48e8886be30dacdc4f5dd685d02daf82afad8fe37c7bd', 609009,
        38.0, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v02', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 2,
        123, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v02.mp3', '1ce60e0060be6175510328457fed698cdd9e5c1aaf45cec67446844c0daeda30', 664598,
        41.46, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v03', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 3,
        128, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v03.mp3', '9d3677dbf250f6ec4f45301b21a200ae85f36e75101c1dfc874fc30f3d696075', 642028,
        40.07, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v04', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 4,
        125, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v04.mp3', 'e9db80a8d808ca54b494f3725b47f3f34c1963cbb58ad6c2358e735ccefbc560', 662508,
        41.33, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v05', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 5,
        122, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v05.mp3', 'a9cd5706c5840d4994e57acceb74ec6de32eb7417add03e3e86f4a70bf00b550', 624056,
        38.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v06', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 6,
        126, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v06.mp3', 'ad1eb52b656a394eaf35628714ae1f87977771ed55f5577a5cbd8bd22d54178b', 662926,
        41.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v07', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 7,
        114, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v07.mp3', '103a6e3d22defe0b0d2887eaed527c27e7511a1d0dc356f50fe09cc5c5a6f449', 610263,
        38.08, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v08', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 8,
        118, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v08.mp3', '48cf69938d27d7556aa2448ab520ed02e30624978746ea91e5fa3d5993bc9b25', 653731,
        40.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v09', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 9,
        114, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v09.mp3', '3d66f76fabe0f43eb7e35801610523c522810b0d811e568f0c7abdc27f544c98', 659164,
        41.14, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v10', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 10,
        113, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v10.mp3', 'c605bc031c35d63272f4f2fc6861feb8b54e5351a2e9329a990ad2e722af8893', 615696,
        38.4, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v11', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 11,
        128, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v11.mp3', '9e21bdb0319e5f3ee383442f35d1e6f71bff101e33e15b6f8a2f543024b10623', 658328,
        41.08, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v12', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 12,
        122, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v12.mp3', '75c0ceb127e631f718ee05d9b4025212dcd0c7f04cf032bd9ede165b082d7d9f', 558436,
        34.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v13', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 13,
        115, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v13.mp3', '256544ee650f5e688a4734731e1c9bbf26f37726c2433fef4024be47a3f7e15d', 657492,
        41.04, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v14', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 14,
        119, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v14.mp3', '24025112386f24c8019fda692f5cc9960fe6bb51825eff8b98d4166c47a67b86', 591873,
        36.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v15', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 15,
        118, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v15.mp3', '3c1fe6643ef4c7ff6524bc7e2bc8d672653bf8ca05bc6c40d025718532b6b548', 570139,
        35.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v16', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 16,
        114, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v16.mp3', '839c2a121b0ae4c60d5397503f734f4d3dbad4fcbb12c6dac7c228b214394e89', 648715,
        40.47, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v17', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 17,
        125, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v17.mp3', 'c338f1256dc3a05fb4679d30bf701ccd06ef42e8cf3e94e110370201c854d666', 654985,
        40.88, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v18', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 18,
        115, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v18.mp3', 'a1cb3fbf082e228fa52f2a84943cd7219bc01c1eb11ad076499a8ad4a26dca2e', 552167,
        34.44, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v19', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 19,
        112, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v19.mp3', '9aec2cde736a08a6df8119aad548cd27bccd5e3769e581a3cfe5a376f0419c64', 578498,
        36.09, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_restaurants_maquis_v20', 'musique_t4_restaurants_maquis', 'restaurants_maquis_T4',
        'restaurants_maquis', 'T4', 20,
        124, 'afro-house cuisine groove', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T4/musique_t4_restaurants_maquis_v20.mp3', '94378c8c5fc2b6c2c049b045979a1e1596f6eda3a287e5b58b72a8806ab98f70', 603576,
        37.67, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v01', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 1,
        92, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v01.mp3', 'a769a1293882fb020825cf622d35d13c9d98905ce8dd81f6ecc59c4a2bfb2fc0', 894475,
        55.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v02', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 2,
        79, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v02.mp3', '5ebb7344c34da75efb42b8f0b04a8234e7f39bbafc57516c09bd369539b6978a', 823004,
        51.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v03', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 3,
        81, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v03.mp3', 'fd4501e7b1ff8ea25d761cb7b599d38fa5c1f04bbb2f25a9d96a944f8e6c8933', 821750,
        51.29, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v04', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 4,
        90, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v04.mp3', 'af72e52b0db01080e05416897c1debc33f904fe84672a7e157425a46a4cc2374', 909522,
        56.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v05', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 5,
        81, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v05.mp3', '6f5f1d14b448f5e67c5903d04d078c369368d8276a5593b43991854f5a8e3546', 892803,
        55.74, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v06', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 6,
        92, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v06.mp3', '1f1341c4bdb18a5b930aaddaf98b800f4c34ac6cd5d4e442d4d1ab821523f945', 886116,
        55.32, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v07', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 7,
        88, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v07.mp3', '0d1f0c4ed1170d45350b22b0f97445d18195f05a48e547ef34e8a9e7e6ae2ecc', 915373,
        57.14, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v08', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 8,
        86, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v08.mp3', '10a01ad2e2afb55681463b41378db0d073f48f4465c70b7ca2b64d943239c9fc', 859367,
        53.64, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v09', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 9,
        92, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v09.mp3', '6ccea073eb1d17ea928ce3bb046d0b9ec483e9cf5487d4b020836badf80227af', 824676,
        51.47, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v10', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 10,
        96, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v10.mp3', 'b02f8bdd599f09d619bfd92d2c0e12bd99513686891009b48e48ab650b3aa372', 843902,
        52.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v11', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 11,
        85, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v11.mp3', '28ae7fa3e82998cf3717c8a3b330926580f00108c550d6068fc370c7136dd1f2', 895311,
        55.9, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v12', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 12,
        78, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v12.mp3', '28ad21227fc890b780ca4f00a54bfe6a978cd223c7f587d95924b1fb87b9c117', 811301,
        50.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v13', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 13,
        94, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v13.mp3', '3b25fb712d2938cc4fbc785c6fce8e3eb7e5fd1b3e3e2d9a88caf653d2da4c0e', 916209,
        57.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v14', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 14,
        95, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v14.mp3', '43139488b56b866d543bb005cfb1a7c2b77528a511a17d82d5d0c72295b13745', 837633,
        52.28, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v15', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 15,
        83, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v15.mp3', '1f1c20380e95fe5b8016188bac0beb9f89e12727294bad070667e750e7d46133', 896983,
        56.0, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v16', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 16,
        96, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v16.mp3', 'dec6be8628591b56f3fe69a1169199ba3d907a93d4e21a8cdb7f52186326f09a', 894057,
        55.82, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v17', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 17,
        81, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v17.mp3', '988d46b860a3d05818a999396000ac35da6b991153421faf13de1c244b5ebd6b', 846410,
        52.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v18', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 18,
        82, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v18.mp3', '40766952d145028519b2b3254d3b82df69a558e5188c8ec7154be8be455db573', 907432,
        56.64, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v19', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 19,
        84, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v19.mp3', '59a158c730fa64b52f52b94c4519811221215f3c466f596f8b958d9974acabe0', 866054,
        54.07, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_restaurants_maquis_v20', 'musique_t5_restaurants_maquis', 'restaurants_maquis_T5',
        'restaurants_maquis', 'T5', 20,
        87, 'afro-soul maquis instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/restaurants_maquis/T5/musique_t5_restaurants_maquis_v20.mp3', '0bfa5f1c67b6bf4d976fdabbb23f898d7b3fb12452dcf75568ca3eb21d464324', 817571,
        51.02, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v01', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 1,
        103, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v01.mp3', 'c265e883d67ca05de8e8cadfadf551db464d4c61fd832d0bda5464126902f603', 610681,
        38.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v02', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 2,
        112, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v02.mp3', 'be38be286086d783951229dd99d769838842232e9f3894b73cb83fb3704d2d38', 671703,
        41.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v03', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 3,
        104, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v03.mp3', '048f656df55d71e558b0d367f982dd424999c0a014c099f5bbf7737d0b9a1c31', 610681,
        38.09, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v04', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 4,
        103, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v04.mp3', '6272b04f85bba61acaabef4255c381e00eb8f5d4f3294474a63000773bb437f8', 660836,
        41.23, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v05', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 5,
        112, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v05.mp3', '814e9b58a05bad743f25aba074124dfa4645ee7bef0f301f478ab60883ea7f56', 670031,
        41.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v06', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 6,
        108, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v06.mp3', 'e69d23f977ba4bd2e83a1a92eb5b72a25f60b4ccfc573e7545a676502cfb87d8', 665434,
        41.51, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v07', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 7,
        108, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v07.mp3', 'c534a6e495f980505f01d1e0c49bd533f47b20c65010e0aa202c19552f426882', 589783,
        36.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v08', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 8,
        106, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v08.mp3', 'e026fb566f32549c2e2f7f1266e421d9e36883cae1f47ce5d9d7240906aa40bd', 617368,
        38.53, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v09', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 9,
        111, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v09.mp3', '35964a5b77dc7820c9145faa9c079c2f3cadd5a4e112e75c3ea2c8f6a146ffa6', 652059,
        40.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v10', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 10,
        114, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v10.mp3', '547796ce53a6817e93cc8513d73599f1ce289901ab50d5c529e47888db3f14fa', 679644,
        42.4, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v11', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 11,
        109, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v11.mp3', 'ada8e23b071b5d4c896fa47c3f8ed3bf521905f40bf0d8ee6d97221f86bfaa18', 680062,
        42.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v12', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 12,
        102, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v12.mp3', '3444809217e3dd5cc531cb55f3aa30ba32442fa4b1c8bdc16973b368f060024d', 611099,
        38.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v13', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 13,
        110, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v13.mp3', 'fd54ccf4c0525a09f055f361e8030595f0c3e6aafd54c93293412ac368543530', 616114,
        38.45, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v14', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 14,
        110, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v14.mp3', '0d88c38687a6b6b804fbc9bb739e8cd4bef9d1cd6b7e6787c2cbd414abe588d0', 647879,
        40.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v15', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 15,
        104, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v15.mp3', 'cbc2c1e18ed6806f94abebf75d04f8b10b9a4185ebe5c8471010cb8249c3e673', 654567,
        40.85, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v16', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 16,
        106, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v16.mp3', '0c2fafdaee0a146516273895a31a353235b9b57d4bec5cddc89c9d0d262f733f', 606083,
        37.81, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v17', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 17,
        112, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v17.mp3', '9a47e1786746ccdaa27fc301c8971cc581ed8c8555fe6ae095b0e21ea4ed2a74', 601068,
        37.51, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v18', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 18,
        111, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v18.mp3', '44872ae6aa2d496f3e1d9375db4c46d34b87e6526c52e0ec233e2eb35fd376a3', 594381,
        37.09, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v19', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 19,
        104, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v19.mp3', '7b76d04f2b9fd03722e170c9c304d2f9872639b8858e5304763cf4d5a77a741a', 580588,
        36.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_shops_small_business_v20', 'musique_t1_shops_small_business', 'shops_small_business_T1',
        'shops_small_business', 'T1', 20,
        106, 'afrobeats commercial instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T1/musique_t1_shops_small_business_v20.mp3', '678d258e25df9b6200c49bb199105801628386fdb040b266491082fd20d1b4a9', 639520,
        39.9, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v01', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 1,
        105, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v01.mp3', '662586130c7401a0077317276e9f82bdba7a55ea39fd957bd6ed18630a61f7f2', 596470,
        37.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v02', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 2,
        109, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v02.mp3', '49ca090a7b897c6b23eb50aca037f5dcd7d9e5c8a940f155ad4fbddbb7d13ca9', 683824,
        42.66, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v03', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 3,
        99, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v03.mp3', '8f946a9f7d6ad1443e80e73404d78364743aa8b387c24b5d0c9ac254112cf043', 673375,
        42.03, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v04', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 4,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v04.mp3', 'a2e8974ef170411e23991bd500782da37d9b071d59484a3e1c6f8b5d2873025e', 585185,
        36.51, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v05', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 5,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v05.mp3', '1d0687ebabe37bb1e231c5b7d1e1325382adffa61798203198943057eb4746a7', 668359,
        41.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v06', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 6,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v06.mp3', 'bd9bcafdcc32f9d40184c7e0cebfe0b51f83692aefc70043c5ccee90f4caf92b', 681316,
        42.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v07', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 7,
        96, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v07.mp3', '63ae60532b0069e118bc08a4a10d68039fecdfa7c77d7aa87f7dba2ea6e4b48d', 577662,
        36.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v08', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 8,
        101, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v08.mp3', 'f6eba4101c296583d26a59d40e4ea41ee2c9523668c2d10eea9c537d1008507b', 654567,
        40.85, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v09', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 9,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v09.mp3', '4dd0863f3b37c407ab774953c41d1534994730cd0c09d2645034219938e1ed68', 625727,
        39.03, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v10', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 10,
        109, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v10.mp3', '1cf33d2102d6dfbe58932e263488c33e7e0946242278fb16d39219e4e31fc012', 646625,
        40.35, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v11', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 11,
        100, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v11.mp3', 'a1d8ed05a01b9df89bb7887bebe6ff3a60d49c10a32d8a3219f3a0d13c595303', 619458,
        38.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v12', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 12,
        97, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v12.mp3', 'e134d73efe8ebbad72e34105edaca64b161d488da5ec47e154187352f369232c', 612353,
        38.21, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v13', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 13,
        107, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v13.mp3', 'eb0a6aa8d4be4996f7dc876132e04ea8a266797abad3c0b5be2eb2433a1950fa', 586857,
        36.6, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v14', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 14,
        106, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v14.mp3', '52304c0a3bf4afcd297d39f0bb0c7ff23fdf11bc5a13a9e720b3057ca9678c64', 669195,
        41.75, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v15', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 15,
        106, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v15.mp3', '8a810305a0cad652456d81565299169714dc862c04b011ab47d27c58bc693386', 655403,
        40.89, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v16', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 16,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v16.mp3', '340fbf6b472a9449a42cebbfae995589a5d83ae1ebb4427f4a487df3590c324f', 628235,
        39.19, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v17', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 17,
        102, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v17.mp3', '1d3b3f6ae68bca60cac7a9928f1505692b603a22e98041153d2b836c32cb96be', 596888,
        37.23, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v18', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 18,
        109, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v18.mp3', '30d0aa07668b0ac25aba79df8d89472c4962c7a50ae4097e28e334fd7e888b5d', 616114,
        38.44, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v19', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 19,
        110, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v19.mp3', '626014f09ca8b83cde52c33ea53a6541356b141337d6585c905e1561da3b177d', 688421,
        42.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_shops_small_business_v20', 'musique_t2_shops_small_business', 'shops_small_business_T2',
        'shops_small_business', 'T2', 20,
        107, 'coupé-décalé instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T2/musique_t2_shops_small_business_v20.mp3', '21b34aa5076e933880bfe5fde09f962d6d00308cc4e9bef20da27d2e59ac1bf3', 584350,
        36.46, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v01', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 1,
        99, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v01.mp3', '4e508efa327be26a2ee67b3e7e9463fe308e797a6b98ef3cfb9bad3190cb23ad', 700960,
        43.75, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v02', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 2,
        105, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v02.mp3', '5cb90124218ba5fae63dffea87850dab30d22ba7e1ceb229f105d999cefb9351', 701796,
        43.79, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v03', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 3,
        102, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v03.mp3', 'c3478991c5cd065ef7abf07f55ae0825b88db26ace509044435f79f4acd45ef8', 744846,
        46.48, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v04', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 4,
        95, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v04.mp3', '385b41975eda9f943ee37fdb02777553b5f59b2746f455e050224788a9cadbd9', 745264,
        46.5, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v05', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 5,
        90, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v05.mp3', 'e577cee8f5fef01661a6f2908cdd903fc74240fdb4d991ab6c574b3e5b713c7f', 741920,
        46.31, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v06', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 6,
        96, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v06.mp3', '0b2ef73bf2c5bc9fc145c76d7280c4e34d874584f2c4d14878a64b309a286f43', 761982,
        47.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v07', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 7,
        100, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v07.mp3', '4865f155ae318cb83ea6c253d2a2447783e8d91c13791fbc1adc8fa5571e9975', 720186,
        44.95, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v08', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 8,
        92, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v08.mp3', 'cb4fdb4fba08cb2f4fc923ac28739b331effe8f310f240e217046b9596790ea1', 693019,
        43.24, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v09', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 9,
        91, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v09.mp3', '996b1ba1b43bc420a1d95422dd02d6fe0a3fc876ac8b37e9f3f6e83bd8f4b529', 667105,
        41.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v10', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 10,
        97, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v10.mp3', '6d89b7c2dad12e2297e6d28faad2e28df95818ddf523733a8e67af3001cbd4da', 728963,
        45.5, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v11', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 11,
        104, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v11.mp3', '48cb6817a5211fa646041a5812135ad0df30841543754a9031e13056b489a23b', 724784,
        45.24, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v12', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 12,
        96, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v12.mp3', '0140da2e7199e3600b0e5b5e90be4c48ac499f24175bcab6643a3fe5a70aa3cc', 764490,
        47.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v13', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 13,
        92, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v13.mp3', '84d6d3bf72eba19b7b7b207c9ea7a8bb5e48b4ffcd75f8f82d23da61bc5cd3d6', 764490,
        47.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v14', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 14,
        100, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v14.mp3', '5f6acf07462fd46bdc8e02cafb0c8ddb3de5ebeb53776f219012d0ec05069c9a', 727710,
        45.41, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v15', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 15,
        103, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v15.mp3', '4340c62d948cf37ee09c70d84185882b9c361d510783f26671724cc6ed00ca6e', 673793,
        42.04, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v16', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 16,
        91, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v16.mp3', '0fa80d656fdc152f1ab7892e78646fa81c1b3ebcb0e464d09198684eabf5b11e', 677136,
        42.26, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v17', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 17,
        106, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v17.mp3', 'e7dd33cdeda08db1f2919a495d6463959c2567c29bc6f50921d5dec6fb7aa371', 745682,
        46.54, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v18', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 18,
        101, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v18.mp3', '293b651d88809b074cc09f81ca3608d15aa8e1a6c6d39c06387bfd9491207d98', 734815,
        45.87, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v19', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 19,
        106, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v19.mp3', '7069cc8767701d4eda56e937d319ab43f0cfb3227ddb49893361010117b68c17', 704304,
        43.96, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_shops_small_business_v20', 'musique_t3_shops_small_business', 'shops_small_business_T3',
        'shops_small_business', 'T3', 20,
        97, 'amapiano groove instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T3/musique_t3_shops_small_business_v20.mp3', 'a631d80764ef88f010aad561c6350fe3596f409cf387903798d337a6bda1278a', 749861,
        46.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v01', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 1,
        113, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v01.mp3', '760a3349f8597b5fad0ef0e90bc37dad8dfcda993fc0a6641849343c9a460ae2', 554256,
        34.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v02', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 2,
        118, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v02.mp3', 'ed2a13635aa84649ea6ba9405569acac735bf91d04900c0acc83a39ec4f06566', 588529,
        36.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v03', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 3,
        122, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v03.mp3', '3f8951d4790e5bb4b1fa36569cd2849c2e3ef2fa205625fd8ba4634c3d95fd8f', 619040,
        38.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v04', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 4,
        120, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v04.mp3', 'dcb9423c4dac8f32d8fbdd32040288ddc92b53069b7d9f9eaf2b6fd2bbd39563', 619040,
        38.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v05', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 5,
        114, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v05.mp3', '59aeeaa79043a35378eccd130fefddbf81334a60b5e834e0fef77f6d23a000d3', 573065,
        35.76, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v06', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 6,
        113, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v06.mp3', '75a3a280efb94e9ce644d642bca6363dd024b467c3a5c42fc8c615dd1eb88658', 561362,
        35.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v07', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 7,
        118, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v07.mp3', '191bf4cfa76efbbe87b261826cada37b460bb5ce6301266ceef51a1b6a6a1952', 632833,
        39.5, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v08', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 8,
        127, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v08.mp3', 'c18ce556d8942cd1d4452395693aec328603e8c49b5e73d9e11215ebe5066cbd', 593545,
        37.02, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v09', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 9,
        124, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v09.mp3', '3e99a4fae29f73acd65dd740483679c03291ac702118f728652ffe3d2e7b1051', 656238,
        40.94, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v10', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 10,
        120, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v10.mp3', 'd1bc89b5571274eace0cf3c487c6bb81e76ddfa60b82610ee1ed38a9fd7461e1', 607755,
        37.93, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v11', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 11,
        126, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v11.mp3', '0bcf1f0253aad73d8cafc8233b05792a1fee861ebc6c2e4f3925379afc5e4c33', 652477,
        40.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v12', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 12,
        112, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v12.mp3', 'd4e4d32fc812b7525f9c8d9094061579deefad829cb4d2996dc0c9a7d4463f78', 593963,
        37.06, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v13', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 13,
        113, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v13.mp3', '72596fba6738e74593fd8621976c0a3593b06d2ddc800fb19abc2bdd8979b2f3', 606501,
        37.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v14', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 14,
        119, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v14.mp3', 'eaa7067276d597a9674c6609416c6da87677f6f3daab5fe49c68371623ee962f', 622802,
        38.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v15', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 15,
        118, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v15.mp3', '58f785dcc815bab9124adac56686cb0c33e3130a8f7b28d26276f77c21847ef2', 569721,
        35.54, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v16', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 16,
        115, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v16.mp3', '8ce6ae9f274523613a64359057ce5f659776093b9ec781604191c2a4ae5281cb', 636176,
        39.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v17', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 17,
        124, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v17.mp3', 'fc46eb956bd224445e7edc1f6a425baa7e182bfef0e197dfa6bb5776984851c7', 557600,
        34.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v18', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 18,
        126, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v18.mp3', '56d0e8e8fc43791f0a27137378316b5ceda2805a98adf27de9ac9a9058814e10', 563452,
        35.14, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v19', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 19,
        115, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v19.mp3', '2d89d26c017d8796a7a675578898dae96ad25be1206caf1130064e640bcd768a', 576826,
        35.99, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_shops_small_business_v20', 'musique_t4_shops_small_business', 'shops_small_business_T4',
        'shops_small_business', 'T4', 20,
        125, 'highlife léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T4/musique_t4_shops_small_business_v20.mp3', '09c0b6a7a4b8e59d93b2bed98447dda37118e7e22862893e525f44284ed970cd', 656238,
        40.94, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v01', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 1,
        91, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v01.mp3', '66c44b0a149d81a2db62a3739bbcb47678c1fab81a885fa208edaf5297300604', 860621,
        53.73, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v02', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 2,
        83, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v02.mp3', 'feeceb1a4339b11489284b35bd6e9090e3d0111f3ce3b34dad5fde99821833e7', 859367,
        53.63, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v03', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 3,
        93, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v03.mp3', 'a65cff8fc10b8303bdb3413a7ff6e054db7cfe260e668d8adaf4dc7d5c8b9c70', 891550,
        55.66, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v04', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 4,
        84, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v04.mp3', '026a359e3cdc55724901e4b2b1d04d4866e13b2cb4166441afd53de20a6de230', 886116,
        55.31, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v05', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 5,
        92, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v05.mp3', '44a058493e415c77ae164ec5eb08c1e7ecb0ce18ac8fa2df818045d3038e138d', 891550,
        55.66, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v06', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 6,
        95, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v06.mp3', 'be4e12b610f766074e78c3c2df3410765322945b30c4f7d0cc8a7310a7ffeff7', 876921,
        54.73, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v07', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 7,
        90, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v07.mp3', '53078b54ee74db75e6630922313d3d3f3727b7b74d7e5cff4071557bf5363605', 904088,
        56.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v08', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 8,
        79, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v08.mp3', 'ffb295a7e1ea3b0820fe9e0fea2cf64981db64bcee572c49d903031c9f7bb7b0', 859785,
        53.68, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v09', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 9,
        83, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v09.mp3', '905b319bce70effedf6463a66cd4fa28ed032e0d1e3ec5016023b77eee9f4594', 904924,
        56.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v10', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 10,
        85, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v10.mp3', '266b5fbd62bc203dd2056bb6388da6afd58ad43c787ceab284a304df082c60a9', 824258,
        51.45, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v11', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 11,
        82, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v11.mp3', '3bf35f5dec6c334637f21a1267714a1ab2e92b2da6cd21ec1b613ef6cefaebdc', 838887,
        52.37, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v12', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 12,
        92, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v12.mp3', 'd62338bd63e9c00448f04f49eacace9d49705104bd33c48d285bb7620c298f2a', 837633,
        52.27, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v13', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 13,
        79, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v13.mp3', 'bf35080faa2e0a5aad800233de884c1ab4cea3d2502b234702cda99d03cbefbc', 843484,
        52.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v14', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 14,
        93, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v14.mp3', '5b1df3d46a3accaf87da8171a7b098aecfd9e8ecb03e701ffb77d0e085864bbf', 846828,
        52.85, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v15', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 15,
        94, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v15.mp3', 'eb067b985ee2d612f78182ffd5de80dbfba478d8cf95e983fd14a7f6b4002ab4', 918299,
        57.33, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v16', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 16,
        80, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v16.mp3', 'c1bd41e3f44a02a25de45524f21addae1b5107551780a6b9309d86cc9cbc786e', 822586,
        51.34, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v17', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 17,
        86, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v17.mp3', '6294bdeb600206353307e53fb0b0aed0f747309d05a009ea794c129bad007081', 863546,
        53.9, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v18', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 18,
        88, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v18.mp3', 'd91db3a0c4ad5db8ff2f692678ddfe69d64ae5bbe550093d070d77710b529734', 890296,
        55.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v19', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 19,
        81, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v19.mp3', '96f3816f2a14a555136e6f360bd9e09f65ceb46c6693111ef6adb91a5a8625a7', 835543,
        52.16, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_shops_small_business_v20', 'musique_t5_shops_small_business', 'shops_small_business_T5',
        'shops_small_business', 'T5', 20,
        95, 'afro-house dynamique instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/shops_small_business/T5/musique_t5_shops_small_business_v20.mp3', '7d7f339e291aedd4a892d71c4870d2b02d424a96d2d030102f0de5bb59664046', 902416,
        56.33, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v01', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 1,
        110, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v01.mp3', 'b1bcf3ba494e7a94aea17f40e183fbec2b2c85228931304666d7c6cf54ea8848', 654567,
        40.85, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v02', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 2,
        112, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v02.mp3', '90831d4d7128f0a3bbca467a9a4dc97242ac2efb15625dec7f8e42383cb8f307', 606501,
        37.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v03', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 3,
        106, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v03.mp3', '9556f268e51ef194a562ee136e3f95796e6d7b00c6fd9644ee61fbfe67cd5c73', 606919,
        37.86, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v04', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 4,
        111, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v04.mp3', '0248750fecf440ab3a1e690bb52b34d94fa488ce2d1c90658f88fe0ed0dc3944', 599814,
        37.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v05', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 5,
        101, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v05.mp3', '8fcde55ab80702e929a87eb7a88bee341a644e94d762c78f7282931fb092177d', 662508,
        41.34, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v06', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 6,
        112, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v06.mp3', 'ea93b2ced91457b885116cd138822f9481815899036e5ef1247e61a1abb3cb56', 634505,
        39.58, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v07', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 7,
        107, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v07.mp3', '0d5b948d8c142d700be2582ef9f1a199eb0a2f4a4bbb38a250759d54ed8bc058', 680480,
        42.47, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v08', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 8,
        109, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v08.mp3', '490963d94dd1a3a7212456a3e3f4f1a19189e1cc16ca913756e61553d35e7fb6', 617786,
        38.54, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v09', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 9,
        100, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v09.mp3', '6de7f68b18c948d0d13e94a85b943a53c37e21cf8c08cb203e18f53e81cb6c32', 642028,
        40.07, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v10', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 10,
        106, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v10.mp3', 'e01c9249b694d0a3dbf42177dee5c45e8d649d938e4465b3dcaa1c3d42fb57c2', 658746,
        41.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v11', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 11,
        102, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v11.mp3', '61ab52cccf84d1382018fd56e0abbb86252b9c1fcaaa06524047ab0ef58e0d64', 632415,
        39.45, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v12', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 12,
        103, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v12.mp3', 'e3c8e7988a32bdc902ce47398d6c69578bb6a6848db76ed03eabc63428213199', 586439,
        36.59, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v13', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 13,
        111, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v13.mp3', '683063922c05b6f4cc2d0bda32b617c404491b0d5c5b0b709e0057165a6b5da9', 665852,
        41.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v14', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 14,
        105, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v14.mp3', '303f704b97ae5f7baa07cc5ed8286c176b46956bc16c85fabee6033005b9e6f5', 623638,
        38.91, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v15', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 15,
        105, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v15.mp3', 'ab975522a7e153d06f26dcc00257b34f60a675f8827c2790440a3aa0a47869ba', 619040,
        38.61, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v16', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 16,
        104, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v16.mp3', '086a6e9eff9d7e15018d353e3eacd24e96119d2df285864e3d3264e941b33c26', 658746,
        41.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v17', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 17,
        110, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v17.mp3', '632be3e5c0ab4510895b840dc63f9ed80f03c1c4d3cefd3771a0544b37c00913', 620712,
        38.72, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v18', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 18,
        108, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v18.mp3', '935a8a4864984fb8da12f8501b307a153455411f2ab4a74313b9b28a523956a3', 591873,
        36.92, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v19', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 19,
        109, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v19.mp3', '20ccc4cd43010e0432ee4c9b2729bbd6aaa6282137efc983cc6f2e813c2d1635', 677554,
        42.28, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t1_vetements_mode_v20', 'musique_t1_vetements_mode', 'vetements_mode_T1',
        'vetements_mode', 'T1', 20,
        105, 'afrobeats élégant instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T1/musique_t1_vetements_mode_v20.mp3', '86544edbb55bfacfff7199a8da6fd5bcd4704a53ef5cee33ea404411921b692a', 630325,
        39.34, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v01', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 1,
        94, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v01.mp3', '50834c4ddd9c4115f9bddaadd0e0022671a3ce59696c7d7115d48fd3662b9513', 646625,
        40.35, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v02', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 2,
        106, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v02.mp3', 'a964e85b17cbbc2391e9bbc716d4081c20e11c3da17efd0b8fd431d14dd8dec7', 634505,
        39.59, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v03', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 3,
        102, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v03.mp3', '5c683a6e81ba564f140676334e755b3538737747c944364460beb4fd31e1ac8c', 642864,
        40.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v04', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 4,
        104, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v04.mp3', 'c38c31a45293ddccb08ccdd46f31f29b45ac378696d75ee17d848bff2e0c767b', 583096,
        36.36, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v05', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 5,
        103, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v05.mp3', '13c817a17642ab4aa6b54448b1c53a60120ff64699391d56d01ff5bd2879ff53', 687167,
        42.87, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v06', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 6,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v06.mp3', '3b3c8c0442a65bf7fee11ffa28c3e0a6389a64771be7889534145005ee5b565c', 598142,
        37.31, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v07', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 7,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v07.mp3', 'b4ebc0a07449c44b400f53e0795c889abb2e6b85b08736d42c166a5ac22c4214', 587693,
        36.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v08', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 8,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v08.mp3', 'cdd9470fd0b032713f789f435a18c45e36905be3598723b15a04a4a60d908d5b', 649133,
        40.51, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v09', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 9,
        102, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v09.mp3', '39c595f0ba768756f4f11ba0a80bf47b237d046fe5687173ed7dc4d8a6e37887', 579334,
        36.14, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v10', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 10,
        100, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v10.mp3', '0318dbd1d22baed96d2fcf3a60b2af61f39804434d8ab14e6829aeb96701e599', 579752,
        36.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v11', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 11,
        104, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v11.mp3', '1a97fcdf045fed1a7c6a6ed33f31f9c46c704fb15c0ccd9fd5bbf2a5a72d4514', 625727,
        39.05, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v12', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 12,
        107, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v12.mp3', '8e7b009fed0b07f79c1158a82c2d612512dab5bdd0a44a923c45a8243ff7c58e', 669613,
        41.78, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v13', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 13,
        98, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v13.mp3', '491f1df15d120760ba01814a0b29c4a1536f36d39cfaa9ff251841ea53d9c91a', 672957,
        42.0, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v14', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 14,
        99, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v14.mp3', 'da23475f49ee6f1b8beada5788ad789016d48db1c8ac8da11562ef1568b3a054', 642446,
        40.09, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v15', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 15,
        103, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v15.mp3', 'ba9b23e7779817cf61cd1b99990ef38d6833924235f66188d0079f0c8c50f1cc', 665434,
        41.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v16', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 16,
        108, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v16.mp3', '780e0b2ab7536f7e03062fc8928209bc441dda585d46a9d7d62f336a5719031f', 662090,
        41.3, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v17', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 17,
        96, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v17.mp3', '2f6a075096822fb2d9260fc203afba5f153188f68339e772bad26e856a924d21', 646625,
        40.35, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v18', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 18,
        101, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v18.mp3', '95e6a62317a53e93d997c770c7f887e45041d47b6c4a7654b0f330640793cd01', 685914,
        42.81, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v19', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 19,
        97, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v19.mp3', '7f94051d8dfa8037743a140dece8d43e1abee45e4dfa7eed83c346e671650128', 611517,
        38.14, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t2_vetements_mode_v20', 'musique_t2_vetements_mode', 'vetements_mode_T2',
        'vetements_mode', 'T2', 20,
        105, 'afro-house runway instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T2/musique_t2_vetements_mode_v20.mp3', 'c30f0ab3a2627aeca60ba2bc915391acb174cbf4079ac1ea916c34b492ee1504', 667105,
        41.62, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v01', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 1,
        102, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v01.mp3', '43fa934c046489fae3fc71c069cf930c2e056de60a02cc5ca10dae0e09579c25', 666270,
        41.56, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v02', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 2,
        92, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v02.mp3', '65b16e400b3ee5e3b72b57cdcc5eb725046a7595eb5bbb65abb2c5819d6428c4', 670449,
        41.83, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v03', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 3,
        102, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v03.mp3', '1a31711a7e676a02d6359fe68e8818fb328b1b57307cb0e773429cb4181ea510', 668777,
        41.73, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v04', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 4,
        93, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v04.mp3', '226665c001ae9ac1bf008863ed6d7a72bffd6d1a7f71fecc3a5f7e1499e084bc', 738994,
        46.12, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v05', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 5,
        99, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v05.mp3', 'eb1bbac87bff4ae6bbdd2f25dc3afe75ac901ec96df3c188979c854c2eca98f0', 684660,
        42.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v06', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 6,
        90, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v06.mp3', '566ce26185e4903433620e12085c47db6ab98af4cb112e5dfb1de9bf05dcd568', 717261,
        44.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v07', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 7,
        104, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v07.mp3', '2d3df169c5828f3585d2a244fb24477c0ebd1c38c26d29a756c20b34319cb5a4', 695945,
        43.42, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v08', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 8,
        88, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v08.mp3', 'e7977c5239a68d56c6673e8d87091fa9809f53c6cbddd7a58d1726949d98ee02', 707647,
        44.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v09', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 9,
        102, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v09.mp3', '9a9ad01ac5e10336356d4b01165b9f3fd53da380ab3267c6b5887ca28f8ce831', 766580,
        47.84, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v10', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 10,
        94, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v10.mp3', '648130665b1bd09dec19614c4ae6c3f2ff0bd3f0a257ebbcfeeacf0a9daeb443', 699288,
        43.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v11', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 11,
        97, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v11.mp3', '3f8f465fbc6f75383e848e6072ccffe2fc22946aaed5cae16cdf347e2bca7f1a', 672539,
        41.97, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v12', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 12,
        100, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v12.mp3', '477c26c6dfd54df4282a2e2838f5802a62b69a2fe1f12028eec7af214d4d4c98', 689675,
        43.04, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v13', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 13,
        99, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v13.mp3', 'ef81512b840299f7db75df075a17e5b5f032219ad9ad69637124d7abeba08caf', 692601,
        43.23, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v14', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 14,
        88, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v14.mp3', 'acbbc24b0af766f5d3c3302dfc798b20b52e61c97ac2cc06b8bc24c0d90d3d4d', 698452,
        43.58, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v15', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 15,
        90, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v15.mp3', '69bf536f9deb3c297e4a38684c3cc01bd4bcf3c63c74b4b691cf7f7e4e645f52', 691765,
        43.17, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v16', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 16,
        95, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v16.mp3', '9eefcb86623d5b17d4427f08995fd4e053f2eb276064f9b1354a333b5e8840bd', 759056,
        47.38, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v17', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 17,
        103, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v17.mp3', '7ae80334fa2ea83ad28dde7830005159d664cd1aa67ebc986a110fb438192f06', 736905,
        45.99, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v18', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 18,
        96, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v18.mp3', 'a990b3e4983cf5b9bf33e16b843fa0a623c150a0395550d74e8ccfcc80280b25', 744428,
        46.45, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v19', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 19,
        94, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v19.mp3', '8716e980461aabffc43e7789f35ee2a9a70362230ef29446d79165a550bcf833', 741920,
        46.31, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t3_vetements_mode_v20', 'musique_t3_vetements_mode', 'vetements_mode_T3',
        'vetements_mode', 'T3', 20,
        91, 'highlife moderne instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T3/musique_t3_vetements_mode_v20.mp3', '8a9a3b26d1eb11dd4b1cc0304c0d1aec834bd99d5f5e769617bb6295636d474c', 738158,
        46.07, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v01', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 1,
        112, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v01.mp3', '3fe0ba27ad8a39368795fe2da275dab011745e9ded2417578db51117b2c274e9', 673375,
        42.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v02', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 2,
        119, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v02.mp3', 'a958a29dacb2907b441fa02682f242f1a0e73f97aeae6787da3f7fd79d3ff93c', 586021,
        36.57, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v03', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 3,
        121, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v03.mp3', '94622def80bcbb127a1ccf1b5ff533868b87a12bbe14dd96652399c5195d8f48', 568885,
        35.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v04', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 4,
        114, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v04.mp3', '7c34c9f335eae2e2c98f9c4234eb3026315fb6e9be1a49999c91716815b85c77', 595634,
        37.16, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v05', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 5,
        115, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v05.mp3', '7bc6f92f1c90659dbd68bca11efd5bd63a588e8509a5e8b4ea119451ad38d140', 674211,
        42.06, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v06', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 6,
        116, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v06.mp3', 'b4ca4fb1e9b44c8f816d4c6978fd6e8cfd18e60e192e7b9fd7722f97f64d05e5', 652477,
        40.71, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v07', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 7,
        120, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v07.mp3', '32d599975efafe28d62a505634962728543337f0d35e11dbc0d373c8929ca987', 568467,
        35.47, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v08', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 8,
        110, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v08.mp3', '8d7efa754ec3e3a7110bf221636cfc9367d6aa5a03668131303a38737aea13f8', 657910,
        41.06, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v09', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 9,
        110, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v09.mp3', '7abfc08694104114b40210b2629f527664b5f620a4aef0af4a8af519a72627f0', 606083,
        37.82, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v10', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 10,
        120, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v10.mp3', '22a062c72027d9b9a16ae4c6f2a69739678e9a891bbe4efe01a85913cc4d856d', 656656,
        40.96, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v11', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 11,
        117, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v11.mp3', '1c7eade12c3123809ae35989747e18744bf016bbc692f74e684bea105c6885f9', 591037,
        36.88, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v12', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 12,
        112, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v12.mp3', '1410a6490e62deb1850ecdc60be946d8602bcf07cf17eec5163ea482dd248e52', 603576,
        37.65, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v13', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 13,
        126, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v13.mp3', '06039d5dc0c07624d9db1f391b5aafb93739cb70634c410901dfdca1abbe0fb7', 581842,
        36.29, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v14', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 14,
        117, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v14.mp3', '3ade5503b902f6a92a395e8cd16833cc531e2f88028dbcd91195c876ce6fe997', 613189,
        38.26, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v15', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 15,
        111, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v15.mp3', 'd63b146071a9019c5de67746ba65f18a0ad439877686405a7a4541d50d08c40b', 668359,
        41.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v16', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 16,
        122, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v16.mp3', '1204a4a87b3ecf8faaaa75228cf7bca7ee517dd6c9b9fd7073bf433c7a443326', 644118,
        40.19, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v17', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 17,
        118, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v17.mp3', '15d38bd7642d8b3e7255628f655ba96f8419f54b90f920df0a827db576d35b10', 611517,
        38.15, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v18', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 18,
        126, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v18.mp3', '1a40dc87c82a25a53cae0c6323a838d5ca3b880518cb5d3a683fec80d63e813e', 615278,
        38.39, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v19', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 19,
        116, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v19.mp3', '5221c90914f9a56529ed6dbf5ce9b51b82878a1c4920499dab7a38cf2140a94a', 593127,
        37.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t4_vetements_mode_v20', 'musique_t4_vetements_mode', 'vetements_mode_T4',
        'vetements_mode', 'T4', 20,
        125, 'afro-soul doux instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T4/musique_t4_vetements_mode_v20.mp3', '18118de5f86274288c01db9ced0c5736099195905a6d665be946f789725965c7', 673375,
        42.02, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v01', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 1,
        82, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v01.mp3', '602d5c6244e7e83557812cd1d8e2dd8ed037a2bc994e760f4008b374b275fded', 818825,
        51.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v02', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 2,
        89, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v02.mp3', 'ef74e8b25aa8552a832cb467f268bc4ea66bee2505483bd63549ed8c073934ea', 841394,
        52.52, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v03', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 3,
        88, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v03.mp3', '9b7a8ab8abf8404804780a0d2bc616c05c2b73428e7f3b881edb602f635301ea', 869816,
        54.29, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v04', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 4,
        79, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v04.mp3', '58c0fafd7104ba1d6b8a9d7292f228c7e72f4c4d293361d5882e69c0ef407d76', 848918,
        52.99, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v05', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 5,
        76, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v05.mp3', '7a016b95258d54f4b814f74d1dde83516a2709f584041ed25df7309731e131bc', 895729,
        55.92, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v06', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 6,
        82, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v06.mp3', 'e6a0af5327786270bfad4677853492b91c4ccf883217c7f25f4e1f89f436b3e4', 861874,
        53.8, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v07', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 7,
        91, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v07.mp3', 'd6056980245b1a8da4a9538b45749d29589495f629964641df86601f426f604b', 834707,
        52.11, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v08', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 8,
        86, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v08.mp3', '3407a0ba602606f4aef71be76597e41a014f3a78e1403bc1100670f1fcac570f', 850590,
        53.1, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v09', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 9,
        92, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v09.mp3', '0fdb07ac6ebc6954df3cdb6b309b237342dc5fbb025c9bfc6fb0ace392b82b5a', 837215,
        52.25, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v10', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 10,
        90, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v10.mp3', '4a463c6406e97d30d9ec99cbe960cf5b80ac3c824a2db35457198479e5934bc7', 884444,
        55.22, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v11', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 11,
        89, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v11.mp3', 'b1b6e9ed651dd93feaeff59dbeea241fa06adb13b6fa57f707c8acf3cc64fe94', 876503,
        54.7, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v12', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 12,
        94, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v12.mp3', 'fba306d4b5801a19b2bad5f913a5403666b491aee6d08259ccd31b0a6e2015ba', 885280,
        55.27, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v13', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 13,
        90, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v13.mp3', '16a63a606a9c1717880aa27f80d4b4f9760a1aae7dab270b259dc9b6e7311e1c', 874413,
        54.58, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v14', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 14,
        86, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v14.mp3', '33ab74a20038cf84b105a0adaa7b480e5fe27e6038542b0c6a82a83234439f32', 888206,
        55.45, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v15', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 15,
        78, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v15.mp3', 'c8576e015801c5abfa24ac63a8c10e068f4acdc9da92e4f1709e66e24f081ea2', 817153,
        51.01, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v16', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 16,
        82, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v16.mp3', '26b6bb240989930c2793d0da2c107796946eaa944eb7db529c3fb5b3c7407ab8', 902416,
        56.33, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v17', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 17,
        80, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v17.mp3', '2b28622e60e123dff08bdd698db2c5c76a7bbe1b2660286da3ccd62e5338bb35', 845992,
        52.82, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v18', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 18,
        89, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v18.mp3', '0227ab4ed73eb7f40836e645ca00112724baf408e0efb661f5e33dea1dba45c4', 920807,
        57.49, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v19', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 19,
        86, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v19.mp3', 'bd3b86e33555e791753c27fc5605a2966205939fb1109f0450d62a0c12d4e42c', 845574,
        52.77, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
INSERT OR REPLACE INTO bgm_library
       (piste_id, categorie_audio, gabarit_id, secteur, format, variation,
        bpm, genre, origine, licence, object_key, sha256, taille_octets,
        duree_s, preuve_sha256, statut, updated_at)
VALUES ('musique_t5_vetements_mode_v20', 'musique_t5_vetements_mode', 'vetements_mode_T5',
        'vetements_mode', 'T5', 20,
        84, 'amapiano léger instrumental', 'synthese_procedurale_v2_fix_silence_initial', 'CC0-1.0',
        'audio/bgm_r2/vetements_mode/T5/musique_t5_vetements_mode_v20.mp3', 'c89721edb9910dbb4da53430721fc30315e25582b2fb522d014dc422c735d7a3', 839723,
        52.43, 'd42.28-fix-initial-silence', 'EN_LIGNE',
        strftime('%Y-%m-%dT%H:%M:%fZ','now'));
