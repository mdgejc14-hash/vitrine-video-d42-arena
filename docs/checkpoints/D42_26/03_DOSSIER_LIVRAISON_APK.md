# D42.26 — DOSSIER DE LIVRAISON APK (rc12) — procédure et justification officielle

**Objet** : ce dossier rend la remise de l'APK **officiellement justifiée** et
**exécutable sans ambiguïté** par le fondateur. La qualification logicielle
est TERMINÉE (rapport final 99_RAPPORT_FINAL.md, matrice 00_MATRICE, 4 runs
consécutifs complets en vert sur le code livré). Ce qui suit est la porte de
sortie : rien ne peut être remis tant que chaque case n'est pas cochée.

---

## 1. Pourquoi un rc12 (et pas rc11)

rc11 (release privée d42.23-rc11, commit privé 2cd6991 du 08/11 09:17,
APK sha256 b052e7c9…c83bb6) est ANTÉRIEUR aux corrections produit du tour
D42.26, notamment :

- **fix UI petit écran 540×960 + S12** (D42.26-15/16/17 : garde bounds,
  preuve différée S14) — validé 5/5 variantes zéro défaut ×4 runs ;
- durcissements du harnais (sans impact produit) et docs.

Livrer rc11 = livrer un APK ne contenant PAS les corrections qualifiées.
**Le rc12 est donc obligatoire** (décision D6 du rapport final).

## 2. Périmètre exact du rc12

Base : **fbd8625** (HEAD qualifié, arène mdgejc14-hash/vitrine-video-d42-arena).
Diff produit depuis rc11 : corrections UI ci-dessus (le reste = outillage,
workflows, docs — neutres pour l'APK). Aucune modification des 600
compositions audio, aucune écriture D1/B2 audio (règle absolue respectée).

## 3. Procédure en 3 étages (ne pas inverser, ne pas sauter)

### Étage 1 — build public
Sur le dépôt arène à fbd8625 (ou miroir privé synchronisé — synchronisation
à faire par le fondateur, l'agent n'a jamais poussé au privé) :

```
./gradlew :app:assembleRelease
# produit : app/build/outputs/apk/release/app-release.apk (non signé)
#           app/build/outputs/mapping/release/mapping.txt
```

### Étage 2 — re-signature locale fondateur (keystore officiel JAMAIS versionné)
Avec le keystore du certificat officiel (celui qui a produit rc11 et
rc-audio-v2) :

```
apksigner sign --ks <keystore_officiel> --out vitrine-rc12-signed.apk app-release.apk
```

### Étage 3 — vérifications OBLIGATOIRES avant remise (toute non-conformité = abandon)

```
sha256sum vitrine-rc12-signed.apk                      # à consigner (checksums)
unzip -t vitrine-rc12-signed.apk                       # ZIP intègre
apksigner verify --print-certs vitrine-rc12-signed.apk # empreintes
sha256sum app/build/outputs/mapping/release/mapping.txt
```

**Le certificat DOIT être EXACTEMENT** (sinon ABANDON — keystore erroné) :

| Champ | Valeur attendue |
|---|---|
| Owner/Issuer | CN=Vitrine Video, OU=Mobile, O=EPD HOLDING, L=Cotonou, ST=Littoral, C=BJ |
| SHA-256 | `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192` |
| SHA-1 | `89fab9b6c2b340d64a493059bc674a06ce0cd8a3` |
| Algorithme | SHA256withRSA, RSA 2048 |
| Validité | 31/10/2026 → 23/10/2056 |

*(Empreintes relevées directement sur rc11 ET rc-audio-v2 le 09/11 — keystore
unique inter-builds, preuve 12.2. Méthode de secours sans apksigner :
`keytool -printcert -jarfile <apk>` sur une build signée V1, ou lecture du
fichier checksums de la release.)*

Puis : installation sur téléphone réel (`adb install -r`) et exécution de la
**checklist physique D8** (02_PLAN_VERIFICATIONS_PHYSIQUES.md, 45-60 min).

## 4. Conditions de porte avant remise publique (tout doit être tranché)

| # | Décision (détail au rapport final §2) | Statut |
|---|---|---|
| D1 | Arbitrage A — silence initial 1,03-3,18 s (assumer ou re-masteriser) | ⬜ fondateur |
| D2 | Arbitrage B — 54 clés titulaires absentes (uploader ou purger) | ⬜ fondateur |
| D3 | Arbitrage C — bascule caméra avant/arrière absente | ⬜ fondateur |
| D4 | Arbitrage D — brouillon inter-sessions absent | ⬜ fondateur |
| D5 | Arbitrage E — contrôle préventif stockage absent | ⬜ fondateur |
| D6 | rc12 produit + **certificat confirmé = empreintes ci-dessus** | ⬜ fondateur |
| D7 | Google Sign-In réel testé (1re connexion, expiration, isolation) | ⬜ fondateur |
| D8 | Checklist physique exécutée sans FAIL bloquant | ⬜ fondateur |
| D9 | Manifeste gabarits périmé (régénérer ou assumer le WARN) | ⬜ fondateur |

## 5. Justification officielle — chaîne de preuves (résumé)

1. **Code livré** : fbd8625, validé par 4 runs e2e-lab consécutifs complets
   (42562414209, 42573687240, 42577296432, 42581107224 — 12/12 jobs SUCCESS
   chacun) : P0 5/5 variantes zéro défaut, P1 36/0/0, **camerap 42/0/0
   intégral**, offline 14/0/0, gabarits 817, langues ×3, auth/security/backend.
2. **Audio** : 600/600 mesurées (one-shot 42542375491) — sha256 conformes,
   décodables, 0 clip, σ 0,81 dB ; 2 constats = arbitrages A/B.
3. **Backend/data** : D1 24/24 tables (restore drill 42534124616 PASS non
   destructif), backup cron armé + preuve nuit (42557585700), aucune
   fabrication client possible (api-security CI), SKYPAY 501 assumé.
4. **Intégrité/certificat** : méthode appliquée à rc11 (sha256 = checksums
   consigné, ZIP intègre, certificat lu, mapping vérifié, commit confirmé) —
   la MÊME méthode s'applique au rc12 (attendu : certificat identique).
5. **Honnêteté** : 3 FAIL-documentés (arbitrages A/B/C), 1 PARTIAL (D),
   aucun masquage ; tout NOT RUN restant est physique par nature (2.4).
6. **Budget** : 0 FCFA consommé sur tout le tour D42.26.

## 6. Après remise

Consigner dans le dépôt : sha256 du rc12 signé, empreintes vérifiées, date,
version du téléphone de test, résultats D8. Toute régression ouverte un
ticket avec étapes exactes (aucune modification des compositions audio sans
autorisation).
