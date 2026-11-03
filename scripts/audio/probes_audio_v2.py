#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sondes E2E audio v2 — Worker production
Connexion Firebase (compte sonde) -> idToken -> routes audio :
  /health, /api/v1/audio/catalog (30), /api/v1/audio/library (total 600,
  100/secteur), /api/v1/audio/track/<categorie> (streaming sha-exact + Range 206).
Le sha256 du flux track est comparé au manifeste v2 (piste servie = 1re
variation de la catégorie, ou master titulaire s'il existe).
"""
import argparse
import hashlib
import json
import sys
import urllib.request

BASE = "https://vitrine-video-api.mdgejcinfluence.workers.dev"
FIREBASE_KEY = "REMPLACE_PAR_API_KEY"
SONDE_EMAIL = "vv-auth-probe@vitrine.video"
SONDE_MDP = "Sonde-Auth-2026!prod"


UA = "vv-probes-audio-v2/1.0 (curl-compatible)"


def get(url, headers=None, data=None):
    h = {"User-Agent": UA}
    h.update(headers or {})
    rq = urllib.request.Request(url, headers=h, data=data)
    try:
        rep = urllib.request.urlopen(rq)
        return rep.status, dict(rep.headers), rep.read()
    except urllib.error.HTTPError as e:
        return e.code, dict(e.headers), e.read()


def idtoken():
    body = json.dumps({"email": SONDE_EMAIL, "password": SONDE_MDP, "returnSecureToken": True}).encode()
    st, _, raw = get(f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_KEY}",
                     {"Content-Type": "application/json"}, body)
    if st != 200:
        print("ABORT : connexion sonde échouée", st, raw[:200])
        sys.exit(1)
    return json.loads(raw)["idToken"]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default=BASE)
    ap.add_argument("--manifeste", default="/home/user/audio_v2/manifests/bgm_lib_manifest_v2.json")
    args = ap.parse_args()
    base = args.base.rstrip("/")
    tok = idtoken()
    h = {"Authorization": "Bearer " + tok}
    echecs = []

    st, _, raw = get(base + "/health")
    print(f"/health -> {st}")
    if st != 200:
        echecs.append("health")

    st, _, raw = get(base + "/api/v1/audio/catalog", h)
    d = json.loads(raw) if st == 200 else {}
    cats = d.get("pistes") or []
    dispo = sum(1 for c in cats if c.get("disponible"))
    print(f"/audio/catalog -> {st} | catégories: {len(cats)} | disponibles: {dispo}")
    if st != 200 or len(cats) != 30:
        echecs.append(f"catalog {st} {len(cats)}")

    st, _, raw = get(base + "/api/v1/audio/library?limit=700", h)
    d = json.loads(raw) if st == 200 else {}
    total = d.get("total")
    pistes = d.get("pistes", [])
    print(f"/audio/library -> {st} | total={total} | reçues={len(pistes)}")
    if total != 600:
        echecs.append(f"library total {total}")
    v2 = {p["piste_id"]: p for p in pistes}
    man = {e["piste_id"]: e for e in json.load(open(args.manifeste))}
    desync = [pid for pid in man if pid in v2 and (v2[pid]["sha256"] != man[pid]["sha256"] if "sha256" in v2[pid] else False)]
    # la route library ne sert pas sha256 (colonnes servies limitées) : contrôle via taille+durée
    mism = [pid for pid in man if pid in v2 and (abs(v2[pid]["duree_s"] - man[pid]["duree_s"]) > 0.5 or v2[pid]["taille_octets"] != man[pid]["taille_octets"])]
    print(f"library vs manifeste v2 : {len(v2)}/600 présentes | durées/tailles divergentes : {len(mism)}")
    if mism:
        echecs.append(f"library desync {mism[:3]}")
    for s in sorted({e['secteur'] for e in man.values()}):
        st, _, raw = get(base + f"/api/v1/audio/library?secteur={s}&limit=200", h)
        n = json.loads(raw).get("count") if st == 200 else None
        print(f"  secteur {s}: count={n}")
        if n != 100:
            echecs.append(f"secteur {s} {n}")

    # streaming sha-exact sur 3 catégories (1 par famille de format)
    for cat, pid_attendu in (("musique_t1_vetements_mode", "musique_t1_vetements_mode_v01"),
                             ("musique_t3_restaurants_maquis", "musique_t3_restaurants_maquis_v01"),
                             ("musique_t5_coiffure_beaute", "musique_t5_coiffure_beaute_v01")):
        st, hdr, raw = get(base + f"/api/v1/audio/track/{cat}", h)
        sha = hashlib.sha256(raw).hexdigest() if raw else ""
        att = man.get(pid_attendu, {}).get("sha256")
        ok = st == 200 and sha == att
        print(f"/audio/track/{cat} -> {st} | {len(raw)} o | sha256 {'== manifeste v2 ✓' if sha == att else f'≠ (attendu {att[:12] if att else None}…, reçu {sha[:12]}…)'}")
        if not ok:
            echecs.append(f"track {cat}")
        if st == 200:
            st2, hdr2, raw2 = get(base + f"/api/v1/audio/track/{cat}", {**h, "Range": "bytes=0-1023"})
            print(f"   Range 0-1023 -> {st2} | {len(raw2)} o | Content-Range: {hdr2.get('Content-Range', hdr2.get('content-range', '?'))}")
            if st2 != 206:
                echecs.append(f"range {cat}")

    print()
    if echecs:
        print("ÉCHECS :", echecs)
        sys.exit(1)
    print("SONDES E2E AUDIO v2 : TOUTES VERTES")


if __name__ == "__main__":
    main()
