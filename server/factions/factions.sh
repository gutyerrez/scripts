DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

if [ "$#" -eq 1 ]; then
  SERVER_NAME=$1

  j=$(screen -list | grep -P "[0-9]+\.$SERVER_NAME[ \t]+" | wc -l)

  if [[ $j < 1 ]]; then
    cd ${FACTIONS_DIRECTORY}/${SERVER_NAME}

    # Only in test servers

    if [[ $SERVER_NAME == "factions-test" ]]; then
      yes | cp ${OUTPUT_DIRECTORY}/PaperSpigot.jar ${FACTIONS_DIRECTORY}/${SERVER_NAME}
    fi

    # Only in test servers

    if ! [[ -e "settings.json" ]]; then
      cp ${CLOUD_DIRECTORY}/scripts/server/factions/settings.json ${FACTIONS_DIRECTORY}/${SERVER_NAME}
    else
      plugins=$(jq .plugins ${CLOUD_DIRECTORY}/scripts/server/factions/settings.json)
      
      jq ".plugins |= $plugins" settings.json > settings.tmp && mv settings.tmp settings.json
    fi

    plugins=$(jq .plugins[] settings.json)

    # Only in test servers

    if [[ $SERVER_NAME == "factions-test" ]]; then
      find ${FACTIONS_DIRECTORY}/${SERVER_NAME}/plugins/ -maxdepth 1 -type f -name "*.jar" -delete
    fi

    # Only in test servers

    for plugin in $plugins; do
      plugin=${plugin//\"}

      if [[ -e "${OUTPUT_DIRECTORY}/$plugin" ]]; then
        yes | cp ${OUTPUT_DIRECTORY}/$plugin ${FACTIONS_DIRECTORY}/${SERVER_NAME}/plugins
      else
        echo -e "${COLOR_RED}Não foi possível localizar o plugin $plugin.${COLOR_RESET}"
      fi
    done

    echo -e "${COLOR_GREEN}Ligando o factions em $(pwd)...${COLOR_RESET}"
    
    if [[ $SERVER_NAME == "factions-test" ]]; then
      # Only in test servers

      screen -dmS ${SERVER_NAME} java ${MINECRAFT_JAVA_FLAGS} -Xms128M -Xmx512M -jar PaperSpigot.jar

      # Only in test servers
    else
      screen -dmS ${SERVER_NAME} java ${MINECRAFT_JAVA_FLAGS} -Xms128M -Xmx8G -jar paper.jar
    fi

  else
    echo -e "${COLOR_YELLOW}Servidor já está ligado.${COLOR_RESET}"
  fi
fi