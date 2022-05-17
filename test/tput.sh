#!/usr/bin/env bash

# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes/438357#438357
for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done
