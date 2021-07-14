json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'api/v2/public/batches/batches', batches: @race.qualification_round_batches.includes(competitors: [:club, :series])
