#!/usr/bin/bash
unset BASHLY_PATH

./bashly.sh ; assert 1 "Prohibit running bashly.sh"
source ./bashly.sh ; assert 0 "Sourcing bashly.sh"

