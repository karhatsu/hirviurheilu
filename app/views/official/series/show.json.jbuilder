json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@series, :id, :name, :estimates, :has_start_list, :race_id)
json.competitors @series.competitors.each do |competitor|
  json.partial! 'official/competitors/competitor', competitor: competitor
end
