Given /^the race has a club "([^"]*)"$/ do |name|
  Factory.create(:club, :race => @race, :name => name)
end
