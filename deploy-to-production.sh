#!/bin/sh
set -e
./run-all-tests.sh
git push production main
heroku run rake db:migrate --app hirviurheilu
heroku restart --app hirviurheilu
URL=https://www.hirviurheilu.com bundle exec cucumber test/smoke/smoke.feature
