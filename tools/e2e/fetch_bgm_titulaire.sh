#!/usr/bin/env bash
# D42.28 (P2/P3) — télécharger la piste TITULAIRE d'une catégorie audio via
# l'API de production, avec le COMPTE SONDE dédié aux sondes audio
# (vv-auth-probe@vitrine.video — identifiants publics dans
# scripts/audio/probes_audio_v2.py, utilisés par l'audit intégral 26/0 ;
# ce compte a un profil « actif » dans la table users D1, contrairement au
# compte de test A qui reçoit 403 account_inactive sur /audio/track —
# requireUser vérifie le statut D1, run 42742724174).
#
# Sert à INJECTER le BGM en cache local (files/bgm/{catégorie}.mp3) pour les
# bancs offline/modes-audio : le produit ne télécharge le BGM qu'avec un jeton
# Firebase (session démo = pas de téléchargement, export SFX seuls —
# comportement produit, constaté aux runs 42728504073/42737266239 : files/bgm
# créé mais vide).
#
#   tools/e2e/fetch_bgm_titulaire.sh <categorie_audio> <sortie.mp3>
#
# Env requis : FIREBASE_WEB_API_KEY. API_BASE_URL optionnel (défaut prod).
# rc 0 + fichier non vide = succès.
set -uo pipefail

CAT="${1:?catégorie audio requise (ex. musique_t1_shops_small_business)}"
SORTIE="${2:?chemin de sortie requis}"
API="${API_BASE_URL:-https://vitrine-video-api.mdgejcinfluence.workers.dev}"

: "${FIREBASE_WEB_API_KEY:?env requis}"

python3 - "$CAT" "$SORTIE" "$API" <<'PYEOF'
import json, os, sys, urllib.request

cat, sortie, api = sys.argv[1], sys.argv[2], sys.argv[3]
key = os.environ["FIREBASE_WEB_API_KEY"]

# UA dédié (celui de scripts/audio/probes_audio_v2.py) : le UA python par
# défaut est refusé (403) sur les routes de l'API — constaté aux runs
# 42742724174/42759689694 avec la sonde pourtant valide (l'audit 26/0 du
# même jour passait avec ce UA).
UA = "vv-probes-audio-v2/1.0 (curl-compatible)"

# 1. SignIn REST du compte sonde (même compte que scripts/audio/probes_audio_v2.py)
req = urllib.request.Request(
    f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={key}",
    data=json.dumps({
        "email": "vv-auth-probe@vitrine.video",
        "password": "Sonde-Auth-2026!prod",
        "returnSecureToken": True,
    }).encode(),
    headers={"Content-Type": "application/json", "User-Agent": UA},
    method="POST",
)
with urllib.request.urlopen(req, timeout=30) as r:
    data = json.loads(r.read())
token = data["idToken"]
print(f"E2E BGM : jeton sonde obtenu (localId {data['localId'][:6]}…)")

# 2. Piste titulaire (sans ?v : master titulaire prioritaire — re-audit D42.28 : 206 audio/mpeg)
req = urllib.request.Request(
    f"{api}/api/v1/audio/track/{cat}",
    headers={"Authorization": f"Bearer {token}", "User-Agent": UA},
    method="GET",
)
try:
    r = urllib.request.urlopen(req, timeout=120)
except urllib.error.HTTPError as e:
    print(f"E2E BGM : ECHEC HTTP {e.code} — corps : {e.read()[:300]!r}")
    sys.exit(1)
with r:
    corps = r.read()
    ctype = r.headers.get("Content-Type", "")
    print(f"E2E BGM : HTTP {r.status}, {len(corps)} octets, {ctype}")

# 3. Garde : MP3 reconnaissable (ID3 ou trame MPEG) et taille plausible
if len(corps) < 100_000 or not (corps[:3] == b"ID3" or corps[:2] in (b"\xff\xfb", b"\xff\xf3", b"\xff\xf2")):
    print(f"E2E BGM : ECHEC — réponse non-MP3 ou trop petite ({len(corps)} octets)")
    sys.exit(1)

with open(sortie, "wb") as f:
    f.write(corps)
print(f"E2E BGM : piste titulaire {cat} -> {sortie} ({len(corps)} octets)")
PYEOF
