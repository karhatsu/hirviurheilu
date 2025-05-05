json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :id, :name)
json.competitors @race.competitors.each do |competitor|
  json.partial! 'official/competitors/competitor', competitor: competitor
end
