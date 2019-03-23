Given /^the race has a relay "([^*]*)"$/ do |name|
  @relay = create(:relay, :race => @race, :name => name)
end

Given /^the race has a relay with attributes:$/ do |table|
  @relay = create(:relay, {:race => @race}.merge(table.rows_hash))
end

Given /^the relay has a team "([^"]*)"$/ do |name|
  @relay_team = create(:relay_team, :relay => @relay, :name => name)
end

Given /^the relay has a team "([^"]*)" with number (\d+)$/ do |name, number|
  @relay_team = create(:relay_team, :relay => @relay, :name => name, :number => number)
end

Given /^the relay team has a competitor with attributes:$/ do |table|
  @relay_competitor = create(:relay_competitor, {:relay_team => @relay_team}.merge(table.rows_hash))
end

Given /^the estimate for the relay competitor "([^"]*)" "([^"]*)" is (\d+)$/ do |first,
    last, estimate|
  competitor = RelayCompetitor.where(:first_name => first, :last_name => last).first
  competitor.estimate = estimate
  competitor.save!
end

Given /^the relay has the correct estimates:$/ do |table|
  table.hashes.each do |hash|
    create(:relay_correct_estimate, :relay => @relay,
      :leg => hash[:leg], :distance => hash[:distance])
  end
end

Given /^the relay is finished$/ do
  @relay.finish!
end

Given /^the relay team is deleted$/ do
  @relay.relay_teams.last.destroy
end

When("someone else saves data for the relay") do
  @relay_competitor.estimate = 123
  @relay_competitor.save!
end

Then(/^there should be editable relay competitor "(.*?)" "(.*?)" with (\d+) misses and estimate (\d+)$/) do |first_name, last_name, misses, estimate|
  expect(find('#relay_relay_teams_attributes_0_relay_competitors_attributes_0_first_name').value).to eq(first_name)
  expect(find('#relay_relay_teams_attributes_0_relay_competitors_attributes_0_last_name').value).to eq(last_name)
  expect(find('#relay_relay_teams_attributes_0_relay_competitors_attributes_0_misses').value).to eq(misses)
  expect(find('#relay_relay_teams_attributes_0_relay_competitors_attributes_0_estimate').value).to eq(estimate)
end
