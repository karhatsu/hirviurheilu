Given /^there is an active announcement "(.*?)"$/ do |title|
  create(:announcement, :active => true, :title => title)
end

Given(/^there is an active front page announcement "(.*?)"$/) do |title|
  create(:announcement, active: true, front_page: true, title: title)
end

Given /^there is a non\-active announcement "(.*?)"$/ do |title|
  create(:announcement, :active => false, :title => title)
end

Given(/^there is a non\-active front page announcement "(.*?)"$/) do |title|
  create(:announcement, active: false, front_page: true, title: title)
end

Given /^there is an active front page announcement with title "(.*?)" and markdown "(.*?)"$/ do |title, markdown|
  create(:announcement, active: true, front_page: true, title: title, markdown: markdown)
end
