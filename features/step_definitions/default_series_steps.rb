Given /^there is a default series "([^"]*)"$/ do |name|
  Factory.create(:default_series, :name => name)
end
