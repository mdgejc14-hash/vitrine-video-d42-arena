# NEXT_ACTION — D42.34 ordre final (génération en chaîne, échéance 18/11)

Base : 2dfd907 (fonctionnel, immuable) → … → c03159b (HEAD).
Chaîne de ce tour : e645e46 (file+scripts) → 2c69d77 (LOT 1) → 82c2402
(VERIFIED) → 8930838 (blocage lot 2 consigné) → c03159b (preuves rendu + test).

## REPRISE IMMÉDIATE (prochain tour) — LOT 2/3

**Limite plateforme : 10 images générées par tour (stricte, vérifiée).**
Le lot 1 a consommé le quota de ce tour ; le lot 2 a été refusé
(« Image generation limit of 10 reached for this turn ») et remis PENDING.

```
cd /home/user/lab23
python3 scripts/process_catalog_asset_queue.py next 10   # réserve lot 2
# → générer les 10 images via l'outil (prompts affichés par next)
#    fichiers : /home/user/assets_gen/apercu_<secteur>_T<n>.png
python3 scripts/process_catalog_asset_queue.py integrate <ids...>
python3 scripts/process_catalog_asset_queue.py emit-map && ... verify
git add -A && git commit && git push   (+ git checkout gradle.properties avant)
# vérifier fichiers distants (API contents 200) puis mark-verified <ids...>
```

Lot 2 : immo_auto T2-T5, restaurants_maquis T1-T5, shops_small_business T1.
Lot 3 (ensuite) : shops T2-T5, vetements_mode T1-T5 (9 images).

## Après les 30/30 (même tour que le lot 3 si quota partagé sinon suivant)

1. `verify` final : 30 fichiers, 0 doublon, map complète.
2. Recaptures (§6) : remplacer D34-01/02/03 (catalogue définitif : étendre
   D34Lot6 aux 6 secteurs), carrousels D34-11/13/14 + secteurs D34-15 déjà
   faits, montage phases, dashboard Bonjour {prénom}, paywall FR/EN CTA,
   consentement R4, dialogue reprise, export prêt. Tests Robolectric,
   copie build/visual-check → visual-review/.
3. Inventaire (§7) : vérifier exhaustivité vs code (73 = minimum).
4. Galerie (§8) : régénérer scripts/galerie_lotf.py (extraire avant
   /tmp/apres33 + /tmp/maquettes : raw.githubusercontent + PAT, le clone est
   blob:none). Ajouter section « 30 gabarits et leurs aperçus ».
5. Lot G (§13) : 13_RAPPORT_CONFORMITE_VISUELLE.md.

## Pièges connus (ce tour)

- **Remote git perdu à chaque reset sandbox** (.git/config non persisté) :
  `git remote add origin https://x-access-token:$(cat ~/.d42_secrets/gh_pat_fondateur.txt)@github.com/mdgejc14-hash/vitrine-video-d42-arena.git`
  — sinon push échoue en silence (« and the repository exists »).
- Identité git à refaire après reset : user.name d42-agent / email noreply.
- Toolchain : JDK /opt/toolchain/jdk-17.0.21+9, cmdline-tools 15859902,
  platforms;android-37.0, build-tools 37.0.0 — swap 2G à recréer si reset
  (sudo fallocate …/mkswap/swapon).
- gradle.properties local 1024m/640m JAMAIS committé.
- git archive sur blobs D33 échoue (clone filtré) : utiliser raw.githubusercontent + PAT.
- build/visual-check/*.png : copier les captures vouluables avant rm -rf build.

## Statut file

10/29 VERIFIED (lot 1) + batiment T1 préexistant = **11/30 aperçus intégrés**.
