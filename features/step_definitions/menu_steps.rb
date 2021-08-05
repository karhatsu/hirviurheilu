When(/^I choose "(.*?)" from main menu$/) do |menu_item|
  find('.menu--main').click_link(menu_item)
end

When('I choose {string} from main menu {string} dropdown') do |dropdown_item, menu_item|
  find('.menu__item a', text: menu_item).hover
  find('.menu--main .dropdown-menu__item').click_link(dropdown_item)
end

When(/^I choose "(.*?)" from sub menu$/) do |menu_item|
  find('.menu--sub-1').click_link(menu_item)
end

When(/^I choose "(.*?)" from third level menu$/) do |menu_item|
  find('.menu--sub-2').click_link(menu_item)
end

Then /^the "([^"]*)" main menu item should be selected$/ do |title|
  find('.menu--main a.selected').should have_text(title)
end

Then /^the official main menu item should be selected$/ do
  find('.menu--main a.selected').should have_text('Toimitsijan sivut')
end

Then /^the "([^"]*)" sub menu item should be selected$/ do |title|
  find('.menu--sub-1 a.selected').should have_text(title)
end

Then(/^the races main menu item should contain "(.*?)"$/) do |race_name|
  find('.menu--main').should have_text(race_name)
end

Then(/^the races main menu item should not contain "(.*?)"$/) do |race_name|
  find('.menu--main').should_not have_text(race_name)
end
