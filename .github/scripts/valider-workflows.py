#!/usr/bin/env python3
"""Validation stricte des workflows GitHub.

PyYAML accepte silencieusement les cles DUPLIQUEES (la derniere gagne) alors
que GitHub Actions rejette le fichier : « 'if' is already defined ». Ce
validateur echoue donc sur tout doublon, avant le push.
"""
import sys
import yaml


class Strict(yaml.SafeLoader):
    pass


def construct_mapping(loader, node, deep=False):
    mapping = {}
    for key_node, value_node in node.value:
        cle = loader.construct_object(key_node, deep=deep)
        if cle in mapping:
            raise ValueError(
                f"cle dupliquee '{cle}' ligne {key_node.start_mark.line + 1}"
            )
        mapping[cle] = loader.construct_object(value_node, deep=deep)
    return mapping


Strict.add_constructor(
    yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, construct_mapping
)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("usage: valider-workflows.py fichier.yml [...]")
        raise SystemExit(2)
    for chemin in sys.argv[1:]:
        try:
            with open(chemin, encoding="utf-8") as flux:
                yaml.load(flux, Loader=Strict)
            print(f"OK {chemin}")
        except Exception as erreur:  # noqa: BLE001
            print(f"ECHEC {chemin} : {erreur}")
            raise SystemExit(1)
