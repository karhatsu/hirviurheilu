class Sport
  SKI = "SKI"
  RUN = "RUN"
  ILMAHIRVI = "ILMAHIRVI"
  ILMALUODIKKO = "ILMALUODIKKO"

  BASE_CONFIGS = {
      SKI_AND_RUN: {
          start_list?: true,
          batch_list?: false,
          qualification_round: false,
          final_round: false,
          only_shooting?: false,
          relays?: true,
      },
      AIR_GUNS: {
          start_list?: false,
          batch_list?: true,
          only_shooting?: true,
          relays?: false,
      },
  }

  CONFIGS = {
      RUN: OpenStruct.new(BASE_CONFIGS[:SKI_AND_RUN].merge({ name: 'Hirvenjuoksu' })),
      SKI: OpenStruct.new(BASE_CONFIGS[:SKI_AND_RUN].merge({ name: 'Hirvenhiihto' })),
      ILMAHIRVI: OpenStruct.new(BASE_CONFIGS[:AIR_GUNS].merge({ name: 'Ilmahirvi', qualification_round: [10], final_round: [10] })),
      ILMALUODIKKO: OpenStruct.new(BASE_CONFIGS[:AIR_GUNS].merge({ name: 'Ilmaluodikko', qualification_round: [5, 5], final_round: [5, 5] })),
  }

  def self.by_key(key)
    CONFIGS[key.to_sym] or raise "Unknown sport key: #{key}"
  end

  def self.default_sport_key
    month = Time.new.month
    return RUN if month >= 5 and month <= 10
    SKI
  end
end
