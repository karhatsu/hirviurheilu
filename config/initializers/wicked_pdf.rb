exe_path = Rails.env == 'production' || Rails.env == 'staging' ?
  Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s : '/usr/bin/wkhtmltopdf'
WICKED_PDF = {
  #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
  #:layout => "pdf.html",
  :exe_path => exe_path
}
