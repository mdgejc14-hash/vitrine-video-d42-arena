# D42.24 — 01. DIAGNOSTIC ZÉRO COÛT DU BLOCAGE (D23-1)

## Question : pourquoi GitHub bloque-t-il les exécutions ?

### Cause établie (preuves D42.23 + confirmations API du 08/11)
- **Symptôme** : tout workflow du dépôt PRIVÉ `mdgejc14-hash/vitrine-video`
  meurt en quelques secondes, zéro étape exécutée, aucun runner alloué —
  vérifié en direct par dispatch le 08/11 (~09:15 Bénin, D42.23). Le
  backup D1 quotidien échoue depuis le **04/11** pour cette cause.
- **Runs privés récents relevés via API le 08/11 ~10:20 UTC** (signature
  du blocage, toujours active) : Backup D1 → `failure` à 09:53 et 08:55
  (42469043847, 42464996752) ; preview-d1-migrations → `failure` à
  09:48 et 09:08 (42468739662, 42465887953) ; Cleanup self-hosted →
  `queued` depuis 03:39 (42443629416, en attente d'un runner
  self-hosted inexistant — sans rapport, à ignorer).
- **Nature du blocage** : quota de minutes gratuites (plan gratuit,
  2 000 min/mois pour les dépôts privés) consommé + plafond de dépenses
  à 0 → GitHub refuse d'allouer tout runner aux dépôts privés du
  compte. Ce n'est PAS un problème de type de runner (voir tableau),
  PAS un workflow invalide (les mêmes passent sur le miroir public),
  PAS un problème d'environnement (0 requis — inventaire D42.23/01).

### Vérifications structurantes (08/11, PAT restitué)
| Point | Résultat |
|---|---|
| Types de runners des 16 workflows | **100 % `ubuntu-latest`** (standard) — sauf 3 workflows self-hosted expérimentaux (cleanup, mock-server, qa-interactive) hors chaîne de qualification |
| Runner payant `*-4xlarge`+ | **Aucun** |
| API billing (`/users/…/settings/billing/actions`) | **403 « Resource not accessible by personal access token »** — le PAT fondateur n'a pas le périmètre billing ; les montants exacts ne sont pas lisibles par l'agent. Non bloquant : le comportement observé (runs privés morts / runs publics verts) établit le diagnostic. |
| Date du jour | 08/11/2026 ~10:15 UTC — **même journée** que la constatation D42.23 → aucun reset mensuel de quota n'a pu intervenir. Probe empirique prévu (workflow témoin, voir ci-dessous) pour le confirmer en direct. |
| Artefacts volumineux | Les artefacts récents vivent sur le miroir (public, gratuit) ; côté privé, la sortie de build locale a été perdue par le snapshot mais l'APK+mapping sont en release privée 438156110 — rien de dépendant du stockage Actions. |
| Workflows dupliqués / relances | e2e-lab annulé 2× par concurrency (42465877611, 42468715512) — coût nul (public). |
| Téléchargements répétés | Cache Gradle déjà branché (`gradle/actions/setup-gradle@v4`) dans android-ci et e2e-lab. |
| Environnements GitHub | 0 (D42.23, inchangé). |

### La règle de facturation GitHub qui débloque tout
- **Dépôts PUBLICS** : runners standards (`ubuntu-latest`) **gratuits et
  illimités** — aucun plafond, aucune carte requise.
- **Dépôts PRIVÉS** (plan gratuit) : 2 000 min/mois incluses, puis
  blocage si plafond de dépenses = 0 (décision fondateur : il le reste).
- Conclusion : **toute la qualification s'exécute à 0 FCFA sur le
  miroir public**, à condition que les secrets nécessaires y soient
  présents (ajout fondateur via l'interface — jamais dans le contenu du
  dépôt) et que les gardes de cadrage D42.23 soient étendues proprement
  (voir 02).

### Probe empirique (à exécuter — workflow témoin sur le privé)
Un workflow minimal `zz-zero-cost-probe.yml` (1 job `echo`, 0 secret,
~5 s) sera poussé sur `d42.23-production` du privé et dispatché :
- s'il **s'exécute** → le quota s'est reconstitué : le privé redevient
  utilisable gratuitement dans la limite des 2 000 min (architecture
  alors simplifiée : chaîne originale D42.23 sur le privé) ;
- s'il **meurt sans étape** → D23-1 confirmé en direct → architecture
  miroir (prévue).

### Décision d'architecture (appliquée — mission §2/§3)
**Miroir public = usine de qualification** (runners standards gratuits) ;
privé = détenteur des artefacts de distribution (release rc11) et du
code à secrets committés. Aucune dépense, aucun runner payant, aucune
exposition de contenu sensible : les secrets transitent par le coffre
GitHub du miroir (chiffré côté serveur, valeurs jamais lisibles), les
workflows à secrets ne sont déclenchables que par les collaborateurs
(tags/dispatch — jamais `pull_request_target`).
