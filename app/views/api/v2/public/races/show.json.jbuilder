json.(@race, :name, :location, :start_date, :end_date, :organizer, :short_start_time, :sport_name)

json.series @race.series do |series|
  json.(series, :name)

  json.competitors series.competitors do |competitor|
    json.(competitor, :first_name, :last_name, :number, :start_datetime)

    json.club competitor.club, :name
  end
end
