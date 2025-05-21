#!/usr/bin/env bash
set -eux

# ── 0) Desactiva qualsevol proxy HTTP/HTTPS globalment ───────────────
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
git config --global --unset http.proxy  || true
git config --global --unset https.proxy || true

# ── 0.1) Reconfigura SSH per redirigir github.com al port 443 ────────
mkdir -p ~/.ssh
cat > ~/.ssh/config << 'EOF'
Host github.com
  HostName ssh.github.com
  Port 443
  User git
  IdentityFile ~/.ssh/id_ed25519
  StrictHostKeyChecking no
EOF
chmod 600 ~/.ssh/config

# ── 1) Instal·la Git i SSH client si no estan presents ────────────────
if ! command -v git >/dev/null 2>&1; then
  apt-get update
  apt-get install -y git openssh-client netcat
fi

# ── 2) Clona el repo si encara no existeix el .git ────────────────────
if [ ! -d ".git" ]; then
  git clone git@github.com:PlayNuzic/encapsulated.git .
fi

# ── 3) Inicia l’agent SSH i afegeix la teva clau ──────────────────────
eval "$(ssh-agent -s)"

if [ -n "${SSH_KEY-}" ]; then
  :
elif [ -f "${HOME}/.ssh/id_ed25519" ]; then
  export SSH_KEY="$(cat "${HOME}/.ssh/id_ed25519")"
elif [ -f "${HOME}/.ssh/id_rsa" ]; then
  export SSH_KEY="$(cat "${HOME}/.ssh/id_rsa")"
else
  echo "ERROR: no s'ha trobat cap clau SSH a ~/.ssh" >&2
  exit 1
fi

echo "$SSH_KEY" > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519

# ── 4) Afegim GitHub al known_hosts ───────────────────────────────────
ssh-keyscan github.com >> ~/.ssh/known_hosts

# ── 5) Instal·la i autentica amb GitHub CLI via PAT ───────────────────
if ! command -v gh >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y gh
fi

echo "Autenticant amb GitHub CLI…"
echo "$GITHUB_TOKEN" | gh auth login --with-token
gh auth status

# ── 6) Sincronitza la branca aleatorizador ───────────────────────────
git fetch --all
git checkout aleatorizador

# ── 7) Pull amb rebase (o merge si cal) ──────────────────────────────
git pull --rebase origin aleatorizador || git pull origin aleatorizador

echo "=== Entorn completament configurat. Ja pots fer git push origin aleatorizador ==="
