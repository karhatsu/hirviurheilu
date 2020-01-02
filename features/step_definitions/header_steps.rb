Then /^the page title should contain "(.*?)"$/ do |title|
  within(".body__on-top-title") do
    page.should have_content(title)
  end
end
