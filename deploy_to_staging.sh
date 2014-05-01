#!/bin/sh
set -e
spring rspec spec
spring cucumber features
spring cucumber -p js features
git push staging master
heroku run rake db:migrate --app hirvitesti
heroku restart --app hirvitesti
ruby test/smoke/smoketests.rb http://testi.hirviurheilu.com