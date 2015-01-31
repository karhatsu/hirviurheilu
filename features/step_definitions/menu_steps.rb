When(/^I choose "(.*?)" from main menu$/) do |menu_item|
  find('.main_menu').click_link(menu_item)
end

When(/^I choose "(.*?)" from sub menu$/) do |menu_item|
  find('.second_level_menu').click_link(menu_item)
end

When(/^I choose "(.*?)" from third level menu$/) do |menu_item|
  find('.third_level_menu').click_link(menu_item)
end

Then /^the "([^"]*)" main menu item should be selected$/ do |title|
  find('div.main_menu a.selected').should have_text(title)
end

Then /^the official main menu item should be selected$/ do
  find('div.main_menu a.selected').should have_text('Toimitsijan sivut')
end

Then /^the "([^"]*)" sub menu item should be selected$/ do |title|
  find('div.second_level_menu div.sub_menu a.selected').should have_text(title)
end
