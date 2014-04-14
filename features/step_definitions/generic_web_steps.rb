When(/^I follow the first "(.*?)" link$/) do |link|
  first(:link, link).click
end
