# Famille 09 — Dashboard & parrainage (§7.12 / §9.3)

**Statut : terminée localement, commit <à remplacer après push>, CI à vérifier.**

## Périmètre

Écrans du hub `DashboardActivity` : dashboard (E10), parrainage dédié (R8),
réglages (E12). **Paywall volontairement NON touché** (famille 10 tarifs/aide) :
`PaywallScreen` byte-identique à HEAD (vérifié par extraction diff), le test
pixel `PaywallUiCheckTest` reste vert sans modification.

## Ordre vertical imposé §7.3/§7.12 — implémenté

1. **Header** : avatar 40 dp (initiale RÉELLE du nom, sinon insigne vitrine_logo —
   jamais un prénom inventé), « Bonjour » Tiny + prénom BodyStrong en deux tons
   **dans un seul nœud texte** (sémantique `dash_hello` préservée pour les tests),
   secteur Tiny, réglages 44 dp (`dash_settings_icon`).
2. **Carte héros NAVY r26** : `EXPORTS RESTANTS` Label/Blanc70 + compteur Num
   blanc + « offerts » Sub/Blanc80 (si crédits > 0), détails réels (rendus cloud,
   qualité/watermark) Tiny/Blanc70, anneau décoratif orange (300°, hors zone
   texte), sync honnête (pastille verte seulement après aller-retour serveur,
   spinner, hors-ligne + Réessayer), badge « Essai gratuit » (seulement si
   crédits bienvenue et pas de formule), pastille « Formules › »
   (`dash_see_plans` conservé). **Cas formule active préservé** (D42.32 Lot 7) :
   `dash_plan_active` au lieu d'un « 0 » trompeur, jamais le plafond 9999.
3. **Panneau CTA** (8 dp sous la héros, blanc r26 bas) : `BoutonPrimaire`
   56 « Créer une vidéo » (`dash_create_video`) + micro-copie existante
   `dash_create_body`. **Un seul bouton orange plein sur l'écran.**
4. **Reprendre** : ligne-tuile blanche affichée **seulement si un brouillon
   Room actif existe** (DraftStore). Titre = `skinName` réel du brouillon,
   sous-titre = étape réelle (Brief en cours / Tournage en cours) — jamais de
   numéro de scène inventé. L'action relance `MainActivity` avec l'extra
   `vv_reprise` → **dialogue D42.27 validé réutilisé tel quel** (Reprendre =
   retour exact à l'étape, rushs restaurés ; Nouvelle vidéo = brouillon effacé
   sur décision explicite).
5. **Parrainage** : tuile blanche r22, code réel copiable `OrangeDeep` sur
   `OrangeVoile` (`dash_referral_code`), « Copier mon code » = secondaire doux
   (hiérarchie : un seul CTA orange plein), « Partager sur WhatsApp » outlined
   filet Line, jauge 4 dp (`dash_referral_gauge`) + sous-libellé serveur,
   « Voir mes filleuls » OrangeDeep.
6. **Derniers exports** : ligne-tuile affichée **seulement si
   countSucceeded > 0** — comptage et date RÉELS du journal Room (états
   SUCCEEDED). Pas de miniatures : les métadonnées fichiers ne sont pas
   journalisées → vérité comptable, aucune vignette inventée.
7. **Tab bar §7.13** (`BarreOnglets` DS) : Accueil / Formules / **Créer**
   (central orange 56) / Parrainage / Réglages — navigation vers les **vues
   réelles existantes** du hub (view switch), action centrale = onCreateVideo.

## Écrans secondaires

- **ReferralScreen** : H2 Navy + Sub Muted, 3 tuiles blanches r22 (code,
  progression `ref2_gauge`, récompense), historique repliable (Text cliquable
  OrangeDeep, icônes check/vert et horloge/muted — plus de glyphes ✓/○),
  CTA unique `BoutonPrimaire` partage WhatsApp.
- **SettingsScreen** : H2 + Sub, 7 lignes-tuiles `LigneListe` DS (r22, ombre
  douce, chevron ; compte sans chevron — informatif). Comportements réels
  D41 (F6) inchangés, signature inchangée.

## Contrats préservés (aucune régression)

- `DashboardScreen` : signature **backward-compatible** (24 paramètres, les 8
  nouveaux ont des défauts). `SyncState`, `ReferralGaugeUi`, `EntitlementsCache`
  inchangés.
- `DashboardActivity` : synchroniser/chargerParrainage/copierCode/share/
  startCheckout/dialogs/espaceUtilise **intacts** ; seuls ajouts : champs d'état,
  `relireDonneesProjet()` (Room lecture seule, appelé par onCreate/retour
  Accueil/relancerSync — plus de `render()` direct), `surOnglet`,
  `relancerReprise`.
- DAO : 2 requêtes **additives en lecture seule**
  (`countSucceeded(uid)`, `lastSucceededTs(uid)`) — aucun contrat/écriture modifié.
- `MainActivity` : entrée `vv_reprise` **explicite uniquement** (extra absent =
  démarrage normal inchangé ; deep-link et session restaurés avant). E2E
  launcher-intent sans impact.
- testTags intangibles : `dash_settings_icon`, `dash_create_video`,
  `dash_referral_code`, `dash_referral_gauge`, `dash_see_plans`, `ref2_gauge`,
  `price_*`, `paywall_*`, `paywall_soon` — tous présents.

## États honnêtes (mission §8)

- Pas d'icône notifications dans le header (aucun système réel — un point
  orange serait un faux indicateur). **Écart documenté.**
- « Bonjour » seul si aucun nom réel (jamais « — »).
- Reprendre / Derniers exports absents si données réelles absentes.
- Sync : « Synchronisé » uniquement après preuve serveur (comportement D42.32
  Lot 5 conservé à l'identique dans `LigneSync`).

## Tests

- `DashboardVisualCheckTest` : assertion `dash_app_name` retirée (le nom d'app
  quitte le header — avatar à la place, marque portée par l'insigne et les
  autres écrans) ; ajout `dash_tab_create` + `dash_tab_home` (§9.3.6). Toutes
  les autres assertions inchangées et satisfaites (vérifié assertion par
  assertion : bonjour deux-tons un nœud, compteur 6, qualité 1080p, sync,
  CTA, code, copie, partage, jauge 3/5, hors-ligne + Réessayer +
  `ref_code_pending`, formule active sans « 0 »/9999, historique repliable).
- `DashboardL10nCheckTest`, `PaywallUiCheckTest` : inchangés, satisfaits
  (paywall intact ; réglages `set_title`/`set_logout`/`set_storage` présents).

## Vérifications statiques locales

- Accolades 118/118, parenthèses équilibrées, imports tous utilisés
  (audit regex), symboles DS tous importés, chaînes FR/EN symétriques (90/90),
  fonctions ≤ 80 lignes (detekt LongMethod=80 ; max nouvelle = SettingsScreen
  73 ; PaywallScreen 81 = inchangée HEAD, déjà verte en CI), trailing commas
  conformes au style du dépôt.
- 2 bugs auto-infligés détectés et corrigés avant commit : `relireDonneesProjet`
  dupliqué (replace à double ancre) et `stringResource` dans
  `buildAnnotatedString` (lambda non composable).

## Reste famille 09 → rien. Prochaine : famille 10 (tarifs/aide).
