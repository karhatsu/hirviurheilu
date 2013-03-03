# encoding: UTF-8
Then /^Finnish locale flag should be visible$/ do
  page.should have_xpath("//img[@alt='Suomeksi']")
end

Then /^Finnish locale flag should not be visible$/ do
  page.should have_no_xpath("//img[@alt='Suomeksi']")
end

Then /^Swedish locale flag should be visible$/ do
  page.should have_xpath("//img[@alt='På svenska']")
end

Then /^Swedish locale flag should not be visible$/ do
  page.should have_no_xpath("//img[@alt='På svenska']")
end
