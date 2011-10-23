if WINDOWS_PLATFORM
  exe_path = Rails.root.join('bin', 'wkhtmltopdf.exe').to_s
elsif ['staging', 'production'].include?(Rails.env)
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
# winoffline-dev is used in Linux when testing sqlite3 migrations
elsif ['development', 'test', 'cucumber', 'winoffline-dev'].include?(Rails.env)
  exe_path = '/usr/bin/wkhtmltopdf'
else
  raise "Unknown non-Windows environment: #{Rails.env}"
end
raise "File #{exe_path} does not exist" unless File.exist?(exe_path)
WickedPdf.config[:exe_path] = exe_path
