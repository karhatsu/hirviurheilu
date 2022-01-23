module CsvReader
  extend ActiveSupport::Concern

  private

  def read_csv_file(file_path)
    %w[r:utf-8 r:windows-1252:utf-8].each do |read_encoding|
      data = []
      begin
        File.open(file_path, read_encoding).each_line do |line|
          separator = resolve_separator line
          columns = line.gsub(/\r\n?/, '').gsub(/\n?/, '').split(separator)
          break if columns.length == 0
          data << columns.map {|column| column.strip}
        end
        return data
      rescue ArgumentError
      end
    end
    raise UnknownCsvEncodingException.new
  end

  def resolve_separator(line)
    line.index(';') ? ';' : ','
  end
end
