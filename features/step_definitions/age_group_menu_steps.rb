Then /^the age group menu should be hidden$/ do
  page.should_not have_css('#ageGroupId', visible: true)
end

Then /^the age group menu should contain items "(.*?)"$/ do |items|
  items.split(',').each_with_index do |item, i|
    option = find('#ageGroupId').all('option')[i]
    expect(option.text).to eq item
  end
end

Then /^the limited official competitors page age group menu should contain items "(.*?)"$/ do |items|
  items.split(',').each_with_index do |item, i|
    option = find('#competitor_age_group_id').all('option')[i]
    expect(option.text).to eq item
  end
end

Then /^"(.*?)" should be selected in the series menu$/ do |series_name|
  selected_option = find('#seriesId').find('option', visible: false, match: :first) do |option|
    option.selected?
  end
  expect(selected_option.text).to eq(series_name)
end

Then /^"(.*?)" should be selected in the limited official competitors page series menu$/ do |series_name|
  selected_option = find('#competitor_series_id').find('option', visible: false, match: :first) do |option|
    option.selected?
  end
  expect(selected_option.text).to eq(series_name)
end

Then /^"(.*?)" should be selected in the age group menu$/ do |age_group_name|
  selected_option = find('#ageGroupId').find('option', visible: false, match: :first) do |option|
    option.selected?
  end
  expect(selected_option.text).to eq(age_group_name)
end

Then /^"(.*?)" should be selected in the limited official competitors page age group menu$/ do |age_group_name|
  selected_option = find('#competitor_age_group_id').find('option', visible: false, match: :first) do |option|
    option.selected?
  end
  expect(selected_option.text).to eq(age_group_name)
end
