json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.officials @race_rights.each do |race_right|
  json.partial! 'race_right', race_right: race_right
end
