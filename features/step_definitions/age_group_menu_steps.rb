Then /^the age group menu should be hidden$/ do
  page.should_not have_css('#age_groups_span', :visible => true)
end

Then /^the age group menu should not be hidden$/ do
  page.should have_css('#age_groups_span', :visible => true)
end

Then /^the age group menu should contain items "(.*?)"$/ do |items|
  items.split(',').each_with_index do |item, i|
    page.should have_xpath("//select[@id='competitor_age_group_id']/option[#{i+1}][text()='#{item}']")
  end
end

Then /^"(.*?)" should be selected in the age group menu$/ do |item|
  page.should have_xpath("//select[@id='competitor_age_group_id']/option[@selected = 'selected'][text()='#{item}']")
end
