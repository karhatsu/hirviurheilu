#!/bin/sh
set -e
./run_all_tests.sh
git push staging master
heroku run rake db:migrate --app hirviurheilu-testi
heroku restart --app hirviurheilu-testi
URL=https://testi.hirviurheilu.com cucumber test/smoke/smoke.feature
