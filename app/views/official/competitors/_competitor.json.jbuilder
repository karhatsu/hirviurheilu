json.(competitor,
  :estimate1,
  :estimate2,
  :estimate3,
  :estimate4,
  :estimate_points,
  :first_name,
  :id,
  :last_name,
  :no_result_reason,
  :number,
  :series_id,
  :shooting_score,
  :shooting_score_input,
  :shots,
  :time_in_seconds,
)
json.arrival_time time_print(competitor.arrival_time, true)
json.start_time time_print(competitor.start_time, true)
