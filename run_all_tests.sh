#!/bin/sh
set -e
if [ "$(cat STABLE_COMMIT)" != "$(git rev-list --max-count=1 HEAD)" ]
then
  echo "Running all tests..."
  spring rspec spec
  spring cucumber --format progress features
  spring cucumber -p js --format progress features
  git rev-list --max-count=1 HEAD > STABLE_COMMIT
else
  echo "No need to run tests."
fi
