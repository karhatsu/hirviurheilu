Then /^the series menu should contain options "(.*?)"$/ do |items|
  items.split(',').each_with_index do |item, i|
    page.should have_xpath("//select[@id='competitor_series_id']/option[#{i+1}][text()='#{item}']")
  end
end
