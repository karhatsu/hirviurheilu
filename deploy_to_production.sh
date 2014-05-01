#!/bin/sh
set -e
spring rspec spec
spring cucumber features
spring cucumber -p js features
git push production master
heroku run rake db:migrate --app hirvi
heroku restart --app hirvi
ruby test/smoke/smoketests.rb http://www.hirviurheilu.com