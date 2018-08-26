FactoryBot.define do
  factory :relay_competitor do
    relay_team
    first_name { 'Mikko' }
    last_name { 'Miettinen' }
    leg { 2 }
  end
end