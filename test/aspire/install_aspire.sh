#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "no separate .NET SDK is installed" \
bash -c "! command -v dotnet"

check "aspire CLI is installed" \
command -v aspire

check "aspire CLI runs successfully" \
aspire --version

check "aspire CLI is on PATH without shell profiles" \
env -i HOME="$HOME" PATH=/usr/local/bin:/usr/bin:/bin bash --noprofile --norc -c \
'test "$(command -v aspire)" = /usr/local/bin/aspire && aspire --version'

if [[ "$(id -u)" -eq 0 ]]; then
    check "aspire CLI is on PATH for a non-root user" \
    su -s /bin/sh nobody -c 'env -i HOME=/tmp PATH=/usr/local/bin:/usr/bin:/bin bash --noprofile --norc -c "aspire --version"'
fi

reportResults
