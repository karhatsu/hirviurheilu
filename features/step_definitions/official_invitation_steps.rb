Given /^I have invited "(.*?)" "(.*?)" to the race$/ do |first_name, last_name|
  official = User.where(:first_name => first_name, :last_name => last_name).first
  RaceRight.create!(:user => official, :race => @race)
end

Then /^current officials card (\d+) should contain "(.*?)" with full rights$/ do |row, name|
  expect_name_with_rights row, name, 'Täydet oikeudet'
end

Then /^current officials card (\d+) should contain "(.*?)" with limited rights to all clubs$/ do |row, name|
  expect_name_with_rights row, name, 'Seurat: Kaikki nykyiset'
end

Then /^current officials card (\d+) should contain "(.*?)" with limited rights to club "(.*?)"$/ do |row, name, club_name|
  expect_name_with_rights row, name, "Seurat: #{club_name}"
end

Then /^the current officials table should not contain "(.*?)"$/ do |name|
  find(:css, "#current_officials").should_not have_content(name)
end

def expect_name_with_rights(row, name, rights)
  find(:xpath, "(//div[@id='current_officials']//div[@class='card'])[#{row.to_i}]//div[@class='card__name']").should have_content(name)
  find(:xpath, "(//div[@id='current_officials']//div[@class='card'])[#{row.to_i}]//div[@class='card__middle-row'][2]").should have_content(rights)
end
