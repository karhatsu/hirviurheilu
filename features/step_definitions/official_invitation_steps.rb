Given /^I have invited "(.*?)" "(.*?)" to the race$/ do |first_name, last_name|
  official = User.where(:first_name => first_name, :last_name => last_name).first
  RaceRight.create!(:user => official, :race => @race)
end

When('I fill multiple official invitation textarea with {string} and {string}') do |line1, line2|
  fill_in('Sähköpostit ja mahdolliset piirit/seurat', with: "#{line1}\n#{line2}")
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
  within(:xpath, "(//div[@id='current_officials']//div[@class='card'])[#{row.to_i}]") do
    expect(page).to have_css(".card__name", text: name)
    expect(page).to have_css(".card__middle-row:nth-of-type(3)", text: rights) # second middle-row but 3rd div
  end
end
