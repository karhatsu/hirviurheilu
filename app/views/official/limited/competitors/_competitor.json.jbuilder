json.(competitor, :id, :series_id, :age_group_id, :club_id, :first_name, :last_name, :team_name, :caliber)
json.club competitor.club, :name
json.series competitor.series, :name
if competitor.age_group
  json.age_group competitor.age_group, :name
end
