# BUILD THE SERVER IMAGE
FROM --platform=linux/amd64 debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    unzip \
    procps \
    gettext-base \
    libicu-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install .NET 8 runtime (required for DepotDownloader)
RUN curl -sL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --channel 8.0 --runtime dotnet --install-dir /usr/share/dotnet && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    rm /tmp/dotnet-install.sh

# Download DepotDownloader
ARG DEPOT_DOWNLOADER_VERSION=3.4.0
RUN curl -sL \
    "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_${DEPOT_DOWNLOADER_VERSION}/DepotDownloader-linux-x64.zip" \
    -o /tmp/dd.zip && \
    mkdir -p /depotdownloader && \
    unzip /tmp/dd.zip -d /depotdownloader && \
    chmod +x /depotdownloader/DepotDownloader && \
    rm /tmp/dd.zip

RUN useradd -m -s /bin/bash steam

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/satisfactory-server-docker" \
      github="https://github.com/indifferentbroccoli/satisfactory-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/satisfactory-server-docker"

ENV HOME=/home/steam \
    GAME_PORT=7777 \
    RELIABLE_PORT=7778 \
    SERVER_IP=0.0.0.0 \
    GENERATE_SETTINGS=true \
    BRANCH=public \
    UPDATE_ON_START=true

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /satisfactory && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "Factory" > /dev/null || exit 1

EXPOSE 7777/udp 7777/tcp 7778/tcp

ENTRYPOINT ["/home/steam/server/init.sh"]