When("I fill shots {string}") do |shots_string|
  shots_string.split(',').each_with_index do |shot, i|
    fill_in "shot-#{@competitor.id}-#{i}", with: shot
  end
end

When('I select qualification round shotgun shots from {int} to {int}') do |from, to|
  (1...from).each do |i|
    page.find(:xpath, "(//div[contains(@class, 'binary-shot__option--0')])[#{i}]").click
  end
  (from..to).each do |i|
    page.find(:xpath, "(//div[contains(@class, 'binary-shot__option--1')])[#{i}]").click
  end
  ((to + 1)..25).each do |i|
    page.find(:xpath, "(//div[contains(@class, 'binary-shot__option--0')])[#{i}]").click
  end
end

When('I select final round shotgun shots from {int} to {int}') do |from, to|
  final_from = 25 + from
  final_to = 25 + to
  (26...final_from).each do |i|
    page.find(:xpath, "(//div[contains(@class, 'binary-shot__option--0')])[#{i}]").click
  end
  (final_from..final_to).each do |i|
    page.find(:xpath, "(//div[contains(@class, 'binary-shot__option--1')])[#{i}]").click
  end
  ((final_to + 1)..50).each do |i|
    page.find(:xpath, "(//div[contains(@class, 'binary-shot__option--0')])[#{i}]").click
  end
end
