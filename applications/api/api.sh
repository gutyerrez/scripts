DIRECTORY_PATH=$(dirname ${0})

cd $(dirname $(readlink -f ${0}))

source /home/cloud/scripts/main.sh

j=$(screen -list | grep -P "[0-9]+\.api[ \t]+" | wc -l)

if [[ $j -lt 1 ]]; then
  cd ${APPLICATIONS_DIRECTORY}/api

  yes | cp ${OUTPUT_DIRECTORY}/api.jar ${APPLICATIONS_DIRECTORY}/api

  echo -e "${COLOR_GREEN}Ligando a aplicação em $(pwd)...${COLOR_RESET}"
  screen -dmSL api java ${MINECRAFT_JAVA_FLAGS} -Xms128M -Xmx2G -jar api.jar
else
  echo -e "${COLOR_YELLOW}A aplicação já está ligada.${COLOR_RESET}"
fi
