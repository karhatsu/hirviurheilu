json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'race_right', race_right: @race_right
