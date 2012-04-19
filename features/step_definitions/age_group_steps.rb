Given /^the series has an age group "([^"]*)"$/ do |name|
  @series.age_groups << FactoryGirl.build(:age_group, :name => name, :series => @series)
end