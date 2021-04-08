DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

if [ "$#" -eq 1 ]; then
  PROJECT_NAME=$1

  if [[ $PROJECT_NAME == "scripts" ]]; then
    echo -e "${COLOR_GREEN}Iniciando o download do projeto ${PROJECT_NAME}!${COLOR_RESET}"

    cd ${CLOUD_DIRECTORY}/scripts

    git pull
  else
    if [[ -d "${PROJECTS_DIRECTORY}/${PROJECT_NAME}" ]]; then
      echo -e "${COLOR_GREEN}Iniciando o download do projeto ${PROJECT_NAME}!${COLOR_RESET}"

      cd ${PROJECTS_DIRECTORY}/${PROJECT_NAME}

      git pull

      if [[ -e "gradlew" ]]; then
        chmod -R 777 gradlew

        ./gradlew shadowJar && ./gradlew publishToMavenLocal
      elif [[ -e "pom.xml" ]]; then
        mvn clean install
      elif [[ $(ls -1 -- ${PROJECTS_DIRECTORY}/${PROJECT_NAME}/src/*.go | wc -l) == "1" ]]; then
        echo -e "Opa"

        cd src

        go build && mv src Nyrah && mv Nyrah ${OUTPUT_DIRECTORY}
      fi
    else
      echo -e "${COLOR_RED}Não foi possível localizar este projeto.${COLOR_RESET}"
    fi
  fi
else
  echo -e "${COLOR_RED}Utilize download <projeto>.${COLOR_RESET}"
fi