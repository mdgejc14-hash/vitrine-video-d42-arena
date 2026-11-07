# D42.18 — Audit du partage (statique + ce qui reste à prouver en exécution)

Le partage n'a jamais été exécuté (D42.17 : le bouton n'apparaît qu'à l'état
« Vidéo prête ! », jamais atteint en CI à cause de la boucle de quota —
désormais corrigée par le FGS). Audit statique complet du chemin :

## Contrat vérifié dans le code (aucun défaut trouvé)

| Point exigé | État | Preuve (code) |
|---|---|---|
| Visibilité du bouton | ✓ conçu | `observeExport()` : à SUCCEEDED → `export_share.visibility = VISIBLE` + listener `shareVideo(path)` ; avant : GONE |
| Action Android Intent | ✓ | `Intent(Intent.ACTION_SEND)` (`ExportActivity.shareVideo`) |
| Type MIME | ✓ | `type = "video/mp4"` |
| URI FileProvider | ✓ | `FileProvider.getUriForFile(this, "$packageName.fileprovider", file)` — autorité `android:authorities="${applicationId}.fileprovider"`, `exported=false` |
| Fichier couvert par les chemins | ✓ | sortie = `context.cacheDir/export-$attempt.mp4` ; `file_paths.xml` = `<cache-path name="exports" path="."/>` → tout `cacheDir` couvert, **aucune exception IllegalArgumentException possible** |
| Autorisation de lecture | ✓ | `addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)` sur l'Intent porteur du stream (motif documenté Android pour ACTION_SEND + EXTRA_STREAM unique) |
| Résolution sûre (aucun crash si aucune app) | ✓ | `startActivity(Intent.createChooser(...))` — le sélecteur système se résout toujours |
| Visibilité de paquet Android 11+ | ✓ | `<queries>` du manifeste app : `ACTION_SEND` + `mimeType video/mp4` ET `text/plain` (WhatsApp visible depuis l'app) |
| Fichier inexistant | ✓ | `if (!file.exists()) return` (silencieux — acceptable) |

## Points d'attention (pas des défauts, à surveiller à l'exécution)

1. **Chemin transmis** : `shareVideo(path)` reçoit `KEY_OUTPUT` du WorkInfo —
   le fichier vit dans `cacheDir` : le système peut le purger sous pression
   mémoire **après** la fin de l'export (rare). Le partage immédiat est sûr ;
   un partage tardif (heures après) pourrait ne rien trouver. Hors périmètre
   D42.18 (déplacement vers un stockage durable = évolution produit).
2. **WhatsApp spécifiquement** : WhatsApp accepte `video/mp4` via EXTRA_STREAM ;
   le sélecteur l'affichera si installé. À prouver sur l'appareil du fondateur.
3. **Annulation / retour** : rien à gérer côté app — `createChooser` rend la
   main ; le retour à l'application est le comportement standard Android.
4. `FLAG_GRANT_READ` posé sur l'Intent interne au chooser : pattern canonique
   Android ; si un cas limite de grant apparaissait (certaines ROM), le repli
   documenté serait `setClipData`. À confirmer en exécution réelle.

## Ce qui manque pour marquer PASS (règle fondatrice : preuve réelle)

- CI (après réautorisation PAT) : `P1_partage` du harnais — bouton visible,
  tap, sélecteur Android présent (capture écran dans l'artefact).
- Appareil physique (protocole 04) : partage **WhatsApp** réel, partage vers
  une autre app (Drive/Photos), annulation du sélecteur, retour à l'app,
  lecture de la vidéo reçue côté destinataire si possible.
