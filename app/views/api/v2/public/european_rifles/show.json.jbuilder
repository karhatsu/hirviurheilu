json.cache! [@series || rand, request.headers['X-Camel-Case']] do
  json.key_format! camelize: :lower if request.headers['X-Camel-Case']
  json.(@series, :id, :name, :competitors_count, :rifle_national_record) if @series
  results = @series ? @series.european_rifle_results : @race.european_rifle_results
  json.competitors results do |competitor|
    json.(competitor, :id, :position, :first_name, :last_name, :number, :no_result_reason, :only_rifle, :european_rifle1_score, :european_rifle1_shots, :european_rifle2_score, :european_rifle2_shots, :european_rifle3_score, :european_rifle3_shots, :european_rifle4_score, :european_rifle4_shots, :european_rifle_score, :european_rifle1_score2, :european_rifle1_shots2, :european_rifle2_score2, :european_rifle2_shots2, :european_rifle3_score2, :european_rifle3_shots2, :european_rifle4_score2, :european_rifle4_shots2, :european_rifle_extra_shots, :european_rifle_extra_score)
    json.has_shots !!competitor.has_european_rifle_shots?
    json.club competitor.club, :name
  end
end
