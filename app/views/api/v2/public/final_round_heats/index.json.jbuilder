json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'api/v2/public/heats/heats', heats: @race.final_round_heats.includes(competitors: [:club, :series])
