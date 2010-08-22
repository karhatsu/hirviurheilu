Factory.sequence :sport_key do |n|
  "key #{n}"
end

Factory.define(:sport) do |s|
  s.name 'Hirvenjuoksu'
  s.key { Factory.next(:sport_key) }
end