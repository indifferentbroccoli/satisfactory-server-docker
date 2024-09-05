#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

config_file="/satisfactory/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini"
config_dir=$(dirname "$config_file")

mkdir -p "$config_dir" || exit

export AUTO_PAUSE=${AUTO_PAUSE:-True}
export AUTO_SAVE_ON_DISCONNECT=${AUTO_SAVE_ON_DISCONNECT:-True}

cat > "$config_file" <<EOF
$(envsubst < /home/steam/server/templates/ServerSettings.ini.template)
EOF