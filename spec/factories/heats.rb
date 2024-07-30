FactoryBot.define do
  factory :heat do
    type { 'QualificationRoundHeat' }
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end

  factory :qualification_round_heat do
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end

  factory :final_round_heat do
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end
end
