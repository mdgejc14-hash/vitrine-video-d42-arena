-- Vitrine Vidéo V2.0 : modèle D1 / SQLite PROPOSÉ, NON DÉPLOYÉ.
-- Comparer aux migrations et données réellement présentes. Ne pas exécuter
-- automatiquement sur production. Aucun prestataire, prix ou offre n'est inséré.
-- La propriété du compte, les changements de statut et la validation des
-- licences restent contrôlés par les requêtes préparées du Worker.

PRAGMA foreign_keys = ON;

CREATE TABLE v20_plan_catalog (
    plan_code TEXT PRIMARY KEY,
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
    quota_videos INTEGER NOT NULL CHECK (quota_videos >= 2), -- formule payée : plusieurs crédits
    quota_period_rule TEXT NOT NULL CHECK (quota_period_rule IN ('SUBSCRIPTION_WINDOW', 'CALENDAR_MONTH', 'CUSTOM_APPROVED')),
    export_allowed INTEGER NOT NULL CHECK (export_allowed IN (0,1)),
    clean_export_allowed INTEGER NOT NULL CHECK (clean_export_allowed IN (0,1)),
    watermarked_export_allowed INTEGER NOT NULL CHECK (watermarked_export_allowed IN (0,1)),
    status TEXT NOT NULL CHECK (status IN ('DRAFT','ACTIVE','RETIRED')),
    -- Aucun export final filigrané ; si l'export existe, il est propre.
    CHECK (watermarked_export_allowed = 0),
    CHECK (clean_export_allowed = export_allowed),
    CHECK (status <> 'ACTIVE' OR export_allowed = 1)
);

CREATE TABLE v20_plan_prices (
    offer_id TEXT PRIMARY KEY,
    plan_code TEXT NOT NULL REFERENCES v20_plan_catalog(plan_code),
    market_code TEXT NOT NULL,
    currency TEXT NOT NULL CHECK (length(currency) = 3),
    amount_minor INTEGER NOT NULL CHECK (amount_minor >= 0),
    valid_from_sec INTEGER NOT NULL,
    valid_until_sec INTEGER CHECK (valid_until_sec IS NULL OR valid_until_sec > valid_from_sec),
    status TEXT NOT NULL CHECK (status IN ('DRAFT','ACTIVE','RETIRED'))
);
CREATE INDEX v20_prices_market ON v20_plan_prices(market_code, currency, status);

CREATE TABLE v20_payment_orders (
    order_id TEXT PRIMARY KEY,
    account_id TEXT NOT NULL,
    offer_id TEXT NOT NULL REFERENCES v20_plan_prices(offer_id),
    plan_code TEXT NOT NULL REFERENCES v20_plan_catalog(plan_code),
    provider TEXT NOT NULL,
    provider_reference TEXT,
    amount_minor INTEGER NOT NULL CHECK (amount_minor >= 0),
    currency TEXT NOT NULL CHECK (length(currency) = 3),
    status TEXT NOT NULL CHECK (status IN ('CREATED','PENDING','PAID','FAILED','CANCELLED','REFUNDED','DISPUTED')),
    created_at_sec INTEGER NOT NULL,
    updated_at_sec INTEGER NOT NULL,
    idempotency_key TEXT NOT NULL,
    request_sha256 TEXT NOT NULL CHECK (length(request_sha256) = 64),
    UNIQUE (account_id, idempotency_key),
    UNIQUE (provider, provider_reference)
);
CREATE INDEX v20_orders_account ON v20_payment_orders(account_id, created_at_sec);

CREATE TABLE v20_payment_events (
    provider TEXT NOT NULL,
    provider_event_id TEXT NOT NULL,
    order_id TEXT REFERENCES v20_payment_orders(order_id),
    received_at_sec INTEGER NOT NULL,
    payload_sha256 TEXT NOT NULL CHECK (length(payload_sha256) = 64),
    authenticity_verified INTEGER NOT NULL CHECK (authenticity_verified IN (0,1)),
    processing_status TEXT NOT NULL CHECK (processing_status IN ('PENDING','APPLIED','REJECTED','CONFLICT')),
    PRIMARY KEY (provider, provider_event_id)
);

CREATE TABLE v20_subscriptions (
    subscription_id TEXT PRIMARY KEY,
    account_id TEXT NOT NULL,
    order_id TEXT NOT NULL UNIQUE REFERENCES v20_payment_orders(order_id),
    plan_code TEXT NOT NULL REFERENCES v20_plan_catalog(plan_code),
    starts_at_sec INTEGER NOT NULL,
    ends_at_sec INTEGER NOT NULL CHECK (ends_at_sec > starts_at_sec),
    status TEXT NOT NULL CHECK (status IN ('ACTIVE','EXPIRED','REVOKED','REFUNDED','DISPUTED'))
);
CREATE INDEX v20_subscriptions_account ON v20_subscriptions(account_id, status, ends_at_sec);

-- Registre des versions APK publiées, maintenu par l'éditeur. Le hash de fichier
-- aide au téléchargement mais n'est PAS prouvé par Android Key Attestation.
-- Une version/signature partagée entre canaux ne démontre pas le canal d'installation.
CREATE TABLE v20_android_releases (
    release_id TEXT PRIMARY KEY,
    package_name TEXT NOT NULL,
    version_code INTEGER NOT NULL CHECK (version_code >= 1),
    apk_file_sha256 TEXT NOT NULL CHECK (length(apk_file_sha256) = 64),
    status TEXT NOT NULL CHECK (status IN ('DRAFT','ACTIVE','RETIRED')),
    UNIQUE (package_name, version_code, apk_file_sha256)
);
-- Chaque signer_set_id décrit un ensemble exact autorisé pour la release.
-- Le Worker traite la rotation/multi-signature et la compatibilité Android ;
-- vérifier qu'au moins un ensemble existe pour chaque release activée.
CREATE TABLE v20_android_release_signers (
    release_id TEXT NOT NULL REFERENCES v20_android_releases(release_id),
    signer_set_id TEXT NOT NULL,
    certificate_sha256 TEXT NOT NULL CHECK (length(certificate_sha256) = 64),
    PRIMARY KEY (release_id, signer_set_id, certificate_sha256)
);

CREATE TABLE v20_installations (
    installation_id TEXT PRIMARY KEY,
    account_id TEXT NOT NULL,
    -- NULL lors de la création du défi, avant la génération de clé attestée.
    public_key_spki_b64url TEXT,
    public_key_sha256 TEXT UNIQUE CHECK (public_key_sha256 IS NULL OR length(public_key_sha256) = 64),
    -- Niveau vérifié par le Worker ; UNKNOWN si aucune preuve fiable.
    key_security_level TEXT NOT NULL CHECK (key_security_level IN ('UNKNOWN','SOFTWARE','TEE','STRONGBOX')),
    status TEXT NOT NULL CHECK (status IN ('PENDING','PENDING_REVIEW','ACTIVE','REJECTED','REVOKED','LOST')),
    integrity_tier TEXT NOT NULL CHECK (integrity_tier IN ('PENDING_REVIEW','DIRECT_ATTESTED','DIRECT_BASIC_APPROVED','REJECTED')),
    verified_release_id TEXT REFERENCES v20_android_releases(release_id),
    attestation_verified_at_sec INTEGER,
    -- Référence de politique de risque ou décision de support autorisée.
    basic_approval_reference TEXT,
    registration_idempotency_key TEXT,
    registration_body_sha256 TEXT CHECK (registration_body_sha256 IS NULL OR length(registration_body_sha256) = 64),
    created_at_sec INTEGER NOT NULL,
    registered_at_sec INTEGER,
    CHECK ((public_key_spki_b64url IS NULL AND public_key_sha256 IS NULL)
        OR (public_key_spki_b64url IS NOT NULL AND public_key_sha256 IS NOT NULL)),
    CHECK ((registration_idempotency_key IS NULL AND registration_body_sha256 IS NULL)
        OR (registration_idempotency_key IS NOT NULL AND registration_body_sha256 IS NOT NULL)),
    CHECK (integrity_tier <> 'DIRECT_ATTESTED' OR (verified_release_id IS NOT NULL
        AND attestation_verified_at_sec IS NOT NULL AND key_security_level IN ('TEE','STRONGBOX'))),
    CHECK (integrity_tier <> 'DIRECT_BASIC_APPROVED' OR basic_approval_reference IS NOT NULL),
    CHECK (status <> 'ACTIVE' OR (public_key_sha256 IS NOT NULL AND registered_at_sec IS NOT NULL
        AND registration_idempotency_key IS NOT NULL AND integrity_tier IN ('DIRECT_ATTESTED','DIRECT_BASIC_APPROVED'))),
    UNIQUE (account_id, registration_idempotency_key)
);
CREATE INDEX v20_installations_account ON v20_installations(account_id, status);

-- Attribution une seule fois à la création d'un compte éligible ; pas d'expiration.
CREATE TABLE v20_welcome_accounts (
    account_id TEXT PRIMARY KEY,
    verified_creation_event_id TEXT NOT NULL UNIQUE,
    verified_account_created_at_sec INTEGER NOT NULL,
    awarded_at_sec INTEGER NOT NULL,
    quota_total INTEGER NOT NULL DEFAULT 3 CHECK (quota_total = 3),
    reserved_outstanding INTEGER NOT NULL DEFAULT 0 CHECK (reserved_outstanding >= 0),
    consumed_reported INTEGER NOT NULL DEFAULT 0 CHECK (consumed_reported >= 0),
    status TEXT NOT NULL CHECK (status IN ('ACTIVE','REVOKED','DISPUTED')),
    CHECK (reserved_outstanding + consumed_reported <= quota_total)
);

-- Artefact chiffré du shader final ; la clé de contenu est chiffrée côté serveur.
-- cipher_sha256 couvre tous les octets VVSH1 ; jamais de clé en clair dans D1.
CREATE TABLE v20_shader_artifacts (
    shader_payload_id TEXT PRIMARY KEY,
    release_id TEXT NOT NULL REFERENCES v20_android_releases(release_id),
    abi TEXT NOT NULL,
    cipher_sha256 TEXT NOT NULL CHECK (length(cipher_sha256) = 64),
    key_sha256 TEXT NOT NULL CHECK (length(key_sha256) = 64),
    content_key_ciphertext BLOB,
    content_key_encryption_key_id TEXT,
    status TEXT NOT NULL CHECK (status IN ('DRAFT','ACTIVE','RETIRED')),
    CHECK ((content_key_ciphertext IS NULL AND content_key_encryption_key_id IS NULL)
        OR (content_key_ciphertext IS NOT NULL AND content_key_encryption_key_id IS NOT NULL)),
    CHECK (status <> 'ACTIVE' OR content_key_ciphertext IS NOT NULL)
);

CREATE TABLE v20_challenges (
    challenge_sha256 TEXT PRIMARY KEY CHECK (length(challenge_sha256) = 64),
    account_id TEXT NOT NULL,
    installation_id TEXT NOT NULL REFERENCES v20_installations(installation_id),
    purpose TEXT NOT NULL CHECK (purpose IN ('ISSUE','WELCOME_ISSUE','TIME_ANCHOR','REGISTER')),
    created_at_sec INTEGER NOT NULL,
    expires_at_sec INTEGER NOT NULL CHECK (expires_at_sec > created_at_sec),
    consumed_at_sec INTEGER,
    consumed_by_attempt_id TEXT,
    CHECK ((consumed_at_sec IS NULL AND consumed_by_attempt_id IS NULL)
        OR (consumed_at_sec IS NOT NULL AND consumed_by_attempt_id IS NOT NULL))
);

-- Une tentative consomme un défi du bon compte, installation et but dans la
-- même transaction que la réservation ou la reprise idempotente. Le temps de
-- tentative est fixé par le Worker, jamais par le client.
CREATE TABLE v20_welcome_issue_attempts (
    attempt_id TEXT PRIMARY KEY,
    challenge_sha256 TEXT NOT NULL UNIQUE REFERENCES v20_challenges(challenge_sha256),
    account_id TEXT NOT NULL,
    installation_id TEXT NOT NULL REFERENCES v20_installations(installation_id),
    idempotency_key TEXT NOT NULL,
    request_sha256 TEXT NOT NULL CHECK (length(request_sha256) = 64),
    attempted_at_sec INTEGER NOT NULL
);
CREATE TRIGGER v20_welcome_consume_challenge
BEFORE INSERT ON v20_welcome_issue_attempts
BEGIN
    UPDATE v20_challenges
       SET consumed_at_sec = NEW.attempted_at_sec, consumed_by_attempt_id = NEW.attempt_id
     WHERE challenge_sha256 = NEW.challenge_sha256 AND account_id = NEW.account_id
       AND installation_id = NEW.installation_id AND purpose = 'WELCOME_ISSUE'
       AND consumed_at_sec IS NULL AND created_at_sec <= NEW.attempted_at_sec
       AND NEW.attempted_at_sec < expires_at_sec;
    SELECT CASE WHEN changes() <> 1 THEN RAISE(ABORT, 'WELCOME_CHALLENGE_INVALID') END;
END;

CREATE TABLE v20_quota_periods (
    period_id TEXT PRIMARY KEY,
    subscription_id TEXT NOT NULL REFERENCES v20_subscriptions(subscription_id),
    starts_at_sec INTEGER NOT NULL,
    ends_at_sec INTEGER NOT NULL CHECK (ends_at_sec > starts_at_sec),
    quota_total INTEGER NOT NULL CHECK (quota_total > 0),
    reserved_outstanding INTEGER NOT NULL DEFAULT 0 CHECK (reserved_outstanding >= 0),
    consumed_reported INTEGER NOT NULL DEFAULT 0 CHECK (consumed_reported >= 0),
    CHECK (reserved_outstanding + consumed_reported <= quota_total),
    UNIQUE (subscription_id, starts_at_sec, ends_at_sec)
);

CREATE TABLE v20_offline_grants (
    grant_id TEXT PRIMARY KEY,
    period_id TEXT REFERENCES v20_quota_periods(period_id),
    account_id TEXT NOT NULL,
    installation_id TEXT NOT NULL REFERENCES v20_installations(installation_id),
    idempotency_key TEXT NOT NULL,
    request_sha256 TEXT NOT NULL CHECK (length(request_sha256) = 64),
    allocated_count INTEGER NOT NULL CHECK (allocated_count > 0),
    reported_count INTEGER NOT NULL DEFAULT 0 CHECK (reported_count >= 0 AND reported_count <= allocated_count),
    permit_first INTEGER NOT NULL CHECK (permit_first >= 1),
    created_at_sec INTEGER NOT NULL,
    expires_at_sec INTEGER CHECK (expires_at_sec IS NULL OR expires_at_sec > created_at_sec),
    status TEXT NOT NULL CHECK (status IN ('ISSUE_PENDING','ISSUED','EXPIRED','REVOKED')),
    token_sha256 TEXT CHECK (token_sha256 IS NULL OR length(token_sha256) = 64),
    token_jws_ciphertext BLOB,
    token_encryption_key_id TEXT,
    grant_kind TEXT NOT NULL DEFAULT 'PAID' CHECK (grant_kind IN ('PAID','WELCOME')),
    welcome_account_id TEXT REFERENCES v20_welcome_accounts(account_id),
    welcome_issue_attempt_id TEXT REFERENCES v20_welcome_issue_attempts(attempt_id),
    shader_payload_id TEXT REFERENCES v20_shader_artifacts(shader_payload_id),
    CHECK ((token_jws_ciphertext IS NULL AND token_encryption_key_id IS NULL AND token_sha256 IS NULL)
        OR (token_jws_ciphertext IS NOT NULL AND token_encryption_key_id IS NOT NULL AND token_sha256 IS NOT NULL)),
    CHECK ((grant_kind = 'PAID' AND period_id IS NOT NULL AND welcome_account_id IS NULL
            AND welcome_issue_attempt_id IS NULL AND expires_at_sec IS NOT NULL)
        OR (grant_kind = 'WELCOME' AND period_id IS NULL AND welcome_account_id IS NOT NULL
            AND welcome_issue_attempt_id IS NOT NULL AND welcome_account_id = account_id
            AND expires_at_sec IS NULL AND allocated_count <= 3 AND status <> 'EXPIRED')),
    CHECK (status <> 'ISSUED' OR (token_jws_ciphertext IS NOT NULL AND shader_payload_id IS NOT NULL)),
    UNIQUE (account_id, installation_id, idempotency_key)
);
CREATE INDEX v20_grants_period ON v20_offline_grants(period_id, installation_id);

CREATE TABLE v20_usage_events (
    grant_id TEXT NOT NULL REFERENCES v20_offline_grants(grant_id),
    permit_serial INTEGER NOT NULL CHECK (permit_serial >= 1),
    installation_id TEXT NOT NULL REFERENCES v20_installations(installation_id),
    mp4_sha256 TEXT NOT NULL CHECK (length(mp4_sha256) = 64),
    plan_sha256 TEXT NOT NULL CHECK (length(plan_sha256) = 64),
    receipt_sha256 TEXT NOT NULL CHECK (length(receipt_sha256) = 64),
    event_sha256 TEXT NOT NULL CHECK (length(event_sha256) = 64),
    received_at_sec INTEGER NOT NULL,
    PRIMARY KEY (grant_id, permit_serial)
);

-- Gardes transactionnelles de bienvenue. Les écritures directes sur ces compteurs
-- sont interdites au reste du Worker. Pas de INSERT OR IGNORE / DO NOTHING sur
-- un lot : une collision doit lever une erreur et annuler l'instruction entière.
-- Reprendre ensuite par (account_id, installation_id, idempotency_key), vérifier
-- request_sha256 et renvoyer le même jeton après défi neuf. Toute erreur dans un
-- D1 batch doit annuler la transaction ; tester ce comportement en production.
CREATE TRIGGER v20_welcome_reserve_before_insert
BEFORE INSERT ON v20_offline_grants
WHEN NEW.grant_kind = 'WELCOME'
BEGIN
    SELECT CASE WHEN NOT EXISTS (
        SELECT 1 FROM v20_welcome_issue_attempts a JOIN v20_installations i
          ON i.installation_id = a.installation_id
         WHERE a.attempt_id = NEW.welcome_issue_attempt_id
           AND a.account_id = NEW.account_id AND a.installation_id = NEW.installation_id
           AND a.idempotency_key = NEW.idempotency_key AND a.request_sha256 = NEW.request_sha256
           AND i.account_id = NEW.account_id AND i.status = 'ACTIVE'
    ) THEN RAISE(ABORT, 'WELCOME_ATTEMPT_INVALID') END;
    UPDATE v20_welcome_accounts
       SET reserved_outstanding = reserved_outstanding + NEW.allocated_count
     WHERE account_id = NEW.account_id AND status = 'ACTIVE'
       AND quota_total - reserved_outstanding - consumed_reported >= NEW.allocated_count;
    SELECT CASE WHEN changes() <> 1 THEN RAISE(ABORT, 'WELCOME_QUOTA_UNAVAILABLE') END;
END;

CREATE TRIGGER v20_grant_identity_immutable
BEFORE UPDATE OF grant_id, grant_kind, account_id, installation_id, period_id,
    welcome_account_id, welcome_issue_attempt_id, allocated_count, permit_first, idempotency_key, request_sha256
ON v20_offline_grants
BEGIN
    SELECT RAISE(ABORT, 'GRANT_IDENTITY_IMMUTABLE');
END;

-- Le hash du JWS et l'artefact émis restent figés. La rotation de l'enveloppe
-- chiffrée est possible après déchiffrement, revérification du hash et audit.
CREATE TRIGGER v20_issued_token_immutable
BEFORE UPDATE OF token_sha256, shader_payload_id
ON v20_offline_grants
WHEN OLD.status <> 'ISSUE_PENDING'
BEGIN
    SELECT RAISE(ABORT, 'ISSUED_TOKEN_IMMUTABLE');
END;

-- Un lot déjà signé/émis ne peut jamais être libéré par simple suppression.
-- Une réservation strictement pending sans jeton peut seule être annulée, après
-- avoir prouvé qu'aucun jeton n'a été envoyé avant commit durable.
CREATE TRIGGER v20_welcome_no_delete_issued
BEFORE DELETE ON v20_offline_grants
WHEN OLD.grant_kind = 'WELCOME'
 AND (OLD.status <> 'ISSUE_PENDING' OR OLD.token_jws_ciphertext IS NOT NULL)
BEGIN
    SELECT RAISE(ABORT, 'WELCOME_GRANT_NOT_RECLAIMABLE');
END;

CREATE TRIGGER v20_welcome_cancel_unsigned
AFTER DELETE ON v20_offline_grants
WHEN OLD.grant_kind = 'WELCOME' AND OLD.status = 'ISSUE_PENDING'
 AND OLD.token_jws_ciphertext IS NULL
BEGIN
    UPDATE v20_welcome_accounts
       SET reserved_outstanding = reserved_outstanding - OLD.allocated_count
     WHERE account_id = OLD.account_id AND reserved_outstanding >= OLD.allocated_count;
    SELECT CASE WHEN changes() <> 1 THEN RAISE(ABORT, 'WELCOME_COUNTER_INCONSISTENT') END;
END;

-- Le Worker vérifie d'abord signature, JWS et hash ; cette garde de base ne les
-- remplace pas. Un usage reçu après expiration peut encore être synchronisé.
CREATE TRIGGER v20_usage_permit_guard
BEFORE INSERT ON v20_usage_events
WHEN NOT EXISTS (
    SELECT 1 FROM v20_offline_grants g
     WHERE g.grant_id = NEW.grant_id AND g.installation_id = NEW.installation_id
       AND g.status IN ('ISSUED','EXPIRED','REVOKED')
       AND NEW.permit_serial >= g.permit_first
       AND NEW.permit_serial - g.permit_first < g.allocated_count
)
BEGIN
    SELECT RAISE(ABORT, 'USAGE_OUTSIDE_GRANT');
END;

CREATE TRIGGER v20_welcome_consume_after_insert
AFTER INSERT ON v20_usage_events
WHEN (SELECT grant_kind FROM v20_offline_grants WHERE grant_id = NEW.grant_id) = 'WELCOME'
BEGIN
    UPDATE v20_offline_grants SET reported_count = reported_count + 1
     WHERE grant_id = NEW.grant_id AND reported_count < allocated_count;
    SELECT CASE WHEN changes() <> 1 THEN RAISE(ABORT, 'WELCOME_GRANT_EXHAUSTED') END;
    UPDATE v20_welcome_accounts
       SET reserved_outstanding = reserved_outstanding - 1,
           consumed_reported = consumed_reported + 1
     WHERE account_id = (SELECT account_id FROM v20_offline_grants WHERE grant_id = NEW.grant_id)
       AND reserved_outstanding >= 1 AND consumed_reported < quota_total;
    SELECT CASE WHEN changes() <> 1 THEN RAISE(ABORT, 'WELCOME_COUNTER_INCONSISTENT') END;
END;

CREATE TABLE v20_admin_roles (
    account_id TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('CATALOGUE_PUBLISHER','PAYMENT_REVIEWER','SECURITY_ADMIN','AUDITOR')),
    active INTEGER NOT NULL CHECK (active IN (0,1)),
    approved_at_sec INTEGER NOT NULL,
    PRIMARY KEY (account_id, role)
);

-- Métadonnées audio : les fichiers et preuves complets restent dans B2 privé.
CREATE TABLE v20_audio_evidence (
    evidence_id TEXT PRIMARY KEY,
    object_key TEXT NOT NULL,
    document_sha256 TEXT NOT NULL CHECK (length(document_sha256) = 64),
    status TEXT NOT NULL CHECK (status IN ('QUARANTINE','APPROVED','REJECTED'))
);
CREATE TABLE v20_audio_tracks (
    track_id TEXT PRIMARY KEY,
    sector_id TEXT NOT NULL,
    primary_template_id TEXT NOT NULL,
    master_sha256 TEXT NOT NULL UNIQUE CHECK (length(master_sha256) = 64),
    derivative_sha256 TEXT NOT NULL CHECK (length(derivative_sha256) = 64),
    licence TEXT NOT NULL CHECK (licence IN ('CC0-1.0','DOMAINE_PUBLIC_VERIFIE')),
    evidence_id TEXT NOT NULL REFERENCES v20_audio_evidence(evidence_id),
    status TEXT NOT NULL CHECK (status IN ('QUARANTINE','APPROVED','REVOKED'))
);
CREATE TABLE v20_track_templates (
    track_id TEXT NOT NULL REFERENCES v20_audio_tracks(track_id),
    template_id TEXT NOT NULL,
    template_sha256 TEXT NOT NULL CHECK (length(template_sha256) = 64),
    status TEXT NOT NULL CHECK (status IN ('QUARANTINE','APPROVED','REJECTED')),
    approval_id TEXT,
    PRIMARY KEY (track_id, template_id)
);
CREATE TABLE v20_audio_releases (
    release_seq INTEGER PRIMARY KEY CHECK (release_seq >= 1),
    manifest_object_key TEXT NOT NULL UNIQUE,
    manifest_sha256 TEXT NOT NULL CHECK (length(manifest_sha256) = 64),
    status TEXT NOT NULL CHECK (status IN ('DRAFT','PUBLISHED','REVOKED')),
    created_at_sec INTEGER NOT NULL
);
CREATE TABLE v20_audio_packs (
    release_seq INTEGER NOT NULL REFERENCES v20_audio_releases(release_seq),
    pack_id TEXT NOT NULL,
    sector_id TEXT NOT NULL,
    object_key TEXT NOT NULL,
    zip_sha256 TEXT NOT NULL CHECK (length(zip_sha256) = 64),
    size_bytes INTEGER NOT NULL CHECK (size_bytes > 0),
    status TEXT NOT NULL CHECK (status IN ('DRAFT','PUBLISHED','REVOKED')),
    PRIMARY KEY (release_seq, pack_id),
    UNIQUE (release_seq, object_key)
);
CREATE TABLE v20_pack_tracks (
    release_seq INTEGER NOT NULL,
    pack_id TEXT NOT NULL,
    track_id TEXT NOT NULL REFERENCES v20_audio_tracks(track_id),
    ordinal INTEGER NOT NULL CHECK (ordinal BETWEEN 1 AND 30),
    PRIMARY KEY (release_seq, pack_id, track_id),
    UNIQUE (release_seq, pack_id, ordinal),
    FOREIGN KEY (release_seq, pack_id) REFERENCES v20_audio_packs(release_seq, pack_id)
);
CREATE TABLE v20_audio_starter_tracks (
    release_seq INTEGER NOT NULL REFERENCES v20_audio_releases(release_seq),
    track_id TEXT NOT NULL REFERENCES v20_audio_tracks(track_id),
    PRIMARY KEY (release_seq, track_id)
);
CREATE TABLE v20_audio_release_pointer (
    channel TEXT PRIMARY KEY,
    release_seq INTEGER NOT NULL REFERENCES v20_audio_releases(release_seq)
);
CREATE TABLE v20_audio_blocklist (
    release_seq INTEGER NOT NULL REFERENCES v20_audio_releases(release_seq),
    asset_sha256 TEXT NOT NULL CHECK (length(asset_sha256) = 64),
    reason_code TEXT NOT NULL,
    PRIMARY KEY (release_seq, asset_sha256)
);

-- Important : les CHECK ne vérifient pas la signature, le paiement, les liens
-- entre comptes, l'authenticité APK, une chaîne d'attestation, le BPM ou les
-- preuves. Le profil DIRECT_BASIC_APPROVED n'est pas une attestation matérielle.
-- Ces décisions exigent Worker, transactions, application locale et tests réels.
-- Play Integrity n'est pas une obligation pour la distribution directe V1.
