Factory.define :team_competition do |tc|
  tc.association :race
  tc.name 'Ladies'
  tc.team_competitor_count 8
end