#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'direnv' feature with no options.
#
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test \
#               --features direnv\
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu .

set -e

source dev-container-features-test-lib

check "version" direnv version
check "bash-integration" grep "_direnv_hook" ~/.bashrc

# zsh integration is only present when zsh is installed
if command -v zsh >/dev/null 2>&1; then
    check "zsh-integration" grep "_direnv_hook" ~/.zshrc
fi

reportResults
