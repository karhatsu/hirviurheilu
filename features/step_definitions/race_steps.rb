Given /^there is a race "([^"]*)"$/ do |name|
  @race = create(:race, :name => name)
end

Given "there is a {string} race {string}" do |sport_key, name|
  @race = create :race, sport_key: sport_key, name: name
end

Given(/^there is a race "(.*?)" that starts in 7 days$/) do |name|
  @race = create(:race, name: name, start_date: 7.days.from_now)
end

Given /^there is a race with attributes:$/ do |fields|
  @race = create(:race, fields.rows_hash)
end

Given /^there is a race "(.*?)" with series, competitors, team competitions, and relays$/ do |name|
  @race = create(:race, :name => name)
  @series = build(:series, :race => @race)
  @race.series << @series
  @age_group = build(:age_group, :series => @series)
  @series.age_groups << @age_group
  @competitor = build(:competitor, :series => @series, :age_group => @age_group)
  @series.competitors << @competitor
  @team_competition = build(:team_competition, :race => @race)
  @race.team_competitions << @team_competition
  @relay = build(:relay, :race => @race)
  @race.relays << @relay
  @relay_team = build(:relay_team, :relay => @relay)
  @relay.relay_teams << @relay_team
  @relay_competitor = build(:relay_competitor, :relay_team => @relay_team)
  @relay_team.relay_competitors << @relay_competitor
end

Given /^the race "([^"]*)" is renamed to "([^"]*)"$/ do |old_name, new_name|
  race = Race.find_by_name(old_name)
  race.name = new_name
  race.save!
end

Given /^I have a race "([^"]*)"$/ do |name|
  @race = create(:race, name: name, start_date: 10.days.ago)
  @user.race_rights.create!(:race => @race)
end

Given("I have a {string} race {string}") do |sport_key, name|
  @race = create :race, sport_key: sport_key, name: name
  @user.race_rights.create! race: @race
end

Given /^I have a race with attributes:$/ do |fields|
  @race = create(:race, fields.rows_hash)
  @user.race_rights.create!(:race => @race)
end

Given /^I have a race "(.*?)" with competitor "(.*?)" "(.*?)" in series "(.*?)", with number (\d+) and start time "(.*?)"$/ do |race_name,
    first_name, last_name, series_name, number, start_time|
  @race = create(:race, :name => race_name, :start_order => Race::START_ORDER_MIXED)
  @series = build(:series, :race => @race, :name => series_name)
  @race.series << @series
  @competitor = build(:competitor, :series => @series, :first_name => first_name, :last_name => last_name,
    :number => number, :start_time => start_time)
  @series.competitors << @competitor
  @user.race_rights.create!(:race => @race)
end

Given("I have a {string} race {string} with competitor {string} {string} in series {string}, with number {int}") do |sport_key, race_name, first_name, last_name, series_name, number|
  @race = create :race, name: race_name, sport_key: sport_key
  @series = create :series, race: @race, name: series_name
  @competitor = create :competitor, series: @series, first_name: first_name, last_name: last_name, number: number
  @user.race_rights.create! race: @race
end

Given /^there is a race "([^"]*)" in the past$/ do |name|
  @race = create(:race, :start_date => Date.today - 1, :name => name)
end

Given(/^there is a finished race "([^"]*)" for the district$/) do |name|
  @race = create :race, name: name, district: @district, start_date: 5.days.ago
end

Given(/^there is a race "(.*?)" that was (\d+) days ago$/) do |name, days_ago|
  @race = create :race, start_date: days_ago.to_i.days.ago, name: name
end

Given /^there is a race "([^"]*)" today/ do |name|
  @race = create(:race, :start_date => Date.today, :name => name)
end

Given(/^there is an ongoing race "([^"]*)" for the district$/) do |name|
  @race = create :race, name: name, district: @district, start_date: Date.today
end

Given /^there is a race "([^"]*)" in the future$/ do |name|
  @race = create(:race, :start_date => Date.today + 1, :name => name)
end

Given /^there is an ongoing race with attributes:$/ do |fields|
  @race = create(:race, {:start_date => Date.today}.merge(fields.rows_hash))
end

Given(/^there is a future race "([^"]*)" for the district$/) do |name|
  @race = create :race, name: name, district: @district, start_date: Date.today + 2
end

Given /^the race is finished$/ do
  @race.reload
  @race.finish!
end

Given /^I have an ongoing race "([^"]*)"$/ do |name|
  @race = create(:race, :start_date => Date.today, :name => name, sport_key: Sport::SKI)
  @user.race_rights.create!(:race => @race)
end

Given /^I have an ongoing race with attributes:$/ do |fields|
  @race = create(:race, {:start_date => Date.today, sport_key: Sport::SKI}.merge(fields.rows_hash))
  @user.race_rights.create!(:race => @race)
end

Given /^I have a future race "([^"]*)"$/ do |name|
  @race = create(:race, :start_date => Date.today + 1, :name => name)
  @user.race_rights.create!(:race => @race)
end

Given /^I have a complete race "([^"]*)" located in "([^"]*)"$/ do |name, location|
  @race = create(:race, :name => name, :location => location,
    :start_date => Date.today - 1)
  @user.race_rights.create!(:race => @race)
  @race.clubs << build(:club, :race => @race)
  series = build(:series, :race => @race, :first_number => 1,
    :start_time => '01:00')
  @race.series << series
  competitor = build(:competitor, :series => series)
  series.competitors << competitor
  series.generate_start_list! Series::START_LIST_ADDING_ORDER
  competitor.reload
  competitor.shooting_score_input = 85
  competitor.estimate1 = 100
  competitor.estimate2 = 150
  competitor.arrival_time = '02:00'
  competitor.save!
  @race.correct_estimates << build(:correct_estimate, :race => @race,
    :min_number => 1, :max_number => 1)
  @race.set_correct_estimates_for_competitors
  @race.finish!
end

When(/^I choose to delete the race "(.*?)"$/) do |race_name|
  race = Race.find_by_name(race_name)
  within "#race_row_#{race.id}" do
    click_link 'Poista'
  end
end

Then /^the page should not contain the remove race button$/ do
  page.should have_no_button('Poista kilpailu')
end

Then /^the race should be completely removed from the database$/ do
#  Race.exists?(@race.id).should be_false
  Series.exists?(@series.id).should be_falsey
  AgeGroup.exists?(@age_group.id).should be_falsey
  Competitor.exists?(@competitor.id).should be_falsey
  TeamCompetition.exists?(@team_competition.id).should be_falsey
  Relay.exists?(@relay.id).should be_falsey
  RelayTeam.exists?(@relay_team.id).should be_falsey
  RelayCompetitor.exists?(@relay_competitor.id).should be_falsey
end

Then(/^the last race billing info should be "(.*?)"$/) do |billing_info|
  billing_info = nil if billing_info.empty?
  expect(Race.last.billing_info).to eql billing_info
end
