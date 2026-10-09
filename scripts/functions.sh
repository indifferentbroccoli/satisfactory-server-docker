#!/bin/bash

#================
# Log Definitions
#================
export LINE='\n'                        # Line Break
export RESET='\033[0m'                  # Text Reset
export WhiteText='\033[0;37m'           # White

# Bold
export RedBoldText='\033[1;31m'         # Red
export GreenBoldText='\033[1;32m'       # Green
export YellowBoldText='\033[1;33m'      # Yellow
export CyanBoldText='\033[1;36m'        # Cyan
#================
# End Log Definitions
#================

LogInfo() {
  Log "$1" "$WhiteText"
}
LogWarn() {
  Log "$1" "$YellowBoldText"
}
LogError() {
  Log "$1" "$RedBoldText"
}
LogSuccess() {
  Log "$1" "$GreenBoldText"
}
LogAction() {
  Log "$1" "$CyanBoldText" "====" "===="
}
Log() {
  local message="$1"
  local color="$2"
  local prefix="$3"
  local suffix="$4"
  printf "$color%s$RESET$LINE" "$prefix$message$suffix"
}

install() {
  LogAction "Starting server install"

  local branch_args=()
  if [ "${BRANCH}" = "experimental" ]; then
    branch_args=(-beta experimental)
    LogInfo "Installing branch: experimental"
  else
    LogInfo "Installing branch: public"
  fi

  local manifest_args=()
  local auth_args=()
  if [ -n "${GAME_MANIFEST:-}" ]; then
    manifest_args=(-depot 1690802 -manifest "${GAME_MANIFEST}")
    LogInfo "Pinning to manifest: ${GAME_MANIFEST}"

    if [ -z "${STEAM_USERNAME:-}" ] || [ -z "${STEAM_PASSWORD:-}" ]; then
      LogError "GAME_MANIFEST requires a Steam login. Set STEAM_USERNAME and STEAM_PASSWORD."
      exit 1
    fi
    auth_args=(-username "${STEAM_USERNAME}" -password "${STEAM_PASSWORD}")
  fi

  if ! /depotdownloader/DepotDownloader \
    -app 1690800 \
    "${auth_args[@]}" \
    "${branch_args[@]}" \
    "${manifest_args[@]}" \
    -dir /satisfactory \
    -validate; then
    LogError "Failed to install server (branch: ${BRANCH})"
    exit 1
  fi

  chmod +x /satisfactory/FactoryServer.sh
  find /satisfactory -name "FactoryServer-Linux-Shipping" -exec chmod +x {} +

  LogSuccess "Server install complete"
}

cpu_check(){
  if [[ $(lscpu | grep 'Model name:' | sed 's/Model name:[[:space:]]*//g') = "Common KVM processor" ]]; then
    LogWarn " Your CPU model is configured as \"Common KVM processor\". This may cause issues with the server."
    return 1
  else
    return 0
  fi
}

memory_check() {
  RAMAVAILABLE=$(awk '/MemAvailable/ {printf( "%d\n", $2 / 1024000 )}' /proc/meminfo)
  if [ "$RAMAVAILABLE" -lt "12" ]; then
    LogWarn "You have less than 12GB of RAM available. This may cause issues with the server."
    return 1
  else
    return 0
  fi
}

install_mods() {
  local mods_dir="/satisfactory/FactoryGame/Mods"
  local marker="${mods_dir}/.installed_mods"
  local mod id

  if [ -z "${MODS}" ]; then
    return
  fi

  LogAction "Checking mods for updates"
  mkdir -p "${mods_dir}"

  for mod in $(tr ',' ' ' 2>/dev/null < "${marker}"); do
    if [[ ",${MODS}," != *",${mod},"* ]]; then
      LogInfo "Removing mod ${mod}"
      rm -rf "${mods_dir:?}/${mod}"
    fi
  done

  for mod in ${MODS//,/ }; do
    id=$(curl -sf https://api.ficsit.app/v2/query -H 'Content-Type: application/json' \
      -d "{\"query\":\"{ getModByReference(modReference: \\\"${mod}\\\") { latestVersions { release { id } } } }\"}" \
      | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

    if [ -z "${id}" ]; then
      if [ -d "${mods_dir}/${mod}" ]; then
        LogWarn "Could not check ${mod} for updates, keeping installed version"
        continue
      fi
      LogError "Could not find a release for mod ${mod}"
      exit 1
    fi

    if [ "${id}" = "$(cat "${mods_dir}/${mod}/.version" 2>/dev/null)" ]; then
      LogInfo "Mod ${mod} is up to date"
      continue
    fi

    LogInfo "Installing mod ${mod} (${id})..."
    rm -rf "${mods_dir:?}/${mod}"
    if ! curl -sfL "https://api.ficsit.app/v1/version/${id}/LinuxServer/download" -o /tmp/mod.zip \
      || ! unzip -qo /tmp/mod.zip -d "${mods_dir}/${mod}"; then
      LogError "Failed to install mod ${mod}"
      rm -f /tmp/mod.zip
      exit 1
    fi
    rm -f /tmp/mod.zip
    echo "${id}" > "${mods_dir}/${mod}/.version"
  done

  echo "${MODS}" > "${marker}"
  LogSuccess "Mods installed"
}
