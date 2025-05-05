json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'competitor', competitor: @competitor
