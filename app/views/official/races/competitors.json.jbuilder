json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :id, :name)
competitors = @race.competitors.includes(series: :race)
json.competitors competitors.each do |competitor|
  json.partial! 'official/competitors/competitor', competitor: competitor
end
