FactoryBot.define do
  factory :batch do
    type { 'QualificationRoundBatch' }
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end

  factory :qualification_round_batch do
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end

  factory :final_round_batch do
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end
end
