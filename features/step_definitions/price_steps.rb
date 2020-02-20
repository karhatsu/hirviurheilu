Then /^I should see a link to the production environment with text "(.*?)"$/ do |text|
  page.should have_link(text, :href => "#{PRODUCTION_URL}/prices")
end
