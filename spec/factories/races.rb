Factory.define(:race) do |c|
  c.association :sport
  c.name 'Championships'
  c.location 'Tervo'
  c.start_date '2010-08-14'
  c.start_interval_seconds 60
end