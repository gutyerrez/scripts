# shellcheck disable=SC2034
DIRECTORY_PATH="$(dirname "${0}")"

# shellcheck disable=SC2046
# shellcheck disable=SC2164
cd "$(dirname $(readlink -f "${0}"))"

source /home/cloud/scripts/main.sh

if [ "$#" -eq 1 ]; then
  SERVER_NAME=$1

  # shellcheck disable=SC2126
  j=$(screen -list | grep -P "[0-9]+\.${SERVER_NAME}[ \t]+" | wc -l)

  if [[ $j -lt 1 ]]; then
    # shellcheck disable=SC2164
    cd "${MAIN_LOBBIES_DIRECTORY}/${SERVER_NAME}"

    # shellcheck disable=SC2216
    yes | cp "${OUTPUT_DIRECTORY}/${MINECRAFT_SERVER_JAR}" "${MAIN_LOBBIES_DIRECTORY}/${SERVER_NAME}"

    if ! [[ -e "settings.json" ]]; then
      cp "${CLOUD_DIRECTORY}/scripts/server/lobbies/settings.json" "${MAIN_LOBBIES_DIRECTORY}/${SERVER_NAME}"
    else
      plugins=$(jq .plugins "${CLOUD_DIRECTORY}/scripts/server/lobbies/settings.json")

      jq ".plugins |= $plugins" settings.json >settings.tmp && mv settings.tmp settings.json
    fi

    plugins=$(jq .plugins[] settings.json)

    find "${MAIN_LOBBIES_DIRECTORY}/${SERVER_NAME}/plugins/" -maxdepth 1 -type f -name "*.jar" -delete

    for plugin in ${plugins}; do
      plugin=${plugin//\"/}

      if [[ -e "${OUTPUT_DIRECTORY}/${plugin}" ]]; then
        # shellcheck disable=SC2216
        yes | cp "${OUTPUT_DIRECTORY}/${plugin}" "${MAIN_LOBBIES_DIRECTORY}/${SERVER_NAME}/plugins"
      else
        echo -e "${COLOR_RED}Não foi possível localizar o plugin ${plugin}.${COLOR_RESET}"
      fi
    done

    echo -e "${COLOR_GREEN}Ligando o ${SERVER_NAME} em $(pwd)...${COLOR_RESET}"
    screen -dmS "${SERVER_NAME}" java "${MINECRAFT_JAVA_FLAGS}" -Xms128M -Xmx3G -jar "${MINECRAFT_SERVER_JAR}"
  else
    echo -e "${COLOR_YELLOW}O ${SERVER_NAME} já está ligado.${COLOR_RESET}"
  fi
fi
