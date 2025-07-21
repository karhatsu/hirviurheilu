json.heats heats.each do |heat|
  json.(heat, :number, :track, :description)
  json.date heat_date(@race.start_date.advance(days: heat.day - 1))
  json.date2 heat_date(@race.start_date.advance(days: heat.day2 - 1))
  json.date3 heat_date(@race.start_date.advance(days: heat.day3 - 1))
  json.date4 heat_date(@race.start_date.advance(days: heat.day4 - 1))
  json.time heat.time.strftime('%H:%M')
  json.time2 heat.time2.strftime('%H:%M') if heat.time2
  json.time3 heat.time3.strftime('%H:%M') if heat.time3
  json.time4 heat.time4.strftime('%H:%M') if heat.time4
  json.competitors heat.competitors do |competitor|
    json.(competitor, :id, :series_id, :number, :first_name, :last_name, :qualification_round_track_place, :final_round_track_place)
    json.club competitor.club, :name
    json.series competitor.series, :name
  end
end
