json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@event, :id, :name)
json.races @event.races.each do |race|
  json.(race, :id, :name, :sport_key, :start_date, :end_date)
end
