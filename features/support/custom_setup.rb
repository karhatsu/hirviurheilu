require 'email_spec/cucumber'
require 'cucumber/rspec/doubles'

def setup_database
  Role.create!(:name => Role::ADMIN) unless Role.find_by_name(Role::ADMIN)
  Role.create!(:name => Role::OFFICIAL) unless Role.find_by_name(Role::OFFICIAL)
  
  Sport.ensure_default_sports_exist
end

setup_database