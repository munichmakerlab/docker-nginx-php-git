#!/bin/bash

# Config

ORG="munichmakerlab"
TOPIC="webintern"
WEBROOT="/var/www/html"
# WEBROOT="./src"

# helper functions

uri_escape() {
  php -r "echo urlencode(\"$@\");"
}

# prepare request

IFS=$'\n'

QUERY="q=$(uri_escape "org:$ORG topic:$TOPIC")";
URL="https://api.github.com/search/repositories?$QUERY"


echo "==> Getting Data ..."
DATA=$(curl -sS $URL)

PROJECTS=$(echo $DATA | jq -rc '.items[] | "NAME=\"" + .name + "\"; REPO=\"" + .clone_url + "\"; DATE=\"" + (.created_at | fromdateiso8601 | tostring) + "\"" ')
INSTALLED=$(pushd $WEBROOT  > /dev/null ; ls -1d */ | cut -f1 -d'/'; popd > /dev/null )
ONLINE=$(echo $DATA | jq -rc '.items[].name ')

if [[ -z "$ONLINE" ]]; then
  echo "No Projects found. Error requesting from GitHub??"
  echo "Exitting"
  exit 1
fi

echo PROJECTS
echo "$PROJECTS"
echo

echo INSTALLED
echo "$INSTALLED"
echo

echo ONLINE
echo "$ONLINE"
echo

echo "==> Cleaning up ..."
for P in $INSTALLED
do
  echo "Check if $P is still in topic"
  echo "$ONLINE" | egrep -q "^${P}$"
  if [ "$?" -eq 0 ]; then
    echo "Yes, so keeping it"
  else
    echo "No, so removing it"
    rm -r "$WEBROOT/$P"
  fi
  echo
done

for ROW in $PROJECTS
do
  eval $ROW

  echo "-> Name of the Project: $NAME"
  echo "-> URL of the Repository: $REPO"
  # echo "-> Online Updated at: $(date -r $DATE)"
  echo "-> Online Updated at: $(date -d @$DATE)"

  if [ ! -d "$WEBROOT/$NAME" ]; then
    echo "==> Folder does not exist. Creating and Cloning ..."
    pushd "$WEBROOT" > /dev/null
    git clone $REPO
    cd $P
  else
    pushd "$WEBROOT/$NAME" > /dev/null

    if [ -f .lastcheck ]; then
      LOCALDATE=$(cat .lastcheck)
      # echo "-> Local version from: $(date -r $DATE)"
      echo "-> Local Updated at: $(date -d @$DATE)"
    fi

    if [[ "$LOCALDATE" -ne "$DATE" ]]; then
      echo "--> different time -> checking for changes"

      git fetch
      if [ "$(git rev-parse HEAD)" == "$(git rev-parse @{u})" ]; then
        echo "No upstream Changes"
      else
        echo "Repo has changes, pulling ..."
        git pull
        if [ -f build.sh ]; then
          ./build.sh
        fi
      fi
      echo $DATE > .lastcheck
    else
      echo "Local version is recent."
    fi
  fi

  popd > /dev/null
  echo
done

