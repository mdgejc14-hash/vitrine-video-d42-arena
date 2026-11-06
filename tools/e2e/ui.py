#!/usr/bin/env python3
"""Pilotage de l'UI Android par ADB + uiautomator — laboratoire D42.13.

Aucune dépendance externe : uniquement `adb` et la bibliothèque standard.
Chaque commande écrit une ligne `E2E ...` sur stdout — ces lignes servent de
journal de preuve dans les artefacts GitHub Actions.

Commandes :
  probe                      affiche tous les noeuds (text / resource-id / bounds)
  wait   --text T | --id I   attend l'apparition (timeout)
  tap    --text T | --id I | --xy x,y
  inside --text T | --id I   vérifie que l'élément est ENTIÈREMENT dans l'écran
  shot   chemin.png          capture d'écran
  swipe  x1,y1,x2,y2 [ms]
  size                       taille d'écran déclarée par le système
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
import time
import xml.etree.ElementTree as ET

DUMP_REMOTE = "/sdcard/window_dump.xml"


def resolve_adb():
    """adb n'est pas toujours sur le PATH du runner : on le cherche explicitement."""
    for base in ("ANDROID_SDK_ROOT", "ANDROID_HOME", "ANDROID_SDK"):
        root = os.environ.get(base)
        if root:
            cand = os.path.join(root, "platform-tools", "adb")
            if os.path.exists(cand):
                return cand
    found = shutil.which("adb")
    if found:
        return found
    for cand in ("/usr/local/lib/android/sdk/platform-tools/adb",
                 os.path.expanduser("~/Android/Sdk/platform-tools/adb")):
        if os.path.exists(cand):
            return cand
    raise SystemExit("E2E FATAL adb introuvable (PATH=" + os.environ.get("PATH", "") + ")")


ADB = resolve_adb()


def adb(*args, timeout=180):
    return subprocess.run([ADB, *args], capture_output=True, text=True, timeout=timeout,
                          errors="replace")


def screen_size():
    out = adb("shell", "wm", "size").stdout
    m = re.search(r"Override size:\s*(\d+)x(\d+)", out) or re.search(r"Physical size:\s*(\d+)x(\d+)", out)
    return (int(m.group(1)), int(m.group(2))) if m else (0, 0)


def dump_nodes(retries=3):
    for _ in range(retries):
        adb("shell", "uiautomator", "dump", DUMP_REMOTE)
        xml = adb("exec-out", "cat", DUMP_REMOTE).stdout
        if xml and "<hierarchy" in xml:
            try:
                root = ET.fromstring(xml)
                return list(root.iter("node")), xml
            except ET.ParseError:
                pass
        time.sleep(1)
    return [], ""


def parse_bounds(b):
    m = re.match(r"\[(-?\d+),(-?\d+)\]\[(-?\d+),(-?\d+)\]", b or "")
    if not m:
        return None
    x1, y1, x2, y2 = map(int, m.groups())
    return x1, y1, x2, y2


def find(nodes, text=None, rid=None):
    for n in nodes:
        t = n.get("text") or ""
        r = n.get("resource-id") or ""
        if not n.get("bounds") or n.get("package") not in (None, ""):
            pass
        if text is not None and text.lower() in t.lower():
            return n
        if rid is not None and rid in r:
            return n
    return None


def describe(n):
    b = parse_bounds(n.get("bounds"))
    return f'text="{n.get("text")}" id="{n.get("resource-id")}" bounds={b} clickable={n.get("clickable")}'


def cmd_probe(args):
    print(f"E2E adb={ADB}")
    nodes, _ = dump_nodes()
    w, h = screen_size()
    print(f"E2E screen={w}x{h} nodes={len(nodes)}")
    for n in nodes:
        if (n.get("text") or "").strip() or (n.get("resource-id") or "").strip():
            print("E2E node " + describe(n))
    return 0


def cmd_size(args):
    w, h = screen_size()
    print(f"E2E screen={w}x{h}")
    return 0 if w and h else 1


def _wait(args, must=True):
    deadline = time.time() + args.timeout
    last = None
    while time.time() < deadline:
        nodes, _ = dump_nodes()
        n = find(nodes, args.text, args.id)
        if n is not None:
            print("E2E FOUND " + describe(n))
            return n
        last = len(nodes)
        time.sleep(1.5)
    msg = f"E2E TIMEOUT text={args.text} id={args.id} after {args.timeout}s (nodes={last})"
    print(msg, file=sys.stderr if must else sys.stdout)
    return None


def cmd_wait(args):
    return 0 if _wait(args) else 1


def cmd_tap(args):
    if args.xy:
        x, y = map(int, args.xy.split(","))
        adb("shell", "input", "tap", str(x), str(y))
        print(f"E2E TAP_XY {x},{y}")
        return 0
    n = _wait(args)
    if n is None:
        return 1
    b = parse_bounds(n.get("bounds"))
    x, y = (b[0] + b[2]) // 2, (b[1] + b[3]) // 2
    adb("shell", "input", "tap", str(x), str(y))
    print(f"E2E TAP {x},{y} -> {n.get('text') or n.get('resource-id')}")
    return 0


def cmd_inside(args):
    """Vérifie qu'un élément est entièrement visible (aucune partie hors écran)."""
    n = _wait(args)
    if n is None:
        print("E2E FAIL element_absent", file=sys.stderr)
        return 2
    w, h = screen_size()
    x1, y1, x2, y2 = parse_bounds(n.get("bounds"))
    label = n.get("text") or n.get("resource-id")
    inside = x1 >= 0 and y1 >= 0 and x2 <= w and y2 <= h and (y2 - y1) > 0
    print(f"E2E INSIDE {label!r} bounds=({x1},{y1},{x2},{y2}) screen=({w},{h}) => "
          f"{'PASS' if inside else 'FAIL_HORS_ECRAN'}")
    # Vérifie aussi que l'élément est cliquable (le bouton épinglé doit l'être)
    print(f"E2E CLICKABLE {label!r} => {n.get('clickable')}")
    return 0 if inside else 3


def cmd_shot(args):
    with open(args.path, "wb") as f:
        p = subprocess.run([ADB, "exec-out", "screencap", "-p"], stdout=f, timeout=180)
    ok = p.returncode == 0
    print(f"E2E SHOT {args.path} {'OK' if ok else 'ECHEC'}")
    return 0 if ok else 1


def cmd_swipe(args):
    x1, y1 = map(int, args.start.split(","))
    x2, y2 = map(int, args.end.split(","))
    adb("shell", "input", "swipe", str(x1), str(y1), str(x2), str(y2), str(args.ms))
    print(f"E2E SWIPE {x1},{y1}->{x2},{y2} {args.ms}ms")
    return 0


def build_parser():
    p = argparse.ArgumentParser(description="Pilotage UI Android (D42.13)")
    sub = p.add_subparsers(dest="cmd", required=True)

    sub.add_parser("probe")
    sub.add_parser("size")

    def target(sp):
        sp.add_argument("--text")
        sp.add_argument("--id")
        sp.add_argument("--timeout", type=int, default=25)

    target(sub.add_parser("wait")).set_defaults(func=cmd_wait)
    t = sub.add_parser("tap")
    target(t)
    t.add_argument("--xy")
    t.set_defaults(func=cmd_tap)
    target(sub.add_parser("inside")).set_defaults(func=cmd_inside)
    s = sub.add_parser("shot")
    s.add_argument("path")
    s.set_defaults(func=cmd_shot)
    w = sub.add_parser("swipe")
    w.add_argument("start")
    w.add_argument("end")
    w.add_argument("--ms", type=int, default=300)
    w.set_defaults(func=cmd_swipe)
    return p


if __name__ == "__main__":
    a = build_parser().parse_args()
    sys.exit(a.func(a))
