# D42.22 — 06. ANDROID E2E (qualifiés sur le commit final 1c10cad + release)

## Base certifiée (non rejouée sans raison)
- Preuve A (D42.21) : parcours complet 35/35 sur APK signé + e2e-lab 9/9 —
  réutilisés comme référentiel, pas rejoués à l'identique.

## e2e-lab sur le commit final `1c10cad` (D42.22-04) — VERT ×2
- Branche `main` : run **42456741703** (08/11 06:56) : **SUCCESS — 9/9 jobs**
  (android-e2e, android-e2e-p1, langues en/es/ja, backend-http, auth-local,
  security-local, harness-selftest).
- Branche `d42.13-lab` : run **42456741399** : **SUCCESS — 9/9 jobs** (identique).
- Les runs antérieurs (145ece6, 453e470) ont été annulés par la concurrency
  au profit de ceux-ci — comportement attendu, aucune perte.

## e2e-official sur la release rc10-audio-v2 — VERT (étage 3 de qualification)
- Run **42456670342** (tag `d42.21-rc-audio-v2`@453e470, 06:55 → 07:22 UTC) :
  **SUCCESS — PASS=37 FAIL=0 BLOCKED=0**.
- Chaîne de contrôle du run :
  1. APK téléchargé DEPUIS l'asset de la release GitHub (pas d'un build local) ;
  2. `sha256 = 4e2acf14e9276a406369907ebda432cad59c101ddd523cf119985137523f7edb` ✓ ;
  3. apksigner : certificat APK == officiel
     `758077eb…33e192` (CN=Vitrine Video, O=EPD HOLDING, C=BJ) — refus sinon ✓ ;
  4. parcours P1 complet sur émulateur (caméra émulée, API 30, Pixel 5) :
     installation → langue → session locale → carrousel → activité →
     parrainage → catalogue → gabarit → brief (valide/invalide/refus vide) →
     2 prises caméra → guide → aperçu → export local ;
  5. export POURSUIVI pendant 45 s d'écran éteint (FGS, notification
     vv_export) → « Vidéo prête ! » ;
  6. MP4 extrait : `export-0.mp4` **9 140 832 octets**, h264 1920×1080 +
     **AAC 44,1 kHz stéréo**, 34,99 s, **décodage intégral rc=0** ;
  7. crédits : journal `CONFIRMED`, solde 2 (attendu 2) — PASS ;
  8. feuille de partage Android ouverte ; **aucune FATAL EXCEPTION**.
- Artefact `e2e-p1-official` (13608501901, 30 108 467 octets, 57 fichiers :
  MP4, captures, results.tsv, logcat, APK, apksigner_verify) — rétention 14 j.

## Mesure audio du MP4 exporté (vérification locale complémentaire, 08/11)
- volumedetect (ffmpeg 7.1.5) : **moyenne −53,3 dB / crête −27,3 dB** —
  identique à la preuve v1 (même chaîne audio : diff v1→v2 = i18n + formatage).
- Profil temporel par fenêtres de 5 s : contenu NON MUET sur toute la durée
  (moyennes −51 à −54 dB, crêtes −27 à −29 dB) ; fenêtre 20-25 s plus
  recluse (−84,3 dB moyen) = transition entre prises, le plancher de bruit
  étant à −84 dB contre −53 dB sur le reste → signal réel, pas du silence.
- Limite honnête : la voix n'est pas mesurable sur émulateur (caméra virtuelle
  sans micro). La validation perceptive du mix voix/musique (voix dominante,
  musique en retrait, aucun clipping) reste le point B2 du test physique
  fondateur — non transformable en résultat validé sans ce test.

## Conclusion
E2E lab (2 branches) + E2E official (release signée) : **VERTS sur le code
final**. La chaîne complète install→export→partage est prouvée sur l'APK
officiellement signé publié.
