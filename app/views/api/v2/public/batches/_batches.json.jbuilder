json.batches batches.each do |batch|
  json.(batch, :number, :track)
  json.date @race.start_date.advance(days: batch.day - 1).strftime('%d.%m')
  json.date2 @race.start_date.advance(days: batch.day2 - 1).strftime('%d.%m')
  json.date3 @race.start_date.advance(days: batch.day3 - 1).strftime('%d.%m')
  json.date4 @race.start_date.advance(days: batch.day4 - 1).strftime('%d.%m')
  json.time batch.time.strftime('%H:%M')
  json.time2 batch.time2.strftime('%H:%M') if batch.time2
  json.time3 batch.time3.strftime('%H:%M') if batch.time3
  json.time4 batch.time4.strftime('%H:%M') if batch.time4
  json.competitors batch.competitors do |competitor|
    json.(competitor, :id, :series_id, :number, :first_name, :last_name, :qualification_round_track_place, :final_round_track_place)
    json.club competitor.club, :name
    json.series competitor.series, :name
  end
end
