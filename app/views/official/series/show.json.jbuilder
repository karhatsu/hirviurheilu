json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@series, :id, :name, :estimates, :has_start_list, :race_id)
competitors = @series.competitors.includes(:series)
sorted_competitors = params[:qualification_round] ? Competitor.sort_by_qualification_round(@series.sport, competitors) : competitors
json.competitors sorted_competitors.each do |competitor|
  json.partial! 'official/competitors/competitor', competitor: competitor
end
