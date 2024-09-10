<!-- markdownlint-disable-next-line -->
![marketing_assets_banner](https://github.com/user-attachments/assets/b8b4ae5c-06bb-46a7-8d94-903a04595036)
[![GitHub License](https://img.shields.io/github/license/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/satisfactory-server-docker/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/satisfactory-server-docker/releases)
[![GitHub Repo stars](https://img.shields.io/github/stars/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/satisfactory-server-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/indifferentbroccoli/satisfactory-server-docker?style=for-the-badge&color=6aa84f)](https://hub.docker.com/r/indifferentbroccoli/satisfactory-server-docker)

Game server hosting

Fast RAM, high-speed internet

Eat lag for breakfast

[Try our Satisfactory Server hosting free for 2 days!](https://indifferentbroccoli.com/satisfactory-server-hosting)

# Satisfactory Server Docker

> [!IMPORTANT]
> Using Docker Desktop with WSL2 on Windows will result in a very slow download!

## Server Requirements

| Resource | Minimum                                                                 | Recommended |
|----------|-------------------------------------------------------------------------|-------------|
| CPU      | Recent (comparable to the Ryzen 5 3600 AMD or better) x86/64 processor. | n.a.        |
| RAM      | 12GB                                                                    | 16GB        |
| Storage  | 25GB                                                                    | 25GB        |

## How to use

> [!IMPORTANT]
> .env settings will override the current settings in the `.ini` files
> If you do not want that to happen, set GENERATE_SETTINGS=false

Copy the .env.example file to a new file called .env file. Then use either `docker compose` or `docker run`

> [!IMPORTANT]
> Please make sure to claim your server and immediately set a strong password!

### Docker compose

> [!WARNING]
> As of v5.0.4 the console tab in the server manager is the only way to execute commands
> When you want to shutdown the server you need to use the console tab and type `quit` to save the game and stop the server
> If you do not do this, the server may not save the game and you may lose progress.

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
    environment:
      PUID: 1000
      PGID: 1000
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
    -e GENERATE_SETTINGS=true \
    --env-file .env \
    -v ./satisfactory/server-files:/satisfactory \
    -v ./satisfactory/server-data:/home/steam/.config/Epic/FactoryGame/Saved/SaveGames
    indifferentbroccoli/satisfactory-server-docker
```

## Environment Variables

### Server settings

| Variable                  | Default   | Description             |
|---------------------------|-----------|-------------------------|
| `AUTO_PAUSE`              | `True`    | Auto pause              |
| `AUTO_SAVE_ON_DISCONNECT` | `True`    | Auto save on disconnect |
| `MAX_PLAYERS`             | `4`       | Maximum players         |
| `GAME_PORT`               | `7777`    | Game port (TCP & UDP)   |
| `SERVER_IP`               | `0.0.0.0` | Server IP               |

### Game settings

| Variable                                                        | Default     | Description                                                   |
|-----------------------------------------------------------------|-------------|---------------------------------------------------------------|
| `TOTAL_NET_BANDWIDTH`                                           | `104857600` | Total bandwidth for the server (bytes)                        |
| `MAX_DYNAMIC_BANDWIDTH`                                         | `104857600` | Maximum dynamic bandwidth for the server (bytes)              |
| `MIN_DYNAMIC_BANDWIDTH`                                         | `104857600` | Minimum dynamic bandwidth for the server (bytes)              |
| `MAX_POSITION_ERROR_SQUARED`                                    | `32.00f`    | Maximum position error squared                                |
| `MOVE_REP_SIZE`                                                 | `512.0f`    | Movement replication size                                     |
| `CLIENT_ADJUST_UPDATE_COST`                                     | `512.0f`    | Client adjust update cost                                     |
| `MOVEMENT_TIME_DISCREPANCY_DETECTION`                           | `false`     | Movement time discrepancy detection                           |
| `MOVEMENT_TIME_DISCREPANCY_RESOLUTION`                          | `false`     | Movement time discrepancy resolution                          |
| `MOVEMENT_TIME_DISCREPANCY_FORCE_CORRECTIONS_DURING_RESOLUTION` | `false`     | Movement time discrepancy force corrections during resolution |
| `MAX_CLIENT_UPDATE_INTERVAL`                                    | `2.20f`     | Maximum client update interval                                |
| `MAX_MOVE_DELTA_TIME`                                           | `0.700f`    | Maximum move delta time                                       |
| `MAX_CLIENT_SMOOTHING_DELTA_TIME`                               | `2.20f`     | Maximum client smoothing delta time                           |
| `MAX_CLIENT_FORCED_UPDATE_DURATION`                             | `1.0f`      | Maximum client forced update duration                         |
| `CLIENT_NET_SEND_MOVE_DELTA_TIME`                               | `0.0332`    | Client net send move delta time                               |
| `CLIENT_NET_SEND_MOVE_DELTA_TIME_STATIONARY`                    | `0.0664`    | Client net send move delta time stationary                    |
| `CLIENT_NET_SEND_MOVE_THROTTLE_OVER_PLAYER_COUNT`               | `99`        | Client net send move throttle over player count               |
| `SERVER_FORCED_UPDATE_HITCH_THRESHOLD`                          | `2.800f`    | Server forced update hitch threshold                          |
| `CONNECTION_TIMEOUT`                                            | `300.0`     | Connection timeout                                            |
| `INITIAL_CONNECT_TIMEOUT`                                       | `300.0`     | Initial connect timeout                                       |

### Game User settings

| Variable                                    | Default                          | Description                               |
|---------------------------------------------|----------------------------------|-------------------------------------------|
| `INT_VALUES`                                | `()`                             | Integer values                            |
| `FLOAT_VALUES`                              | `(("FG.AutosaveInterval", 300))` | Float values                              |
| `PRIMARY_LANGUAGE`                          |                                  | Primary language                          |
| `CURRENT_FG_GAME_USER_SETTINGS_VERSION`     | `0`                              | Current FG game user settings version     |
| `PREFERRED_ONLINE_INTEGRATION_MODE`         | `Undefined`                      | Preferred online integration mode         |
| `USE_VSYNC`                                 | `False`                          | Use VSync                                 |
| `USE_DYNAMIC_RESOLUTION`                    | `False`                          | Use dynamic resolution                    |
| `RESOLUTION_SIZE_X`                         | `1280`                           | Resolution size X                         |
| `RESOLUTION_SIZE_Y`                         | `720`                            | Resolution size Y                         |
| `LAST_USER_CONFIRMED_RESOLUTION_SIZE_X`     | `1280`                           | Last user confirmed resolution size X     |
| `LAST_USER_CONFIRMED_RESOLUTION_SIZE_Y`     | `720`                            | Last user confirmed resolution size Y     |
| `WINDOW_POS_X`                              | `-1`                             | Window position X                         |
| `WINDOW_POS_Y`                              | `-1`                             | Window position Y                         |
| `FULLSCREEN_MODE`                           | `1`                              | Fullscreen mode                           |
| `LAST_CONFIRMED_FULLSCREEN_MODE`            | `1`                              | Last confirmed fullscreen mode            |
| `PREFERRED_FULLSCREEN_MODE`                 | `1`                              | Preferred fullscreen mode                 |
| `VERSION`                                   | `5`                              | Version                                   |
| `AUDIO_QUALITY_LEVEL`                       | `0`                              | Audio quality level                       |
| `LAST_CONFIRMED_AUDIO_QUALITY_LEVEL`        | `0`                              | Last confirmed audio quality level        |
| `FRAME_RATE_LIMIT`                          | `0.000000`                       | Frame rate limit                          |
| `DESIRED_SCREEN_WIDTH`                      | `1280`                           | Desired screen width                      |
| `DESIRED_SCREEN_HEIGHT`                     | `720`                            | Desired screen height                     |
| `LAST_USER_CONFIRMED_DESIRED_SCREEN_WIDTH`  | `1280`                           | Last user confirmed desired screen width  |
| `LAST_USER_CONFIRMED_DESIRED_SCREEN_HEIGHT` | `720`                            | Last user confirmed desired screen height |
| `LAST_RECOMMENDED_SCREEN_WIDTH`             | `-1.000000`                      | Last recommended screen width             |
| `LAST_RECOMMENDED_SCREEN_HEIGHT`            | `-1.000000`                      | Last recommended screen height            |
| `LAST_CPU_BENCHMARK_RESULT`                 | `-1.000000`                      | Last CPU benchmark result                 |
| `LAST_GPU_BENCHMARK_RESULT`                 | `-1.000000`                      | Last GPU benchmark result                 |
| `LAST_GPU_BENCHMARK_MULTIPLIER`             | `1.000000`                       | Last GPU benchmark multiplier             |
| `USE_HDR_DISPLAY_OUTPUT`                    | `False`                          | Use HDR display output                    |
| `HDR_DISPLAY_OUTPUT_NITS`                   | `1000`                           | HDR display output nits                   |
| `RESOLUTION_QUALITY`                        | `100.000000`                     | Resolution quality                        |
| `VIEW_DISTANCE_QUALITY`                     | `3`                              | View distance quality                     |
| `ANTI_ALIASING_QUALITY`                     | `3`                              | Anti aliasing quality                     |
| `SHADOW_QUALITY`                            | `3`                              | Shadow quality                            |
| `POST_PROCESS_QUALITY`                      | `3`                              | Post process quality                      |
| `TEXTURE_QUALITY`                           | `3`                              | Texture quality                           |
| `EFFECTS_QUALITY`                           | `3`                              | Effects quality                           |
| `FOLIAGE_QUALITY`                           | `3`                              | Foliage quality                           |
| `SHADING_QUALITY`                           | `3`                              | Shading quality                           |
| `USE_DESIRED_SCREEN_HEIGHT`                 | `False`                          | Use desired screen height                 |

### Scalability settings

| Variable                | Default     | Description                                      |
|-------------------------|-------------|--------------------------------------------------|
| `TOTAL_NET_BANDWIDTH`   | `104857600` | Total bandwidth for the server (bytes)           |
| `MAX_DYNAMIC_BANDWIDTH` | `104857600` | Maximum dynamic bandwidth for the server (bytes) |
| `MIN_DYNAMIC_BANDWIDTH` | `104857600` | Minimum dynamic bandwidth for the server (bytes) |

### Engine settings

| Variable                    | Default     | Description                          |
|-----------------------------|-------------|--------------------------------------|
| `CONFIGURED_INTERNET_SPEED` | `104857600` | Configured internet speed (bytes)    |
| `CONFIGURED_LAN_SPEED`      | `104857600` | Configured LAN speed (bytes)         |
| `MAX_CLIENT_RATE`           | `104857600` | Maximum client rate (bytes)          |
| `MAX_INTERNET_CLIENT_RATE`  | `104857600` | Maximum internet client rate (bytes) |

## Developer information

### Building the image

You can build the image from the Dockerfile using the following command:

```bash
docker build -t indifferentbroccoli/satisfactory-server-docker .
```

### Scripts

#### init.sh

Entrypoint of the container. This script will check if the server is installed and if not, it will install it.
Also has a term_handler function to catch SIGTERM signals to gracefully stop the server.
Features basic checks that will confirm if the server can be started.

#### start.sh

Starts the server with the settings from the .env file.
Will also call the `compile-*-settings.sh` scripts to generate the server settings.

#### install.scmd

Installs the server. This script will download the server files using SteamCMD and extract them to the server directory.

#### funtions.sh

Contains functions that are used in the other scripts.

#### compile-*-settings.sh scripts

Generates the server settings file from the .env file.
Uses envsubst to replace the variables in the `.ini.template` files.
