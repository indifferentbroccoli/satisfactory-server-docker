#!/bin/bash
source /home/steam/server/functions.sh

cat /branding

warn_about_hardware

if [ "$UPDATE_ON_START" = "true" ] || ! server_is_installed; then
  install_server
else
  LogWarn "UPDATE_ON_START is false, skipping server update"
fi

install_mods

stop_server() {
  LogWarn "Stopping server"
  kill -SIGTERM "$(pidof FactoryServer-Linux-Shipping)"
  wait "$server_pid"
}
trap stop_server SIGTERM

./start.sh &
server_pid=$!
wait "$server_pid"
