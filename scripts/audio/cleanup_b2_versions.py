#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Nettoyage B2 — bucket vitrine-video-media, préfixe audio/
Supprime TOUTES les versions anciennes (v1, versions non conformes du batch
interrompu, témoin .m4a caché) en ne gardant que la DERNIÈRE version de chaque
nom. Les marqueurs de dossier (fichiers se terminant par '/') sont conservés
(taille 0, rôle cosmétique console). --dry-run par défaut implicite : passer
--execute pour supprimer réellement.
"""
import argparse
import json
import os
import sys
import urllib.request

ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, ROOT)
import generateur_audio_v2 as G  # noqa: E402


def call(sess, name, body):
    rq = urllib.request.Request(
        sess["apiUrl"] + "/b2api/v2/" + name,
        data=json.dumps(body).encode(),
        headers={"Authorization": sess["token"], "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(rq))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--execute", action="store_true")
    args = ap.parse_args()
    sess = G.b2_session()
    versions = []
    start_file, start_ts = "", None
    while True:
        body = {"bucketId": sess["bucketId"], "prefix": "audio/", "maxFileCount": 1000,
                "startFileName": start_file}
        if start_ts is not None:
            body["startFileTimeStamp"] = start_ts
        d = call(sess, "b2_list_file_versions", body)
        versions += d["files"]
        if d.get("nextFileName"):
            start_file, start_ts = d["nextFileName"], d.get("nextFileTimeStamp")
        else:
            break
    print("versions listées:", len(versions))
    # dernière version par nom = première rencontrée (tri B2 : nom asc, timestamp desc)
    derniere = {}
    a_supprimer = []
    for v in versions:
        nom = v["fileName"]
        if nom.endswith("/"):
            continue  # marqueur dossier : conservé
        if nom not in derniere:
            derniere[nom] = v
        else:
            a_supprimer.append(v)
    # fichiers cachés (action=hide) : la "dernière version" est un hide-marker ;
    # on supprime hide-marker + versions upload du même nom (témoin .m4a)
    for nom, v in list(derniere.items()):
        if v.get("action") != "upload":
            a_supprimer.append(v)
            for w in versions:
                if w["fileName"] == nom and w is not v:
                    a_supprimer.append(w)
    # dédupliquer
    vus = set()
    final = []
    for v in a_supprimer:
        cle = (v["fileName"], v["fileId"])
        if cle not in vus:
            vus.add(cle)
            final.append(v)
    print("noms avec version latest 'upload':", sum(1 for v in derniere.values() if v.get("action") == "upload"))
    print("versions à supprimer:", len(final))
    for v in final[:8]:
        print("   ", v["fileName"], v.get("action"), v["fileId"][:12])
    if not args.execute:
        print("MODE DRY-RUN (ajouter --execute pour supprimer)")
        return
    ok = 0
    for v in final:
        try:
            call(sess, "b2_delete_file_version", {"fileName": v["fileName"], "fileId": v["fileId"]})
            ok += 1
        except Exception as e:
            print("échec", v["fileName"], v["fileId"], e)
    print(f"SUPPRIMÉES : {ok}/{len(final)}")


if __name__ == "__main__":
    main()
