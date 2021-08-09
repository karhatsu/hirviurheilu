json.cache! [@series, @series.started?, request.headers['X-Camel-Case']] do
  json.key_format! camelize: :lower if request.headers['X-Camel-Case']
  json.(@series, :id, :name, :competitors_count, :has_start_list, :points_method, :shorter_trip, :estimates, :finished, :national_record)
  if @series.race.sport.european?
    json.competitors_count @series.competitors.where('only_rifle=?', false).count
  end
  json.active @series.active?
  json.started @series.started?
  json.start_time @series.start_datetime
  json.time_points @series.time_points?

  json.age_groups @series.age_groups do |age_group|
    json.(age_group, :id, :name, :shorter_trip)
  end

  unofficials_rule = unofficials_result_rule(@series.race)
  if @series.race.sport.nordic?
    competitors = @series.nordic_race_results
  elsif @series.race.sport.european?
    competitors = @series.european_race_results
  elsif @series.race.sport.shooting?
    competitors = @series.shooting_race_results
  else
    competitors = @series.three_sports_results(unofficials_rule)
  end
  json.competitors competitors.each do |competitor|
    json.(competitor, :id, :position, :first_name, :last_name, :number, :no_result_reason, :unofficial, :shots, :updated_at)
    json.points competitor.points(unofficials_rule)
    if @series.race.sport.nordic?
      json.(competitor, :nordic_trap_score, :nordic_trap_shots, :nordic_shotgun_score, :nordic_shotgun_shots, :nordic_rifle_moving_score, :nordic_rifle_moving_shots, :nordic_rifle_standing_score, :nordic_rifle_standing_shots, :nordic_score, :nordic_extra_score)
    elsif @series.race.sport.european?
      json.(competitor, :only_rifle, :european_trap_score, :european_trap_shots, :european_compak_score, :european_compak_shots, :european_rifle1_score, :european_rifle1_shots, :european_rifle2_score, :european_rifle2_shots, :european_rifle3_score, :european_rifle3_shots, :european_rifle4_score, :european_rifle4_shots, :european_score, :european_extra_score)
    elsif @series.race.sport.shooting?
      json.(competitor, :shots, :qualification_round_sub_scores, :qualification_round_shots, :qualification_round_score, :final_round_shots, :final_round_score, :shooting_score, :extra_score, :extra_shots)
    else
      json.(competitor, :arrival_time, :shooting_overtime_penalty, :time_in_seconds, :estimate_points, :shooting_score, :shooting_points)
      json.time_points competitor.time_points(unofficials_rule)
      json.comparison_time_in_seconds competitor.comparison_time_in_seconds(unofficials_rule)
    end
    json.has_shots !!competitor.has_shots?
    if @series.race.show_correct_distances?
      json.estimates competitor.estimates
      json.correct_distances competitor.correct_distances
    end
    json.finished competitor.finished?
    json.has_correct_estimates competitor.has_correct_estimates?
    json.age_group competitor.age_group, :name if competitor.age_group
    json.club competitor.club, :name
  end
end
