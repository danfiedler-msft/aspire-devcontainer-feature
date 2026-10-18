#!/usr/bin/env bash

set -euo pipefail

FEATURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../src/aspire" && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT
export HOME="$TEST_DIR"

curl() {
    [[ "$*" == "-fsSL https://aspire.dev/install.sh" ]] || return 1
    if [[ "${FAIL_DOWNLOAD:-false}" == "true" ]]; then
        return 22
    fi
    cat <<'INSTALLER'
printf '%s\n' "$*" > "$HOME/installer-args"
mkdir -p "$HOME/.aspire/bin"
touch "$HOME/.aspire/bin/aspire"
INSTALLER
}

ldconfig() {
    echo libicudata
}

cp() {
    [[ "$1" == "$HOME/.aspire/bin/aspire" && "$2" == "/usr/local/bin/aspire" ]]
    touch "$HOME/copied"
}

chmod() {
    [[ "$*" == "755 /usr/local/bin/aspire" ]]
    touch "$HOME/executable"
}

export -f curl ldconfig cp chmod

run_case() {
    local label="$1" expected_args="$2"
    shift 2
    rm -f "$HOME/installer-args" "$HOME/copied" "$HOME/executable"
    env -u INSTALLCLI -u USEDAILYBUILDS "$@" bash "$FEATURE_DIR/install.sh"
    if [[ "$expected_args" == "skipped" ]]; then
        [[ ! -e "$HOME/installer-args" && ! -e "$HOME/copied" && ! -e "$HOME/executable" ]]
    else
        [[ "$(cat "$HOME/installer-args")" == "$expected_args" ]]
        [[ -e "$HOME/copied" && -e "$HOME/executable" ]]
    fi
    echo "Passed: $label"
}

run_case "default stable release" ""
run_case "explicit stable release" "" USEDAILYBUILDS=false
run_case "daily build" "--quality dev" USEDAILYBUILDS=true
run_case "case-insensitive daily build" "--quality dev" USEDAILYBUILDS=TRUE
run_case "CLI disabled" "skipped" INSTALLCLI=false
run_case "CLI disabled with daily builds enabled" "skipped" INSTALLCLI=false USEDAILYBUILDS=true

if FAIL_DOWNLOAD=true bash "$FEATURE_DIR/install.sh"; then
    echo "Expected installer download failure to propagate." >&2
    exit 1
fi
echo "Passed: installer download failure propagates"
