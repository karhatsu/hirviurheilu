json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.clubs @race.clubs.each do |club|
  json.partial! 'club', club: club
end
