#!/bin/bash

set -e

echo Setting up gems.

gem install bundler --no-ri --no-rdoc
bundle install --jobs $(nproc) --path vendor/bundle

echo Setting up gems DONE.
