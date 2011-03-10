Factory.define :relay_competitor do |rc|
  rc.association :relay_team
  rc.first_name 'Mikko'
  rc.last_name 'Miettinen'
  rc.leg 2
end