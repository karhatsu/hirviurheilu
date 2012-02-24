def check_path(path)
  raise "File #{exe_path} does not exist" unless File.exist?(path)
end

if WINDOWS_PLATFORM
  exe_path = Rails.root.join('bin', 'wkhtmltopdf.exe').to_s
  check_path Rails.root.join('bin', 'libgcc_s_dw2-1.dll').to_s
elsif ['staging', 'production'].include?(Rails.env)
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
# winoffline-dev is used in Linux when testing sqlite3 migrations
elsif ['development', 'test', 'cucumber', 'winoffline-dev'].include?(Rails.env)
  exe_path = Rails.root.join('bin', 'wkhtmltopdf-i386').to_s
else
  raise "Unknown non-Windows environment: #{Rails.env}"
end

check_path exe_path
WickedPdf.config[:exe_path] = exe_path

class WickedPdf
  def pdf_from_string(string, options={})
    # OWN: double quotes around the exe path
    command = "\"#{@exe_path}\" #{parse_options(options)} -q - - " # -q for no errors on stdout
    p "*"*15 + command + "*"*15 unless defined?(Rails) and Rails.env != 'development'
    pdf, err = Open3.popen3(command) do |stdin, stdout, stderr|
      stdin.binmode
      stdout.binmode
      stderr.binmode
      stdin.write(string)
      stdin.close
      [stdout.read, stderr.read]
    end
    raise "PDF could not be generated!" if pdf and pdf.rstrip.length == 0
    pdf
  rescue Exception => e
    raise "Failed to execute:\n#{command}\nError: #{e}"
  end

  private
    def make_option(name, value, type=:string)
      "--#{name.gsub('_', '-')} " + case type
        when :boolean then ""
        when :numeric then value.to_s
        else "\"#{value}\"" # OWN: double quotes around the value
      end + " "
    end
end
