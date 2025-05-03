Then /^the series menu should contain options "(.*?)"$/ do |items|
  items.split(',').each_with_index do |item, i|
    page.should have_xpath("//select[@id='seriesId']/option[#{i+1}][text()='#{item}']")
  end
end
