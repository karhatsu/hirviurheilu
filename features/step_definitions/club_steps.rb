Given /^there is a club "([^"]*)"$/ do |name|
  Factory.create(:club, :name => name)
end
