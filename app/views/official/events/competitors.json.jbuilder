json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@event, :id, :name)
json.races @event.races.each do |race|
  json.(race, :id, :name)
  json.series race.series.each do |series|
    json.(series, :id, :name)
    json.competitors series.competitors.each do |competitor|
      json.(competitor, :id, :first_name, :last_name, :number)
      json.club competitor.club, :name
    end
  end
end
