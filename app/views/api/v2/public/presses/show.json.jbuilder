json.cache! [@race, request.headers['X-Camel-Case']] do
  json.key_format! camelize: :lower if request.headers['X-Camel-Case']
  json.series @race.series.filter{|s| s.finished? || @race.finished?}.each do |series|
    if series.competitors_count > 0
      json.(series, :name)
      json.competitors series.results.each do |competitor|
        unless competitor.no_result_reason
          json.(competitor, :first_name, :last_name, :points, :club_id)
          json.national_record_passed competitor.position === 1 && competitor.national_record_passed?
          json.national_record_reached competitor.position === 1 && competitor.national_record_reached?
          json.club competitor.club, :name
        end
      end
    end
  end
end
