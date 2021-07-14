json.cache! [@tc, request.headers['X-Camel-Case']] do
  json.partial! 'api/v2/public/team_competitions/team_competition_response', rifle: true
end
