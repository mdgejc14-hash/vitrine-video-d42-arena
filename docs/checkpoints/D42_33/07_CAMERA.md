# D42.33 — 07 Famille Caméra & Revue des prises (famille G)

Commit : voir RUNS.md. Écrans : HUD de prise (gabarit), overlay générique,
barre de commandes XML, compte à rebours, badge REC.

## Réalisations (spec §7.15, §8-G ; mission §7.7)

| Zone | Avant (D42.32) | Après (D42.33) |
|---|---|---|
| Bandeaux HUD (haut/bas/état) | noir 80 % (`0xCC000000`/`0xB3000000`) | **navy translucide `rgba(2,35,88,.55)`** (§7.15) |
| Cadre de visée | coins orange 3 dp dessinés à la main | **`OverlayViseur` du design system** : coins blancs 2 dp 70 % rayon 18 + **grille des tiers 30 %**, borné à la zone utile au-dessus de la barre |
| Carte consigne | carte BLANCHE (0xF2FFFFFF) | **bandeau navy 55 % + flou** (rayon 22, blur 20 dp — no-op < API 31), textes blancs/Blanc80, label « À filmer » OrangeHi |
| Badge « visages détectés · porte R4 » | affiché (vert/rouge) | **SUPPRIMÉ de l'UI** (mission : aucun label technique) — la porte de consentement R4 (dialogue réel + ConsentGate + envoi serveur) est **inchangée** |
| Texte guide bloqué | « Plan bloqué : consentement manquant (R4) » | « Plan bloqué : consentement manquant » (label technique retiré, FR+EN) |
| Chip état flux | vert/ambre codés durs (0xFF2E7D32/0xFF8D6E00) | tokens **VertSucces / AmbreAlerte**, pilule |
| Badge REC | point rouge 0xFFFF3B30, fond noir | point **RougeBloquant #B42318**, fond navy — rouge = enregistrement/arrêt uniquement |
| Compte à rebours | fond noir 60 % | fond **navy 60 %** (chiffre blanc 84 sp inchangé) |
| Confirmation prise | vert codé dur | **VertSucces** 80 % |
| Bouton ENREGISTRER (XML) | teinte par défaut du thème | **orange #F95C0F** ; **devient rouge #B42318 quand l'action affichée est un ARRÊT** (enregistrement en cours / annulation du décompte) — §7.15 « jamais orange pour l'arrêt » |
| Bascule caméra (XML) | bleu-noir #331B2A4A | navy 20 % #33022358 |
| Ligne d'état (XML) | noir 80 % | navy 55 % |

Fonctionnel INTACT : PreviewView = seule zone de cadrage (flux CameraX réel
D42.30), barre XML unique (ids camera_record_button/camera_flip_button/
camera_next_button stables pour le harnais), compte à rebours précédant
TOUJOURS le recorder, annulation par second tap, verrou 3A, ConsentGate +
dialogue + envoi serveur, finalize/confirmation, textes e2e intacts
(« Filme ta prise », « Verrouiller et enregistrer », « Arrêter et continuer »,
« Refaire », « Suivant », « Changer de caméra », « Caméra prête »).

## Nettoyage conséquent (labels techniques)

- `camera_faces_ok` / `camera_faces_ko` retirées des strings FR+EN (plus
  affichées nulle part — i18n cohérent).
- `PriseGuideScreen`/`GuidedShootingOverlay` : paramètres `faceCount`/
  `gateAllowed` retirés de la signature (appelants mis à jour :
  CameraGuideActivity + CameraVisualCheckTest). `overlayFaces`/`gateAllowed`
  (write-only) supprimés de l'activity — `decision`/`onFaces`/dialogue
  inchangés.
- « (R4) » retiré de `camera_blocked` (FR+EN).

## Corrections regroupées dans le même commit

- **Imports GabaritBriefScreen** (échec compile run 43602520884) : l'ajout
  d'imports avait utilisé une ancre inexistante (replace silencieux) — les 9
  imports design system sont désormais ajoutés avec ancre vérifiée + audit
  croisé automatisé symboles/imports sur les 8 fichiers modifiés.
- Preuve du fix Robolectric offline : le run 43602520884 montre
  « robolectric offline prêt : android-all-instrumented-14-…-i7.jar » et
  « …-9-…-i7.jar » — AUCUNE erreur MavenArtifactFetcher (les tests JVM sont
  ensuite passés jusqu'à l'échec compile feature-brief, indépendant).

## Tests

- CameraVisualCheckTest (Robolectric SDK 34) : appels à jour, rend l'écran réel.
- e2e caméra (run_gallery/run_p0/run_p1) : aucune dépendance aux textes
  modifiés (vérifié par grep : « visages », « R4 » absents des assertions UI ;
  run_p1 teste le DIALOGUE via ses boutons, inchangés).
