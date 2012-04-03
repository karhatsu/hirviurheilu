Given /^there is a cup "([^"]*)"$/ do |name|
  @cup = Factory.create(:cup, :name => name)
end

Given /^there is a cup "([^"]*)" with (\d+) top competitions$/ do |name, top_competitions|
  @cup = Factory.create(:cup, :name => name, :top_competitions => top_competitions)
end

Given /^the race belongs to the cup$/ do
  @cup.races << @race
end
