#!/usr/bin/env bash
#
# Build and test the site content (Chirpy Theme)
#
# Requirements:
#   - jekyll
#   - html-proofer
#
# Usage:
#   bash tools/test.sh [--config "_config.yml"]


set -eu

SITE_DIR="_site"
_config="_config.yml"
_baseurl=""

help() {
  echo "Build and test the site content"
  echo
  echo "Usage:"
  echo "   bash $0 [options]"
  echo
  echo "Options:"
  echo '     -c, --config   "<config_a[,config_b[...]]>"    Specify config file(s)'
  echo "     -h, --help               Print this information."
}

read_baseurl() {
  if [[ $_config == *","* ]]; then
    IFS=","
    read -ra config_array <<<"$_config"
    for ((i = ${#config_array[@]} - 1; i >= 0; i--)); do
      _tmp_baseurl="$(grep '^baseurl:' "${config_array[i]}" | sed "s/.*: *//;s/['\"]//g;s/#.*//")"
      if [[ -n $_tmp_baseurl ]]; then
        _baseurl="$_tmp_baseurl"
        break
      fi
    done
  else
    _baseurl="$(grep '^baseurl:' "$_config" | sed "s/.*: *//;s/['\"]//g;s/#.*//")"
  fi
}

main() {
  if [[ -d $SITE_DIR ]]; then
    rm -rf "$SITE_DIR"
  fi

  read_baseurl

  echo -e "\n🔧 Building site with config: $_config"
  JEKYLL_ENV=production bundle exec jekyll build \
    -d "$SITE_DIR$_baseurl" -c "$_config"

  echo -e "\n🔍 Running html-proofer checks (with relaxed rules)..."
  bundle exec htmlproofer "$SITE_DIR" \
    --disable-external \
    --allow-hash-href \
    --assume-extension \
    --empty-alt-ignore \
    --check-html \
    --ignore-urls "/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/"
}

while (($#)); do
  opt="$1"
  case $opt in
  -c | --config)
    _config="$2"
    shift 2
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    help
    exit 1
    ;;
  esac
done

main