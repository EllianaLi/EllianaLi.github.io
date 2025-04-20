##!/usr/bin/env bash
##
## Build and test the site content
##
## Requirement: html-proofer, jekyll
##
## Usage: See help information
#
#set -eu
#
#SITE_DIR="_site"
#
#_config="_config.yml"
#
#_baseurl=""
#
#help() {
#  echo "Build and test the site content"
#  echo
#  echo "Usage:"
#  echo
#  echo "   bash $0 [options]"
#  echo
#  echo "Options:"
#  echo '     -c, --config   "<config_a[,config_b[...]]>"    Specify config file(s)'
#  echo "     -h, --help               Print this information."
#}
#
#read_baseurl() {
#  if [[ $_config == *","* ]]; then
#    # multiple config
#    IFS=","
#    read -ra config_array <<<"$_config"
#
#    # reverse loop the config files
#    for ((i = ${#config_array[@]} - 1; i >= 0; i--)); do
#      _tmp_baseurl="$(grep '^baseurl:' "${config_array[i]}" | sed "s/.*: *//;s/['\"]//g;s/#.*//")"
#
#      if [[ -n $_tmp_baseurl ]]; then
#        _baseurl="$_tmp_baseurl"
#        break
#      fi
#    done
#
#  else
#    # single config
#    _baseurl="$(grep '^baseurl:' "$_config" | sed "s/.*: *//;s/['\"]//g;s/#.*//")"
#  fi
#}
#
#main() {
#  # clean up
#  if [[ -d $SITE_DIR ]]; then
#    rm -rf "$SITE_DIR"
#  fi
#
#  read_baseurl
#
#  # build
#  JEKYLL_ENV=production bundle exec jekyll b \
#    -d "$SITE_DIR$_baseurl" -c "$_config"
#
#  # test
#  bundle exec htmlproofer "$SITE_DIR" \
#    --disable-external \
#    --ignore-urls "/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/"
#}
#
#while (($#)); do
#  opt="$1"
#  case $opt in
#  -c | --config)
#    _config="$2"
#    shift
#    shift
#    ;;
#  -h | --help)
#    help
#    exit 0
#    ;;
#  *)
#    # unknown option
#    help
#    exit 1
#    ;;
#  esac
#done
#
#main

#!/usr/bin/env bash
#
# Build the site without any test
#
# Requirement: jekyll
# Usage: bash tools/test.sh [--config "_config.yml"]

set -eu

SITE_DIR="_site"
_config="_config.yml"
_baseurl=""

help() {
  echo "Build the site content only"
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

  echo -e "\n🚀 Building site using config: $_config"
  JEKYLL_ENV=production bundle exec jekyll build \
    -d "$SITE_DIR$_baseurl" -c "$_config"

  echo -e "\n✅ Build complete! Output folder: $SITE_DIR$_baseurl"
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
