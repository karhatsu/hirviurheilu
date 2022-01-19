json.(race, :id, :name, :start_date, :end_date, :location, :cancelled, :sport_key)
json.district do
  json.(race.district, :name, :short_name)
end
json.level do
  json.id race.level
  json.name_fi t("levels.#{race.level}", locale: :fi)
  json.name_sv t("levels.#{race.level}", locale: :sv)
end
json.sport do
  json.name_fi t("sport_name.#{race.sport_key}", locale: :fi)
  json.name_sv t("sport_name.#{race.sport_key}", locale: :sv)
end
json.url race_url(race)
