json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'official/limited/competitors/competitor', competitor: @competitor
