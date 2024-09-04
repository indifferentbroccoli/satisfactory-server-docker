#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

config_file="/satisfactory/FactoryGame/Saved/Config/LinuxServer/Engine.ini"
config_dir=$(dirname "$config_file")

mkdir -p "$config_dir" || exit

export CONFIGURED_INTERNET_SPEED=${CONFIGURED_INTERNET_SPEED:-120000}
export CONFIGURED_LAN_SPEED=${CONFIGURED_LAN_SPEED:-130000}
export MAX_CLIENT_RATE=${MAX_CLIENT_RATE:-120000}
export MAX_INTERNET_CLIENT_RATE=${MAX_INTERNET_CLIENT_RATE:-120000}

cat > "$config_file" <<EOF
$(envsubst < /home/steam/server/templates/Engine.ini.template)
EOF