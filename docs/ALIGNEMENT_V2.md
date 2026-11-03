# ALIGNEMENT V2.0 — Spécification maître ↔ code existant ↔ stratégie d'assemblage

Source : `Spécification V2.0 · Kit d'ingénierie moteur` (78 p, 29/10/2026, joint PDF).
Règle de lecture : la spec elle-même déclare « moteur, musiques et SFX non fournis
ni testés ici ; services réels non audités » → ce document fixe ce qui est DÉJÀ
couvert par le code testé, ce qui est ADDITIF, et ce qui attend un téléphone réel.

## 1. Matrice d'alignement (spec → existant → delta)

| Exigence V2.0 | Couverture actuelle | Delta / décision |
|---|---|---|
| R1 marqueurs SCxx in/out par guide, reprise remplace la prise | overlay guidé + rushs physiques par prise | 🔧 persister SC_DEBUT/SC_FIN par prise (Room) + horloge média réelle |
| R2 vitesse source prioritaire, pas de double accélération | clipping Media3 sans speed effect | ✅ conforme ; garde-fou test à ajouter |
| R3 effets de vitesse des cartes → animations | transitions cut/swipe/flash/glitch | 🔧 mapper « speed cards » du gabarit JSON vers TimestampWrapper |
| R4 minuteur guide vocal, scènes à durée fixe | jauge de scène + beat sheet | ✅ (durées = beat sheet, cohérent) |
| R5 visage parlant & voix même prise à 1× | gate R4 + prise unique par guide | ✅ ; test d'alignement prise/voix à ajouter |
| R6 22 transitions durées+replis | 4 transitions testées | ⏳ étendre catalogue transitions (JSON Drive) |
| R7 effets légers + replis petits téléphones | DeviceProfiler/EncoderProbe classes | ✅ |
| MP4 final sous gardien après permis, 0 crédit = 0 MP4 | absent | 🎯 `core-guard` (ce cycle) + NDK `vvguard` (commit suivant) |
| Reçu ECDSA P-256 (Keystore), RFC 8785, fallback logiciel signalé | absent | 🎯 `core-guard/Receipt` |
| Enveloppe VVSH1 (nonce 12, GCM 16, SHA-256 global, AAD RFC 8785, keywrap Keystore) | absent | 🎯 `core-guard/Vvsh1` + vérif native NDK |
| Ancre temporelle monotone | absent | 🎯 `core-guard/MonotonicAnchor` |
| Anti-modding : SHA-256 APK, anti-resign/Frida/Lucky | absent | 🎯 `IntegrityGuard` (heuristiques honnêtes) + Play Integrity ⏳ |
| Manifeste éditeur signé, clé publique embarquée | manifest non signé | ⏳ signature hors app + vérif app (clé injectée build) |
| Audio : détection voix, mix, loudness, limiting on-device | AudioChain = contrat + ffmpeg banc | ⏳ module PCM natif N2 (spec §7) ; banc assumé en attendant |
| Mission 600 (60 locales/540 cloud/9 SFX) | aucune musique | ⏳ dépend Drive/droits ; fallback « sans musique » documenté par la spec |
| Workers/D1/B2 URLs HMAC | ✅ Phase A + uploads signés | ✅ (RAPPORT_AUDIT_SERVEUR.md) |
| iOS AVFoundation/Metal | PWA (décision D5) | hors périmètre Android v1 |

## 2. Stratégie d'assemblage (décisions d'architecte)

1. **Le compositeur Media3 RESTE le cœur de rendu** : il utilise déjà MediaCodec +
   OpenGL ES en interne ; la spec autorise Media3 pour « les tâches qui ne créent
   pas le MP4 final ». Le **gardien natif** prend le contrôle APRÈS composition :
   vérifications (crédits, ancre, intégrité, tag VVSH1) puis, en N2, remux/encode
   final MediaCodec NDK sur vrai téléphone (prototype spec §5 impossible au sandbox).
2. **Crypto asymétrique & matériel de clé = Android Keystore/java.security**
   (clés non exportables, impossibles en native sans keywrap) ; **natif C/C++ =
   portes, tags SHA-256, anti-tamper, export final N2**. Répartition documentée,
   conforme à l'esprit VVSH1_KEYWRAP de la spec.
3. **Rien n'attend Drive pour le gardien** : formats (RFC 8785, VVSH1, ECDSA DER
   base64url) sont spécifiés dans le PDF → implémentés et testés JVM maintenant.
4. **30 gabarits & 197 maquettes** : zip Drive requis ; le repo fournit déjà le
   schéma + validateur compatibles (`tools/valider_gabarits.py` à créer) pour
   avaler les fichiers dès réception, sans bloquer le gardien.

## 3. Ordre des micro-commits (couteau suisse, CI = banc)

1. `core-guard` : ExportGate, MonotonicAnchor, Receipt (ECDSA P-256 RFC 8785),
   Vvsh1 (AES-GCM Keystore) + tests JVM.
2. `IntegrityGuard` (app) : SHA-256 APK auto-contrôle + heuristiques resign/Frida.
3. Câblage gate dans ExportActivity (0 crédit = enqueue refusé, message paywall).
4. Module NDK `vvguard` (C : SHA-256, vérif tag VVSH1, gates ABI) + bridge JNI.
5. À réception Drive : ingestion 30 JSON (validateur), transitions 22, speed cards.
