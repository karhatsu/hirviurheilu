Factory.sequence :club_name do |n|
  "Ampumaseura #{n}"
end

Factory.define :club do |c|
  c.association :race
  c.name { Factory.next(:club_name) }
end