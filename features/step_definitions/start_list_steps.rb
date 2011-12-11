Given /^the start list has been generated for the series$/ do
  @series.generate_start_list!(Series::START_LIST_ADDING_ORDER)
end

Then /^I should see a start list row (\d+) with values:$/ do |order_number, values|
  values.rows_hash.values.each do |cell|
    step %{I should see "#{cell}" within "tr#comp_#{order_number}"}
  end
end
