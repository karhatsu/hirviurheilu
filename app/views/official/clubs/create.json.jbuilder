json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.partial! 'club', club: @club
