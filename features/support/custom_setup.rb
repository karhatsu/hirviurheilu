require 'email_spec/cucumber'
require 'cucumber/rspec/doubles'

def setup_database
  Role.ensure_default_roles_exist
  Sport.ensure_default_sports_exist
end

setup_database