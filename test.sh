#!/usr/bin/env bash

cd $(dirname "$0")
source ./common.sh

echo "Running tests..."

for unit in ./test/*; do
    if [ -f $unit ]; then
        echo -e "\x1b[34;1mTest unit $unit\x1b[0m"
        source $unit
    fi
done
