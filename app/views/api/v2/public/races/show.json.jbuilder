json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@race, :id, :name, :location, :start_date, :end_date, :address, :home_page, :organizer, :organizer_phone, :sport_name, :club_level, :finished, :cancelled, :public_message, :sport_key, :hide_qualification_round_batches, :hide_final_round_batches, :days_count, :nordic_sub_results_for_series, :show_european_shotgun_results)
json.start_date_time @race.start_datetime
json.start_time @race.short_start_time
json.all_competitions_finished @race.all_competitions_finished?
json.show_correct_distances @race.show_correct_distances?
json.unofficials_configurable @race.year < 2018
json.user_ids @race.users.map(&:id)
if @official
  json.pending_official_email @race.pending_official_email
end

json.sport do
  json.batch_list @race.sport.batch_list?
  json.european @race.sport.european?
  json.nordic @race.sport.nordic?
  json.one_batch_list @race.sport.one_batch_list?
  json.shooting @race.sport.shooting?
  json.shooting_simple @race.sport.shooting? && !@race.sport.european? && !@race.sport.nordic?
  json.start_list @race.sport.start_list?
end

json.series @race.series do |series|
  json.(series, :id, :name, :competitors_count, :finished)
  json.started series.started?
  json.start_time series.start_datetime

  unless params[:no_competitors]
    json.competitors series.competitors do |competitor|
      json.(competitor, :first_name, :last_name, :number)
      json.start_date_time competitor.start_datetime

      json.club competitor.club, :name
    end
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

json.qualification_round_batches @race.qualification_round_batches do |batch|
  json.(batch, :id)
end

json.final_round_batches @race.final_round_batches do |batch|
  json.(batch, :id)
end

json.cups @race.cups do |cup|
  json.(cup, :id, :name)
end

json.clubs @race.clubs do |club|
  json.(club, :id, :name)
end
