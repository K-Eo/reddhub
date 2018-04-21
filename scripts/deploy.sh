#!/bin/bash

echo "Deploy to $APP_NAME app."

# Install private ssh key
which ssh-agent
eval $(ssh-agent -s)
echo "$SSH_HEROKU_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add heroku.com as known host
echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts

cat > ~/.netrc << EOF
machine api.heroku.com
  login $HEROKU_LOGIN
  password $HEROKU_API_KEY
EOF

git remote -v
git remote rm heroku
git remote add heroku git@heroku.com:$APP_NAME.git
git fetch heroku

# Check for migrations
MIGRATION_CHANGES=$(git diff HEAD heroku/master --name-only -- db | wc -l)
echo "$MIGRATION_CHANGES db changes."

# Check for workers
PREV_WORKERS=$(heroku ps --app $APP_NAME | grep "^worker." | wc -l | tr -d ' ')
echo "$PREV_WORKERS workers."

# Downtime during migrations
if test $MIGRATION_CHANGES -gt 0; then
  heroku maintenance:on --app $APP_NAME

  # Stop workers
  heroku scale worker=0 --app $APP_NAME
fi

# Deploy
git push heroku $CI_COMMIT_SHA:refs/heads/master

if [ $? -eq 0 ]; then
    echo OK
else
    heroku maintenance:off --app $APP_NAME
    echo FAIL
    exit 1
fi

if test $MIGRATION_CHANGES -gt 0; then
  heroku run rake db:migrate --app $APP_NAME
  heroku scale worker=$PREV_WORKERS --app $APP_NAME
  heroku restart --app $APP_NAME
fi

heroku maintenance:off --app $APP_NAME
