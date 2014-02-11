#!/bin/sh
git push production master
heroku run rake db:migrate --app hirvi
heroku restart --app hirvi
