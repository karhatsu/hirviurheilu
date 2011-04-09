Then /^I should see a result row (\d+) with values:$/ do |order_number, values|
  values.rows_hash.values.each do |cell|
    Then %{I should see "#{cell}" within "tr#comp_#{order_number}"}
  end
end

Then /^I should see a team (\d+) competitor row (\d+) with values:$/ do |team_order_number,
    competitor_order_number, values|
  values.rows_hash.values.each do |cell|
    Then %{I should see "#{cell}" within "tr#team_#{team_order_number}_comp_#{competitor_order_number}"}
  end
end