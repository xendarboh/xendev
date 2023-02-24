#!/usr/bin/env bash

kitty --debug-font-fallback \
  | sed -e 's/.*ps_name=\(.*\), path.*/\1/' \
  | tee -a /tmp/kitty-fonts.txt
