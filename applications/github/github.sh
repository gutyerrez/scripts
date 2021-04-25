DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

j=$(screen -list | grep -P "[0-9]+\.github[ \t]+" | wc -l)

if [[ $j < 1 ]]; then
  cd ${APPLICATIONS_DIRECTORY}/github

  echo -e "${COLOR_GREEN}Ligando a aplicação em $(pwd)...${COLOR_RESET}"
  /etc/actions-runner/run.sh
else
  echo -e "${COLOR_YELLOW}A aplicação já está ligada.${COLOR_RESET}"
fi
