json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :id, :name, :location, :start_time, :start_date, :end_date, :organizer, :sport_name, :club_level, :cancelled)
json.start_time @race.short_start_time
json.all_competitions_finished @race.all_competitions_finished?

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

json.team_competitions @race.team_competitions do |tc|
  json.(tc, :id, :name)
end

json.relays @race.relays do |relay|
  json.(relay, :id, :name)
end
