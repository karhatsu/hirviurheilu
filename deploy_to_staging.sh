#!/bin/sh
set -e
./run_all_tests.sh
git push staging master
heroku run rake db:migrate --app hirviurheilu-testi
heroku restart --app hirviurheilu-testi
ruby test/smoke/smoketests.rb http://testi.hirviurheilu.com
