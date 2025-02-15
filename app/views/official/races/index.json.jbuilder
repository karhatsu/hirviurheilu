json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.races @races.each do |race|
  json.(race, :id, :name, :location, :start_date, :end_date, :event_id)
end
