Factory.define :correct_estimate do |ce|
  ce.association :race
  ce.min_number 10
  ce.max_number 20
  ce.distance1 115
  ce.distance2 97
end