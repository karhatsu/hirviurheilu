Then /^the series menu should contain options "(.*?)"$/ do |items|
  expected_options = items.split(',').map(&:strip)
  expect(page).to have_select('seriesId', options: expected_options)
end
