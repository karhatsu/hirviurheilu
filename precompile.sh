#!/bin/sh
RAILS_ENV=production bundle exec rake assets:precompile
git add public/assets
git commit -m "assets precompiled for production"
git log -1 --name-only
