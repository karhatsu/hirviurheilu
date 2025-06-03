json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :id, :name, :location, :start_date, :end_date, :address, :home_page, :organizer, :organizer_phone, :sport_name, :club_level, :finished, :cancelled, :public_message, :sport_key, :hide_qualification_round_heats, :hide_final_round_heats, :days_count, :nordic_sub_results_for_series, :show_european_shotgun_results, :level, :event_id, :double_competition)
json.start_date_time @race.start_datetime
json.start_time @race.short_start_time
json.all_competitions_finished @race.all_competitions_finished?
json.show_correct_distances @race.show_correct_distances?
json.unofficials_configurable @race.year < 2018
json.user_ids @race.users.map(&:id)
json.has_team_competitions_with_team_names @race.has_team_competitions_with_team_names?
if @race.sport.start_list? || @race.sport.heat_list?
  json.next_number @race.next_start_number
end
if @race.sport.start_list?
  next_start_time = @race.next_start_time
  json.next_start_time next_start_time == '00:00:00' ? next_start_time : time_print(next_start_time, true)
end
json.pending_official_email @race.pending_official_email

json.sport do
  json.best_shot_value @race.sport.best_shot_value
  json.heat_list @race.sport.heat_list?
  json.european @race.sport.european?
  json.final_round @race.sport.final_round
  json.final_round_shot_count @race.sport.final_round_shot_count
  json.nordic @race.sport.nordic?
  json.one_heat_list @race.sport.one_heat_list?
  json.qualification_round @race.sport.qualification_round
  json.qualification_round_shot_count @race.sport.qualification_round_shot_count
  json.shooting @race.sport.shooting?
  json.shooting_simple @race.sport.shooting? && !@race.sport.european? && !@race.sport.nordic?
  json.shot_count @race.sport.shot_count
  json.shots_per_extra_round @race.sport.shots_per_extra_round
  json.start_list @race.sport.start_list?
end

json.series @race.series do |series|
  json.(series, :id, :name, :competitors_count, :finished, :estimates)
  json.has_start_list series.has_start_list?
  json.started series.started?
  json.start_time series.start_datetime

  json.age_groups series.age_groups do |age_group|
    json.(age_group, :id, :name)
  end
end

json.correct_estimates @race.correct_estimates do |ce|
  json.(ce, :min_number, :max_number, :distances)
end

json.team_competitions @race.team_competitions do |tc|
  json.(tc, :id, :name)
end

json.relays @race.relays do |relay|
  json.(relay, :id, :name)
  json.started relay.started?
  json.start_time relay.start_datetime
end

json.qualification_round_heats @race.qualification_round_heats do |heat|
  json.(heat, :id, :number, :track)
  json.final_round false
end

json.final_round_heats @race.final_round_heats do |heat|
  json.(heat, :id, :number, :track)
  json.final_round true
end

json.cups @race.cups do |cup|
  json.(cup, :id, :name)
end

json.clubs @race.clubs do |club|
  json.(club, :id, :name)
end
