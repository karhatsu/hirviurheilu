Then /^current officials table row (\d+) should contain "(.*?)" with full rights$/ do |row, name|
  find(:xpath, "//div[@id='current_officials']//tr[#{row.to_i+1}]/td[1]").should have_content(name)
  page.should_not have_xpath("//div[@id='current_officials']//tr[#{row.to_i+1}]/td[2]/img")
end

Then /^current officials table row (\d+) should contain "(.*?)" with limited rights to all clubs$/ do |row, name|
  find(:xpath, "//div[@id='current_officials']//tr[#{row.to_i+1}]/td[1]").should have_content(name)
  page.should have_xpath("//div[@id='current_officials']//tr[#{row.to_i+1}]/td[2]/img")
end

Then /^current officials table row (\d+) should contain "(.*?)" with limited rights to club "(.*?)"$/ do |row, name, club_name|
  find(:xpath, "//div[@id='current_officials']//tr[#{row.to_i+1}]/td[1]").should have_content(name)
  page.should have_xpath("//div[@id='current_officials']//tr[#{row.to_i+1}]/td[2]/img")
  find(:xpath, "//div[@id='current_officials']//tr[#{row.to_i+1}]/td[3]").should have_content(club_name)
end
