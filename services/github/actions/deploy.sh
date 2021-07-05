DIRECTORY_PATH=$(dirname ${0})

cd $(dirname $(readlink -f ${0}))

source /home/cloud/scripts/main.sh

while read -r HOST; do
  for FILE in $@; do
    if [[ $FILE == "scripts" ]]; then
      scp -o StrictHostKeyChecking=no -r /home/cloud/scripts root@$HOST:/home/cloud
    else
      scp -o StrictHostKeyChecking=no "$GITHUB_WORKSPACE/$FILE" root@$HOST:/home/cloud/output
    fi
  done
done <<< $HOSTS