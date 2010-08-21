Factory.sequence :role_name do |n|
  "role_#{n}"
end

Factory.define :role do |r|
  r.name { Factory.next(:role_name) }
end