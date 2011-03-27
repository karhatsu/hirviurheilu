Given /^the race has a club "([^"]*)"$/ do |name|
  Factory.create(:club, :race => @race, :name => name)
end

Given /^the race has a club "([^"]*)" with long name "([^"]*)"$/ do |name, long_name|
  Factory.create(:club, :race => @race, :name => name, :long_name => long_name)
end
