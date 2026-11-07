# RAPPORT D42.18 — Exports longs fiables, qualification rc9

**Mission** : corriger les interruptions destructrices des exports longs
(WorkManager), préparer la validation physique, documenter partage/crédits,
produire la release signée officiellement. Aucun acquis D42.17 recommencé.

**Verdict : OBJECTIF PRIORITÉ 1 ATTEINT** — le correctif FGS élimine les
redémarrages destructeurs. Un défaut produit latent, indépendant du correctif,
a été découvert et documenté (audio, §6). Rapport honnête : deux contrôles
restent non-PASS en CI et sont explicitement expliqués.

## 1. Identification

| Élément | Valeur |
|---|---|
| Commit final branche d42.13-lab | **`dd82565`** (correctif FGS = `fbc78d9`, régénéré après l'incident de persistance — contenu identique à d8fbbb2) |
| Build de qualification | run **42386176290** (tag d42.18-build-4) — **SUCCESS** |
| Tests unitaires (même run) | **5/5, 0 échec** — dont `ExportForegroundInfoTest` **4/4** (Robolectric : canal idempotent, type dataSync sur API 29+, sans type avant 29, contenu/ongoing/icône) |
| APK RC9 | `vitrine-video-0.8.0-b0-d42.18-rc9-official.apk`, 44 141 502 o |
| SHA-256 APK | **`0fbe524138cbdee37abdd5cac68959653701c41abb47464e9a41c84e4a5439e8`** (recomputé par le workflow E2E depuis l'asset publié) |
| APK non signé (CI) | `d4daa7e3…bd4da`, 44 111 609 o (aucun secret en CI) |
| Certificat (unique signataire) | DN `CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ` — SHA-256 **`758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192`**, v2+v3, zipalign OK |
| Release | `d42.18-rc9` (id 437663102), asset vérifié (HTTP 201, uploaded) |
| E2E | run **42387189875** (54 min) — verdict 34 PASS / 2 FAIL / 1 BLOCKED |

## 2. Le correctif (un seul composant applicatif)

`ExportWorker.doWork()` appelle `setForeground(ForegroundInfo)` **avant
l'encodage** : type `dataSync`, notification ongoing « Export en cours… »
(canal `vv_export`, IMPORTANCE_LOW), repli silencieux en job classique si
Android 12+ interdit le départ en arrière-plan. Manifeste :
`FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`, `POST_NOTIFICATIONS` +
override `SystemForegroundService` typé. Rien d'autre n'a changé (enqueue,
contraintes, crédits, backend, UI intacts). Livre la promesse T1 déjà
affichée à l'utilisateur.

## 3. Résultat vs rc8 (l'objectif de la mission)

| Mesure | rc8 (avant) | **rc9 (après)** |
|---|---|---|
| Interruptions du worker | 4 (raison -512, à 600 s pile) | **0** |
| Démarrages du worker | 5 (boucle sans fin) | **1** |
| Notification d'export | absente | **présente** (P1_notif_fgs PASS) |
| Écran éteint pendant l'encode | non testé | **survécu, export poursuivi** (P1_ecran_etaint PASS) |
| Crédits | mono-débit, aucune perte | **idem** (1 ligne RESERVED, solde 3→2) |
| Crash | aucun | **aucun** |

Intégrité : **IntegrityGuard INTACT et SATISFAIT** (su masqué, APK officiel →
porte passée, export lancé — « Export local en cours… » constaté).

## 4. Mesures d'export (émulateur API 30, codec logiciel swiftshader)

- essai 0 (1080×1920, 34,99 s de vidéo) : **15 min 09 s** ;
- essai 1 (720×1280, repli) : 12 min 49 s ; essai 2 : ≥ 13 min à la capture ;
- mémoire stable (PSS natif ≈ 69 Mo), aucun crash, progression « — % »
  (non branchée — cosmétique, documenté) ;
- **MP4 extrait** : export-0.mp4, 8 521 124 o, h264 1080×1920, 34,99 s,
  **décodage intégral ffmpeg rc=0** — mais **non accepté comme réussite** :
  le vérificateur l'a rejeté (§6).

## 5. Partage

Toujours **BLOCKED en CI** sur ce tirage : le bouton n'apparaît qu'à
« Vidéo prête ! », non atteint (§6). L'audit statique complet
(03_AUDIT_PARTAGE.md) n'a trouvé aucun défaut (ACTION_SEND, MIME video/mp4,
FileProvider couvrant cacheDir, FLAG_GRANT_READ, createChooser, <queries>).
**À prouver sur téléphone** (protocole 07, étape 7).

## 6. Défaut produit latent découvert : audio absent de l'export

Quand le gabarit planifie BGM/SFX (tirage aléatoire au parcours — le harnais
n'a pas d'étape musique), l'export produit **une vidéo parfaite mais sans
piste audio** : `verif=Checks(durationOk, resolutionOk, bitrateOk, nonBlack=3,
audioVerdict=ECHEC)` — double cause établie (code + logcat) : les rushs CI
sont vidéo-seuls ET la musique n'entre jamais comme item audio dans la
composition (le mixer custom ne peut que décorer une entrée existante).
Conséquence : replis successifs puis échec définitif **avec compensation du
crédit** (aucune perte — mécanisme sain). Indépendant du correctif FGS ;
invisible en D42.17 (gabarits tirés sans audio). **Le test physique est
décisif** : si le téléphone enregistre la voix, le mixer a une entrée et
l'audio doit sortir. Sinon, correctif produit identifié : ajouter la BGM en
`EditedMediaItem` (à chiffrer dans un cycle dédié).

## 7. Crédits et fiabilité

Une réservation par export (1 ligne RESERVED, solde 3→2), aucune double
consommation sur aucun run, remboursement à l'échec prouvé (rc5),
réconciliation orpheline intacte. L'état CONFIRMED n'a pas été atteint en CI
faute de fin d'export dans la fenêtre (cohérent — pas une anomalie crédit).

## 8. Défauts restants / à trancher

1. **Audio** (§6) — test physique décisif, correctif produit identifié.
2. « Vidéo prête ! » + partage en CI : bloqués par (1) sur les tirages audio
   (sur un gabarit sans audio, l'export doit finir — cf. rc6 D42.17).
3. Progression « — % » : cosmétique, non branchée (Transformer 1.11.1).
4. POST_NOTIFICATIONS non demandé à l'exécution (Android 13+) : sans octroi,
   le FGS tourne mais la notification n'est pas affichée — choix minimal
   documenté.

## 9. Sécurité et conformité

- Keystore/mots de passe : jamais passés par le dépôt public, jamais extraits
  (build CI sans secret + signature locale, option C, méthode D42.17).
- IntegrityGuard : jamais touché (actif et satisfait).
- PAT : usage limité au miroir, jamais en clair ; **supprimé à la clôture**
  — le fondateur peut le révoquer.
- Backend non modifié ; SKYPAY `501 billing_not_configured` ; budget 0 FCFA ;
  itérations CI limitées aux défauts de mesure/traitement identifiés
  (traçabilité complète : 06_RUN_RC9.md §5).

## 10. Livrables

- `docs/checkpoints/D42_18/` : 00 état, 01 diagnostic WorkManager, 02 décision
  d'architecture, 03 audit partage, 04 protocole physique complet, 05
  fiabilité crédits, **06 analyse run rc9**, **07 protocole physique court RC9**.
- Preuves locales : `D42_18/run_42387189875/` (artefact complet : results.tsv,
  logcat, MP4, ffprobe, décodage, db, captures) ; `D42_18/build4/` (APK signé
  + SHA + preuves apksigner).
- Prochaine action : **test physique du fondateur sur RC9** (protocole 07),
  en filmant en parlant (la question audio est décisive).
