Factory.sequence :number do |n|
  n
end

Factory.define(:competitor) do |c|
  c.association :club
  c.association :series
  c.first_name 'Tauno'
  c.last_name 'Miettinen'
  c.number { Factory.next :number }
end