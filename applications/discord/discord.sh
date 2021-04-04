DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

j=$(screen -list | grep -P "[0-9]+\.discord-bot[ \t]+" | wc -l)

if [[ $j < 1 ]]; then
  cd ${BUILD_DIRECTORY}/${SERVER_NAME}

  yes | cp ${OUTPUT_DIRECTORY}/discord-bot.jar ${APPLICATIONS_DIRECTORY}/discord-bot

  echo -e "${COLOR_GREEN}Ligando a aplicação em $(pwd)...${COLOR_RESET}"
  screen -dmS discord-bot java ${MINECRAFT_JAVA_FLAGS} -Xms128M -Xmx512M -jar discord-bot.jar
else
  echo -e "${COLOR_YELLOW}A aplicação já está ligada.${COLOR_RESET}"
fi
