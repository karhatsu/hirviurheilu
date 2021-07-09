json.cache! [@tc, request.headers['X-Camel-Case']] do
  json.partial! 'team_competition_response', rifle: false
end
