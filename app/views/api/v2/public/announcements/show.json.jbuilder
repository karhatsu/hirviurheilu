json.key_format! camelize: :lower if request.headers['X-Camel-Case']
json.(@announcement, :id, :title, :published, :content)
