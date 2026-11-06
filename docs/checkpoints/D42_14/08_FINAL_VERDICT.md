# D42.14 — Verdict

**6 novembre 2026, 14 h 15 UTC.** Échéance : 7 novembre, 10 h 00 (Bénin).

## Verdict

# NO-GO commercial

Trois parcours critiques restent **non exécutés**, et aucun GO ne peut être prononcé sur
des parcours non exécutés. Le NO-GO de D42.13 est donc **maintenu**, pour des raisons
**plus précises** qu'hier.

## Ce qui est prouvé aujourd'hui

| # | Preuve | Nature |
|---|---|---|
| 1 | RC6 intègre : SHA-256 identique sur deux téléchargements, signature v2, ressources identiques au build release (5 476 lignes / 3 674 chaînes) | vérification de fichier |
| 2 | Worker démarré sur les 12 migrations : **15 contrôles HTTP PASS / 0 FAIL**, reproduits en CI **et** dans le bac à sable | serveur réellement lancé |
| 2bis | **18 contrôles authentifiés PASS / 0 FAIL** : dotation, idempotence, anti-fraude C16, isolation A/B, auto-parrainage refusé, `501` de facturation | Worker réel importé, JWKS locale, D1 réelle |
| 3 | **4 langues** : chaque écran affiché dans la langue choisie jusqu'au catalogue (fr/en/es/ja), 3 jobs verts | exécution sur appareil |
| 4 | Parcours amont complet jusqu'à la **sélection de gabarit** (carrousel vérifié écran par écran) | exécution sur appareil |
| 5 | **6 causes racines** de faux résultats trouvées dans le harnais et corrigées (faux PASS, faux échecs, clavier, défilement) | code + runs |
| 6 | Matrice 120 combinaisons, **8 lignes non conformes nommées** | analyse statique |
| 7 | 3 illustrations distinctes | captures |

## Ce qui bloque

| # | Parcours | Pourquoi ce n'est pas contournable |
|---|---|---|
| B1 | **RC6 exécutée** | 403 Actions sur le dépôt privé ; pas de KVM local ; artefacts publics en 401 ; diffuser l'APK privée est interdit |
| B2 | **Caméra réelle** | aucun téléphone dans le laboratoire |
| B3 | **Brief → export MP4 → partage** | la validation du brief n'aboutit pas encore sur émulateur |
| B4 | **Connexion Google réelle** | ni client OAuth configuré, ni compte de test |
| B5 | **Crédits / parrainage / isolation HTTP** | **levé par le banc local (18/18)** — reste `PASS_PROD` non atteint faute de compte Firebase |
| B6 | **Paysage** | mesure corrigée, verdict définitif en attente des captures |

## Pourquoi ce n'est pas de la prudence excessive

Un GO signifierait : « un commerçant installe cette version, filme, exporte et partage ».
Or **personne n'a encore filmé avec un vrai capteur, ni exporté un MP4 depuis cette version**
dans un environnement contrôlé. Le seul endroit où la RC6 peut tourner aujourd'hui est le
téléphone du fondateur — protocole prêt, 12 minutes, `09_PROTOCOLE_PHYSIQUE.md`.

## Ce qui ferait basculer le verdict

| Condition | Effort | Débloque |
|---|---|---|
| Protocole physique exécuté (12 étapes, captures + durée d'export) | 12 min | **B1, B2, B4** (+ B6 en option) |
| Export MP4 abouti sur émulateur (2 prises + fichier + `ffprobe`) | 1 run | **B3** |
| Compte Firebase de test (e-mail/mot de passe) | 10 min | **B5** |
| Fichier secret restauré (`~/.d42_secrets/gh_token.txt`) | immédiat | reprise des push et du dépouillement des artefacts |

## Décision

**NO-GO maintenu.** La prochaine revue peut prononcer un GO dès que B1–B4 sont levés par des
preuves datées. Aucune de ces preuves ne peut être produite par du code : elles exigent un
appareil, un compte ou une permission.
