# D42.23 — 08. CONFIGURATION PRODUCTION DE L'APPLICATION (Phase H)

## Alignements vérifiés (APK ↔ services)
| Élément | Valeur | Statut |
|---|---|---|
| URL API (vvApiBaseUrl → BuildConfig) | `https://vitrine-video-api.mdgejcinfluence.workers.dev` | ✓ identique au Worker déployé (wrangler.jsonc + sondes) |
| Package | `video.vitrine.app` (versionName 0.8.0-b0, constaté install E2E) | ✓ |
| Projet Firebase | `vitrine-video` (projectId gateway = audience JWKS worker) | ✓ concordant |
| Clé API Firebase | **rc10 : FACTICE (D23-3)** → **rc11 : RÉELLE** (extraite dex + sonde contrastée) | corrigé |
| AppId Firebase | `1:609889830251:web:3fbac877b49c108a93782e` | ✓ (projet réel 609889830251) |
| Client OAuth Google | `609889830251-484f8cs7k48bmegr60stddn2514beht1.apps.googleusercontent.com` (server+web) | ✓ même projet |
| Certificat signature | `758077eb1388376d8ac797db88eec976b27f7a553dc09d6d85529fbd0b33e192` (CN=Vitrine Video, O=EPD HOLDING, C=BJ) | ✓ officiel (rc10 vérifié ; rc11 signé avec) |
| Porte d'intégrité | `-PvvApkSha256=758077eb…` injecté au build (IntegrityGuard V2.0 §22 actif — APK re-signé/repacké → refus d'export) | ✓ appliqué au build rc11 |
| R8 full + shrinkResources | oui (obfuscation moteur + features, mapping.txt conservé) | ✓ |

## Parcours complet (constaté E2E rc10 — code Android inchangé depuis)
Installation → langue → (login Google : clé réelle à partir de rc11) →
activité → catalogue → gabarit → brief (5 champs, validations) → caméra →
prises → guide → aperçu → export local FGS (écran éteint 45 s) →
« Vidéo prête ! » → MP4 1080p AAC 34,99 s → historique → partage →
crédits (CONFIRMED/2). Aucune FATAL EXCEPTION. 37/37 contrôles.

## Ce qui change entre rc10-audio-v2 et rc11-production
- **Unique différence applicative : la clé API Firebase (BuildConfig)** —
  Android code identique (453e470 → 2cd6991 ne touchent que le worker,
  les workflows, la doc et gradle.properties côté clé).
- La validation E2E de rc10 (37/0/0, run 42456670342) se transpose au
  code ; le delta clé est validé par : build+tests locaux, présence
  dex, sonde contrastée identitytoolkit, et le futur login réel du test
  physique (seul test définitif de la chaîne Google Sign-In).
- Re-run release-official-e2e complet : bloqué D23-1 (privé) — prévu
  au déblocage (tag dans le privé) pour re-certifier l'artefact exact.

## Non testés (honnêteté)
- Login Google réel (Play Services + compte) → test physique A2/B1 ;
- chaîne BGM authentifiée → audio-audit-1 + test physique B2/B3/C1 ;
- parcours SKYPAY (501 par design) ; rendu longue durée sur matériel
  réel (D2).
