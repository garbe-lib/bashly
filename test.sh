#!/usr/bin/env bash

source ./common.sh

echo "Running tests..."

for unit in ./test/*; do
    echo -e "\x1b[34;1mTest unit $unit\x1b[0m"
    source $unit
done
