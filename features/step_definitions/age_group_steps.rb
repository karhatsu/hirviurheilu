Given /^the series has an age group "([^"]*)"$/ do |name|
  @series.age_groups << FactoryGirl.build(:age_group, :name => name, :series => @series)
end

Given(/^the series has an age group "(.*?)" with (\d+) minimum competitors for own comparison time$/) do |name, min_competitors|
  @series.age_groups << FactoryGirl.build(:age_group, name: name, series: @series, min_competitors: min_competitors)
end

Given(/^the series has an age group "(.*?)" with shorter trip$/) do |name|
  @series.age_groups << FactoryGirl.build(:age_group, name: name, series: @series, shorter_trip: true)
end
