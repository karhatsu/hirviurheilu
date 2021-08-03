json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.announcements @announcements do |announcement|
  json.(announcement, :id, :title, :published, :content)
end
