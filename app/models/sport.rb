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
          max_shot: 10,
          max_shots_count: 10,
          inner_ten?: false,
          default_series: [
              ['S13', ['T13', 'P13', 'T11', 'P11', 'T9', 'P9', 'T7', 'P7']],
              ['S15', ['T15', 'P15']],
              ['S17', ['T17', 'P17']],
              ['S20', ['T20', 'P20']],
              ['M', ['M40']],
              ['M50'],
              ['M60', ['M65']],
              ['M70', ['M75']],
              ['M80', ['M85', 'M90']],
              ['N', ['N40']],
              ['N50', ['N55', 'N60']],
              ['N65', ['N70', 'N75', 'N80', 'N85', 'N90']],
          ],
      },
      AIR_GUNS: {
          start_list?: false,
          batch_list?: true,
          only_shooting?: true,
          relays?: false,
          default_series: [
              ['S15', ['T15', 'P15']],
              ['S17', ['T17', 'P17']],
              ['S20', ['T20', 'P20']],
              ['M'],
              ['M50'],
              ['M60'],
              ['M70'],
              ['M80'],
              ['N'],
              ['N50'],
              ['N65'],
          ],
      },
  }

  CONFIGS = {
      RUN: OpenStruct.new(BASE_CONFIGS[:SKI_AND_RUN].merge(
          { name: 'Hirvenjuoksu' }
      )),
      SKI: OpenStruct.new(BASE_CONFIGS[:SKI_AND_RUN].merge(
          { name: 'Hirvenhiihto' }
      )),
      ILMAHIRVI: OpenStruct.new(BASE_CONFIGS[:AIR_GUNS].merge(
          {
              name: 'Ilmahirvi',
              qualification_round: [10],
              final_round: [10],
              max_shot: 10,
              max_shots_count: 20,
              inner_ten?: false,
              shots_per_extra_round: 2,
          }
      )),
      ILMALUODIKKO: OpenStruct.new(BASE_CONFIGS[:AIR_GUNS].merge(
          {
              name: 'Ilmaluodikko',
              qualification_round: [5, 5],
              final_round: [5, 5],
              max_shot: 11,
              max_shots_count: 20,
              inner_ten?: true,
              shots_per_extra_round: 1,
              default_series: [['S13', ['T13', 'P13']]] + BASE_CONFIGS[:AIR_GUNS][:default_series],
          }
      )),
  }

  def self.by_key(key)
    return nil unless key
    CONFIGS[key.to_sym] or raise("Unknown sport key: #{key}")
  end
end
