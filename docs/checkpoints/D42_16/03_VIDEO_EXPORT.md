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
