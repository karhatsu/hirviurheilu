json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'competitor', competitor: @competitor
if @race.sport.start_list? || @race.sport.heat_list?
  json.next_number @race.next_start_number
end
if @race.sport.start_list?
  next_start_time = @race.next_start_time
  json.next_start_time next_start_time == '00:00:00' ? next_start_time : time_print(next_start_time, true)
end
