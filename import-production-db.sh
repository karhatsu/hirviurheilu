#!/usr/bin/env bash
set -e

rm -f latest.dump
heroku pg:backups:download -r production
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d hirviurheilu latest.dump
