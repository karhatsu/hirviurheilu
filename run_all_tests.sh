#!/bin/sh
set -e
npm run lint
if [ "$(cat STABLE_COMMIT)" != "$(git rev-list --max-count=1 HEAD)" ]
then
  echo "Running all tests..."
  if [ "$(cat STABLE_COMMIT_RSPEC)" != "$(git rev-list --max-count=1 HEAD)" ]
  then
    echo "Running RSpec..."
    rspec spec
    git rev-list --max-count=1 HEAD > STABLE_COMMIT_RSPEC
  else
    echo "No need to run RSpec."
  fi
  bundle exec cucumber --format progress features
  git rev-list --max-count=1 HEAD > STABLE_COMMIT
else
  echo "No need to run tests."
fi
