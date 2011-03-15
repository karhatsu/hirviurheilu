Factory.sequence :race_location do |i|
  "Tervo#{i}"
end

Factory.define(:race) do |c|
  c.association :sport
  c.name 'Championships'
  c.location { Factory.next(:race_location) }
  c.start_date '2010-08-14'
  c.start_interval_seconds 60
  c.batch_size 0
  c.batch_interval_seconds 180
end
