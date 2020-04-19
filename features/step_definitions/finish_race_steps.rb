When("I choose {string} for the competitor on finish race") do |action|
  choose "competitor_#{@competitor.id}_#{action}"
end
