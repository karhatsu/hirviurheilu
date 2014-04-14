When(/^I follow the first "(.*?)" link$/) do |link|
  first(:link, link).click
end

When(/^I press the first "(.*?)" button$/) do |button_text|
  first(:button, button_text).click
end
