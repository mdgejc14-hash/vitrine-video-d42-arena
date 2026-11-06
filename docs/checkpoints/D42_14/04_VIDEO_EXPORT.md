# D42.14 — Tournage, montage, export MP4

## 1. La chaîne

```
CameraX (caméra) → MediaCodec → MP4 de prise
        → montage (segmentation par positions de coupe, 53 invariants)
        → export local → MP4 final → feuille de partage Android
```

Sur émulateur la **chaîne logicielle est réelle** ; seule l'image filmée est synthétique.
Aucun MP4 n'est préfabriqué : le fichier doit être produit par l'application puis mesuré.

## 2. Libellés exacts (lus dans le code, pas devinés)

| Étape | Libellé | Source |
|---|---|---|
| Brief | `Ma vidéo`, badge `1 / 4`, `Continuer` | `GabaritBriefScreen.kt` |
| Récapitulatif | `Avant de commencer` → `OK, je commence` | `ReadyCheckScreen.kt` |
| Guidage | `Filme ta prise` → `Tourner` | `strings_e6.xml` |
| Capture | `Verrouiller et enregistrer` → `Arrêter et continuer` | `strings_camera.xml` |
| Aperçu / export | `Aperçu de votre vidéo`, `Lancer l'export local` | `strings_export.xml` |
| Fin | `Vidéo prête ! Partage-la avec tes clients.` | `strings_export.xml` |
| Partage | `Partager la vidéo` | `strings_export.xml` |

## 3. Ce que la session a mesuré

| Écran | Atteint ? | Note |
|---|---|---|
| Catalogue + gabarit | **OUI** | `P1_catalogue`, `P1_gabarit_visible`, `P1_selection_gabarit` = PASS |
| Brief affiché | **OUI** (5 champs détectés) | `P1_brief` = PASS |
| Brief validé | **NON** | bouton actionné, écran `Avant de commencer` absent |
| Caméra / prises / export / MP4 / partage | **NON** | dépend de la validation |

**Aucun MP4 n'a encore été produit dans le laboratoire.** Statut : `NOT_RUN`.

## 4. Le point de blocage, précisément

`GabaritBriefScreen` : un seul écran défilant, bouton `Continuer` **désactivé** tant que
tous les champs obligatoires ne sont pas remplis **et** valides.

| Champ requis | Piège observé |
|---|---|
| Nom du commerce * | — |
| WhatsApp * | format international exigé (`+229…`) |
| Nom du produit * | libellé variable selon le secteur (« Nom du vêtement » ici) |
| Prix * | **numérique uniquement** — un texte avec lettres rend le champ invalide |
| Monnaie * | **préremplie** `FCFA` — la remplir casse le formulaire |
| **Quartier et ville *** | **n'apparaît qu'après défilement** |

Deux obstacles de harnais corrigés : valeurs saisies **décalées** quand l'écran défile
(corrigé par `ui.py champs`, qui associe chaque champ à **son libellé**), et `RETOUR`
utilisé pour fermer le clavier, qui **remontait au catalogue** quand le clavier était déjà fermé.

## 5. Ce que le protocole physique apporte et que l'émulateur ne peut pas

| Contrôle | Émulateur | Téléphone réel |
|---|---|---|
| Image réelle du produit | ✗ (mire synthétique) | ✓ |
| Autofocus, exposition, bascule caméra | ✗ | ✓ |
| Durée réelle d'export (2 min annoncées) | mesure faussée (CPU partagé) | ✓ mesurable au chronomètre |
| Lecture du MP4 dans WhatsApp | partiel | ✓ |
| Perte audio/voix | ✗ | ✓ |

Étapes 10 à 12 de `09_PROTOCOLE_PHYSIQUE.md` : 4 minutes, deux prises, une mesure de durée,
une preuve de lecture.

## 6. Garde-fous respectés

- Le MP4 doit être **produit par l'application** : aucun fichier préfabriqué n'est utilisé.
- Le partage est vérifié par la **présence de la feuille Android**, pas par un simple appui.
- « Vidéo prête » n'est accepté que sur la **chaîne complète et exacte** — le slogan
  du carrousel (« Une vidéo prête à publier en 30 secondes ») avait produit un faux PASS,
  corrigé au run suivant.
