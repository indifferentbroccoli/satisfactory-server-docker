#BUILD THE SERVER IMAGE
FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    gettext-base=0.21-12 \
    procps=2:4.0.2-3 \
    xdg-user-dirs=0.18-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/satisfactory-server-docker" \
      github="https://github.com/indifferentbroccoli/satisfactory-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/satisfactory-server-docker"

ENV HOME=/home/steam \
    GAME_PORT=7777 \
    BEACON_PORT=15000 \
    QUERY_PORT=15777 \
    SERVER_IP=0.0.0.0 \
    GENERATE_SETTINGS=true

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /satisfactory && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "UnrealServer" > /dev/null || exit 1

EXPOSE 7777/udp 7777/tcp

ENTRYPOINT ["/home/steam/server/init.sh"]