Given /^there is a price "(.*)" for min competitors (\d+)$/ do |price, min_competitors|
  Factory.create(:price, :price => price, :min_competitors => min_competitors)
end
