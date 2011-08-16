require 'email_spec/cucumber'
require 'cucumber/rspec/doubles'

Role.create!(:name => Role::ADMIN) unless Role.find_by_name(Role::ADMIN)
Role.create!(:name => Role::OFFICIAL) unless Role.find_by_name(Role::OFFICIAL)

Sport.create!(:name => "Hirvenjuoksu", :key => "RUN") unless Sport.find_by_key("RUN")
Sport.create!(:name => "Hirvenhiihto", :key => "SKI") unless Sport.find_by_key("SKI")