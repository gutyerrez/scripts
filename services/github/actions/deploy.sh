DIRECTORY_PATH="$(dirname ${0})"

cd "$(dirname $(readlink -f ${0}))"

source /home/cloud/scripts/main.sh

while read -r HOST; do
  for FILE in $@; do
    scp -o StrictHostKeyChecking=no -r "$GITHUB_WORKSPACE/$FILE" root@$HOST:/home/cloud/output
  done
done <<< $HOSTS