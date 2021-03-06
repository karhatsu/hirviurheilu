Given /^there is a cup "([^"]*)"$/ do |name|
  @cup = create(:cup, :name => name)
end

Given /^there is a cup "([^"]*)" with (\d+) top competitions$/ do |name, top_competitions|
  @cup = create(:cup, :name => name, :top_competitions => top_competitions)
end

Given(/^there is a cup "([^"]*)" with (\d+) top competitions and last race as mandatory$/) do |name, top_competitions|
  @cup = create :cup, name: name, top_competitions: top_competitions, include_always_last_race: true
end

Given /^I have a cup "([^"]*)"$/ do |name|
  @cup = create(:cup, :name => name)
  @user.cups << @cup
end

Given /^I have a cup "([^"]*)" with (\d+) top competitions$/ do |name, top_competitions|
  @cup = create(:cup, :name => name, :top_competitions => top_competitions)
  @user.cups << @cup
end

Given /^the cup has a series "([^"]*)"$/ do |cup_series_name|
  @cup.cup_series << build(:cup_series, :cup => @cup, :name => cup_series_name)
end

Given /^the cup has a series "([^"]*)" with series names "([^"]*)"$/ do |cup_series_name, series_names|
  @cup.cup_series << build(:cup_series, :cup => @cup, :name => cup_series_name, :series_names => series_names)
end

Given /^the race belongs to the cup$/ do
  @cup.races << @race
end

Given /^the cup contains the default cup series$/ do
  @cup.create_default_cup_series
end

Then /^I should see error about too few races selected for the cup$/ do
  step %{I should see "Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä" within ".message--error"}
end
