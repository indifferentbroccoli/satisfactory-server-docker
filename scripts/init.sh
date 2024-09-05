#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

LogAction "Set file permissions"

# if the user has not defined a PUID and PGID, throw an error and exit
if [ -z "${PUID}" ] || [ -z "${PGID}" ]; then
    LogError "PUID and PGID not set. Please set these in the environment variables."
    exit 1
else
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
fi

chown -R steam:steam /satisfactory /home/steam/

cat /branding

LogAction "Checking for compatibility issues"
if cpu_check && memory_check; then
    LogSuccess "Compatibility checks passed"
fi

install

# shellcheck disable=SC2317
term_handler() {
    LogWarn "SIGTERM received, shutting down server"
    kill -SIGTERM "$(pidof UnrealServer-Linux-Shipping)"
    tail --pid="$killpid" -f 2>/dev/null
}

trap 'term_handler' SIGTERM

# Start the server
./start.sh &

# Process ID of su
killpid="$!"
wait "$killpid"