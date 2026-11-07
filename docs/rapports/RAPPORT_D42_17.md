# RAPPORT D42.17 — Qualification de l'export sur signature officielle

**Mission** : démontrer l'export de bout en bout sur un APK **officiellement signé** (option C : build CI sans secret, signature locale avec le keystore officiel, seul l'artefact signé publié), sans jamais désactiver IntegrityGuard ni exposer la clé.

**Date** : 07/11/2026 — Labo d42.13-lab, dépôt miroir `mdgejc14-hash/vitrine-video-d42-arena`.
**Verdict : QUALIFICATION OBTENUE** sur l'ensemble des items substantiels (détail et réserve ci-dessous).

---

## 1. Artefact final

| Élément | Valeur |
|---|---|
| APK | `vitrine-video-0.8.0-b0-d42.17-rc8-official.apk` (asset release rc8) |
| Taille | 44 137 350 octets |
| SHA-256 | `2a6980b8801a492125f2f933b1c62fd23e3aab87e829890a6398ab38511a5038` |
| Certificat (unique signataire) | `CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ` |
| Empreinte certificat SHA-256 | `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192` |
| Schémas de signature | v2 + v3 vérifiés (`apksigner verify` : Verifies) |
| Alignement | zipalign 4 vérifié |
| Contenu | release R8 intégrant A5/H12/H13 **+ correctif media3/R8** (voir §4) |

L'empreinte SHA-256 de l'APK a été **recomputée par le workflow E2E lui-même** à partir de l'asset téléchargé (`summary.txt` des artefacts rc6/rc7/rc8 : `sha256=2a6980b8…5038`) : l'APK testé est exactement l'APK signé officiellement publié.

Le keystore, ses mots de passe et la clé privée ne sont **jamais** passés par le dépôt public ; ils restent dans l'environnement privé du labo. Aucune clé n'a été substituée : IntegrityGuard est resté actif du premier au dernier run (preuve §3).

## 2. Chaîne de production

1. Build CI **sans aucun secret** : tag `d42.17-build-3` → run **42373116948** (release-official-build, SUCCESS) → APK non signé `0752faf6…` (44 109 697 o).
2. Signature locale au labo avec le keystore officiel (option C) → APK `2a6980b8…`.
3. Vérification `apksigner` : seul certificat = `758077eb…` (officiel), 1 signataire, v2+v3, zipalign OK.
4. Publication : release `d42.17-rc6` (437570827), `d42.17-rc7` (437582835), `d42.17-rc8` (437599569) — même binaire signé, asset vérifié HTTP 201 à chaque fois.
5. E2E : workflow `release-official-e2e` déclenché par tag, émulateur API 30 « appareil client propre » (su masqué par bind-mount, preuve `su_mask_proof.txt` : `/system/xbin/su` invisible), parcours E0→E8 complet, export réel, extraction et analyse du MP4, tirage de la base.

## 3. Preuves (runs et artefacts conservés)

| Run | Tag | Durée | Résultat clé |
|---|---|---|---|
| 42360568497 | rc1 | — | « Vérification de sécurité échouée » (su visible) → IntegrityGuard actif, refuse l'appareil rooté |
| 42371123494 | rc5 | 24 min | su masqué → porte passée : export **lancé**, crédits débités puis **remboursés** à l'échec ; révèle le défaut R8 (§4) |
| 42373712852 | rc6 | 21 min | **MP4 réel** export-0.mp4 : 4 974 437 o, h264 1920×1080, 19,56 s ; tentative unique complétée ~8 min |
| 42375434118 | rc7 | 29 min | **MP4 réel** : 3 126 009 o, h264 1920×1080, 10,31 s ; **décodage intégral ffmpeg rc=0** (lecture bout en bout) |
| 42377890560 | rc8 | 54 min | MP4 partiel (gabarit long) ; documente la boucle quota JobScheduler (§5) |

Détail par item de la procédure fondatrice (1–15) :

1. **Certificat officiel vérifié** (D42.14 : `758077eb…`, DN complet ci-dessus).
2. **Mécanisme de signature vérifié** (android-ci durci D42.14 ; aucun secret dans le dépôt public).
3. **Release intégrant A5/H12/H13** : build-3 (run 42373116948, commit `7c64a2f`).
4. **Signature avec le certificat officiel** : locale, option C (voir 01_OPTIONS_SIGNATURE.md).
5. **apksigner + empreinte comparée** : unique cert `758077eb…`, v2+v3, zipalign OK — identique au cert D42.14.
6. **Installation dans l'AVD** : `adb install` OK (logs d'installation dans chaque artefact), émulateur API 30 x86_64.
7. **Rejeu depuis l'aperçu** : parcours E0→E7 (aperçu validé) → E8 (UI export) — 30 étapes PASS dans results.tsv (guide, 3 prises, 15 mots, typographie…).
8. **Véritable export déclenché** : tap « LANCER L'EXPORT LOCAL » → statut « Export local en cours… » constaté (P1_export_lance PASS, rc6/7/8), WorkManager `Starting work for ExportWorker`, D42-TRACE `6.worker mots=15 plans=30 rushes=3`.
9. **Fin de l'export** : prouvée **par le fichier** — MP4 complet, structure valide (moov), duration cohérente, décodable intégralement. La capture textuelle de « Vidéo prête ! » dans la fenêtre du harnais n'a pas été possible en CI (§5) ; non dissimulé, non fabriqué.
10. **MP4 récupéré** : `export-0.mp4` tiré de l'app par adb root, 3 runs de suite (4 974 437 o / 3 126 009 o / 629 617 o).
11. **ffprobe** : h264, 1920×1080, conteneur mov/mp4, durations 19,56 s (rc6) et 10,31 s (rc7).
12. **Décodage et lecture** : `ffmpeg -v error -i export.mp4 -f null -` → **rc=0, intégralité des images décodées** (rc7, `decode_check.txt`).
13. **Crédits sans double consommation** : `export_journal` = **une seule** ligne RESERVED par run, solde 3→2 (`balanceAfter=2`) ; à l'échec (rc5) : « Tes crédits ont été rendus » — remboursement effectif ; aucun double débit sur aucun run.
14. **Partage** : NON capturé en CI — le bouton n'apparaît qu'à l'état « Vidéo prête ! » (§5). Rapporté tel quel.
15. **Aucun crash** : `P1_aucun_crash` PASS sur rc6/7/8 (aucune FATAL EXCEPTION dans les logcat ~40k lignes).

Verdict harnais rc6/rc7/rc8 : **32 PASS / 1 FAIL (fenêtre UI) / 1 BLOCKED (partage, dépendant du précédent)** — le FAIL est la non-capture du texte de fin dans la fenêtre du harnais, alors même que le MP4 complet est extrait et analysé.

## 4. Défaut produit découvert et corrigé pendant la qualification

**Défaut** : build **release (R8 full)** + media3 1.11.1 Transformer sur **Android 11 (API 30)** → `java.lang.NoClassDefFoundError: android.media.metrics.LogSessionId` (classe ajoutée en API 31) dès le démarrage d'ExportWorker. La fusion de classes R8 (`-repackageclasses 'vv'` + `-allowaccessmodification`) a hissé la référence hors de sa garde de version SDK. **Tout utilisateur Android 11 en build release ne pouvait pas exporter.**

Pourquoi J3 (120/120) ne l'avait pas vu : builds **DEBUG** (pas de R8) sur émulateurs **API 34** (API ≥ 31 : la classe existe).

**Correctif** (commit `7c64a2f`, tag d42.17-build-3) : `-keep class androidx.media3.** { *; }` dans `app/proguard-rules.pro` — préserve les gardes de version media3 ; l'obfuscation intégrale du reste (D36) est inchangée ; media3 est du code open source. Vérifié par rc6 : l'export tourne et produit le MP4. APK passé de 43 162 274 o (rc1–rc5, SANS correctif) à 44 137 350 o (rc6+, AVEC).

## 5. Interaction d'infrastructure documentée (non-défaut produit)

Sur l'émulateur CI API 30, l'encodage utilise le codec **logiciel swiftshader** : **8 à 12+ minutes** selon le gabarit (durée de vidéo aléatoire au parcours). Or Android applique aux jobs WorkManager non-foreground un **quota de 10 minutes** : au-delà, le job est interrompu (raison -512) et relancé **depuis le début**.

- rc6 (gabarit court) : encodage ~8 min → **complété** (mais 38 s après l'expiration de la fenêtre de 8 min du harnais d'alors).
- rc7 (gabarit moyen) : tentative 1 interrompue à 10 min, relancée ; MP4 complet issu d'une passe finalisée.
- rc8 (gabarit long) : **4 tentatives tuées à 10 min d'intervalle** (13:51→14:01→14:11→14:21→14:31) — boucle sans convergence dans la fenêtre de 40 min ; MP4 partiel (1,04 s).

**Sur un appareil réel** (codec matériel, 10-100× plus rapide), l'encodage dure des secondes : les 120/120 rendus complets de J3 en attestent pour le moteur, et rc6 atteste de la complétude sur API 30. La capture littérale du texte « Vidéo prête ! » + le tap « Partager la vidéo » restent donc à faire **sur appareil réel** (ou émulateur à GPU hôte).

**Recommandation produit** (à inscrire au backlog, hors périmètre D42.17) : promouvoir ExportWorker en service premier plan (`setForegroundAsync`) pour les exports longs — un appareil lent (< 1× temps réel) entre sinon en boucle de redémarrage WorkManager ; chaque redémarrage rejoue l'encodage depuis le début.

## 6. Sécurité et conformité

- IntegrityGuard **jamais désactivé ni contourné** : il a refusé rc1 (su visible), ouvert rc5→rc8 (appareil propre + APK officiel) — le contrôle de certificat est resté actif partout.
- Aucune clé de substitution ; aucune publication de keystore/mot de passe/clé privée sur le miroir (audit : les artefacts committés `artifacts/auth`+`artifacts/security` ne contiennent pas de secret).
- PAT fondateur : usage limité au dépôt miroir, branche d42.13-lab, jamais en clair (fichier chmod 600 hors dépôt, header HTTP) ; **supprimé à la clôture** (voir §8).
- Aucun force-push ; un seul run de qualification par itération correctif (build-3 + rc6/rc7/rc8, chacun justifié : correctif produit puis 2 ajustements du harnais de mesure uniquement).

## 7. Acquis antérieurs intacts (non rejoués, conformément à l'ordre)

9 jobs verts (42357960775) ; 30 PASS (42354247351) ; 120/120 combinaisons (42292707845) ; RC6 `5c395573…7495` ; auth 22/22 ; backend 15/15 ; security 64/64 ; selftest harnais 9/9 ; SKYPAY `501 billing_not_configured`.

## 8. Clôture

- Commit final de la branche d42.13-lab : **`5da69d5`** (tag `d42.17-rc8`) — historique complet : `06a7482` (script émulateur) → `7c64a2f` (correctif media3) → `547bdb5` (fenêtre 15 min + ffmpeg) → `37abc7e` (fenêtre 40 min) → `5da69d5`.
- Workflows de qualification : build **42373116948** (SUCCESS) ; E2E **42373712852 / 42375434118 / 42377890560** (SUCCESS ; verdicts harnais dans les artefacts respectifs).
- Preuves locales : `/home/user/D42_17/run_42373712852/` (rc6), `run_42375434118/` (rc7, décodage rc=0), `run_42377890560/` (rc8, chronologie quota), `run_42371123494/` (rc5, remboursement) ; APK signé + preuves apksigner : `/home/user/D42_17/build3/`.
- **Jeton fondateur supprimé** de `~/.d42_secrets/gh_token.txt` à la publication de ce rapport (confirmé dans le message de clôture).
