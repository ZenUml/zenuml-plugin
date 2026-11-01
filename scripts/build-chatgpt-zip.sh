#!/usr/bin/env bash
# Build the ZIP uploaded to the ChatGPT plugin directory.
#
# ChatGPT connects one MCP server per plugin, so its package carries only the
# render server: the root plugin.json and mcp.json, the draw-diagrams skill,
# and the assets. Claude's files (.claude-plugin/, .mcp.json) and the
# confluence-diagrams skill stay out. So do the draw-diagrams lines between
# <!-- claude-only --> markers: OpenAI's guidelines forbid telling the model to
# use another connector.
#
# usage: scripts/build-chatgpt-zip.sh [output.zip]   (default: dist/zenuml-chatgpt-<version>.zip)
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(python3 -c 'import json; print(json.load(open("plugin.json"))["version"])')
out=${1:-dist/zenuml-chatgpt-$version.zip}
case $out in /*) ;; *) out=$PWD/$out ;; esac

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

cp plugin.json mcp.json README.md LICENSE "$stage/"
mkdir -p "$stage/assets" "$stage/skills/draw-diagrams"
cp assets/logo.png "$stage/assets/"
sed '/<!-- claude-only -->/,/<!-- \/claude-only -->/d' skills/draw-diagrams/SKILL.md \
  > "$stage/skills/draw-diagrams/SKILL.md"

if grep -qi 'confluence\|claude-only' "$stage/skills/draw-diagrams/SKILL.md"; then
  echo "draw-diagrams skill still mentions Confluence after stripping" >&2
  exit 1
fi

mkdir -p "$(dirname "$out")"
rm -f "$out"
(cd "$stage" && zip -qrX "$out" .)
echo "$out"
unzip -l "$out"
