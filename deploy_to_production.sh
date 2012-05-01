#!/bin/sh
git push production
heroku rake db:migrate --app hirvi
heroku restart --app hirvi
