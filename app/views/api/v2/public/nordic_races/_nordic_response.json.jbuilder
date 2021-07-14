json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.sub_sport @sub_sport
json.competitors @race.nordic_sub_results(@sub_sport) do |competitor|
  json.(competitor, :id, :position, :first_name, :last_name, :number, :no_result_reason)
  shots = competitor.send("nordic_#{@sub_sport}_shots")
  json.has_shots !shots.nil?
  json.nordic_shots shots
  json.nordic_score competitor.send("nordic_#{@sub_sport}_score")
  json.nordic_extra_shots competitor.send("nordic_#{@sub_sport}_extra_shots")
  json.club competitor.club, :name
  json.series competitor.series, :name
end
