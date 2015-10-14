#!/bin/sh
set -e
./run_all_tests.sh
git push production master
heroku run rake db:migrate --app hirviurheilu
heroku restart --app hirviurheilu
ruby test/smoke/smoketests.rb http://www.hirviurheilu.com
