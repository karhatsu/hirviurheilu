json.key_format! camelize: :lower if request.headers['X-Camel-Case']
race_count = @cup.races.size
top_competitions = @cup.top_competitions
json.(@cup_team_competition, :id, :name)
json.cup_teams @cup_team_competition.results do |cup_team|
  json.(cup_team, :name, :points)
  json.min_points_to_emphasize cup_team.min_points_to_emphasize(race_count, top_competitions)
  json.partial_points cup_team.points!
  json.races @cup.races do |race|
    json.(race, :id, :name)
    team = cup_team.team_for_race race
    if team
      json.team do
        json.(team, :name, :total_score, :team_competition_id)
      end
    end
  end
end
