require 'email_spec/cucumber'
require 'cucumber/rspec/doubles'

def setup_database
  Role.ensure_default_roles_exist
  Sport.ensure_default_sports_exist
  District.find_or_create_by! name: 'Test district', short_name: 'TD'
end

setup_database