Given /^I have invited "(.*?)" "(.*?)" to the race$/ do |first_name, last_name|
  official = User.where(:first_name => first_name, :last_name => last_name).first
  RaceRight.create!(:user => official, :race => @race)
end

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

Then /^the current officials table should not contain "(.*?)"$/ do |name|
  find(:css, "#current_officials").should_not have_content(name)
end
