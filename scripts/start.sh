#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

cd /satisfactory || exit

# if GENERATE_SETTINGS IS FALSE then we will not generate the settings
if [ "$GENERATE_SETTINGS" = "true" ]; then
  LogAction "Compiling Engine settings"
  /home/steam/server/compile-engine-settings.sh
  LogAction "Compiling Game settings"
  /home/steam/server/compile-game-settings.sh
  LogAction "Compiling Game User settings"
  /home/steam/server/compile-game-user-settings.sh
  LogAction "Compiling Scalability settings"
  /home/steam/server/compile-scalability-settings.sh
  LogAction "Compiling Server settings"
  /home/steam/server/compile-server-settings.sh
elif [ "$GENERATE_SETTINGS" = "false" ]; then
  LogWarn "GENERATE_SETTINGS=false, not overwriting settings"
fi

LogAction "Starting server"
su steam -c "./FactoryServer.sh -Port=${GAME_PORT} -ini:Engine:[HTTPServer.Listeners]:DefaultBindAddress=any"