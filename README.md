<!-- markdownlint-disable-next-line -->
![marketing_assets_banner](https://github.com/user-attachments/assets/b8b4ae5c-06bb-46a7-8d94-903a04595036)
[![GitHub License](https://img.shields.io/github/license/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/satisfactory-server-docker/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/satisfactory-server-docker/releases)
[![GitHub Repo stars](https://img.shields.io/github/stars/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/satisfactory-server-docker)
[![Discord](https://img.shields.io/discord/798321161082896395?style=for-the-badge&label=Discord&labelColor=5865F2&color=6aa84f)](https://discord.gg/indifferentbroccoli)
[![Docker Pulls](https://img.shields.io/docker/pulls/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://hub.docker.com/r/indifferentbroccoli/satisfactory-server-docker)

Game server hosting

Fast RAM, high-speed internet

Eat lag for breakfast

[Try our Satisfactory Server hosting free for 2 days!](https://indifferentbroccoli.com/satisfactory-server-hosting)

# Satisfactory Server Docker

## Server Requirements

| Resource | Minimum                                                                 | Recommended |
|----------|-------------------------------------------------------------------------|-------------|
| CPU      | Recent (comparable to the Ryzen 5 3600 AMD or better) x86/64 processor. | n.a.        |
| RAM      | 12GB                                                                    | 16GB        |
| Storage  | 25GB                                                                    | 25GB        |

## How to use

Copy the .env.example file to a new file called .env file. Then use either `docker compose` or `docker run`

> [!IMPORTANT]
> The server runs as user and group 1000, not root. The folders you mount must be owned by that user, for example `sudo chown -R 1000:1000 ./satisfactory`.
> To use a different id, set `user: "1001:1001"` in docker compose or `--user 1001:1001` with docker run, and give your folders to that id instead.

> [!IMPORTANT]
> Please make sure to claim your server and immediately set a strong password.

### Docker compose

Starting the server with Docker Compose:

```yaml
services:
  satisfactory:
    image: indifferentbroccoli/satisfactory-server-docker
    restart: unless-stopped
    container_name: satisfactory
    stop_grace_period: 30s
    ports:
      - '7777:7777/udp'
      - '7777:7777/tcp'
      - '7778:7778/tcp'
    env_file:
      - .env.example
    volumes:
      - ./satisfactory/server-files:/satisfactory
      - ./satisfactory/server-data:/home/steam/.config/Epic/FactoryGame/Saved/SaveGames

```

Then run:

```bash
docker-compose up -d
```

### Docker Run

```bash
docker run -d \
    --restart unless-stopped \
    --name satisfactory \
    --stop-timeout 30 \
    -p 7777:7777/udp \
    -p 7777:7777/tcp \
    -p 7778:7778/tcp \
    -e BRANCH=public \
    --env-file .env \
    -v ./satisfactory/server-files:/satisfactory \
    -v ./satisfactory/server-data:/home/steam/.config/Epic/FactoryGame/Saved/SaveGames \
    indifferentbroccoli/satisfactory-server-docker
```

## Environment Variables

### Container settings

| Variable            | Default  | Description                                                                      |
|---------------------|----------|-----------------------------------------------------------------------------------|
| `BRANCH`            | `public` | Game branch: `public` (stable) or `experimental`                             |
| `UPDATE_ON_START`   | `true`   | Update server files on container start. When `false`, the server is only installed if it is missing |
| `MODS`              |          | Comma separated [ficsit.app](https://ficsit.app) mod references, e.g. `SML,RefinedPower`. Updated to the latest release on every start. Mods removed from the list are deleted. |

### Server settings

| Variable        | Default   | Description           |
|-----------------|-----------|-----------------------|
| `GAME_PORT`     | `7777`    | Game port (UDP & TCP) |
| `RELIABLE_PORT` | `7778`    | Reliable port (TCP)   |
| `SERVER_IP`     | `0.0.0.0` | Server IP             |

### Optional game settings

Each variable is passed to the server as an `-ini:` argument. When it is unset, the value in the `.ini` file is used.

| Variable                   | Example     | Setting                                                  |
|----------------------------|-------------|----------------------------------------------------------|
| `MAX_PLAYERS`              | `4`         | `Game.ini` `[/Script/Engine.GameSession]` `MaxPlayers`   |
| `TOTAL_NET_BANDWIDTH`      | `104857600` | `Game.ini` `[/Script/Engine.GameNetworkManager]` `TotalNetBandwidth` |
| `MAX_DYNAMIC_BANDWIDTH`    | `104857600` | `Game.ini` `[/Script/Engine.GameNetworkManager]` `MaxDynamicBandwidth` |
| `MIN_DYNAMIC_BANDWIDTH`    | `104857600` | `Game.ini` `[/Script/Engine.GameNetworkManager]` `MinDynamicBandwidth` |
| `MAX_CLIENT_RATE`          | `104857600` | `Engine.ini` `[/Script/OnlineSubsystemUtils.IpNetDriver]` `MaxClientRate` |
| `MAX_INTERNET_CLIENT_RATE` | `104857600` | `Engine.ini` `[/Script/OnlineSubsystemUtils.IpNetDriver]` `MaxInternetClientRate` |
| `CONNECTION_TIMEOUT`       | `300`       | `Engine.ini` `[/Script/OnlineSubsystemUtils.IpNetDriver]` `ConnectionTimeout` |
| `INITIAL_CONNECT_TIMEOUT`  | `300`       | `Engine.ini` `[/Script/OnlineSubsystemUtils.IpNetDriver]` `InitialConnectTimeout` |
