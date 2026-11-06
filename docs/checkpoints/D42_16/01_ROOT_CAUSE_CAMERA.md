# D42.16 — Cause racine du bouton d'enregistrement (01)

**Vendredi 6 novembre 2026 — P0 : « l'appui sur le bouton ne démarre pas la prise »**

## Méthode (Double Diamant, stratégie 1)

- **Discover** : exploitation complète des artefacts des runs `42278038365`
  (575baba, cité par le fondateur) et `42281822052` (f148092, même code app) —
  dumps uiautomator, captures, logcat 4,5 Mo, chronologie reconstituée à la
  milliseconde (transitions d'activité, ouvertures caméra, créations
  d'encodeurs OMX, commandes `input` injectées, sondes uiautomator, temps de
  « Fetch time » accessibility).
- **Define** : premier événement attendu qui ne se produit pas = le clic ne
  déclenche PAS `onRecord()` au premier appui ; et le harnais ne voit RIEN de
  ce qui se passe après le bind caméra.
- **Develop/Deploy** : correctifs minimaux par défaut, appliqués et testés.

## Les 4 faits prouvés (identiques sur les DEUX runs)

1. **Dumps périmés (H10)** : les 6 dumps `23`→`29` sont **identiques au
   octet près** (md5 `30286fdcd6d6ff89655178dbd37376aa` sur les deux runs) :
   l'écran « Filme ta prise / PRISE 1/3 / VERROUILLER ET ENREGISTRER » figé à
   l'instant du bind. Les journaux `AccessibilityNodeInfoDumper: Fetch time`
   **s'arrêtent nets juste après le bind caméra** (19:55:06.261 sur
   42281822052 ; 19:25:51.443 sur 42278038365) après être passés de 1-3 ms à
   136 ms : la thread UI de l'application ne répond plus aux traversées
   accessibility. Quand `uiautomator dump` échoue en silence, le fichier
   `/sdcard/window_dump.xml` distant garde l'ancien arbre et le `cat` du
   harnais relisait l'écran d'avant → **harnais aveugle du bind à la fin**.
2. **Tempête UI (A3)** : `MlKitFaceCounter.analyze()` appelait `onFaces()`
   **à chaque frame** (~30/s) → `runOnUiThread { updateStatus() }` → 2×
   `findViewById` + 2× `setText` par frame, sans condition — or `setText`
   invalide le layout même si le texte est identique. Les threads
   `pool-6-thread-1/2` (MlKit) expirent 116-256 lignes toutes les ~4 s en
   continu dans le logcat : c'est la saturation qui tue l'accessibility.
3. **Porte R4 non gérée par le harnais (H11)** : la scène virtuelle de la
   caméra émulée contient des images où MlKit détecte des « visages » →
   `ConsentGate.decide` ≠ ALLOW → le premier appui sur « Verrouiller et
   enregistrer » ouvre le **dialogue « Accord du client »** au lieu
   d'enregistrer (comportement produit attendu : un commerçant qui filme un
   client confirme l'accord). Preuve croisée : au 2ᵉ appui (19:58:02.492 sur
   42281822052 ; 19:28:47.371 sur 42278038365), qui tombe sur « Oui, accord
   confirmé », **CameraX réagit en 30-655 ms** : EOS envoyé à l'encodeur de
   veille, **nouvel encodeur `OMX.google.h264.encoder` créé** (19:58:03.051 /
   19:28:48.026) → l'enregistrement démarre RÉELLEMENT — mais le harnais
   aveugle le déclare FAIL.
4. **Bouton rogné (A4)** : bornes constatées `[44,2032][1036,2072]` = **40 px
   de haut** sur les ~132 px attendus, collé au bord bas de la fenêtre — le
   texte de guide (localisé 4 langues) au-dessus repousse le bouton hors
   écran. Sur un vrai téléphone avec police agrandie, l'action critique du
   produit peut devenir difficilement touchable.

## Chronologie reconstituée (run 42281822052)

| Heure (UTC) | Événement |
|---|---|
| 19:54:59.6 | `CameraGuideActivity` démarrée (tap « OK, je commence » à 19:54:59.606) |
| 19:55:05.4-05.6 | bind CameraX : 3 encodeurs H264 de veille créés (replis qualité), caméra ID 1 ouverte, MlKit démarre |
| 19:55:06.261 | **dernier** « Fetch time » accessibility (136 ms) — ensuite plus rien |
| 19:55:04-19:56:06 | le harnais relit indéfiniment le dump périmé de 19:55:05 |
| 19:56:16.696 | **tap 1** sur « VERROUILLER ET ENREGISTRER » → porte R4 → dialogue « Accord du client » (invisible pour le harnais) |
| ~19:56:37 | `P1_prise_1` FAIL (« sans passage en enregistrement ») — verdict fondé sur un écran figé |
| 19:58:02.492 | **tap 2** → tombe sur « Oui, accord confirmé » du dialogue |
| 19:58:02.82 | EOS de l'encodeur de veille (GraphicBufferSource) |
| 19:58:03.051 | **nouvel encodeur créé → enregistrement actif** (jamais constaté par le harnais) |
| 19:58:2x | `P1_prise_2` FAIL — toujours aveugle |
| 19:59→20:08 | export/partage BLOCKED/FAIL en cascade, dump 29 toujours le même |

## Correctifs appliqués (commit associé)

| Défaut | Correctif minimal | Preuve attendue au prochain run |
|---|---|---|
| A3 tempête UI | `MlKitFaceCounter` ne publie le comptage **que s'il change** ; `updateStatus()` met en cache les libellés et ne touche les vues que s'ils changent | « Fetch time » accessibility redevient < 10 ms après le bind ; dumps frais à chaque étape |
| A4 bouton rogné | bouton **en premier** dans la barre, hauteur explicite `56dp`, texte de guide `maxLines=2` + ellipsize | bornes du bouton ≈ 154 px, entièrement dans la fenêtre |
| H10 dumps périmés | `rm` du fichier distant **avant** chaque dump (ui.py et run_p1.sh), échec journalisé `E2E DUMP_FAIL`, selftest S7/S7b | plus jamais deux dumps identiques quand l'écran a changé |
| H11 porte R4 | `prise()` gère le dialogue : si « Accord du client » apparaît → PASS `P1_r4_consentement_n` + tap « Oui, accord confirmé » | le parcours filme comme un commerçant réel qui confirme l'accord client |
| D5 observabilité | journaux `VV_E2E` : entrée `onRecord` + branche prise, verrou 3A, `start()`, `Finalize` (+taille fichier), visages, bind ; extract `27_vv_e2e_markers.log` ; preuve fichier `27_rushes.txt` (`run-as ls files/rushes`) | chronologie complète lisible dans l'artefact |

**Non-régression** : selftest harnais **9/9** (S0-S6 + S7 « un dump raté ne
rend jamais l'arbre périmé » + S7b contre-épreuve), ciblage 3/3, `bash -n` et
compilation Python OK.

## Ce que ce n'est PAS

- Ce n'est pas un crash CameraX (aucun FATAL, P1_aucun_crash PASS) — le
  FallbackStrategy A2 de D42.14 fonctionne (l'encodeur de veille est créé au
  bind, l'enregistrement démarre réellement au 2ᵉ appui).
- Ce n'est pas un défaut de permission (CAMERA et RECORD_AUDIO pré-accordées
  par `pm grant`, PASS).
- Ce n'est pas un deadlock de `start()` (aucun ANR, l'UI continue de rendre).
