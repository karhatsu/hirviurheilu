When(/^I follow the first "(.*?)" link$/) do |link|
  first(:link, link).click
end

When(/^I press the first "(.*?)" button$/) do |button_text|
  first(:button, button_text).click
end

When('I force mobile UI') do
  page.execute_script("$('.results--desktop').hide()")
  page.execute_script("$('.results--mobile').show()")
end

When('I wait for the results') do
  page.has_no_css? '.spinner'
end
