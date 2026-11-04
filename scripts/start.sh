#!/bin/bash
source /home/steam/server/functions.sh

cd /satisfactory || exit 1

args=(
  -Port="$GAME_PORT"
  -ReliablePort="$RELIABLE_PORT"
  -ExternalReliablePort="$RELIABLE_PORT"
  -ini:Engine:[HTTPServer.Listeners]:DefaultBindAddress=any
)

add_ini_setting() {
  local variable=$1
  local setting=$2
  if [ -n "${!variable}" ]; then
    args+=("-ini:$setting=${!variable}")
  fi
}

add_ini_setting MAX_PLAYERS              "Game:[/Script/Engine.GameSession]:MaxPlayers"
add_ini_setting TOTAL_NET_BANDWIDTH      "Game:[/Script/Engine.GameNetworkManager]:TotalNetBandwidth"
add_ini_setting MAX_DYNAMIC_BANDWIDTH    "Game:[/Script/Engine.GameNetworkManager]:MaxDynamicBandwidth"
add_ini_setting MIN_DYNAMIC_BANDWIDTH    "Game:[/Script/Engine.GameNetworkManager]:MinDynamicBandwidth"
add_ini_setting MAX_CLIENT_RATE          "Engine:[/Script/OnlineSubsystemUtils.IpNetDriver]:MaxClientRate"
add_ini_setting MAX_INTERNET_CLIENT_RATE "Engine:[/Script/OnlineSubsystemUtils.IpNetDriver]:MaxInternetClientRate"
add_ini_setting CONNECTION_TIMEOUT       "Engine:[/Script/OnlineSubsystemUtils.IpNetDriver]:ConnectionTimeout"
add_ini_setting INITIAL_CONNECT_TIMEOUT  "Engine:[/Script/OnlineSubsystemUtils.IpNetDriver]:InitialConnectTimeout"

LogAction "Starting server"
LogInfo "Arguments: ${args[*]}"
./FactoryServer.sh "${args[@]}"
