#!/usr/bin/env bash

set -euo pipefail

pty_bin=${SIMPLE_PTY_BIN:-simple-pty}
termshot_bin=${SIMPLE_TERMSHOT_BIN:-simple-termshot}

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    exit 1
}

if ! command -v "$pty_bin" >/dev/null 2>&1; then
    fail "simple-pty not found; install it or set SIMPLE_PTY_BIN"
fi
if ! command -v "$termshot_bin" >/dev/null 2>&1; then
    fail "simple-termshot not found; install it or set SIMPLE_TERMSHOT_BIN"
fi

project_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
fixture=$project_root/tests/fixtures/stateful-terminal.sh
rows=6
cols=32

test_root=$(mktemp -d "${TMPDIR:-/tmp}/simple-ai-integration.XXXXXX")
export SIMPLE_PTY_DIR=$test_root/sessions
handle=

cleanup() {
    if [[ -n "$handle" ]]; then
        "$pty_bin" stop "$handle" >/dev/null 2>&1 || true
        "$pty_bin" remove "$handle" >/dev/null 2>&1 || true
    fi
    rm -rf -- "$test_root"
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

handle=$("$pty_bin" start --rows="$rows" --cols="$cols" -- \
    /usr/bin/env bash "$fixture")

"$pty_bin" wait-output "$handle" READY --timeout=5000
position=$("$pty_bin" position "$handle")
"$pty_bin" send "$handle" render
"$pty_bin" wait-output "$handle" DONE \
    --from="$position" --timeout=5000

raw_output=$test_root/raw-output.log
"$pty_bin" output "$handle" >"$raw_output"

LC_ALL=C grep -aF 'Progress: 10%' "$raw_output" >/dev/null ||
    fail 'raw PTY history omitted the initial progress state'
LC_ALL=C grep -aF 'Progress: 100%' "$raw_output" >/dev/null ||
    fail 'raw PTY history omitted the final progress state'

rendered=$("$pty_bin" output "$handle" | \
    "$termshot_bin" --width="$cols" --height="$rows")
expected=$'Progress: 100%\nRESULT: complete\nDONE'
if [[ "$rendered" != "$expected" ]]; then
    printf 'Expected rendered screen:\n%s\n' "$expected" >&2
    printf 'Actual rendered screen:\n%s\n' "$rendered" >&2
    fail 'rendered screen did not represent the final terminal state'
fi

position=$("$pty_bin" position "$handle")
"$pty_bin" send "$handle" quit
"$pty_bin" wait-output "$handle" BYE \
    --from="$position" --timeout=5000
target_status=$("$pty_bin" wait "$handle" --timeout=5000)
[[ "$target_status" == 0 ]] ||
    fail "fixture exited with status $target_status"

"$pty_bin" remove "$handle"
handle=
[[ -z "$("$pty_bin" list)" ]] ||
    fail 'an integration-test session remained after removal'

printf 'pty-termshot integration: PASS\n'
