#!/bin/sh
git push staging
heroku rake db:migrate --app hutesti
heroku restart --app hutesti
