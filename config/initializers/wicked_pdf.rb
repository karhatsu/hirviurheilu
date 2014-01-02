def check_path(path)
  raise "File #{path} does not exist" unless File.exist?(path)
end

if WINDOWS_PLATFORM
  exe_path = Rails.root.join('bin', 'wkhtmltopdf.exe').to_s
  check_path Rails.root.join('bin', 'libgcc_s_dw2-1.dll').to_s
elsif OSX_PLATFORM
  exe_path = Rails.root.join('/Applications', 'wkhtmltopdf.app', 'Contents', 'MacOS', 'wkhtmltopdf').to_s
elsif Rails.env.test?
  exe_path = nil
elsif ['staging', 'production'].include?(Rails.env)
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
# winoffline-dev is used in Linux when testing sqlite3 migrations
elsif ['development', 'winoffline-dev'].include?(Rails.env)
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-i386').to_s
else
  raise "Unknown non-Windows environment: #{Rails.env}"
end

if exe_path
  check_path exe_path
  WickedPdf.config[:exe_path] = exe_path
end
