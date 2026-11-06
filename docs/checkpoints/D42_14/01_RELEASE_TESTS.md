# D42.14 — Tests de la vraie RC6

## 1. Identité de l'objet testé

| Élément | Valeur |
|---|---|
| Release GitHub | **436253697** — tag `v0.8.0-b0-d42.13-rc6` |
| Fichier | `vitrine-video-0.8.0-b0-d42.13-rc6.apk` — **43 134 525 octets** |
| SHA-256 | `5c3955731de9765327cc95da3ff2fc098b5dd09dc50a6716819404914c377495` |
| Paquet / version | `video.vitrine.app` · `0.8.0-b0` |
| minSdk / compileSdk | 24 / 37 |
| Signature | v2 vérifiée (`apksigner verify --print-certs`) |
| Tests unitaires du commit | 6 exécutés, 0 échec |
| Re-téléchargement | **octet pour octet identique** (2 téléchargements indépendants) |

## 2. Ce qui est prouvé sur la RC6

| Preuve | Méthode | Statut |
|---|---|---|
| Le fichier publié est intègre et reproductible au téléchargement | `sha256sum` sur deux téléchargements | **PASS** |
| Les **ressources** de la RC6 sont celles du code livré | `aapt2 dump resources` → **5 476 lignes** ; `aapt2 dump strings` → **3 674 chaînes** ; ensembles **identiques** au build release local du même commit | **PASS_STATIC** |
| La signature est valide | `apksigner verify` v2 | **PASS** |
| L'APK **s'installe et s'exécute** | — | **NOT_RUN** |

> L'équivalence `aapt2` atteste **les ressources**, pas un usage. Elle ne remplace pas un parcours exécuté.

## 3. Blocage : la RC6 n'a pas pu être exécutée — 9 tentatives

| # | Tentative | Résultat exact |
|---|---|---|
| 1 | `GET /actions/workflows` (dépôt privé) | **403** `Resource not accessible by personal access token` |
| 2 | `POST /actions/workflows/release-e2e.yml/dispatches` | **403** (idem) |
| 3 | `GET /repos/…/vitrine-video/actions/permissions` | **200** `{"enabled": true, "allowed_actions": "all"}` |
| 4 | Déclenchement par **push** (workflow `on: push`) | 3 push (`edfb583`, `37de061`, `b93646f`) ; **aucun commit du runner** dans la branche après 20 min |
| 5 | Correction d'une cause probable (`${{ inputs.* }}` au niveau du workflow) | workflow réécrit **sans aucune expression `inputs`** ; toujours aucune trace d'exécution |
| 6 | Émulateur **local** dans le bac à sable | **impossible** : `/dev/kvm` absent, 0 flag `vmx`/`svm`, 2 vCPU, 1 Go de RAM, aucun paquet `emulator`/`system-images` |
| 7 | Faire tester la RC6 par le **miroir public** | impossible sans transmettre le PAT (dépôt privé) — **interdit** |
| 8 | Publier l'APK sur le miroir public | **refusé** : rendrait public un binaire du dépôt privé (règle « ne pas exposer le privé ») |
| 9 | Lire les artefacts des runs miroir pour au moins qualifier le parcours | `GET /actions/artifacts/{id}/zip` → **401 Requires authentication** (même dépôt public) ; logs de job → **403 Must have admin rights** |

**Statut : `BLOCKED`.**

## 4. Ce qu'il faudrait — trois voies, toutes soumises au fondateur

| Voie | Coût | Ce qu'elle débloque | Décision requise |
|---|---|---|---|
| A. Portée **Actions** sur un PAT dédié | 0 FCFA | `release-e2e.yml` se déclenche et se lit par API | autoriser une portée supplémentaire (D42.10 exige une démonstration : elle est ci-dessus, tentatives 1-3) |
| B. **Runner auto-hébergé** sur une machine de la mission | 0 FCFA | exécution de la RC6 hors API | matériel + accès |
| C. **Téléphone du fondateur** (protocole 12 min) | 0 FCFA | prouve la RC6 **et** la caméra réelle **et** Google | 12 minutes d'attention |

La voie C est la seule qui lève simultanément B1, B2 et B4 (voir `00_STATE.md` §3).

## 5. Rappel de la règle respectée

> « Ne jamais présenter les résultats debug comme preuve de la release officielle. »

Tous les résultats Android de D42.14 portent la mention **APK debug** et l'empreinte
de l'APK testée figure dans chaque `summary.txt` (ex. `68f184b0…`, `89bb986e…`, `bbdb06d3…` :
trois empreintes différentes pour trois reconstructions — preuve que ce n'est pas la RC6).

## Vérification locale de la RC6 (D42.14, 6 nov. 15 h 05 UTC) — FAITE

Téléchargée depuis la release **privée** 436253697 (tag `v0.8.0-b0-d42.13-rc6`) avec le
jeton du laboratoire (jamais affiché, jamais committé) :

| Contrôle | Attendu (rapport D42.14) | Obtenu | Verdict |
|---|---|---|---|
| SHA-256 | `5c3955731de9765327cc95da3ff2fc098b5dd09dc50a6716819404914c377495` | identique (recalcul local) | **CONFORME** |
| Taille | 43 134 525 octets | 43 134 525 octets | **CONFORME** |
| Package | `video.vitrine.app` | présent dans le manifeste binaire (UTF-16) + badging officiel | **CONFORME** |
| Version | `0.8.0-b0` | manifeste binaire + badging (`versionCode=1`) | **CONFORME** |
| Signature | v2 | bloc `APK Sig Block 42` présent ; `apksigner verify` : **Verifies**, CN=Vitrine Video, O=EPD HOLDING, L=Cotonou, C=BJ | **CONFORME** |

Fichiers de preuve : `D42_14/rc6/` (APK + `SHA256SUMS.txt` + `badging.txt` +
`apksigner_verify.txt` + `build-manifest.json` + `preuve_d42_13.txt`).

### Exécution de la RC6 sur émulateur (en cours)

Le workflow `release-e2e.yml` (dépôt privé, branche `d42.14-critical-paths`) n'avait
**jamais tourné** (D10). Il a été armé ce jour :

1. `718699b` — synchronisation du harnais corrigé (`point_de_clic`, paysage, contrôles
   négatifs du brief) sur la branche privée (rien du privé n'était spécifique : vérifié
   par diff, nos versions sont des sur-ensembles stricts) ;
2. `2f57e67` — **correctif d'un défaut latent** : l'étape P0 n'installait pas l'APK
   téléchargé (`APK=rc/release.apk` désormais passé) — invisible jusqu'ici puisque le
   workflow n'avait jamais été exécuté ;
3. push `1a3e65a..2f57e67` → le déclencheur (`tools/e2e/**`) est satisfait.

Le PAT n'ayant **aucune portée Actions** (lecture ET écriture : 403 mesuré), la seule
voie d'observation est celle prévue par la conception du workflow : les marqueurs
committés dans la branche (`docs/checkpoints/D42_14/rc6/00_PREUVE_DE_VIE.txt`, puis
`01_APK_VERIFIE.txt`, `p0/`, `p1/`). Relevés en cours.
