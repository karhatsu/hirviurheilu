Factory.sequence :club_name do |n|
  "Ampumaseura #{n}"
end

Factory.define(:club) do |c|
  c.name { Factory.next(:club_name) }
end