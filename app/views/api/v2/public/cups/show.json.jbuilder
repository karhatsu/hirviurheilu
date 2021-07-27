json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@cup, :id, :name, :public_message, :top_competitions, :include_always_last_race)
json.has_rifle @cup.has_rifle?
json.races @cup.races do |race|
  json.(race, :id, :name)
end
json.cup_series @cup.cup_series do |cup_series|
  json.(cup_series, :id, :name, :series_names)
  if params[:results]
    json.cup_competitors cup_series.results do |cup_competitor|
      json.(cup_competitor, :first_name, :last_name, :series_names, :points, :club_name)
    end
  end
end
