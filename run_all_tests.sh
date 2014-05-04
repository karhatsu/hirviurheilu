#!/bin/sh
set -e
spring rspec spec
spring cucumber --format progress features
spring cucumber -p js --format progress features
git rev-list --max-count=1 HEAD > STABLE_COMMIT
