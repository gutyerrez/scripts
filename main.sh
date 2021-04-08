COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[1;32m'
COLOR_RED='\033[1;31m'
COLOR_RESET='\033[0m'

MAIN_DIRECTORY="/home"

CLOUD_DIRECTORY="$MAIN_DIRECTORY/cloud"

OUTPUT_DIRECTORY="$CLOUD_DIRECTORY/output"
PROJECTS_DIRECTORY="$CLOUD_DIRECTORY/projects"

MINECRAFT_DIRECTORY="$MAIN_DIRECTORY/minecraft"

PROXIES_DIRECTORY="$MINECRAFT_DIRECTORY/proxies"
LOBBIES_DIRECTORY="$MINECRAFT_DIRECTORY/lobbies"

MAIN_LOBBIES_DIRECTORY="$LOBBIES_DIRECTORY/main"
LOGIN_LOBBIES_DIRECTORY="$LOBBIES_DIRECTORY/login"

SERVERS_DIRECTORY="$MINECRAFT_DIRECTORY/servers"

FACTIONS_DIRECTORY="$SERVERS_DIRECTORY/factions"
RANKUP_DIRECTORY="$SERVERS_DIRECTORY/rankup"

BUILD_DIRECTORY="$SERVERS_DIRECTORY/build"

APPLICATIONS_DIRECTORY="$MAIN_DIRECTORY/applications"

MINECRAFT_JAVA_FLAGS="-Dcom.mojang.eula.agree=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

GO_FETCH=$(ls src/*.go 1> /dev/null | wc -l)