# D42.32 — Galerie de revue visuelle (Phase B, avant/approval fondateur)

> **Statut : SQUELETTE** (recréé après rollback sandbox — commit original perdu).
> Les captures seront déposées au commit candidat Phase B, AVANT la porte
> d'approbation. **AUCUNE capture retouchée** ; toute capture est identifiée
> `emulateur` (Pixel 5 API 34, laboratoire GitHub Actions). FLAG_SECURE actif
> en production : documenté, JAMAIS contourné — les captures de laboratoire
> sont prises sur build debug laboratoire (e2e), hors périmètre FLAG_SECURE.

## Pourquoi cette galerie

Le fondateur approuve visuellement l'app avant toute RC16 (§12). Cette galerie
est la pièce à conviction : chaque correction D42.32 montrée avant/après,
chaque écran inventorié, chaque gabarit vérifié, preuves de tests jointes.

## Contenu

| Fichier | Rôle |
|---|---|
| `GABARITS_INVENTAIRE.csv` | 30 gabarits réels (6 secteurs × 5 formats T1-T5) : durée, scènes, ratio, capture |
| `SCREEN_INVENTORY.csv` | 18 écrans/composants réels du parcours + campagnes e2e existantes |
| `BEFORE_AFTER.csv` | 12 corrections D42.32 (Lots 1-10 + §4 + §6) avec commit exact et écrans |
| `UX_AUDIT.md` | 7 constats UX de l'audit initial + statut de correction |
| `captures/` | *(à venir)* PNG authentiques, identifiés émulateur, par écran |

## Conventions captures

- Nom : `captures/{slug-écran}_{condition}.{png}` — conditions : `fr`, `en`,
  `petit_ecran`, `clavier`, `font130`, `offline`…
- Référence « avant » = RC15 (galerie D42.31 conservée) ; « après » = commit
  candidat Phase B. Une correction sans différence visible le dit explicitement.
- Chaque image est liée au run GitHub Actions qui l'a produite (run id + job).

## Porte d'approbation (§12)

1. Fondateur parcourt cette galerie (GitHub rend les PNG visibles directement).
2. Approbation ⇒ Phase C : APK signée officiellement, checksum, E2E sur l'APK
   exacte, release GitHub, test capteur physique par le fondateur.
3. Refus ⇒ corrections ciblées, nouvelle galerie, nouvelle passe. RC15 reste
   la référence tant que la porte n'est pas passée.
