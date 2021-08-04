json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.today @today do |race|
  json.partial! 'api/v2/public/races/race', race: race
end
json.yesterday @yesterday do |race|
  json.partial! 'api/v2/public/races/race', race: race
end
json.future @future do |key, races|
  json.key key
  json.races races do |race|
    json.partial! 'api/v2/public/races/race', race: race
  end
end
json.past @past do |race|
  json.partial! 'api/v2/public/races/race', race: race
end
json.announcements Announcement.active.front_page do |announcement|
  json.(announcement, :id, :title, :published)
end
