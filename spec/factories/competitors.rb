Factory.define(:competitor) do |c|
  c.association :club
  c.first_name 'Tauno'
  c.last_name 'Miettinen'
  c.year_of_birth 1960
end