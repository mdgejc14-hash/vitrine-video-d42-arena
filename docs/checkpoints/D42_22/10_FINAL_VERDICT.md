# D42.22 — 10. VERDICT FINAL (brouillon — à figer)

## État au [À COMPLÉTER]
- main = d42.13-lab = `145ece6` ; android-ci VERT (42456126318) ;
  e2e-lab : [À COMPLÉTER] ; API Security CI : FAILURE D22-1 (secrets Firebase
  absents du dépôt public — preuve fraîche 42455937366 06:44:32).
- Déploiement Worker : BLOQUÉ D22-1 (jeton Cloudflare vide dans CE dépôt ;
  runs 01/11 réussis = dépôt privé). Action fondateur documentée (08).
- Audio : qualification code + données faite (03/04/05) ; audit production
  (600/30×20/B2) PRÊT (audio-audit-1) — exécution bloquée D22-1.
- Release rc10-audio-v2 : construite + signée + publiée ; étage 3 : [À COMPLÉTER].

## Verdict : [À FIGER — GO CONDITIONNEL si étage 3 vert]
Conditions restantes (toutes = actions fondateur) :
1. Ajouter CLOUDFLARE_API_TOKEN dans CE dépôt → tag `worker-deploy-3`.
2. Ajouter FIREBASE_* (+B2_*) → re-test API Security CI + tag `audio-audit-1`.
3. Test physique final sur téléphone (checklist ci-dessous).

## Checklist du test physique final (fondateur — APRES tout le reste)
1. **Installation** : désinstaller toute version précédente, installer
   `vitrine-release-signed.apk` (rc10-audio-v2) — refuser les sources
   inconnues NE doit pas être nécessaire (APK direct : accepter l'avertissement
   Android). Vérifier : l'app s'ouvre sur l'écran langue.
2. **A1 Langue + onboard** : choisir le français → carrousel → activité →
   catalogue visibles sans crash.
3. **A2 Session locale** : poursuivre sans compte (repli documenté) ;
   si compte Google utilisé : connexion puis écran espace.
4. **B1 Parcours complet** : choisir gabarit → brief (5 champs) → filmer
   2-3 prises AVEC VOIX (parler réellement) → guide → aperçu → **LANCER
   L'EXPORT LOCAL** → notification visible → écran éteint 1 min → retour :
   « Vidéo prête ! ».
5. **B2 AUDIO (le point critique)** : lire le MP4 exporté (partage → lecture) :
   - la voix doit être audible et dominante ;
   - la musique doit être présente, en retrait sous la voix (ducking) ;
   - fondu de fin avant la carte finale ;
   - casque + haut-parleur, volume 50 % puis 100 % (aucune saturation).
6. **B3 Sans voix** : refaire un export sans parler : la musique seule doit
   être audible (retournement du défaut D42.18).
7. **C1 Anti-répétition** : exporter 3 fois le même gabarit : la musique doit
   varier (pas 3 fois la même).
8. **C2 Crédits** : solde initial affiché ; chaque export décrémente de 1 ;
   échec réseau pendant un export → crédit restitué ; pas de crédit gratuit
   en rejouant hors ligne.
9. **D1 Sécurité** : l'app installée depuis le certificat officiel fonctionne ;
   toute version re-signée/repackée doit refuser l'export (« Vérification de
   sécurité échouée »).
10. **D2 Partage** : feuille de partage Android → WhatsApp/Files → le MP4
    reçu se lit sur un AUTRE appareil.
11. **D3 Langues** : repasser l'app en EN/ES/JA : écrans + notifications
    d'export traduits.

## Rapport final (messagerie + GitHub) — contenu exigé
Commits, workflows, releases, APK, SHA-256, certificats, preuves déploiement,
résultats émulateur, tests API, état 600 sons, 20 variations/gabarit, défauts,
non testés. [À COMPLÉTER À LA FIGE]
