#!/bin/sh
set -e
spring rspec spec
spring cucumber features
spring cucumber -p js features
git rev-list --max-count=1 HEAD > STABLE_COMMIT
git push staging master
heroku run rake db:migrate --app hirvitesti
heroku restart --app hirvitesti
ruby test/smoke/smoketests.rb http://testi.hirviurheilu.com