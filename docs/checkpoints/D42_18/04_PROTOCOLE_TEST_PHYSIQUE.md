# D42.18 — Protocole de test sur appareil Android physique (fondateur)

**Exécutant : le fondateur, sur son téléphone. Aucun test physique n'a été
exécuté à ce jour — ce document est un protocole, pas un compte-rendu.**

## Pré-requis

1. Téléphone Android physique, de préférence **modeste** (RAM 2-4 Go, Android
   8 à 14) — c'est la cible de l'objectif commercial. Un 2ᵉ téléphone de test
   avec WhatsApp installé (ou le même téléphone + un contact).
2. APK à tester : la release signée officiellement **à venir (rc9)** contenant
   le correctif FGS — le binaire exact (SHA-256) sera communiqué avec la
   release. Ne PAS tester rc8 : il contient le défaut d'interruption.
   (Si le fondateur veut tester AVANT la rc9 : rc8 reste représentatif de
   tout le parcours sauf l'export long sans interruption.)
3. Mode d'emploi des preuves : à chaque étape marquée 📸, faire une capture
   d'écran (boutons Power + Volume-bas en général) ou une photo de l'écran.
4. Durée totale estimée : 20-30 minutes (plus le temps d'encodage).

## Étapes (les 15 du fondateur)

| # | Étape | Attendu | Preuve |
|---|---|---|---|
| 1 | Installation de l'APK (autoriser « sources inconnues » puis installer) | installé, icône « Vitrine Video » | 📸 écran d'installation terminée |
| 2 | Ouverture + connexion (SSO Google) | session ouverte, écran d'accueil | 📸 écran d'accueil |
| 3 | Sélection d'activité (choisir une activité) | sélection enregistrée | 📸 |
| 4 | Catalogue (parcourir) | liste des gabarits | 📸 |
| 5 | Choix du gabarit | gabarit sélectionné | 📸 |
| 6 | Brief (saisir le texte du commerce) | texte enregistré | 📸 |
| 7 | Caméra (autoriser la caméra) | viseur actif | 📸 |
| 8 | Trois prises (filmer 3 rushes) | 3 prises validées | 📸 écran de fin de prises |
| 9 | Montage | aperçu du montage | 📸 |
| 10 | Musique (choisir) | musique sélectionnée | 📸 |
| 11 | Aperçu (lecture) | lecture fluide de l'aperçu | 📸 (ou vidéo de l'écran) |
| 12 | Export : appuyer « LANCER L'EXPORT LOCAL » | statut « Export local en cours… » **+ notification « Export en cours… » dans la barre de notifications** (nouveau : correctif FGS) | 📸 notification déroulée |
| 12b | **Test T1 (spécifique D42.18)** : éteindre l'écran pendant l'export, attendre | l'export continue (notification présente au réveil ; à la reprise, l'écran affiche l'état) | 📸 après réveil |
| 13 | Attendre la fin | « **Vidéo prête ! Partage-la avec tes clients.** » + bouton « Partager la vidéo » visible | 📸 |
| 14 | Lecture : si un bouton de lecture/aperçu existe, lire ; sinon passer au partage et lire depuis WhatsApp | la vidéo se lit intégralement (durée ≈ celle annoncée), image + son | 🎥 vidéo de l'écran ou 📸 |
| 15 | Partage WhatsApp : « Partager la vidéo » → sélectionner WhatsApp → un contact | vidéo envoyée, lisible côté destinataire | 📸 sélecteur, 📸 conversation WhatsApp, 📸/🎥 lecture côté destinataire |

## Compléments demandés (partage)

- 15b. Partage vers une **autre application** (Drive, Photos, Telegram…) → 📸.
- 15c. **Annulation** : rouvrir le sélecteur puis revenir sans partager →
  l'app reste sur « Vidéo prête ! », aucun plantage → 📸.
- 15d. **Retour à l'app** après un partage réussi → l'écran est intact → 📸.

## Mesures à noter pendant l'export (étape 12-13) — priorité 4

- heure de début / heure de fin de l'export (durée totale) ;
- si possible : Paramètres → À propos → Consommation batterie de l'app
  avant/après (pourcentage) ;
- comportement si vous recevez un appel pendant l'export (optionnel) ;
- l'appareil chauffe-t-il ? (impression suffit).

## En cas d'échec d'une étape

Noter : numéro d'étape, ce qui s'est affiché (📸 de l'écran d'erreur), heure.
NE PAS réinstaller pendant le test sauf si l'app est inutilisable — les
journaux internes servent au diagnostic. Après le test, le fondateur peut
récupérer un journal via Paramètres → Applications → Vitrine Video → Stockage
(ou simplement signaler : l'équipe relaiera la procédure logcat).

## Critères de réussite globale (verdict commercial)

- Parcours 1→15 complet sans plantage ;
- export terminé **sans intervention** (même écran verrouillé) ;
- MP4 reçu et lu dans WhatsApp par le destinataire ;
- aucun crédit anormal (l'app affiche le solde : 3 au départ, 2 après un
  export réussi — vérifier sur l'écran « mon espace ») ;
- le téléphone reste utilisable pendant l'export (pas de gel complet).
