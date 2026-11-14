# D42.33 — 08 Famille Montage & Export (famille H)

Écrans : E7 aperçu (VideoPreviewScreen), E8 export (activity_export.xml),
panneau de typographie cinétique (ExportPreviewPanel).

## Réalisations (spec §7, §8-D/H)

| Zone | Avant (D42.32) | Après (D42.33) |
|---|---|---|
| E7 marges | 16 dp | **20 dp** |
| E7 en-tête | headlineSmall + badge r8 | **H2 Navy + Sub Muted**, badge **APERÇU** FormePill Label |
| E7 vignette 9:16 | fond gris (GrisLiserai r12) + **glyph « ▶ » non cliquable** | fond **Navy rayon 26** (héro), bannière sous-titres navy 80 % r14 — **faux bouton lecture SUPPRIMÉ** (interdiction « éléments-boutons non fonctionnels ») |
| E7 carte vérification | Card M3 | **tuile blanche r22 + ombreSm**, H3, rows Sub Muted / Body 600 Navy |
| E7 CTA | Button M3 (testTag preview_create) | **BoutonPrimaire pilule 56** — testTag `preview_create` conservé, texte « Créer ma vidéo » intact (dépendance e2e) |
| E8 (XML) | padding 24, titres système 24/17 sp, ProgressBar par défaut, boutons wrap | padding **20**, **Jakarta extrabold 21 / bold 16.5 + Inter 14.5** (polices locales), **ProgressBar 8 dp pill orange #F95C0F / piste #EDEFF5**, boutons **56 dp** (partager/exporter) et **48 dp** (voir mes vidéos, OrangeDeep), cartes **r22 blanches** |
| Typo cinétique | mots 18/26 sp system, mot-clé OrangeStore | **Inter 17 / Jakarta ExtraBold 26**, mot-clé **OrangeDeep** (AA sur fond clair §3) |

Fonctionnel INTACT (aucun contrat modifié) :
- ExportActivity : porte V2.0 crédits (gateThen/deny/compensation idempotente),
  WorkManager KEEP, FLAG_SECURE, préparation D42.21, réconciliation orphelines,
  observeExport (succès → partage réel FileProvider ; échec → bouton rendu) ;
  tous les ids XML (export_status/start/progress/share/space/percent) conservés.
- VideoPreviewScreen : signature inchangée (sectorLabel/formatLabel/
  previewTexts/checkRows/values/onCreate).
- Textes e2e intacts : « Aperçu de ta vidéo », « Créer ma vidéo »
  (run_gallery CREER), e7_footnote, export_start/share/space.

## Vérité des états (§8)

- Progression honnête conservée : barre indéterminée tant que le moteur
  n'a pas de valeur réelle ; « — % » inchangé (aucun pourcentage inventé).
- Rappel T1 « vous pouvez éteindre l'écran » conservé (cartes info).
- Le résultat (bouton Partager) n'apparaît qu'après SUCCEEDED réel du worker.

## Tests

- ExportVisualCheckTest (Robolectric SDK 34) : rend l'écran réel (signatures
  inchangées → aucun appel à modifier).
- e2e :aucune dépendance aux éléments restylés (vérifié : texts + testTags
  intacts).
