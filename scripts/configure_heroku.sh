#!/bin/bash

echo "Install heroku"

sudo mkdir -p /usr/local/lib /usr/local/bin
sudo tar -xzf ./tools/heroku.tar.gz -C /usr/local/lib
sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku
