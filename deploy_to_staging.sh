#!/bin/sh
git push staging
heroku run rake db:migrate --app hirvitesti
heroku restart --app hirvitesti
