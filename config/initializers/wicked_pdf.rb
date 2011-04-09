exe_path = Rails.env == 'production' || Rails.env == 'staging' ?
  Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s : '/usr/bin/wkhtmltopdf'
WickedPdf.config[:exe_path] = exe_path