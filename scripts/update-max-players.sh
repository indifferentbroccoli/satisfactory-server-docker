#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

config_file="/satisfactory/FactoryGame/Saved/Config/LinuxServer/Game.ini"
config_dir=$(dirname "$config_file")

MAX_PLAYERS=${MAX_PLAYERS:-8}

mkdir -p "$config_dir" || exit

if [ -f "$config_file" ] && grep -q "^MaxPlayers=" "$config_file"; then
    sed -i "s/^MaxPlayers=.*/MaxPlayers=$MAX_PLAYERS/" "$config_file"
elif [ -f "$config_file" ] && grep -q "^\[/Script/Engine.GameSession\]" "$config_file"; then
    sed -i "/^\[\/Script\/Engine.GameSession\]/a MaxPlayers=$MAX_PLAYERS" "$config_file"
else
    cat >> "$config_file" <<EOF

[/Script/Engine.GameSession]
MaxPlayers=$MAX_PLAYERS
EOF
fi
