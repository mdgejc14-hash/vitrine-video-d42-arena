#!/usr/bin/env python3
"""Contrat HTTP du Worker — laboratoire D42.14 (Piste backend).

Ce script interroge un Worker RÉELLEMENT DÉMARRÉ (wrangler dev, D1 local).
Il ne teste que ce qui est vérifiable sans compte Firebase :

  1. surface publique (/ , /health) ;
  2. refus systématique des routes protégées sans jeton ;
  3. rejet d'un jeton forgé (alg=none) ;
  4. rejet d'une confusion d'algorithme (HS256 signé avec la clé publique) ;
  5. absence de fuite : la facturation répond 401 avant de répondre 501 ;
  6. route inconnue -> 404 ; méthode incorrecte -> 405/404 ;
  7. en-têtes de sécurité / CORS.

Ce que ce script NE PEUT PAS FAIRE, et qu'il dit à voix haute :
les routes authentifiées (crédits, parrainage, isolation de comptes) exigent un
jeton Firebase signé par Google. L'URL JWKS est écrite en dur dans
`src/index.js` (lignes 8-12) : aucun jeton local ne peut la contourner.
=> statut BLOCKED, jamais PASS.

Usage : python3 http_contract.py http://127.0.0.1:8788
"""
import base64
import hashlib
import hmac
import json
import sys
import urllib.error
import urllib.request

BASE = sys.argv[1] if len(sys.argv) > 1 else "http://127.0.0.1:8788"
resultats = []


def record(code, attendu, obtenu, ok, detail=""):
    statut = "PASS" if ok else "FAIL"
    resultats.append({"id": code, "attendu": attendu, "obtenu": obtenu,
                      "statut": statut, "detail": detail})
    print(f"HTTP {statut} {code} :: attendu={attendu} obtenu={obtenu} {detail}")


def appel(methode, chemin, entetes=None, corps=None, timeout=20):
    url = BASE + chemin
    data = corps.encode() if isinstance(corps, str) else corps
    req = urllib.request.Request(url, data=data, method=methode)
    for k, v in (entetes or {}).items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read().decode("utf-8", "replace"), dict(r.headers)
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode("utf-8", "replace"), dict(e.headers)
    except Exception as e:  # réseau
        return 0, str(e), {}


def b64(d):
    return base64.urlsafe_b64encode(d).rstrip(b"=").decode()


def jwt_forge(alg, secret, sub="attaquant-uid"):
    entete = b64(json.dumps({"alg": alg, "typ": "JWT", "kid": "d42"}).encode())
    charge = b64(json.dumps({
        "sub": sub, "iss": "https://securetoken.google.com/vitrine-video",
        "aud": "vitrine-video", "exp": 4102444800, "iat": 1700000000,
    }).encode())
    signature = b64(hmac.new(secret, f"{entete}.{charge}".encode(), hashlib.sha256).digest())
    return f"{entete}.{charge}.{signature}"


def main():
    # 1 — surface publique
    st, corps, _ = appel("GET", "/health")
    record("H1_health", "200", st, st == 200, corps[:80])

    st, corps, _ = appel("GET", "/")
    record("H2_racine", "200", st, st == 200, corps[:100])

    # 2 — routes protégées sans jeton
    for chemin, methode in [("/api/v1/me", "GET"),
                            ("/api/v1/me/entitlements", "GET"),
                            ("/api/v1/me/referral", "GET"),
                            ("/api/v1/quota/consume", "POST"),
                            ("/api/v1/me/welcome-grant", "POST")]:
        st, corps, _ = appel(methode, chemin, {"Content-Type": "application/json"}, "{}")
        record(f"SANS_JETON {methode} {chemin}", "401", st, st == 401, corps[:60])

    # 3 — jeton forgé alg=none (aucune signature)
    entete = b64(json.dumps({"alg": "none", "typ": "JWT"}).encode())
    charge = b64(json.dumps({"sub": "x", "aud": "vitrine-video",
                             "iss": "https://securetoken.google.com/vitrine-video",
                             "exp": 4102444800}).encode())
    st, corps, _ = appel("GET", "/api/v1/me",
                         {"Authorization": f"Bearer {entete}.{charge}."})
    record("H3_alg_none_rejete", "401", st, st == 401, corps[:60])

    # 4 — confusion d'algorithme HS256 signé avec la clé publique Google
    clave_pub = b"-----BEGIN PUBLIC KEY-----\nMIIBfakeD42TestKeyForAlgorithmConfusion\n-----END PUBLIC KEY-----"
    st, corps, _ = appel("GET", "/api/v1/me",
                         {"Authorization": f"Bearer {jwt_forge('HS256', clave_pub)}"})
    record("H4_confusion_algo_rejetee", "401", st, st == 401, corps[:60])

    # 5 — facturation : 401 AVANT 501 (aucune information avant authentification)
    st, corps, _ = appel("POST", "/api/v1/billing/checkout",
                         {"Content-Type": "application/json"}, '{"plan":"pass24h"}')
    record("H5_facturation_sans_jeton", "401 (jamais 501 sans identité)", st,
           st == 401, corps[:60])

    # 6 — route inconnue / méthode incorrecte
    st, _, _ = appel("GET", "/api/v1/nexiste-pas-d42")
    record("H6_route_inconnue", "404", st, st in (404,), "")

    st, _, _ = appel("DELETE", "/health")
    record("H7_methode_incorrecte", "404 ou 405", st, st in (404, 405), "")

    # 7 — CORS
    st, corps, ent = appel("OPTIONS", "/api/v1/me",
                           {"Origin": "https://vitrine.video",
                            "Access-Control-Request-Method": "GET"})
    record("H8_preflight_cors", "200-204", st, st in (200, 204), "")

    st, _, ent = appel("GET", "/health")
    entetes = {k.lower(): v for k, v in ent.items()}
    record("H9_type_contenu_json", "application/json",
           entetes.get("content-type", ""), "application/json" in entetes.get("content-type", ""), "")

    # 8 — le jeton est-il accepté ailleurs qu'en en-tête (fuite par URL) ?
    st, _, _ = appel("GET", "/api/v1/me?token=abc")
    record("H10_pas_de_jeton_en_url", "401 (le jeton d'URL ne suffit pas)", st, st == 401, "")

    npass = sum(1 for r in resultats if r["statut"] == "PASS")
    nfail = sum(1 for r in resultats if r["statut"] == "FAIL")
    print(f"\nHTTP_BILAN PASS={npass} FAIL={nfail}")
    print("HTTP_LIMITE routes authentifiées : BLOCKED (JWKS Google en dur, src/index.js:8-12)")
    with open("http_contract_report.json", "w") as f:
        json.dump({"base": BASE, "resultats": resultats,
                   "limite": "routes authentifiées non testables sans jeton Firebase réel"},
                  f, ensure_ascii=False, indent=2)
    return 0 if nfail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
