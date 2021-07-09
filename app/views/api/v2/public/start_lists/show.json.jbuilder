json.cache! [@series, request.headers['X-Camel-Case']] do
  json.key_format! camelize: :lower if request.headers['X-Camel-Case']
  json.(@series, :id, :name)
  json.start_time @series.start_datetime
  json.started @series.started?
  json.competitors @series.start_list.includes(:club, :age_group) do |competitor|
    json.(competitor, :id, :first_name, :last_name, :number, :start_time, :start_datetime, :unofficial, :team_name)
    json.real_start_time competitor.real_time(:start_time).strftime('%H:%M:%S')
    json.relative_start_time competitor.start_time.strftime('%H:%M:%S')
    json.club competitor.club, :name
    json.age_group competitor.age_group, :name if competitor.age_group
  end
end
