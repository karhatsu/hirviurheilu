json.cache! [@relay, request.headers['X-Camel-Case']] do
  json.key_format! camelize: :lower if request.headers['X-Camel-Case']
  json.(@relay, :id, :race_id, :name, :legs_count, :estimate_penalty_seconds, :shooting_penalty_seconds)
  json.start_time @relay.start_datetime
  json.finished @relay.finished?
  json.started @relay.started?
  json.penalty_seconds @relay.penalty_seconds?
  json.correct_distances @relay.relay_correct_estimates.each do |cd|
    json.(cd, :leg, :distance)
  end
  json.teams @relay.results.each do |team|
    json.(team, :id, :name, :number, :no_result_reason, :time_in_seconds, :estimate_penalties_sum, :estimate_penalty_seconds, :shoot_penalties_sum, :shooting_penalty_seconds, :adjustment, :estimate_adjustment, :shooting_adjustment)
    if @relay.penalty_seconds?
      json.time_with_penalties team.time_in_seconds(nil, true)
    end
    json.competitors team.relay_competitors.each do |competitor|
      json.(competitor, :leg, :first_name, :last_name, :time_in_seconds, :estimate, :estimate_penalties, :misses, :adjustment, :estimate_adjustment, :shooting_adjustment, :updated_at)
      json.cumulative_time team.time_in_seconds(competitor.leg)
      if @relay.penalty_seconds?
        json.estimate_penalty_seconds competitor.estimate_penalty_seconds
        json.shooting_penalty_seconds competitor.shooting_penalty_seconds
        json.time_with_penalties competitor.time_in_seconds(true)
        json.cumulative_time_with_penalties team.time_in_seconds(competitor.leg, true)
      end
    end
  end
  json.leg_results @relay.legs_count.times do |i|
    json.team_ids @relay.leg_results(i + 1).map(&:id)
  end
end
