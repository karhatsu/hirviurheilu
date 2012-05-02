#!/bin/sh
git push production
heroku run rake db:migrate --app hirvi
heroku restart --app hirvi
