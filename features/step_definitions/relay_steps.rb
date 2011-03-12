Given /^the race has a relay "([^*]*)"$/ do |name|
  @relay = Factory.create(:relay, :race => @race, :name => name)
end
