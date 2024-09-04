#BUILD THE SERVER IMAGE
FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    gettext-base=0.21-12 \
    procps=2:4.0.2-3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/satisfactory-server-docker" \
      github="https://github.com/indifferentbroccoli/satisfactory-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/satisfactory-server-docker"

ENV HOME=/home/steam \
    GAMESAVESDIR="/home/steam/.config/Epic/FactoryGame/Saved/SaveGames" \
    ADMIN_USERNAME=admin \
    ADMIN_PASSWORD=admin \
    DEFAULT_PORT=16261 \
    UDP_PORT=16262 \
    RCON_PORT=27015 \
    SERVER_NAME=pzserver \
    STEAM_VAC=true \
    USE_STEAM=true \
    GENERATE_SETTINGS=true

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /satisfactory && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

# HEALTHCHECK --start-period=5m \
#             CMD pgrep "ProjectZomboid" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]