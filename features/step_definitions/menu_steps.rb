When(/^I choose "(.*?)" from main menu$/) do |menu_item|
  find('.main_menu').click_link(menu_item)
end

When(/^I choose "(.*?)" from sub menu$/) do |menu_item|
  find('.second_level_menu').click_link(menu_item)
end

Then /^the "([^"]*)" main menu item should be selected$/ do |title|
  steps %Q{
    Then I should see "#{title}" within "div.main_menu a.selected"
  }
end

Then /^the official main menu item should be selected$/ do
  steps %Q{
    Then I should see "Toimitsijan sivut" within "div.main_menu a.selected"
  }
end

Then /^the "([^"]*)" sub menu item should be selected$/ do |title|
  steps %Q{
    Then I should see "#{title}" within "div.sub_menu a.selected"
  }
end
