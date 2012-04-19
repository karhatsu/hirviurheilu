Given /^there is a price "(.*)" for min competitors (\d+)$/ do |price, min_competitors|
  FactoryGirl.create(:price, :price => price, :min_competitors => min_competitors)
end
