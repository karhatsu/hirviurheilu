#!/bin/sh
RAILS_ENV=test bundle exec rake db:schema:load
