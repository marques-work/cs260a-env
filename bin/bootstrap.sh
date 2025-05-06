#!/usr/bin/env bash
# vim: sts=2 sw=2 et ai

set -euo pipefail

main() {
  if [ 'Darwin' != "$(uname)" ]; then
    die "Sorry, this script is meant for macOS only!"
  fi

  if ! defined brew; then
    die "Sorry, this requires homebrew!"
  fi

  if needs_install docker; then
    brew install docker
  fi

  if needs_install colima; then
    brew install colima
    colima start

    warn "You MUST run the following command in your shell! You" \
         "may as well add this to your shell init as well (e.g.," \
         ".bashrc, .zshrc, etc):"
    cat <<EOF >&2

export DOCKER_HOST="unix://\$HOME/.colima/default/docker.sock"

EOF
  fi

  export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"

  if ! docker ps &> /dev/null; then
    warn "docker daemon not running; starting colima"
    colima start

    if ! docker ps &> /dev/null; then
      die "uh-oh! looks like the docker daemon is still not running!"
    fi
  fi

  info "Prerequisites are installed and docker seems to be running fine."
}

needs_install() {
  local bin="$1"

  if defined "$bin"; then
    info "$bin is already installed"
    return 1
  else
    warn "Needs installation: $bin"
    return 0
  fi
}

defined() {
  if [ "$#" -eq 0 ]; then
    die "defined() requires at least 1 argument"
  fi

  for bin in "$@"; do
    if ! type "$bin" &> /dev/null; then
      return 1
    fi
  done

  return 0
}

# print as many lines as you want; just quote each line
# CAVEAT: if you don't quote your lines, it will print
#         1 word per line!
info() { >&2 printf '\e[32;1m[ INFO] %s\e[0m\n' "$@"; }
warn() { >&2 printf '\e[33;1m[ WARN] %s\e[0m\n' "$@"; }
die()  { >&2 printf '\e[31;1m[FATAL] %s\e[0m\n' "$@"; exit 1; }

main "$@"
