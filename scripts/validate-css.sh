#!/bin/bash
# ============================================================
# CSS Class Validator
# Checks that every CSS class used in HTML is defined in either
# the file's local <style> block or a linked shared CSS file.
#
# Usage:
#   ./scripts/validate-css.sh 03-Synthesis-to-Chat.html
#   ./scripts/validate-css.sh   # validates all 5 workflow files
# ============================================================

set -uo pipefail
cd "$(dirname "$0")/.."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

WORKFLOW_FILES=(
  "01-Investigation.html"
  "02-Evidence-v2.html"
  "03-Synthesis-to-Chat.html"
  "04-Veracity-scoring.html"
  "05-Preview-Approve.html"
)

# If a file is passed as argument, validate only that file
if [ $# -gt 0 ]; then
  WORKFLOW_FILES=("$@")
fi

TOTAL_MISSING=0
TOTAL_FILES=0

for FILE in "${WORKFLOW_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo -e "${RED}File not found: $FILE${NC}"
    continue
  fi
  TOTAL_FILES=$((TOTAL_FILES + 1))

  python3 -c "
import re, sys

file = '$FILE'
with open(file) as f:
    content = f.read()

# 1. Extract local CSS classes from <style> block
style_match = re.search(r'<style>(.*?)</style>', content, re.DOTALL)
style = style_match.group(1) if style_match else ''
local_classes = set()
for m in re.finditer(r'\.([\w-]+)', style):
    local_classes.add(m.group(1))

# 2. Find linked CSS files
linked_classes = set()
for m in re.finditer(r'href=\"(Components/[^\"]+\.css)\"', content):
    css_path = m.group(1)
    try:
        with open(css_path) as f:
            css_content = f.read()
        for cm in re.finditer(r'\.([\w-]+)', css_content):
            linked_classes.add(cm.group(1))
    except FileNotFoundError:
        print(f'  WARNING: linked CSS not found: {css_path}', file=sys.stderr)

all_css = local_classes | linked_classes

# 3. Extract HTML classes from body (after </style>, before <script>)
body_match = re.search(r'</style>(.*?)(<script|$)', content, re.DOTALL)
body = body_match.group(1) if body_match else ''
html_classes = set()
for m in re.finditer(r'class=\"([^\"]+)\"', body):
    for c in m.group(1).split():
        html_classes.add(c)

# 4. Filter out non-class tokens (IDs used as classes, state classes set by JS, etc.)
IGNORE = {
    # JS-toggled states
    'active', 'visible', 'done', 'pending', 'off', 'unchecked',
    'glow-active', 'chat-started', 'updated', 'placeholder',
    'transition-to-chat', 'current',
    # Layout utilities unlikely to have dedicated CSS
    'content-gap', 'section-gap',
    # Semantic table column annotations (no CSS needed — auto-width)
    'col-source', 'col-records', 'col-result', 'col-fresh', 'col-download',
    'col-participants', 'col-role', 'col-response', 'col-timestamp',
    'col-confidence',
    # JS selector hooks (no CSS styling)
    'open-report-btn', 'ev-task-img', 'ev-card-general-progress',
}

missing = sorted(html_classes - all_css - IGNORE)

if missing:
    print(f'  FAIL: {len(missing)} unresolved class(es):')
    for c in missing:
        print(f'    - .{c}')
    sys.exit(1)
else:
    print(f'  OK: all {len(html_classes)} classes resolved ({len(local_classes)} local + {len(linked_classes)} shared)')
    sys.exit(0)
"
  STATUS=$?
  echo -e "${STATUS:+${RED}}${FILE}${NC}"
  if [ $STATUS -ne 0 ]; then
    TOTAL_MISSING=$((TOTAL_MISSING + 1))
  fi
  echo ""
done

echo "---"
if [ $TOTAL_MISSING -eq 0 ]; then
  echo -e "${GREEN}All $TOTAL_FILES file(s) passed.${NC}"
else
  echo -e "${RED}$TOTAL_MISSING of $TOTAL_FILES file(s) have unresolved classes.${NC}"
  exit 1
fi
