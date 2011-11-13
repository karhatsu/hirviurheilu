@ECHO off
rem Builds two hirviurheilu.zip files containing the exe file and the SQLite3 database file (only in the second zip).
rem Dependencies:
rem - ocra: gem install ocra
rem - 7za.exe: http://7-zip.org/download.html (the command line version)

@ECHO on
SET RAILS_ENV=winoffline-prod
CALL rake elk_sports:offline:create_db
SET RAILS_ENV=
CALL move bin\wkhtmltopdf-amd64 ..
CALL cd ..
CALL ocra elk_sports\start.rb elk_sports --no-dep-run --add-all-core --gemfile elk_sports\Gemfile-windows --dll sqlite3.dll --output hirviurheilu.exe --icon elk_sports\public\favicon.ico --chdir-first --no-lzma --innosetup elk_sports\hirviurheilu-offline.iss -- server
CALL 7za a HirviurheiluOffline-asennus.zip Output\HirviurheiluOffline-asennus.exe
CALL move wkhtmltopdf-amd64 elk_sports\bin
CALL cd elk_sports
