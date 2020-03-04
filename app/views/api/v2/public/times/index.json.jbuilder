json.competitors @race.competitors do |competitor|
  json.(competitor, :number, :first_name, :last_name)
  json.start_time competitor.short_time(:start_time)
  json.shooting_start_time competitor.short_time(:shooting_start_time)
  json.shooting_finish_time competitor.short_time(:shooting_finish_time)
  json.arrival_time competitor.short_time(:arrival_time)

  json.series competitor.series, :name
end
