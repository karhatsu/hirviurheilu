json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.team_competitions @team_competitions.each do |tc|
  json.partial! 'team_competition', team_competition: tc
end
