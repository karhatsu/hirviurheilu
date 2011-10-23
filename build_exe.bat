@ECHO off
rem Builds two hirviurheilu.zip files containing the exe file and the SQLite3 database file (only in the second zip).
rem Dependencies:
rem - ocra: gem install ocra
rem - 7za.exe: http://7-zip.org/download.html (the command line version)

@ECHO on
SET RAILS_ENV=winoffline-prod
CALL rake elk_sports:offline:create_db
SET RAILS_ENV=
CALL cd ..
CALL ocra elk_sports\start.rb elk_sports --no-dep-run --add-all-core --gemfile elk_sports\Gemfile --dll sqlite3.dll --output hirviurheilu.exe --icon elk_sports\public\favicon.ico -- server
CALL 7za a hirviurheilu-asennus.zip hirviurheilu.exe hirviurheilu.sqlite3
CALL 7za a hirviurheilu-paivitys.zip hirviurheilu.exe
CALL cd elk_sports
