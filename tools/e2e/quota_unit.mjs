#!/usr/bin/env node
/** D42.32 (§4) — CONTRAT D'EXPORTS PAR PLAN : tests unitaires des décisions
 *  PURES du Worker (src/index.js : planPeriodStart, decideQuota).
 *
 *  Décision fondateur appliquée : Pro = 90 exports / 30 jours (fini le
 *  exports_limit=9999 avec fair_use stocké jamais contrôlé). Pass 6 / 24 h,
 *  Boutique 200 / 30 j. Rendus cloud DISTINCTS (1/5/20). Attribution SERVEUR :
 *  plan actif d'abord, repli dotation de bienvenue, refus quand les DEUX sont
 *  épuisés. L'idempotence est portée par quota_ledger (event_id PK, INSERT
 *  conditionnel atomique) — vérifiée par le contrat HTTP/D1, pas ici.
 *
 *  Usage : node tools/e2e/quota_unit.mjs   (exit 1 au premier échec)
 */
import { planPeriodStart, decideQuota,
         PLAN_EXPORTS_LIMITS, PLAN_CLOUD_LIMITS } from "../../src/index.js";

let pass = 0, fail = 0;
function check(id, attendu, obtenu) {
  const ok = JSON.stringify(attendu) === JSON.stringify(obtenu);
  if (ok) { pass++; console.log(`QUOTA PASS ${id}`); }
  else { fail++; console.log(`QUOTA FAIL ${id} :: attendu=${JSON.stringify(attendu)} obtenu=${JSON.stringify(obtenu)}`); }
}

// ---- 1. Bornes fondateur : la 90e passe, la 91e est refusée -------------
check("Pro_89e_tentative_plan", { source: "pro", allowed: true },
      decideQuota("pro", "export", 89, PLAN_EXPORTS_LIMITS.pro, 0));
check("Pro_90e_tentative_refusee", { source: null, allowed: false, code: "quota_exceeded" },
      decideQuota("pro", "export", 90, PLAN_EXPORTS_LIMITS.pro, 0));
check("Pro_90e_repli_bienvenue", { source: "welcome", allowed: true },
      decideQuota("pro", "export", 90, PLAN_EXPORTS_LIMITS.pro, 3));

// ---- 2. Pass 6 / Boutique 200 (inchangés, désormais réels) --------------
check("Pass_6e_ok_7e_refusee", { source: null, allowed: false, code: "quota_exceeded" },
      decideQuota("pass24h", "export", 6, PLAN_EXPORTS_LIMITS.pass24h, 0));
check("Pass_5e_ok", { source: "pass24h", allowed: true },
      decideQuota("pass24h", "export", 5, PLAN_EXPORTS_LIMITS.pass24h, 0));
check("Boutique_199e_ok", { source: "boutique", allowed: true },
      decideQuota("boutique", "export", 199, PLAN_EXPORTS_LIMITS.boutique, 0));
check("Boutique_200e_refusee", { source: null, allowed: false, code: "quota_exceeded" },
      decideQuota("boutique", "export", 200, PLAN_EXPORTS_LIMITS.boutique, 0));

// ---- 3. Limites exactes de la grille ------------------------------------
check("Grille_exports", { pass24h: 6, pro: 90, boutique: 200 }, PLAN_EXPORTS_LIMITS);
check("Grille_cloud", { pass24h: 1, pro: 5, boutique: 20 }, PLAN_CLOUD_LIMITS);

// ---- 4. Rendus cloud DISTINCTS des exports ------------------------------
check("Cloud_Pro_5e_ok", { source: "pro", allowed: true },
      decideQuota("pro", "cloud", 4, PLAN_CLOUD_LIMITS.pro, 0));
check("Cloud_Pro_6e_refusee", { source: null, allowed: false, code: "quota_exceeded" },
      decideQuota("pro", "cloud", 5, PLAN_CLOUD_LIMITS.pro, 0));
check("Cloud_bienvenue_repli", { source: "welcome", allowed: true },
      decideQuota("pro", "cloud", 5, PLAN_CLOUD_LIMITS.pro, 1));
check("Exports_ne_consomment_pas_cloud", { source: "pro", allowed: true },
      decideQuota("pro", "export", 0, PLAN_EXPORTS_LIMITS.pro, 0));

// ---- 5. Sans abonnement : dotation de bienvenue (comportement D42.30) ---
check("Bienvenue_seule_ok", { source: "welcome", allowed: true },
      decideQuota(null, "export", 0, 0, 3));
check("Bienvenue_epuisee_refus", { source: null, allowed: false, code: "quota_exceeded" },
      decideQuota(null, "export", 0, 0, 0));
check("Abonnement_inactif_null", { source: null, allowed: false, code: "quota_exceeded" },
      decideQuota(null, "export", 0, 0, 0));

// ---- 6. Périodes 30 j / 24 h (fenêtre glissante au renouvellement) ------
const T0 = "2026-10-01T10:00:00.000Z";
const J30 = 30 * 86400000, J1 = 86400000;
check("Periode_pro_premiere", T0,
      planPeriodStart(T0, new Date(Date.parse(T0) + J30).toISOString(), "pro"));
check("Periode_pro_renouvelee_glisse", new Date(Date.parse(T0) + J30).toISOString(),
      planPeriodStart(T0, new Date(Date.parse(T0) + 60 * 86400000).toISOString(), "pro"));
check("Periode_pass_24h", T0,
      planPeriodStart(T0, new Date(Date.parse(T0) + J1).toISOString(), "pass24h"));
check("Periode_sans_renews", T0, planPeriodStart(T0, null, "pro"));
check("Periode_started_invalide", new Date(0).toISOString(), planPeriodStart(null, null, "pro"));

console.log(`\nQUOTA_BILAN PASS=${pass} FAIL=${fail}`);
process.exit(fail === 0 ? 0 : 1);
