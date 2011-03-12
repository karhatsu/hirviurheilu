Given /^the race has a relay "([^*]*)"$/ do |name|
  @relay = Factory.create(:relay, :race => @race, :name => name)
end

Given /^the race has a relay with attributes:$/ do |table|
  @relay = Factory.create(:relay, {:race => @race}.merge(table.rows_hash))
end

Given /^the relay has a team "([^"]*)" with number (\d+)$/ do |name, number|
  @relay_team = Factory.create(:relay_team, :relay => @relay, :name => name, :number => number)
end

Given /^the relay team has a competitor with attributes:$/ do |table|
  Factory.create(:relay_competitor, {:relay_team => @relay_team}.merge(table.rows_hash))
end
