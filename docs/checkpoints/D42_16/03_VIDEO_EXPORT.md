# D42.16 — Export vidéo (03)

**Samedi 7 novembre 2026 — Agent 1**

## État : BLOCKED (dépendance caméra validée + CI)

La chaîne S25+ (aperçu → montage → musique → SFX → export MP4 → lecture →
historique → partage) n'a **jamais été exécutée jusqu'au bout sur émulateur** :
tous les runs précédents échouaient en amont (prise), la laissant BLOCKED.

## Ce qui est prêt

- Libellés vérifiés dans les ressources réelles (`feature-export/.../strings_export.xml`) :
  « Lancer l'export local » (`export_start`), « Vidéo prête ! Partage-la avec
  tes clients. » (`export_done`), « Aperçu de votre vidéo »
  (`export_preview_title`), « Partager la vidéo » (`export_share`).
- H12 corrigé dans le harnais : le partage tape désormais le libellé réel.
- `completer_guide()` amène désormais le parcours JUSQU'À l'écran d'aperçu ;
  les contrôles existants (export lancé, fin en ≤ 8 min, extraction du MP4
  `cache/export-*.mp4`, ffprobe codec/durée/pistes, feuille de partage) sont
  inchangés et s'exécuteront pour la première fois sur des prises réelles.

## Verrous

1. Le run de validation n'a pas pu être déclenché (pas de jeton — PAT compromis
   hors usage sur ordre du fondateur). Le push doit être fait par le fondateur
   (interface web GitHub) ou avec un nouveau jeton minimal.
2. Sans run, aucun MP4 ne peut être produit ni relu : **aucune simulation
   ne sera présentée comme un export réel.**

## Preuves attendues au prochain run

`P1_apercu_export`, `P1_export_lance`, `P1_export_termine`, `P1_mp4_extrait`
(taille), `ffprobe.txt` (conteneur, codec, résolution, durée, pistes),
`29_export_termine.png`, `30_partage.png`.

---

## Mise à jour finale 07/11 (runs 42348472147 → 42354247351)

Chaîne validée jusqu'à l'amorçage de l'export : prises réelles (3 MP4 ~1 Mo,
chronologie VV_E2E 3× ENREGISTREMENT ACTIF → Finalize hasError=false), guide
terminé, E7 atteint puis quitté via « Créer ma vidéo » (P1_apercu_valide PASS),
E8 « Ta vidéo se prépare » affichée avec le bouton « Lancer l'export local »
entièrement visible et actionné.

**Arrêt final PROUVÉ** : statut `export_gate_integrity` (« Vérification de
sécurité échouée. Réinstallez l'application officielle. ») — IntegrityGuard
(spec V2.0 s22) vérifie le SHA-256 du certificat signataire : l'APK debug de
CI ne porte pas le certificat officiel → refus **par conception** (contrôle de
sécurité produit, pas un défaut logiciel). Captures d'écran vides sur cet
écran : FLAG_SECURE (P2 anti-capture) — les dumps XML font foi.

**Remédiation** : rejouer P1 sur l'APK release signé (keystore local prêt,
RC6 0.8.0-b0 SHA-256 5c395573…) ou prévoir un expectedSha256 de dev contrôlé.
Le moteur reste prouvé par J3 : 120/120 MP4 réels (run 42292707845).
