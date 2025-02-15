json.(@event, :id, :name)
json.races @event.races.each do |race|
  json.(race, :id, :name)
end
