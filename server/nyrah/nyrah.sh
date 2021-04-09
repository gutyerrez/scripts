DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

if [ "$#" -eq 1 ]; then
  SERVER_NAME=$1

  j=$(screen -list | grep -P "[0-9]+\.$SERVER_NAME[ \t]+" | wc -l)

  if [[ $j < 1 ]]; then
    cd ${NYRAH_DIRECTORY}

    yes | cp ${OUTPUT_DIRECTORY}/Nyrah ${NYRAH_DIRECTORY}
    yes | cp ${CLOUD_DIRECTORY}/scripts/server/nyrah/settings.json ${NYRAH_DIRECTORY}
    
    echo -e "${COLOR_GREEN}Ligando o ${SERVER_NAME} em $(pwd)...${COLOR_RESET}"
    screen -dmSL ${SERVER_NAME} ./Nyrah
  else
    echo -e "${COLOR_YELLOW}O ${SERVER_NAME} já está ligado.${COLOR_RESET}"
  fi
fi