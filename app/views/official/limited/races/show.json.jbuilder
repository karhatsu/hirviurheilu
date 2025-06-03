json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :id, :name, :location, :start_date, :end_date, :address, :club_level)

json.sport do
  json.shooting @race.sport.shooting?
end

json.series @race.series do |series|
  json.(series, :id, :name)
  json.age_groups series.age_groups do |age_group|
    json.(age_group, :id, :name)
  end
end

json.clubs @race.clubs do |club|
  json.(club, :id, :name)
end
