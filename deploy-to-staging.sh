#!/bin/sh
set -e
./run-all-tests.sh
git push staging main
heroku run rake db:migrate --app hirviurheilu-testi
heroku restart --app hirviurheilu-testi
URL=https://testi.hirviurheilu.com bundle exec cucumber test/smoke/smoke.feature
