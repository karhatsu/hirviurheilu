#!/bin/sh
set -e
if [ "$(cat STABLE_COMMIT)" != "$(git rev-list --max-count=1 HEAD)" ]
then
  echo "Running all tests..."
  spring rspec spec
  spring cucumber --format progress features
  spring cucumber -p js --format progress features
else
  echo "No need to run tests."
fi
git push production master
heroku run rake db:migrate --app hirvi
heroku restart --app hirvi
ruby test/smoke/smoketests.rb http://www.hirviurheilu.com