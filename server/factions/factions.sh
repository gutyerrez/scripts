DIRECTORY_PATH=$(dirname $0)

cd $(dirname $(readlink -f $0))

source /home/cloud/scripts/main.sh

if [ "$#" -eq 1 ]; then
  SERVER_NAME=$1

  j=$(screen -list | grep -P "[0-9]+\.${SERVER_NAME}[ \t]+" | wc -l)

  if [[ $j -lt 1 ]]; then
    cd $FACTIONS_DIRECTORY/$SERVER_NAME

    yes | cp $OUTPUT_DIRECTORY/$MINECRAFT_SERVER_JAR $FACTIONS_DIRECTORY/$SERVER_NAME

    if [[ $SERVER_NAME == "factions-test" ]]; then
      # Only in test servers

      if ! [[ -e "settings.json" ]]; then
        cp "${CLOUD_DIRECTORY}/scripts/server/factions/settings.json" "${FACTIONS_DIRECTORY}/${SERVER_NAME}"
      else
        plugins=$(jq .\"plugins-test\" "${CLOUD_DIRECTORY}/scripts/server/factions/settings.json")
        
        jq ".\"plugins-test\" |= $plugins" settings.json > settings.tmp && yes | mv settings.tmp settings.json
      fi

      plugins=$(jq .\"plugins-test\"[] settings.json)

      find "${FACTIONS_DIRECTORY}/${SERVER_NAME}/plugins/" -maxdepth 1 -type f -name "*.jar" -delete

      for plugin in $plugins; do
        plugin=${plugin//\"}

        if [[ -e "${OUTPUT_DIRECTORY}/${plugin}" ]]; then
          # shellcheck disable=SC2216
          yes | cp "${OUTPUT_DIRECTORY}/${plugin}" "${FACTIONS_DIRECTORY}/${SERVER_NAME}/plugins"
        else
          echo -e "${COLOR_RED}Não foi possível localizar o plugin $plugin.${COLOR_RESET}"
        fi
      done

      echo -e "${COLOR_GREEN}Ligando o ${SERVER_NAME} em $(pwd)...${COLOR_RESET}"
      
      screen -dmS "${SERVER_NAME}" java "${MINECRAFT_JAVA_FLAGS}" -Xms128M -Xmx2G -jar "${MINECRAFT_SERVER_JAR}"

      # Only in test servers
    else
      if ! [[ -e "settings.json" ]]; then
        cp $CLOUD_DIRECTORY/scripts/server/factions/settings.json $FACTIONS_DIRECTORY/$SERVER_NAME
      else
        plugins=$(jq .plugins "${CLOUD_DIRECTORY}/scripts/server/factions/settings.json")
        
        jq ".plugins |= $plugins" settings.json > settings.tmp && yes | mv settings.tmp settings.json
      fi

      plugins=$(jq .plugins[] settings.json)

      for plugin in $plugins; do
        plugin=${plugin//\"}

        if [[ -e $OUTPUT_DIRECTORY/$plugin ]]; then
          yes | cp $OUTPUT_DIRECTORY/$plugin $FACTIONS_DIRECTORY/$SERVER_NAME/plugins
        else
          echo -e "${COLOR_RED}Não foi possível localizar o plugin $plugin.${COLOR_RESET}"
        fi
      done

      echo -e "${COLOR_GREEN}Ligando o ${SERVER_NAME} em $(pwd)...${COLOR_RESET}"
      
      # Depois trocar o "paper" >> "${MINECRAFT_SERVER_JAR}"
      
      screen -dmS $SERVER_NAME java $MINECRAFT_JAVA_FLAGS -Xms128M -Xmx8G -jar paper.jar
    fi
  else
    echo -e "${COLOR_YELLOW}O ${SERVER_NAME} já está ligado.${COLOR_RESET}"
  fi
fi
