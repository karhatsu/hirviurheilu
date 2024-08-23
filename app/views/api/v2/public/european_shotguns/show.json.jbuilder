json.cache! [@series || rand, request.headers['X-Camel-Case']] do
  json.key_format! camelize: :lower if request.headers['X-Camel-Case']
  json.(@series, :id, :name, :competitors_count) if @series
  results = @series ? @series.european_shotgun_results : @race.european_shotgun_results
  json.competitors results do |competitor|
    json.(competitor, :id, :position, :first_name, :last_name, :number, :no_result_reason, :european_trap_score, :european_trap_shots, :european_compak_score, :european_compak_shots, :european_shotgun_score, :european_trap_score2, :european_trap_shots2, :european_compak_score2, :european_compak_shots2, :european_shotgun_extra_score)
    json.has_shots !!competitor.has_european_shotgun_shots?
    json.club competitor.club, :name
  end
end
