json.(team_competition, :id, :name, :team_competitor_count, :multiple_teams, :national_record, :show_partial_teams, :use_team_name, :extra_shots)
json.extra_shots team_competition.extra_shots&.each do |club_extra_shots|
  json.club_id club_extra_shots["club_id"]
  if club_extra_shots["score1"]
    json.score1 club_extra_shots["score1"]
  end
  if club_extra_shots["score2"]
    json.score2 club_extra_shots["score2"]
  end
  if club_extra_shots["shots1"]
    json.shots1 club_extra_shots["shots1"].join(",")
  end
  if club_extra_shots["shots2"]
    json.shots2 club_extra_shots["shots2"].join(",")
  end
end || []
json.series_ids team_competition.series.map(&:id)
json.age_group_ids team_competition.age_groups.map(&:id)
json.series team_competition.series.each do |s|
  json.(s, :id, :name)
end
json.age_groups team_competition.age_groups.each do |ag|
  json.(ag, :id, :name)
end
