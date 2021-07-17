DIRECTORY_PATH=$(dirname ${0})

cd $(dirname $(readlink -f ${0}))

source /home/cloud/scripts/main.sh

FILES=("$@")

while read -r HOST; do
  for FILE in "${FILES[@]}"; do
    ssh -o StrictHostKeyChecking=no root@$HOST rm -rf $FILE
  done
done <<< $HOSTS