# CARTOGRAPHIE 2 — Architecture Serveur & Synchro (Local-First, 0 FCFA)

Légende : ✅ livré · 🎯 cible de ce cycle · ⏳ planifié.
Principe : **le téléphone produit TOUT sans réseau** ; le serveur ne sert que
3 choses légères : gabarits JSON, crédits/abonnements, audit. Coût fixe = 0 FCFA
(Cloudflare free tier + R2 free tier + aucune API voix payante : la voix est celle
du commerçant, captée pendant le tournage INS).

## 1. Schéma global

```
+======================== TELEPHONE (offline-first) ========================+
|                                                                           |
|  UI Compose (E1..E7)                                                      |
|     |                                                                     |
|  MOTEURS LOCAUX (0 reseau)                                                |
|   INS camera (3A, R4) -> rushs mp4 locaux                                 |
|   MotionComposition Media3 (plans, z(t), typo) -> video finale locale     |
|   AudioChain (mix mesure) -> piste finale locale                          |
|     |                                                                     |
|  CACHE LOCAL (source de verite offline)                                   |
|   catalog.json + vignettes (fallback offline)      ✅ CatalogRepository   |
|   session vv_session, langue, secteur              ✅ SharedPreferences   |
|   brouillons brief + rushs                           ✅ fichiers cache     |
|   🎯 coffres AES-256 (session/brouillons)            ⏳ Tink/EncryptedPref |
|     |                                                                     |
|  WORKMANAGER (taches locales + sync silencieuse)                          |
|   export video (unique, KEEP)                      ✅                     |
|   🎯 sync gabarits periodic (12 h, charging+idle)  ⏳                      |
+===============================|===========================================+
                                | HTTPS (rare, leger, compressible)
                                v
+======================== CLOUDFLARE (0 FCFA) ==============================+
|  WORKERS v0.9.0 (sans secret auth : JWKS Firebase distant)   ✅ Phase A   |
|    GET  /health                                    ✅ status/db/schema    |
|    GET  /api/v1/templates/[canary/]manifest.json   ✅ JSON gabarits B2    |
|    GET  /api/v1/users/me + credits                 ✅ (JWKS)              |
|    ⏳ POST /api/v1/billing/checkout + webhooks     §2.4 additif           |
|    cron 0 3 * * * audit orphelins B2 (lecture seule)              ✅      |
|  D1 : prod 0dacf519-... / preview 5b9060b1-... (11 tables, 0001-0003) ✅   |
|  R2 : vignettes gabarits (ListObjectsV2 seule exposition)         ✅      |
+===========================================================================+
```

## 2. Flux de synchronisation (déclencheur / fréquence / repli offline)

| Flux | Déclencheur | Fréquence | Repli offline | Statut |
|---|---|---|---|---|
| Manifeste gabarits JSON | ouverture catalogue | à chaque ouverture, cache d'abord | catalogue cache complet (180 skins) | ✅ |
| Vignettes B2 | affichage cartes | lazy, LruCache mémoire | placeholder « … » + cache disque | ✅ |
| Sync silencieuse gabarits | WorkManager periodic | 🎯 12 h, contraintes charging+idle | aucune action utilisateur, échec silencieux | ⏳ |
| Solde crédits / abonnement | enqueue export | 1 fois par export, JWT en cache | grace : export autorisé si JWT valide < 24 h, sinon paywall à épuisement (D13) | ✅ logique / 🎯 grace période |
| Webhooks paiement (crédits) | FedaPay/CinetPay → worker | événementiel | idempotence + re-vérification serveur | ⏳ §2.4 |
| Audit orphelins B2 | cron worker | 0 3 * * * | n/a (serveur) | ✅ |

## 3. Règles d'or Local-First (contrats)

1. **Aucun écran ne dépend du réseau** hors E2 (SSO initial) : langue, secteur,
   catalogue, brief, tournage, montage, preview = 100 % locaux.
2. **Le serveur ne bloque jamais le rendu** : un échec réseau ne produit jamais
   un écran vide, toujours le cache + bannière discrète (`catalog_offline`).
3. **Crédits sans alourdir l'app** : vérification = 1 requête légère à l'export,
   jamais de SDK billing embarqué ; le paywall s'affiche seulement à épuisement.
4. **Synchro silencieuse = invisible** : WorkManager periodic, silent notification
   uniquement si nouveaux gabarits utiles au secteur de l'utilisateur.
5. **0 FCFA garanti** : Workers/D1/R2 free tier ; voix = commerçant réel ;
   aucun service tiers payant dans la chaîne de rendu.
