# encoding: UTF-8
Given /^there is a cup "([^"]*)"$/ do |name|
  @cup = Factory.create(:cup, :name => name)
end

Given /^there is a cup "([^"]*)" with (\d+) top competitions$/ do |name, top_competitions|
  @cup = Factory.create(:cup, :name => name, :top_competitions => top_competitions)
end

Given /^I have a cup "([^"]*)"$/ do |name|
  @cup = Factory.create(:cup, :name => name)
  @user.cups << @cup
end

Given /^I have a cup "([^"]*)" with (\d+) top competitions$/ do |name, top_competitions|
  @cup = Factory.create(:cup, :name => name, :top_competitions => top_competitions)
  @user.cups << @cup
end

Given /^the race belongs to the cup$/ do
  @cup.races << @race
end

Then /^I should see error about too few races selected for the cup$/ do
  step %{I should see "Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä" within "div.error"}
end