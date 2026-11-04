#!/bin/bash

MODS_DIR=/satisfactory/FactoryGame/Mods
INSTALLED_MODS_FILE=$MODS_DIR/.installed_mods

LogInfo()    { printf '%s\n' "$1"; }
LogWarn()    { printf '\033[1;33m%s\033[0m\n' "$1"; }
LogError()   { printf '\033[1;31m%s\033[0m\n' "$1"; }
LogSuccess() { printf '\033[1;32m%s\033[0m\n' "$1"; }
LogAction()  { printf '\033[1;36m==== %s ====\033[0m\n' "$1"; }

warn_about_hardware() {
  if lscpu | grep -q "Common KVM processor"; then
    LogWarn "Your CPU shows up as \"Common KVM processor\". This may cause issues with the server."
  fi

  local free_ram_gb=$(( $(awk '/MemAvailable/ {print $2}' /proc/meminfo) / 1024000 ))
  if [ "$free_ram_gb" -lt 12 ]; then
    LogWarn "You have less than 12GB of RAM available. This may cause issues with the server."
  fi
}

server_is_installed() {
  [ -x /satisfactory/FactoryServer.sh ]
}

install_server() {
  LogAction "Installing server (branch: $BRANCH)"

  local args=(-app 1690800 -dir /satisfactory -validate)

  if [ "$BRANCH" = "experimental" ]; then
    args+=(-beta experimental)
  fi

  if ! /depotdownloader/DepotDownloader "${args[@]}"; then
    LogError "Server install failed"
    exit 1
  fi

  chmod +x /satisfactory/FactoryServer.sh
  find /satisfactory -name FactoryServer-Linux-Shipping -exec chmod +x {} +

  LogSuccess "Server installed"
}

latest_mod_release() {
  local mod=$1
  curl -sf https://api.ficsit.app/v2/query \
    -H 'Content-Type: application/json' \
    -d "{\"query\": \"{ getModByReference(modReference: \\\"$mod\\\") { latestVersions { release { id } } } }\"}" \
    | grep -o '"id":"[^"]*"' | cut -d'"' -f4
}

# Mods with GameFeatures enabled live in Mods/GameFeatures instead of Mods
mod_folder() {
  local mod=$1
  if [ -d "$MODS_DIR/GameFeatures/$mod" ]; then
    echo "$MODS_DIR/GameFeatures/$mod"
  else
    echo "$MODS_DIR/$mod"
  fi
}

installed_mod_release() {
  cat "$(mod_folder "$1")/.version" 2>/dev/null
}

remove_mod() {
  rm -rf "${MODS_DIR:?}/$1" "${MODS_DIR:?}/GameFeatures/$1"
}

download_mod() {
  local mod=$1
  local release=$2

  curl -sfL "https://api.ficsit.app/v1/version/$release/LinuxServer/download" -o /tmp/mod.zip || return 1
  unzip -qo /tmp/mod.zip -d "$MODS_DIR/$mod" || return 1
  rm /tmp/mod.zip

  echo "$release" > "$MODS_DIR/$mod/.version"

  if grep -qE '"GameFeatures?"[[:space:]]*:[[:space:]]*true' "$MODS_DIR/$mod/$mod.uplugin" 2>/dev/null; then
    mkdir -p "$MODS_DIR/GameFeatures"
    mv "$MODS_DIR/$mod" "$MODS_DIR/GameFeatures/$mod"
  fi
}

is_in_mod_list() {
  [[ ",$MODS," == *",$1,"* ]]
}

install_mods() {
  if [ -z "$MODS" ] && [ ! -f "$INSTALLED_MODS_FILE" ]; then
    return
  fi

  LogAction "Checking mods"
  mkdir -p "$MODS_DIR"

  if [ -f "$INSTALLED_MODS_FILE" ]; then
    for mod in $(tr ',' ' ' < "$INSTALLED_MODS_FILE"); do
      if ! is_in_mod_list "$mod"; then
        LogInfo "Removing $mod"
        remove_mod "$mod"
      fi
    done
  fi

  for mod in ${MODS//,/ }; do
    local release
    release=$(latest_mod_release "$mod")

    if [ -z "$release" ] && [ -d "$(mod_folder "$mod")" ]; then
      LogWarn "Could not check $mod for updates, keeping the installed version"
      continue
    fi

    if [ -z "$release" ]; then
      LogError "Could not find mod $mod"
      exit 1
    fi

    if [ "$release" = "$(installed_mod_release "$mod")" ]; then
      LogInfo "$mod is up to date"
      continue
    fi

    LogInfo "Installing $mod"
    remove_mod "$mod"
    if ! download_mod "$mod" "$release"; then
      LogError "Could not download $mod"
      exit 1
    fi
  done

  echo "$MODS" > "$INSTALLED_MODS_FILE"
  LogSuccess "Mods ready"
}
