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
  if [ -n "${GAME_MANIFEST:-}" ]; then
    manifest_args=(-manifest "${GAME_MANIFEST}")
    LogInfo "Pinning to manifest: ${GAME_MANIFEST}"
  fi

  if ! /depotdownloader/DepotDownloader \
    -app 1690800 \
    -username anonymous \
    "${branch_args[@]}" \
    "${manifest_args[@]}" \
    -dir /satisfactory \
    -validate; then
    LogError "Failed to install server (branch: ${BRANCH})"
    exit 1
  fi

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
