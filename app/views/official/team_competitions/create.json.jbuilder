json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'team_competition', team_competition: @tc
