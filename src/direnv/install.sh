#!/bin/sh

set -e

ARCH=${ARCHITECTURE:-"amd64"}
AUTO_ENABLE=${AUTOENABLE:-true}
VERSION=${VERSION:-"latest"}
INSTALL_PATH=${INSTALLPATH:-"/usr/local/bin/direnv"}

# Install required packages using whichever package manager is available
if command -v apk >/dev/null 2>&1; then
    apk add --no-cache bash curl ca-certificates
elif command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    if [ "$(find /var/lib/apt/lists/* 2>/dev/null | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
    apt-get -y install --no-install-recommends apt-transport-https curl ca-certificates tar
else
    echo "Unsupported package manager: neither apk nor apt-get found"
    exit 1
fi

RELEASES="https://github.com/direnv/direnv/releases"

if [ "${VERSION}" = "latest" ]; then
    VERSION=$(curl -si "${RELEASES}/latest" | awk '/location: /{ n=split($2,t,"/"); print t[n] }' | tr -d "\r\n")
fi

RELEASE_FILE="direnv.linux-${ARCH}"
RELEASE_URL="${RELEASES}/download/${VERSION}/${RELEASE_FILE}"

echo "Downloading direnv ${VERSION} for ${ARCH}..."
curl -o "${INSTALL_PATH}" -fL "${RELEASE_URL}"
chmod +x "${INSTALL_PATH}"

if [ "${AUTO_ENABLE}" = "true" ]; then
    BASHRC="${_REMOTE_USER_HOME}/.bashrc"
    ZSHRC="${_REMOTE_USER_HOME}/.zshrc"

    if ! grep -q "_direnv_hook" "${BASHRC}" 2>/dev/null; then
        echo "Adding direnv hook to ${BASHRC}"
        direnv hook bash >> "${BASHRC}"
    fi

    if command -v zsh >/dev/null 2>&1 && ! grep -q "_direnv_hook" "${ZSHRC}" 2>/dev/null; then
        echo "Adding direnv hook to ${ZSHRC}"
        direnv hook zsh >> "${ZSHRC}"
    fi
fi
