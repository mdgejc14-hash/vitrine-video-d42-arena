# D42.6 — Validations fonctionnelles par rendu réel

Date : 2026-11-04. Dépôt canonique (privé) `mdgejc14-hash/vitrine-video` branche `d42.5` = `ef1bcfb`.
Miroir public d'exécution `vitrine-video-d42-arena` branche `main` = `68f932a`.
Toute preuve ci-dessous vient d'un **MP4 produit par le moteur**, jamais d'une lecture de JSON.

---

## 1. Couverture 120 combinaisons (30 gabarits × 4 langues)

Run `41800424067` (en/es/ja, 24 lots) + run `41797810437` (fr, 8 lots) : **32/32 lots verts**.

| Mesure | Valeur |
|---|---|
| Combinaisons rendues | **120 / 120** |
| `ok=true` | 120 / 120 |
| Erreurs | 0 |
| Collisions de nom de fichier | 0 |
| Volume | 1,3 Go |
| Temps de rendu cumulé | 254 min (71–200 s par rendu) |
| Langues non repliées sur le français | 0 libellé français résiduel en en/es/ja |

Manifestes : `docs/audit/preuves_d426/manifestes_120.json` (sha256 par MP4).

---

## 2. Défaut P1 n°1 — `{pourcentage}` jamais calculé → « -% » à l'écran

**Trouvé par le rendu, invisible en test.** Six gabarits T4 (`batiment_travaux`,
`coiffure_beaute`, `immo_auto`, `restaurants_maquis`, `shops_small_business`,
`vetements_mode`) affichent la scène 6 « -{pourcentage}% ». La variable est déclarée dans
`variables_calculees` du gabarit mais le moteur ne la calculait pas : elle était
substituée par une chaîne vide.

**Correctif 1** : `TexteCommerce.pourcentageReduction` (calcul pur, conditions du gabarit
respectées) + `GabaritBeatSheet.substitute` qui résout les variables calculées d'abord.

**Constat après correctif 1** (run `41807945015`) : le tiret orphelin restait présent
**6 fois par langue**, parce que le harnais fournit `ancien_prix = prix` → aucune réduction
à calculer → le texte se réduisait à « -% ». Cas réel : un commerçant qui ne saisit pas
d'ancien prix voyait « -% » dans sa vidéo.

**Correctif 2** : un texte qui, après substitution, ne contient plus ni lettre ni chiffre
n'est plus dessiné (règle générale, pas un cas particulier du « % »). Le harnais fournit
désormais un ancien prix = prix + 25 % (réduction 20 %) pour exercer la variable de bout en bout.

**Preuve finale** — run `41811176998`, 24/24 rendus verts (6 gabarits T4 × 4 langues) :

| Langue | `-%` orphelin | Libellé de réduction dessiné |
|---|---|---|
| fr | **0** (avant : 6) | `-20%` |
| en | **0** (avant : 6) | `-20%` |
| es | **0** (avant : 6) | `-20%` |
| ja | **0** (avant : 6) | `-20%` |

Tests : `pourcentage - jamais de tiret orphelin a l ecran` (fixture `vetements_mode_T4`),
`pourcentage de reduction - calcule comme le declare le gabarit`. 30/30 verts localement.

---

## 3. Défaut P1 n°2 — les 9 SFX n'étaient jamais alimentés à leur date

**Mesure sur le MP4** `immo_auto_T4_en.mp4` (33,01 s) : le gabarit planifie **15 repères SFX**
(0,00 / 2,20 / 3,88 / 5,88 / 10,39 / 12,62 / 15,04 / 18,96 / 20,58 / 21,82 / 22,88 / 23,99 /
25,26 / 26,63 / 28,50 s). Seuls les **4 derniers** produisaient un transitoire mesurable.

**Cause (code)** : dans `BgmSfxAudioMixer.drainFeeds`, la boucle SFX partageait le garde
d'alimentation consommé par la musique (`FEED_GUARD = 8` blocs par appel). Une BGM plus longue
que la composition (45 s de banc pour 33 s de rendu) ne s'épuise jamais : elle absorbait les
8 blocs à chaque appel et laissait `guard == 0` à l'entrée de la boucle SFX, qui ne tournait
donc jamais. Les SFX n'apparaissaient qu'en fin de composition.

**Correctif** : budget `sfxGuard` propre aux SFX, indépendant de celui de la musique. Le chemin
musique est inchangé. Test de régression ajouté (`les SFX sont alimentes meme si la BGM n est
jamais epuisee`), exécuté par la CI dans `:ins-effects:testDebugUnitTest`.

**Constat restant, non corrigé volontairement** : à la valeur contractuelle **SFX −25 dB**
(≈ −40 dBFS pour un WAV à −15 dB moyen), les SFX restent **~19 dB sous la voix** dans le mix
final : un auditeur ne les perçoit pas. Changer ce niveau est une décision de contrat, pas un
correctif technique — elle n'a pas été prise unilatéralement.

---

## 4. Audio — ce qui est mesuré, ce qui ne l'est pas

Analyse `ffmpeg` du MP4 sorti du moteur (profil validation 960×540, 33,01 s) :

| Mesure | Résultat |
|---|---|
| Piste audio présente | AAC LC, **48 000 Hz, mono**, 131 kb/s |
| Niveau moyen exporté | −21,1 dB |
| Crête | −11,8 dB (aucun écrêtage) |
| Silences > 0,4 s | 0 |
| Niveau du rush (voix) | −21,1 dB moyen, −12,0 dB max |
| Niveau du banc BGM | −39,1 dB moyen → **−59 dB** après le gain −20 dB |
| Transitoires au-delà de +1,2 dB | 2,20 s (+1,20) / 22,88 s (+4,43) / 25,26 s (+3,55) / 26,63 s (+3,51) / 28,50 s (+2,91) |

**Conclusion honnête** : la chaîne audio fonctionne (piste présente, pas d'écrêtage, SFX
désormais alimentés — le transitoire à 2,20 s apparaît avec le correctif et pas avant), mais :

- la **BGM du banc est inaudible** (−59 dB après gain) : le rendu ne prouve pas la présence
  perceptible de la musique. Les 600 pistes de production mesurées à ≈ −16 LUFS (D39) ne sont
  pas dans le dépôt : la vérification de niveau en production reste à faire ;
- le **ducking n'est pas démontrable** ici, faute de musique audible à duckifier ;
- la **voix** du rendu est le son du rush, pas une synthèse : la TTS n'existe pas sur
  l'émulateur, donc « voix » au sens produit (synthèse) reste **non testée** ;
- l'`ExportVerifier` ne contrôle **aucune** propriété audio (durée, résolution, débit,
  images non noires seulement).

---

## 5. Caméra / multi-prises

Le harnais injecte les **3 rushes** du banc (`rush_1..3.mp4`, 12 s chacun, 720×1280, audio AAC
48 kHz mono) via `client_rushes`, donc **chacun des 120 rendus est un montage à 3 prises**
(cas nominal D23). Les mouvements de caméra passent par `CameraMoves.effectsFor(plan)` dans le
même chemin de composition. Limite : la qualité perçue des mouvements n'est pas mesurée, seule
leur présence dans la composition est prouvée (28 à 40 plans par vidéo).

---

## 6. Non testé à cette date

| Point §6 | État | Raison |
|---|---|---|
| Six valeurs commerciales à l'image | partiel | dessinées (logcat `8b.texte`), lisibilité à l'image non vérifiée plan par plan |
| Anomalies de texte | 0 sur 1 792 textes (audit typo) | statique, pas à l'image |
| Prix / badge | dessinés ; badge 30/30 | idem |
| 30 gabarits | 120/120 rendus | — |
| Audio BGM | **non probant** | banc BGM à −39 dB |
| Voix (TTS) | **non testé** | pas de TTS sur l'émulateur |
| Ducking | **non démontré** | musique inaudible dans le banc |
| 9 SFX | alimentation corrigée ; audibilité **non conforme** | −25 dB sous la voix |
| Quotas / sync / parrainage / hors-ligne / droits | **non testés** | hors du chemin de rendu |
| Sécurité serveur | non testée cette session | — |
| Parcours A→Z | **non fait** | téléphone réel indisponible (`BLOCKED_ENVIRONMENT`) |

---

## 7. Blocages durs

1. **Minutes Actions du dépôt privé épuisées** (annotation GitHub « recent account payments
   have failed or your spending limit needs to be increased »). Tout job privé échoue en ~4 s,
   0 étape, `runner_name` vide. Conséquence : **aucun APK release signé ne peut être produit**,
   le keystore (`VV_KEYSTORE_B64`) n'existant que dans le privé.
2. L'artefact `d42-apk` du miroir contient **`app-debug.apk`** (60,9 Mo) et
   `app-debug-androidTest.apk`, **pas** de release signé : il ne peut pas servir d'APK candidat.
3. Téléphone réel / ADB : `BLOCKED_ENVIRONMENT` (installation et lancement non vérifiables).

---

## 8. État Git

| Dépôt | Référence | SHA |
|---|---|---|
| Privé `d42.5` | corrections livrées | `ef1bcfb` |
| Privé `main` | intacte | `74edd98` |
| Privé `d42.2` | intacte, non fusionnée (PR #2) | `2a6906c` |
| Miroir `main` | exécution CI | `68f932a` |

CI verte sur le miroir à `68f932a` : `ktlintCheck`, `detekt`, `testDebugUnitTest` (tous
modules, dont `:ins-effects` et `:data`), `checkModuleGraph` — `BUILD SUCCESSFUL`.
Le privé reste inopérant pour raison de facturation (voir §7).
