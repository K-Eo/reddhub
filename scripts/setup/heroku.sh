#!/bin/bash

set -e

base_path="tools"
package_name="heroku.tar.gz"

echo Setting up Heroku.

echo Download Heroku.

if [ -d "$base_path" ]
then
  echo Directory tools ready.
else
  echo Create tools directory.
  mkdir $base_path
fi

if [ -f "$base_path/$package_name" ]
then
  echo File $package_name already cached. 
else
  echo Downloading heroku.tar.gz.
  wget -nv -O $base_path/$package_name https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz
fi

echo Configure Heroku.

sudo mkdir -p /usr/local/lib /usr/local/bin
sudo tar -xzf $base_path/$package_name -C /usr/local/lib
sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku

echo Setting up Heroku DONE.
