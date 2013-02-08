Given /^there is an active announcement "(.*?)"$/ do |title|
  FactoryGirl.create(:announcement, :active => true, :title => title)
end

Given /^there is a non\-active announcement "(.*?)"$/ do |title|
  FactoryGirl.create(:announcement, :active => false, :title => title)
end

Given /^there is an active announcement with title "(.*?)" and content "(.*?)"$/ do |title, content|
  FactoryGirl.create(:announcement, :active => true, :title => title, :content => content)
end
