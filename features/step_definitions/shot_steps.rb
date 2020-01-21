When("I fill shots {string}") do |shots_string|
  shots_string.split(',').each_with_index do |shot, i|
    fill_in "shot-#{@competitor.id}-#{i}", with: shot
  end
end
