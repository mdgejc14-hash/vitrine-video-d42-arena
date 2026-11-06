/**
 * Préchargement pour `scripts/security-ci.mjs` — D42.14.
 *
 * `node --import ./tools/e2e/idp_preload.mjs scripts/security-ci.mjs`
 *
 * Remplace UNIQUEMENT l'appel de connexion Firebase
 * (`identitytoolkit.googleapis.com/v1/accounts:signInWithPassword`) par un
 * fournisseur LOCAL : même contrat de réponse (`idToken`, `localId`, `email`,
 * `expiresIn`), même signature RS256, même émetteur et même audience que ceux
 * que le Worker vérifie. Toute autre requête réseau passe par le `fetch` normal.
 *
 * Conséquence : les 69 contrôles de sécurité s'exécutent réellement, mais
 * l'identité provient d'un IdP de banc. Statut : PASS_LOCAL_HARNESS.
 */
import { readFileSync, existsSync } from "node:fs";
import { SignJWT, importPKCS8 } from "jose";

const CHEMIN_CLE = "/tmp/d42-idp/cle.pem";
if (!existsSync(CHEMIN_CLE)) {
  throw new Error(
    "idp_preload: clé locale absente — démarrez d'abord tools/e2e/worker_http.mjs"
  );
}
const clePrivee = await importPKCS8(readFileSync(CHEMIN_CLE, "utf8"), "RS256");

const PROJECT_ID = "vitrine-video";
const ISSUER = `https://securetoken.google.com/${PROJECT_ID}`;
const fetchOrigine = globalThis.fetch;

/** email -> uid stable (deux comptes distincts, comme la CI Firebase réelle). */
const identites = new Map();

globalThis.fetch = async (entree, init = {}) => {
  const url = typeof entree === "string" ? entree : entree.url;

  if (url.startsWith("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword")) {
    const corps = JSON.parse(init.body || "{}");
    const email = String(corps.email || "");
    const motDePasse = String(corps.password || "");
    if (!email.includes("@") || motDePasse.length < 6) {
      return new Response(
        JSON.stringify({ error: { code: 400, message: "INVALID_LOGIN_CREDENTIALS" } }),
        { status: 400, headers: { "content-type": "application/json" } }
      );
    }
    if (!identites.has(email)) {
      // uid déterministe : A et B restent distincts d'une exécution à l'autre
      const n = identites.size + 1;
      identites.set(email, { uid: `uid-local-${n}-${email.split("@")[0]}`, email });
    }
    const { uid } = identites.get(email);
    const idToken = await new SignJWT({ email, user_id: uid, email_verified: true })
      .setProtectedHeader({ alg: "RS256", kid: "cle-locale-d42", typ: "JWT" })
      .setIssuer(ISSUER)
      .setAudience(PROJECT_ID)
      .setSubject(uid)
      .setIssuedAt()
      .setExpirationTime("1h")
      .sign(clePrivee);
    return new Response(
      JSON.stringify({ idToken, localId: uid, email, expiresIn: "3600", kind: "identitytoolkit#VerifyPasswordResponse" }),
      { status: 200, headers: { "content-type": "application/json" } }
    );
  }

  return fetchOrigine(entree, init);
};
