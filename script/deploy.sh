#!/bin/sh
if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [ "$TRAVIS_BRANCH" = "feature/travis" ]
then
  echo "This is a travis test."
  exit 0
fi

if [ "$TRAVIS_BRANCH" = "develop" ]
then
  wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
  git remote add heroku git@heroku.com:suicat.git
  echo "Host heroku.com" >> ~/.ssh/config
  echo "   StrictHostKeyChecking no" >> ~/.ssh/config
  echo "   CheckHostIP no" >> ~/.ssh/config
  echo "   UserKnownHostsFile=/dev/null" >> ~/.ssh/config
  yes | heroku keys:add
  yes | git push heroku develop:master
  heroku run rake db:migrate
  heroku restart
  heroku keys:remove `whoami`@`hostname`
fi
