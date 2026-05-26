#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fatal() {
  echo "ERROR: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fatal "Missing command: $1"
}

compose_cmd() {
  docker compose "$@"
}

normalise_instance_name() {
  local xf_version="$1"
  local php_version="$2"
  echo "xf-${xf_version}-php-${php_version}"
}

normalise_project_name() {
  local xf_version="$1"
  local php_version="$2"
  echo "xf_${xf_version}_php_${php_version}" | tr '.+-/' '____' | tr -cd '[:alnum:]_'
}

calculate_port() {
  local xf_version="$1"
  local php_version="$2"
  local xf_minor php_major php_minor
  xf_minor="$(echo "$xf_version" | awk -F. '{print $2+0}')"
  php_major="$(echo "$php_version" | awk -F. '{print $1+0}')"
  php_minor="$(echo "$php_version" | awk -F. '{print $2+0}')"
  echo $((8000 + (xf_minor * 100) + (php_major * 10) + php_minor))
}

abs_path() {
  python3 -c 'import os, sys; print(os.path.abspath(sys.argv[1]))' "$1"
}

resolve_addon_source() {
  local addon_id="$1"
  local addon_source="${ADDON_SOURCE:-}"
  local id_path="$addon_id"

  if [[ -z "$addon_id" ]]; then
    return 1
  fi

  if [[ -n "$addon_source" ]]; then
    local candidate="$addon_source"
    if [[ -f "$candidate/addon.json" ]]; then
      abs_path "$candidate"
      return 0
    fi
    if [[ -f "$candidate/src/addons/$id_path/addon.json" ]]; then
      abs_path "$candidate/src/addons/$id_path"
      return 0
    fi
    if [[ -f "$candidate/addons/$id_path/addon.json" ]]; then
      abs_path "$candidate/addons/$id_path"
      return 0
    fi
    fatal "ADDON_SOURCE was set, but I could not find addon.json for $addon_id under: $addon_source"
  fi

  if [[ -f "$ROOT_DIR/addons/$id_path/addon.json" ]]; then
    abs_path "$ROOT_DIR/addons/$id_path"
    return 0
  fi

  fatal "ADDON_ID=$addon_id was set, but no add-on was found at addons/$id_path/addon.json. Either put it there or set ADDON_SOURCE=/absolute/path/to/$id_path"
}

wait_for_db() {
  local compose_file="$1"
  local project_name="$2"
  local max=90
  local i
  for ((i=1; i<=max; i++)); do
    if compose_cmd -f "$compose_file" -p "$project_name" exec -T db mariadb-admin ping -uroot -proot --silent >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  fatal "Database did not become ready in time. Run: docker compose -f $compose_file -p $project_name logs db"
}


calculate_ngrok_api_port() {
  local xf_version="$1"
  local php_version="$2"
  local xf_minor php_major php_minor
  xf_minor="$(echo "$xf_version" | awk -F. '{print $2+0}')"
  php_major="$(echo "$php_version" | awk -F. '{print $1+0}')"
  php_minor="$(echo "$php_version" | awk -F. '{print $2+0}')"
  echo $((5000 + (xf_minor * 100) + (php_major * 10) + php_minor))
}

shell_quote() {
  python3 -c 'import shlex, sys; print(shlex.quote(sys.argv[1]))' "$1"
}
