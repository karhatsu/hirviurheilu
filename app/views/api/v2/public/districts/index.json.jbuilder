json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.districts @districts do |district|
  json.(district, :id, :name)
end
