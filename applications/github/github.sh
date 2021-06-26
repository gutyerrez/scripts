DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

j=$(screen -list | grep -P "[0-9]+\.github[ \t]+" | wc -l)

if [[ $j -lt 1 ]]; then
  echo -e "${COLOR_GREEN}Ligando o github em $(pwd)...${COLOR_RESET}"
  screen -dmS github bash /etc/github/run.sh
else
  echo -e "${COLOR_YELLOW}o Github já está ligado.${COLOR_RESET}"
fi