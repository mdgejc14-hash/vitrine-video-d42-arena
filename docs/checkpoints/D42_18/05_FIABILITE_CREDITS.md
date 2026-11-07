# D42.18 — Crédits et fiabilité : analyse et plan de vérification

## État vérifié (code + preuves D42.17 — rien à refaire)

| Exigence P5 | État | Preuve |
|---|---|---|
| Une réservation par export | ✓ | `gateThen` → un seul `atomicDebit` + UNE ligne `RESERVED` (exportId UUID) ; garde `dejaEnCours` + compensation immédiate si enqueue impossible (D41-F14) |
| Aucune double consommation | ✓ | `doWork` exige une ligne `RESERVED` existante → tout redémarrage du MÊME WorkSpec réutilise le même exportId, jamais de second débit. Preuves rc8 : 5 démarrages du worker, 1 seule ligne RESERVED ; rc5-rc8 : balanceAfter=2 systématique |
| Remboursement à l'échec | ✓ | code : `COMPENSATED` idempotent (garde `already`) + bilan serveur `ok=false` ; preuve rc5 : « Tes crédits ont été rendus — réessaie » |
| Aucune perte à l'interruption | ✓ (analyse) | interruption système → aucune branche n'est exécutée → RESERVED conservé → soit le travail reprend (WorkManager persiste le WorkSpec), soit à la réouverture d'ExportActivity `reconcileOrphelines()` compense toute RESERVED > 120 s sans travail actif |
| Idempotence | ✓ | compensation : garde d'état ; consommation serveur : `eventId = exportId` (D40-A3/A7) |
| Cohérence du journal | ✓ | états RESERVED → CONFIRMED (succès) / COMPENSATED (échec définitif / orphelin) ; toute ligne reste lisible dans `export_journal` (exportId, merchantId, state, balanceAfter, ts) |

## Effet du correctif FGS sur les crédits

Le FGS ne modifie PAS le chemin crédits. Il supprime la cause des
interruptions → le worker atteint enfin CONFIRMED au lieu de boucler en
RESERVED. Point de vigilance unique : la consommation serveur
(`recordExport ok=true`) survient au succès — elle devient désormais
effectivement atteignable en CI (avant, elle n'était jamais exécutée sur
les gabarits longs).

## À re-vérifier à l'exécution (CI rc9 puis appareil physique)

1. **CI (harnais existant)** : à la fin du run, la base tirée
   (`db/databases/vitrine-local.db`) doit montrer pour l'export de la session :
   exactement 1 ligne RESERVED → état final **CONFIRMED**, balanceAfter=2,
   et `entitlements_cache.welcomeCreditsLeft = 2`. Aucune ligne COMPENSATED
   parasite.
2. **Interruption volontaire (CI)** : le harnais peut tuer l'app
   (`am force-stop`) en milieu d'export puis la relancer : attendu —
   réservation conservée, reprise du travail (ou compensation orpheline à
   la réouverture si WM a abandonné), jamais de solde < 2 sans vidéo.
   *À ne programmer que si le fondateur l'exige : chaque scénario = 1 run.*
3. **Physique (protocole 04)** : solde affiché 3 → 2 après l'export réussi ;
   si l'export échoue sur le téléphone : solde revenu à 3 et message
   « crédits rendus ».

## Non-régression automatisée existante (intacte)

- tests crédits du module data (acquis, non rejoués) ;
- `P1_*` du harnais E2E (30 PASS) ;
- nouveaux tests `ExportForegroundInfoTest` (FGS, sans impact crédits).
