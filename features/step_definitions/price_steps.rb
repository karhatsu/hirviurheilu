Given /^there is a price "(.*)" for min competitors (\d+)$/ do |price, min_competitors|
  FactoryGirl.create(:price, :price => price, :min_competitors => min_competitors)
end

Then /^I should see a link to the production environment with text "(.*?)"$/ do |text|
  page.should have_link(text, :href => "#{PRODUCTION_URL}/prices")
end
