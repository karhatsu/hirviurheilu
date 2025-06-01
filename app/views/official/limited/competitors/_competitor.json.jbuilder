json.(competitor, :id, :first_name, :last_name, :team_name)
json.club competitor.club, :id, :name
json.series competitor.series, :id, :name
if competitor.age_group
  json.age_group competitor.age_group, :id, :name
end
