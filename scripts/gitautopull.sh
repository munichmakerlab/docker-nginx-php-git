#!/usr/bin/env bash

SCRIPTS=/usr/bin

while true
do
    $SCRIPTS/check.sh
    echo "sleeping 5 min"
    sleep 300
done
