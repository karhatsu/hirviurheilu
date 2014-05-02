#!/bin/sh
set -e
spring rspec spec
spring cucumber --format progress features
spring cucumber -p js --format progress features
git rev-list --max-count=1 HEAD > STABLE_COMMIT
git push staging master
heroku run rake db:migrate --app hirvitesti
heroku restart --app hirvitesti
ruby test/smoke/smoketests.rb http://testi.hirviurheilu.com