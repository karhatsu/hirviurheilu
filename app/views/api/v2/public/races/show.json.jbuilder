json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :name, :location, :start_time, :start_date, :end_date, :organizer, :sport_name, :club_level)
json.start_time @race.short_start_time

json.series @race.series do |series|
  json.(series, :id, :name)

  unless params[:no_competitors]
    json.competitors series.competitors do |competitor|
      json.(competitor, :first_name, :last_name, :number)
      json.start_date_time competitor.start_datetime

      json.club competitor.club, :name
    end
  end
end
