Given /^the start list has been generated for the series$/ do
  @series.generate_start_list!
end

Then /^I should see a start list row (\d+) with values:$/ do |order_number, values|
  values.rows_hash.values.each do |cell|
    Then %{I should see "#{cell}" within "tr#comp_#{order_number}"}
  end
end
