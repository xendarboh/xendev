#!/bin/bash

sudo apt update &&
  sudo apt install --no-install-recommends -y -q \
    ffmpeg \
    libsndfile1 &&
  pip install --upgrade --no-cache-dir \
    git+https://github.com/m-bain/whisperx.git
