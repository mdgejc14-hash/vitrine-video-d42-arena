# D42.14 — Protocole de vérification physique (RC6 sur votre téléphone)

**Durée : 12 à 15 minutes. Une seule fois. Aucun mot de passe à me transmettre.**
C'est **le seul** environnement disponible aujourd'hui où la RC6 signée peut réellement tourner
(voir `01_RELEASE_TESTS.md` §3). Chaque étape indique **ce que vous devez voir** et **la preuve**
à garder.

---

## Avant de commencer

| Point | Consigne |
|---|---|
| Téléphone | Android 7.0 minimum (minSdk 24), **connecté à Internet**, 300 Mo libres |
| Compte | un compte Google de test (pas votre compte principal si vous préférez) |
| Réglages | désactiver le mode sombre n'est **pas** nécessaire ; laisser la rotation automatique **activée** |
| Confidentialité | sur les captures, **masquez votre adresse e-mail** si vous le souhaitez — je n'en ai pas besoin |

## Étape 1 — Télécharger la RC6 (2 min)

1. Ouvrir la Release privée : `github.com/mdgejc14-hash/vitrine-video/releases` → tag **`v0.8.0-b0-d42.13-rc6`**.
2. Télécharger `vitrine-video-0.8.0-b0-d42.13-rc6.apk` (**43 134 525 octets**).
3. **Vérifier l'empreinte** : depuis un ordinateur, `sha256sum vitrine-video-0.8.0-b0-d42.13-rc6.apk`
   doit donner exactement :
   `5c3955731de9765327cc95da3ff2fc098b5dd09dc50a6716819404914c377495`
   *(sur téléphone, une application de calcul de SHA-256 fait l'affaire.)*

> **Preuve à garder** : capture de l'écran du terminal / de l'application affichant l'empreinte.
> Si l'empreinte diffère : **arrêtez**, le fichier n'est pas la RC6.

## Étape 2 — Installer et démarrer (1 min)

Installer l'APK (autoriser « installer des applications inconnues » pour le gestionnaire de fichiers),
puis ouvrir **Vitrine Video**.

- **Ce que vous devez voir** : un écran de langue avec **4 cartes** : 🇫🇷 Français · 🇬🇧 English · 🇪🇸 Español · 🇯🇵 日本語.
- **Preuve** : capture `P01_langue.png`.

## Étape 3 — Choisir la langue (30 s)

Appuyer sur **Français**. *(Si l'écran reste sur place, appuyer une seconde fois : le premier appui
applique la langue et redessine l'écran — comportement observé en laboratoire, pas un bug bloquant.)*

- **Ce que vous devez voir** : « Crée tes vidéos publicitaires » + bouton **Continuer avec Google**.
- **Preuve** : capture `P02_connexion.png`.

## Étape 4 — Connexion Google **réelle** (2 min) ← *la preuve que le laboratoire ne peut pas produire*

Appuyer sur **Continuer avec Google**.

- **Ce que vous devez voir** : le sélecteur de compte Google s'ouvre, vous choisissez votre compte,
  puis retour dans l'application **sans message d'erreur**.
- **Preuve** : capture `P03_selecteur_google.png` **puis** `P04_retour_connecte.png`.

> **Si ça échoue** : c'est un résultat en soi. Notez **le texte exact** du message affiché
> (il est maintenant actionnable, plus un nom de classe obfusqué) et envoyez la capture.
> Ne m'envoyez ni mot de passe ni code de vérification.

## Étape 5 — Carrousel (1 min)

Faire défiler les **3 écrans** avec **Suivant**, puis **Commencer**.

- **Ce que vous devez voir** : ① « Filme. Vends. C'est tout. » (commerçante au marché)
  ② « Filme tes produits, on te guide » (main + trépied) ③ « Une vidéo prête à publier en 30 secondes »
  (téléphone + étoiles). **Trois illustrations différentes.**
- **Preuve** : `P05_carrousel1.png`, `P06_carrousel2.png`, `P07_carrousel3.png`.

## Étape 6 — Activité principale (1 min)

Choisir **une** activité (par ex. « Vêtements & Mode ») puis **Continuer**.

- **Ce que vous devez voir** : le bouton **Continuer** est **entièrement visible, en bas**,
  et le contenu défile sans le perdre.
- **Preuve** : `P08_activite.png`.

## Étape 7 — Parrainage (20 s)

Appuyer sur **Je n'ai pas de code**.

- **Ce que vous devez voir** : l'écran de bienvenue (« Bienvenue », crédits offerts) puis **Continuer**.
- **Preuve** : `P09_bienvenue.png` *(le nombre de crédits affiché m'intéresse)*.

## Étape 8 — Catalogue et gabarit (1 min)

- **Ce que vous devez voir** : « **Choisissez un modèle de vidéo** » avec les cartes du secteur :
  « Nouvel arrivage » (35 s · 14–15 scenes · 3 prises), « Avant et après », « Montrer un produit »…
- **Preuve** : `P10_catalogue.png`.
- Appuyer sur **Nouvel arrivage** → **Preuve** : `P11_brief.png`.

## Étape 9 — Formulaire de brief (2 min)

Remplir **tous** les champs marqués `*`. « **Quartier et ville** » est plus bas : **faites défiler**.

- **Ce que vous devez observer (important)** : le bouton **Continuer** reste **grisé** tant qu'un champ
  obligatoire manque, **sans dire lequel**. Notez si vous avez dû chercher.
- **Preuve** : `P12_brief_rempli.png`, puis `P13_avant_de_commencer.png` après validation.

## Étape 10 — Caméra réelle et prises (3 min) ← *la preuve que l'émulateur ne peut pas produire*

« Avant de commencer » → **OK, je commence** → écran de guidage → **Tourner**.

- **Ce que vous devez voir** : l'image de **votre caméra** (pas un dessin), le texte de guidage,
  puis **Verrouiller et enregistrer**, qui devient **Arrêter et continuer** pendant la prise.
- Enregistrer **2 prises** (Suivant entre les deux).
- **Preuve** : `P14_camera.png` (aperçu réel) + **une vidéo écran de 15 s** (`P15_prises.mp4`)
  montrant l'enregistrement et l'arrêt.

> **Point de vigilance** : si une **porte de consentement** (« Accord du client ») apparaît alors que
> personne n'est filmé, c'est un défaut (R4) — notez-le et envoyez la capture.

## Étape 11 — Montage et export (3 min)

Aperçu de la vidéo → **Lancer l'export local** → attendre.

- **Ce que vous devez voir** : progression, puis « **Vidéo prête ! Partage-la avec tes clients.** »
- **Preuve** : `P16_export_termine.png` **avec l'horodatage visible** (durée totale de l'export).
- **Mesure demandée** : le temps écoulé entre le lancement et « Vidéo prête ! » (chronomètre du téléphone).

## Étape 12 — Lecture du fichier et partage (1 min)

Appuyer sur **Partager la vidéo** → choisir **WhatsApp** (ou l'enregistrer dans la galerie).

- **Ce que vous devez voir** : la vidéo **se lit** (image + son), le partage s'ouvre.
- **Preuve** : `P17_partage.png` + **la vidéo elle-même** envoyée sur votre propre WhatsApp
  (elle doit se lire en boucle, sans écran noir, avec la musique).

## Optionnel mais très utile (2 min)

Refaire les **étapes 2 et 4** en **paysage** (rotation automatique) : je dois savoir si
les 4 langues et le bouton Google restent atteignables. **Preuve** : `P18_paysage_langue.png`,
`P19_paysage_connexion.png`.

---

## Ce que j'en ferai

| Preuve reçue | Ce qui passe de `BLOCKED` à qualifié |
|---|---|
| Étape 1 (empreinte) | RC6 identifiée sur l'appareil |
| Étapes 2–9 | parcours d'entrée **sur la RC6** (B1) |
| Étape 4 | **connexion Google réelle** (B4) |
| Étape 10 | **caméra réelle** (B2) |
| Étapes 11–12 | **export MP4 + partage** (B3) — avec durée mesurée |
| Paysage (option) | **2 échecs paysage** tranchés (B6) |

Un seul élément manquant et le parcours concerné reste `NOT_RUN`. C'est la règle que
la mission impose, et je m'y tiendrai.
