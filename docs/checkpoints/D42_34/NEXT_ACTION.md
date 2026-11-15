# NEXT_ACTION — D42.34 finalisation visuelle intégrale (ordre fondateur 17/11)

Base protégée : D42.34 fonctionnel 2dfd907 (CI SUCCESS, 360 tests).
Chaîne visuelle : 60a9d51 (A) → 91ad5a6 (B) → 57e720f (D 10/39) → bdee8f7 (C) →
e4f23e3 (recaptures carrousels/secteurs) → 18f8f21 (F galerie V1) → prompts (à committer).

## ÉTAT DES LOTS

- **A** TERMINÉ — rollback #13 isolé, re-clone partiel propre.
- **B** TERMINÉ — 11_INVENTAIRE_COMPLET_ECRANS.csv (73 écrans/états).
- **C** TERMINÉ — 10_AUDIT_FIDELITE_DESIGN.md (34 maquettes : 18 CONFORME /
  5 ÉCART / 4 NON PROUVÉ / 7 NON APPLICABLE, méthode PIL+code assumée).
- **D** EN COURS 10/39 — carrousels(3)+secteurs(6)+apercu batiment T1 intégrés ;
  mécanisme ApercuGabarit compilé et vérifié (build local + CI 43710292516 SUCCESS).
  **29 aperçus restants : prompts prêts en fin de GENERATED_ASSETS.md.**
- **E** VÉRIFIÉ SANS CORRECTION CODE — VR-051/059/063/064 déjà corrigés en
  CR-4 (phases KEY_PHASE, TexteBonjour, CTA « Choisir … » FR/EN). Reste des
  RECAPTURES uniquement (→ F).
- **F** V1 FAITE — visual-review/README.md (97 entrées, 20 sections, zéro lien
  mort) + 12_MANIFEST_GALERIE.csv + script régénérable scripts/galerie_lotf.py.
  Recaptures D34-11/13/14/15 (post-images) incluses.
- **G** PAS COMMENCÉ — 13_RAPPORT_CONFORMITE_VISUELLE.md après le reste.

## PROCHAINES ÉTAPES (ordre)

1. **Vérifier CI** de bdee8f7 (43711253813), e4f23e3 (43711677451),
   18f8f21 (43711914577) — attendu SUCCESS (docs/captures seuls, zéro code).
2. **Lot D suite (AU PROCHAIN TOUR, limite 10 images/tour)** : générer lot 1
   (batiment T2–T5, coiffure T1–T5, immo_auto T1 — prompts prêts), convertir
   PIL 640×360 webp q86, intégrer drawable-nodpi + ApercuGabarit.map, update
   GENERATED_ASSETS + inventaire VR-016→019, commit+push. Puis lot 2, lot 3
   les tours suivants.
3. **Recaptures Lot F** après Lot D complet : relancer
   :feature-catalog:testDebugUnitTest (tests en secteur Mode → penser à un
   test secteur Bâtiment pour montrer les aperçus), remplacer D34-01/02/03,
   ajouter paywall CTA FR/EN, dashboard « Bonjour, {prénom} », montage phases,
   consentement R4 (dialogue), dialogue reprise ; régénérer la galerie
   (`python3 scripts/galerie_lotf.py` — extraire d'abord /tmp/apres33 et
   /tmp/maquettes si sandbox réinitialisé : git archive origin/...).
4. **Lot G** : 13_RAPPORT_CONFORMITE_VISUELLE.md + validation finale
   (tests ciblés, CI verte, workspace < 100 MB).

## RAPPELS PERMANENTS

- Toolchain locale : cmdline-tools **15859902** (13114758 échoue : pas de
  platforms;android-37) ; la plateforme s'appelle désormais **android-37.0**.
  JDK17 /opt/toolchain/jdk-17, swap 2G à recréer si reset (`sudo mkswap`).
- gradle.properties local (1024m/640m) JAMAIS committé — `git checkout` avant
  tout commit ; valeur repo = 2048m/900m.
- Tests visuels : build/visual-check/*.png → copie manuelle visual-review/.
- Jamais de push main ; jamais d'incomplet sur la branche sans CI vérifiée ;
  checkpoints commit+push+VÉRIFICATION après chaque avancée.
- generate_image : 10/tour — traiter+committer immédiatement chaque lot.
- Aucune fausse capture, aucun FAIL→PASS, approbation finale = fondateur seul.
