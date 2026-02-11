#BUILD THE SERVER IMAGE
FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    gettext-base \
    procps \
    xdg-user-dirs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/satisfactory-server-docker" \
      github="https://github.com/indifferentbroccoli/satisfactory-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/satisfactory-server-docker"

ENV HOME=/home/steam \
    GAME_PORT=7777 \
    RELIABLE_PORT=7778 \
    SERVER_IP=0.0.0.0 \
    GENERATE_SETTINGS=true \
    BRANCH=public

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /satisfactory && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "Factory" > /dev/null || exit 1

EXPOSE 7777/udp 7777/tcp 7778/tcp

ENTRYPOINT ["/home/steam/server/init.sh"]