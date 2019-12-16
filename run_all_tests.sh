#!/bin/sh
set -e
if [ "$(cat STABLE_COMMIT)" != "$(git rev-list --max-count=1 HEAD)" ]
then
  echo "Running all tests..."
  if [ "$(cat STABLE_COMMIT_RSPEC)" != "$(git rev-list --max-count=1 HEAD)" ]
  then
    echo "Running RSpec..."
    spring rspec spec
    git rev-list --max-count=1 HEAD > STABLE_COMMIT_RSPEC
  else
    echo "No need to run RSpec."
  fi
  spring cucumber --format progress features
  git rev-list --max-count=1 HEAD > STABLE_COMMIT
else
  echo "No need to run tests."
fi
