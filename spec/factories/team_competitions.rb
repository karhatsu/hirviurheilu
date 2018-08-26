FactoryBot.define do
  factory :team_competition do
    race
    name { 'Ladies' }
    team_competitor_count { 8 }
  end
end