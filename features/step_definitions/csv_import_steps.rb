When /^I attach the import test file "([^"]*)" to "([^"]*)"$/ do |file_name, field|
  full_path = File.join(Rails.root, 'spec', 'files', file_name)
  steps %Q{
    When I attach the file "#{full_path}" to "#{field}" 
  }
end