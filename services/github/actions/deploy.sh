DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

while read -r HOST; do
  for FILE in $@; do
    if [[ $FILE -eq "scripts" ]]; then
      scp -o StrictHostKeyChecking=no -r "$GITHUB_WORKSPACE" root@$HOST:/home/cloud/scripts
    else
      scp -o StrictHostKeyChecking=no -r "$GITHUB_WORKSPACE/$FILE" root@$HOST:/home/cloud/output
    fi
  done
done <<< $HOSTS