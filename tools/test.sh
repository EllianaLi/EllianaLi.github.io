#!/usr/bin/env bash
#
# Build the Jekyll site without running html-proofer
#
# Usage: bash tools/test.sh

set -eu

SITE_DIR="_site"
CONFIG="_config.yml"

# Clean previous site build
if [[ -d "$SITE_DIR" ]]; then
  rm -rf "$SITE_DIR"
fi

# Build the site
JEKYLL_ENV=production bundle exec jekyll build -d "$SITE_DIR" -c "$CONFIG"

echo "✅ Build completed. HTML-Proofer was skipped."
