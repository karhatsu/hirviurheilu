Given('I paste the file {string} contents to the Megalink data field') do |file_name|
  full_path = File.join Rails.root, 'spec', 'files', file_name
  contents = File.read full_path
  fill_in :file, with: contents
end
