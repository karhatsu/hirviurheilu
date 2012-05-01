#!/bin/sh
git push staging
heroku rake db:migrate --app hirvitesti
heroku restart --app hirvitesti
