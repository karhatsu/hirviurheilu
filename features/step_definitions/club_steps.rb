Given /^the race has a club "([^"]*)"$/ do |name|
  FactoryGirl.create(:club, :race => @race, :name => name)
end

Given /^the race has a club "([^"]*)" with long name "([^"]*)"$/ do |name, long_name|
  FactoryGirl.create(:club, :race => @race, :name => name, :long_name => long_name)
end
