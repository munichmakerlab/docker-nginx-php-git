#!/usr/bin/env bash

SCRIPTS=/usr/bin

while true
do
    $SCRIPTS/check.sh
    echo "sleeping 10 min"
    sleep 600
done
