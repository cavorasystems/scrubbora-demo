#!/usr/bin/env bash
# Swap the real Scrubbora phone number into the site everywhere at once.
# Usage:  ./swap-number.sh 250-555-0142
set -euo pipefail
[ $# -eq 1 ] || { echo "usage: $0 250-XXX-XXXX"; exit 1; }
PRETTY="$1"
DIGITS=$(echo "$PRETTY" | tr -cd '0-9')
[ ${#DIGITS} -eq 10 ] || { echo "need 10 digits, got ${#DIGITS}"; exit 1; }
E164="+1$DIGITS"

for f in index.html areas.html; do
  sed -i '' \
    -e "s|250-XXX-XXXX|$PRETTY|g" \
    -e "s|+1250XXXXXXX|$E164|g" \
    -e "s|\"telephone\":\"+1-250-000-0000\"|\"telephone\":\"$E164\"|g" \
    "$f"
done

echo "Swapped to $PRETTY ($E164)"
echo "Remaining placeholders (should be none):"
grep -o "250-XXX-XXXX\|250-000-0000\|1250XXXXXXX" index.html areas.html || echo "  none"
