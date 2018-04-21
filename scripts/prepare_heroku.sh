#!/bin/bash

echo "Download heroku.tar.gz"

mkdir -p ./tools

if [ -f ./tools/heroku.tar.gz ]; then
  echo "File heroku.tar.gz already cached"
else
  wget -nv -O ./tools/heroku.tar.gz https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz
fi


