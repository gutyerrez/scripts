DIRECTORY_PATH=$(dirname ${0})

cd $(dirname $(readlink -f ${0}))

source /home/cloud/scripts/main.sh

if [ "$#" -eq 1 ]; then
  j=$(screen -list | grep -P "[0-9]+\.nyrah-control[ \t]+" | wc -l)

  if [[ $j -lt 1 ]]; then
    cd $NYRAH_DIRECTORY

    yes | cp $OUTPUT_DIRECTORY/$NYRAH_CONTROL_SERVER_JAR $NYRAH_DIRECTORY
    yes | cp $CLOUD_DIRECTORY/scripts/server/nyrah/settings.json $NYRAH_DIRECTORY

    echo -e "${COLOR_GREEN}Ligando o nyrah-control em $(pwd)...${COLOR_RESET}"
    screen -dmS nyrah-control java -Xms128M -Xmx512M -jar $NYRAH_CONTROL_SERVER_JAR
  else
    echo -e "${COLOR_YELLOW}O nyrah-control já está ligado.${COLOR_RESET}"
  fi
fi