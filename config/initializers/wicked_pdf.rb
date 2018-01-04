def check_path(path)
  raise "File #{path} does not exist" unless File.exist?(path)
end

if OSX_PLATFORM
  exe_path = Rails.root.join('/Applications', 'wkhtmltopdf.app', 'Contents', 'MacOS', 'wkhtmltopdf').to_s
elsif Rails.env.test?
  exe_path = nil
elsif Rails.env.production?
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
else
  raise "Unknown non-OSX environment: #{Rails.env}"
end

if exe_path
  check_path exe_path
  WickedPdf.config[:exe_path] = exe_path
end
