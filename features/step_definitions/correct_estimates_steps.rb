Given /^the race has correct estimates with attributes:$/ do |fields|
  create(:correct_estimate, {:race => @race}.merge(fields.rows_hash))
end

When(/^I fill correct estimate (\d+) and (\d+) for the range (\d+)\-(\d+) in row (\d+)$/) do |distance1, distance2, min, max, index|
  within(:xpath, "//div[@class='form__fields--horizontal'][#{index}]") do
    fill_in "Lähtönumerot", with: min
    fill_in '–', with: max
    fill_in "Etäisyys 1", with: distance1
    fill_in "Etäisyys 2", with: distance2
  end
end

When(/^I fill correct estimate (\d+) and (\d+) for the range (\d+)\- in row (\d+)$/) do |distance1, distance2, min, index|
  within(:xpath, "//div[@class='form__fields--horizontal'][#{index}]") do
    fill_in "Lähtönumerot", with: min
    fill_in "Etäisyys 1", with: distance1
    fill_in "Etäisyys 2", with: distance2
  end
end

Then(/^I should see correct estimates (\d+) and (\d+) set for the competitor "(.*?)" "(.*?)" with number (\d+)$/) do |distance1, distance2, first_name, last_name, number|
  expect(find(:xpath, "//table[@id='competitor_correct_estimates']//tr[#{number.to_i + 1}]/td[2]")).to have_text("#{last_name} #{first_name}")
  expect(find(:xpath, "//table[@id='competitor_correct_estimates']//tr[#{number.to_i + 1}]/td[4]")).to have_text(distance1)
  expect(find(:xpath, "//table[@id='competitor_correct_estimates']//tr[#{number.to_i + 1}]/td[5]")).to have_text(distance2)
end
