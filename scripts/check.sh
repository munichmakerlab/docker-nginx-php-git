#!/usr/bin/env bash

BASE="/var/www/html"
LASTCHECK=$(cat $BASE/.lastcheck | php -r "echo urlencode(file_get_contents('php://stdin'));" )
URL="https://api.github.com/search/repositories?q=org%3Amunichmakerlab+topic%3Awebintern+pushed%3A>$LASTCHECK"

echo checking $URL
echo

REPOLIST=$(curl -s "$URL" | grep clone_url | cut -d '"' -f 4)

cd $BASE

for REPO in $REPOLIST
do
	NAME=$(echo $REPO | cut -d "/" -f 5 | cut -d "." -f 1)

	echo "-> Name of the Project: $NAME"
	echo "-> URL of the Repository: $REPO"

	if [ ! -d $NAME ]; then
		echo "==> Folder does not exist. Creating and Cloning ..."
		git clone $REPO
	else
		echo "==> Folder exists already. Pulling ..."
		cd $NAME
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

	fi

	echo done.

	cd $BASE
	echo
	echo
done

date -u +%FT%T%z > $BASE/.lastcheck
