json.key_format! camelize: :lower if request.headers['X-Camel-Case']
if params[:grouped]
  json.future @future do |race|
    json.partial! 'race', race: race
  end
  json.today @today do |race|
    json.partial! 'race', race: race
  end
  json.past @past do |race|
    json.partial! 'race', race: race
  end
else
  json.races @races do |race|
    json.partial! 'race', race: race
  end
end
