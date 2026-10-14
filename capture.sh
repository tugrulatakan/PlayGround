#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")"
RUNTIME_DIR="${RUNTIME_DIR:-/home/runner/work/_temp/omgithub-runtime}"
if /usr/bin/time -p test -z "${CAPTURE_URL:-}"; then echo "CAPTURE_URL is required." >&2; exit 1; fi
if /usr/bin/time -p test -z "${CAPTURE_DIR:-}"; then echo "CAPTURE_DIR is required." >&2; exit 1; fi
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p test -f "$RUNTIME_DIR/scripts/default-capture.mjs"
set +e
/usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
code=$?
set -u
if /usr/bin/time -p test "$code" -ne 0; then echo "capture backend exited $code" >&2; exit "$code"; fi
if /usr/bin/time -p test ! -s "$CAPTURE_DIR/final-desktop.png"; then echo "missing final-desktop.png" >&2; exit 1; fi
if /usr/bin/time -p test ! -s "$CAPTURE_DIR/final-mobile.png"; then echo "missing final-mobile.png" >&2; exit 1; fi
/usr/bin/time -p ls -l "$CAPTURE_DIR/final-desktop.png" "$CAPTURE_DIR/final-mobile.png"
