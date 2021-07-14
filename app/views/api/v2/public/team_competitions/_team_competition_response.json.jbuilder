json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@tc, :id, :name, :extra_shots, :national_record)
json.has_extra_score @tc.has_extra_score?
teams = rifle ? @tc.rifle_results : @tc.results
json.teams teams do |team|
  json.(team, :name, :total_score)
  json.has_extra_score team.raw_extra_shots.length > 0 || team.raw_extra_score.length > 0
  json.extra_shots team.raw_extra_shots
  json.worse_extra_shots team.raw_extra_shots(true)
  json.extra_score team.raw_extra_score
  json.competitors team.competitors do |competitor|
    json.(competitor, :id, :first_name, :last_name, :no_result_reason, :time_in_seconds, :time_points, :estimate_points, :estimates, :correct_distances, :shooting_score, :shooting_points, :shooting_overtime_penalty)
    json.team_competition_points competitor.team_competition_points(@tc.race.sport, rifle)
    json.series competitor.series, :id, :name, :points_method, :estimates
    if competitor.age_group
      json.age_group competitor.age_group, :name
    end
  end
end
