json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.clubs @race.clubs.each do |club|
  json.(club, :id, :name, :long_name)
  json.competitors_count club.competitors.size
  json.can_be_removed club.can_be_removed?
end
