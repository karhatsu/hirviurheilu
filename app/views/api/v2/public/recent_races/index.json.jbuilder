json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.races @races do |race|
  json.partial! 'api/v2/public/races/race', race: race
end
