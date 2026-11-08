#!/usr/bin/env bash
# ============================================================================
# VV Remote QA — Mise en place COMPLETE du runner self-hosted (machine operateur)
# Cible : PC Ubuntu 22.04+, 16 Go RAM, virtualisation activee (VT-x/AMD-V).
# Cout : 0 FCFA. Duree : ~30-45 min (selon debit). Idempotent : relancable.
#
# CORRECTIONS apportees au document Agent 2 (CI_SELF_HOSTED_ENGINEERING.md) :
#  - repo reel : mdgejc14-hash/vitrine-video (pas EPD-HOLDING)
#  - `avdmanager modify avd --no-window` n'existe pas : le headless se regle
#    au LANCEMENT de l'emulateur (flags -no-window ...), pas a la creation
#  - taches Gradle avec flavors : connectedQaDeterministicDebugAndroidTest
#    (pas connectedAndroidTest -PtestFilter qui n'existe pas)
#  - Appium 2 : capabilities via fichier JSON (--config n'est pas le format) ;
#    le banc natif UiAutomator/androidTest est privilegie (zero dependance)
#  - cleanup : JAMAIS rm -rf ~/.gradle/caches
#
# Usage :
#   1) Creer un token runner : GitHub > Settings > Actions > Runners > New
#      self-hosted runner (Linux x64) => copier le token
#   2) RUNNER_TOKEN=xxxxx ./scripts/setup_runner.sh
# ============================================================================
set -euo pipefail

REPO_URL="https://github.com/mdgejc14-hash/vitrine-video"
RUNNER_TOKEN="${RUNNER_TOKEN:-}"
ANDROID_SDK_DIR="${ANDROID_SDK_DIR:-$HOME/android-sdk}"
API_LEVEL="${API_LEVEL:-34}"
AVD_NAME="${AVD_NAME:-VitrineVideo_AVD}"
RUNNER_DIR="${RUNNER_DIR:-$HOME/actions-runner}"
MOCK_REPO_DIR="${MOCK_REPO_DIR:-$HOME/vitrine-video}"

log() { echo -e "\n\033[1;32m== $1 ==\033[0m"; }
die() { echo -e "\033[1;31mERREUR : $1\033[0m" >&2; exit 1; }

# --- 0. Prérequis système ---------------------------------------------------
log "0/8 Paquets systeme (JDK 17, KVM, outils)"
sudo apt-get update -qq
sudo apt-get install -y -qq openjdk-17-jdk unzip curl git qemu-kvm cpu-checker nodejs npm >/dev/null
sudo adduser "$USER" kvm 2>/dev/null || true
if [ -e /dev/kvm ]; then
  log "KVM disponible : emulateur x86_64 OK"
else
  echo "ATTENTION : /dev/kvm absent. Activez la virtualisation (BIOS VT-x/AMD-V)."
  echo "Sans KVM, utilisez un appareil physique (device_type=physical) — le workflow le supporte."
fi

# --- 1. SDK Android ---------------------------------------------------------
log "1/8 SDK Android (cmdline-tools, platform $API_LEVEL, emulator, image x86_64)"
mkdir -p "$ANDROID_SDK_DIR/cmdline-tools"
if [ ! -d "$ANDROID_SDK_DIR/cmdline-tools/latest" ]; then
  cd /tmp
  curl -sSLo cmdtools.zip "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
  unzip -qo cmdtools.zip -d "$ANDROID_SDK_DIR/cmdline-tools"
  mv "$ANDROID_SDK_DIR/cmdline-tools/cmdline-tools" "$ANDROID_SDK_DIR/cmdline-tools/latest"
fi
export PATH="$ANDROID_SDK_DIR/cmdline-tools/latest/bin:$ANDROID_SDK_DIR/platform-tools:$ANDROID_SDK_DIR/emulator:$PATH"
yes | sdkmanager --licenses >/dev/null 2>&1 || true
sdkmanager "platform-tools" "platforms;android-$API_LEVEL" "build-tools;$API_LEVEL.0.0" \
           "emulator" "system-images;android-$API_LEVEL;google_apis;x86_64" >/dev/null

# --- 2. AVD headless --------------------------------------------------------
log "2/8 Creation AVD $AVD_NAME (pixel_6_pro)"
if ! avdmanager list avd 2>/dev/null | grep -q "$AVD_NAME"; then
  echo "no" | avdmanager create avd -n "$AVD_NAME" \
    -k "system-images;android-$API_LEVEL;google_apis;x86_64" -d pixel_6_pro
fi
cat > "$HOME/.android/advancedFeatures.ini" <<'INI'
hw.gpu.enabled = yes
hw.gpu.mode = swiftshader_indirect
INI
echo "Lancement headless (par le workflow) : emulator -avd $AVD_NAME -no-window -no-audio -no-snapshot -no-boot-anim -gpu swiftshader_indirect -memory 4096"

# --- 3. Mock staging en service systemd -------------------------------------
log "3/8 Mock staging local (service vv-mock, port 3200, LAN uniquement)"
if [ ! -d "$MOCK_REPO_DIR/.git" ]; then
  git clone "$REPO_URL" "$MOCK_REPO_DIR"
fi
sudo tee /etc/systemd/system/vv-mock.service >/dev/null <<UNIT
[Unit]
Description=VV Mock Staging (QA locale, jamais Internet)
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$MOCK_REPO_DIR
ExecStart=/usr/bin/node $MOCK_REPO_DIR/mock-server/server.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable --now vv-mock
sleep 1
curl -sf http://localhost:3200/health && echo " => mock actif" || die "mock vv-mock ne repond pas"

# --- 4. Pare-feu : mock jamais expose sur Internet ---------------------------
log "4/8 Pare-feu ufw (deny incoming par defaut ; 3200 refuse depuis WAN)"
sudo ufw default deny incoming >/dev/null
sudo ufw default allow outgoing >/dev/null
sudo ufw allow OpenSSH >/dev/null
# Pas de `ufw allow 3200` : le mock reste joignable uniquement en loopback/LAN
# via l'interface locale ; l'appareil physique du LAN utilise l'IP privee hote.
sudo ufw --force enable >/dev/null

# --- 5. Runner GitHub Actions ------------------------------------------------
log "5/8 Installation runner GitHub Actions (label android-qa)"
[ -n "$RUNNER_TOKEN" ] || die "RUNNER_TOKEN manquant (GitHub > Settings > Actions > Runners > New)"
mkdir -p "$RUNNER_DIR" && cd "$RUNNER_DIR"
RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | tr -d v)
curl -sSLo runner.tar.gz "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
tar xzf runner.tar.gz && rm runner.tar.gz
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --labels android-qa --unattended --name "$(hostname)-vvqa"
sudo ./svc.sh install "$USER" 2>/dev/null || ./svc.sh install || true
sudo ./svc.sh start 2>/dev/null || ./svc.sh start || true

# --- 6. Appareil physique (optionnel, aide-memoire) --------------------------
log "6/8 Aide-memoire appareil physique (adb WiFi)"
cat <<'PHY'
  Telephone : Parametres > Options developpeur > Debogage USB
  adb tcpip 5555                 # via USB, une fois
  adb connect IP_TELEPHONE:5555  # IP = Parametres > A propos > Etat
  Le workflow qa-interactive-selfhosted.yml prend device_ip=IP_TELEPHONE
  et host_lan_ip=IP_HOTE (mock). Permissions accordees par le workflow (pm grant).
PHY

# --- 7. Vérification finale ---------------------------------------------------
log "7/8 Verification finale"
java -version 2>&1 | head -1
adb version | head -1
node --version
systemctl is-active vv-mock
curl -sf http://localhost:3200/api/v1/pricing/uemoa | head -c 120; echo

log "8/8 TERMINE"
cat <<'DONE'
Prochaines etapes :
  1. GitHub > Actions > "QA interactive (self-hosted)" > Run workflow
     (test_type=all, device_type=emulator) — premier banc complet.
  2. Verifier l'artifact qa-interactive-* (rapports XML + capture).
  3. Documenter le resultat dans docs/QA.md (honneste : PASS/FAIL/BLOCKED).
Rappel securite : machine DEDIEE aux tests (jamais production) ; mock sans
donnees reelles ; certif/secret locaux ; runner label android-qa uniquement.
DONE
