json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@series, :id, :name, :competitors_count, :has_start_list, :points_method, :shorter_trip, :estimates, :finished, :national_record)
json.active @series.active?
json.started @series.started?
json.start_time @series.start_datetime
json.time_points @series.time_points?

json.age_groups @series.age_groups do |age_group|
  json.(age_group, :id, :name, :shorter_trip)
end

json.competitors @series.three_sports_results(unofficials_result_rule(@series.race)) do |competitor|
  json.(competitor, :id, :position, :first_name, :last_name, :number, :no_result_reason, :unofficial, :points, :time_in_seconds, :time_points, :estimate_points, :shooting_score, :shooting_points, :shots, :shooting_overtime_penalty, :only_rifle, :updated_at, :arrival_time)
  if @series.race.show_correct_distances?
    json.estimates competitor.estimates
    json.correct_distances competitor.correct_distances
  end
  json.finished competitor.finished?
  json.has_correct_estimates competitor.has_correct_estimates?
  json.age_group competitor.age_group, :name if competitor.age_group
  json.club competitor.club, :name
end
