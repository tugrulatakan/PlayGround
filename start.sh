#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_ROOT="$PWD"
/usr/bin/time -p test -f dist/index.html
PORT="${PORT:-3000}"
export PORT
OPENCODE_WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
DIST="$PROJECT_ROOT/dist"
/usr/bin/time -p mkdir -p "$OPENCODE_WEB_DIR"
/usr/bin/time -p test -d "$DIST"
if /usr/bin/time -p test -f package.json; then
  if /usr/bin/time -p test -f package-lock.json; then
    /usr/bin/time -p npm ci --no-audit --no-fund
  else
    /usr/bin/time -p npm install --no-audit --no-fund
  fi
  if /usr/bin/time -p node -e "const p=require('./package.json');process.exit(p.scripts&&p.scripts.build?0:1)"; then
    /usr/bin/time -p npm run build
  fi
fi
/usr/bin/time -p test -f "$DIST/index.html"
/usr/bin/time -p bash -c 'printf "%s" "{\"project\":\"$1\",\"directory\":\"$2\"}" | tee "$3/deployment-output.json" >/dev/null' _ "$PROJECT_ROOT" "$DIST" "$OPENCODE_WEB_DIR"
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$DIST" --bind 0.0.0.0
