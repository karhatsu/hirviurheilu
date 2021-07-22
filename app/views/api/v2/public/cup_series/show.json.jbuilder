json.key_format! camelize: :lower if request.headers['X-Camel-Case']
race_count = @cup.races.size
top_competitions = @cup.top_competitions
json.(@cup_series, :id, :name, :series_names)
cup_competitors = @rifle ? @cup_series.european_rifle_results : @cup_series.results
json.cup_competitors cup_competitors do |cup_competitor|
  json.(cup_competitor, :first_name, :last_name, :series_names)
  json.points @rifle ? cup_competitor.european_rifle_score : cup_competitor.points
  json.min_points_to_emphasize cup_competitor.min_points_to_emphasize(race_count, top_competitions)
  json.partial_points cup_competitor.points!
  json.races @cup.races do |race|
    json.(race, :id, :name)
    competitor = cup_competitor.competitor_for_race(race)
    if competitor
      json.competitor do
        json.(competitor, :id, :no_result_reason, :series_id)
        json.points @rifle ? competitor.european_rifle_score : competitor.points
      end
    end
  end
end
