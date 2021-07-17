DIRECTORY_PATH=$(dirname ${0})

cd $(dirname $(readlink -f ${0}))

source /home/cloud/scripts/main.sh

while read -r HOST; do
  for FILE in $@; do
    ssh -o StrictHostKeyChecking=no root@$HOST rm -rf $FILE
  done
done <<< $HOSTS