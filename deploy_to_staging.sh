#!/bin/sh
git push staging master
heroku run rake db:migrate --app hirvitesti
heroku restart --app hirvitesti
