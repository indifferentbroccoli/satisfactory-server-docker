#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

config_file="/satisfactory/FactoryGame/Saved/Config/LinuxServer/Scalability.ini"
config_dir=$(dirname "$config_file")

mkdir -p "$config_dir" || exit

export TOTAL_NET_BANDWIDTH=${TOTAL_NET_BANDWIDTH:-104857600}
export MAX_DYNAMIC_BANDWIDTH=${MAX_DYNAMIC_BANDWIDTH:-104857600}
export MIN_DYNAMIC_BANDWIDTH=${MIN_DYNAMIC_BANDWIDTH:-104857600}

cat > "$config_file" <<EOF
$(envsubst < /home/steam/server/templates/Scalability.ini.template)
EOF