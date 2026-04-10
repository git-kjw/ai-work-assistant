#!/bin/sh
# Check repository for disallowed 'memory/' usages
PATTERN='directory.*memory|memory/memory'
echo "Scanning repository for patterns: $PATTERN"
# Search entire repo
git grep -nE "$PATTERN" || echo "No matches found."
echo "Done."
