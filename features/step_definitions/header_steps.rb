Then /^the page title should contain "(.*?)"$/ do |title|
  within(".main_title") do
    page.should have_content(title)
  end
end
