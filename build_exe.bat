@ECHO off
rem Builds HirviurheiluOffline-asennus.exe installation file and zips it.
rem Dependencies:
rem - ocra: gem install ocra
rem - 7za.exe: http://7-zip.org/download.html (the command line version)
rem - wkhtmltopdf.exe must be in elk_sports\bin (download wkhtmltox.exe, install it, copy wkhtmltopdf.exe from install directory)

@ECHO on
SET RAILS_ENV=winoffline-prod
SET BUNDLE_GEMFILE=Gemfile-windows
CALL bundle exec rake elk_sports:offline:create_db
CALL del log\*.log
CALL move db\offline-dev.sqlite3 ..
SET RAILS_ENV=
CALL move bin\wkhtmltopdf-amd64 ..
CALL copy public\assets\offline\application.css public\assets
CALL copy public\assets\offline\application.js public\assets
CALL cd ..
CALL ocra elk_sports\start.rb elk_sports --no-dep-run --add-all-core --gemfile elk_sports\Gemfile-windows --gem-all --dll sqlite3.dll --dll ssleay32.dll --dll libyaml-0-2.dll --output hirviurheilu.exe --icon elk_sports\public\favicon.ico --chdir-first --no-lzma --innosetup elk_sports\hirviurheilu-offline.iss -- server
CALL 7za a HirviurheiluOffline-asennus.zip Output\HirviurheiluOffline-asennus.exe
CALL move wkhtmltopdf-amd64 elk_sports\bin
CALL move offline-dev.sqlite3 elk_sports\db
CALL del elk_sports\public\assets\application.css
CALL del elk_sports\public\assets\application.js
CALL cd elk_sports
