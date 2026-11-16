#!/usr/bin/env python3
"""D42.34 — Génère pushdir/kernel-metadata.json pour kaggle kernels push.

Usage : preparer_metadata.py <kaggle_username> <title>
Le title est OBLIGATOIRE pour un nouveau kernel (« New kernels must have a
title specified ») ; pour un kernel existant, le title réel est préservé par
l'appelant via `kaggle kernels pull -m`.
"""
import json
import sys

username, title = sys.argv[1], sys.argv[2]
meta = {
    "id": f"{username}/vitrine-video-d42-34-validation",
    "title": title,
    "language": "python",
    "kernel_type": "script",
    "is_private": True,
    "enable_gpu": False,
    "enable_internet": True,
    "code_file": "script.py",
    "dataset_sources": [],
    "kernel_sources": [],
    "competition_sources": [],
}
with open("pushdir/kernel-metadata.json", "w", encoding="utf-8") as f:
    json.dump(meta, f, indent=2)
print("metadata JSON OK — id :", meta["id"], "/ title :", meta["title"])
