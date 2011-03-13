#!/bin/sh
git push production
heroku rake db:migrate --app hirviurheilu
heroku restart --app hirviurheilu
