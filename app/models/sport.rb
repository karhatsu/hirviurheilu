class Sport
  SKI = "SKI"
  RUN = "RUN"
  ILMAHIRVI = "ILMAHIRVI"
  ILMALUODIKKO = "ILMALUODIKKO"
  METSASTYSHIRVI = "METSASTYSHIRVI"
  METSASTYSLUODIKKO = "METSASTYSLUODIKKO"
  METSASTYSHAULIKKO = "METSASTYSHAULIKKO"
  METSASTYSTRAP = "METSASTYSTRAP"
  PIENOISHIRVI = "PIENOISHIRVI"
  PIENOISLUODIKKO = "PIENOISLUODIKKO"
  NORDIC = "NORDIC"
  EUROPEAN = "EUROPEAN"

  ALL_KEYS = [Sport::RUN, Sport::SKI, Sport::ILMAHIRVI, Sport::ILMALUODIKKO, Sport::METSASTYSHIRVI,
              Sport::METSASTYSLUODIKKO, Sport::METSASTYSHAULIKKO, Sport::METSASTYSTRAP, Sport::PIENOISHIRVI,
              Sport::PIENOISLUODIKKO, Sport::NORDIC, Sport::EUROPEAN]

  BASE_CONFIGS = {
      SKI_AND_RUN: {
          start_list?: true,
          batch_list?: false,
          one_batch_list?: false,
          qualification_round: false,
          final_round: false,
          shooting?: false,
          relays?: true,
          best_shot_value: 10,
          shot_count: 10,
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
          nordic?: false,
          european?: false,
      },
      SHOOTING: {
          start_list?: false,
          batch_list?: true,
          one_batch_list?: false,
          shooting?: true,
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
          best_shot_value: 10,
          shot_count: 20,
          inner_ten?: false,
          qualification_round_max_score: 100,
          final_round_max_score: 100,
          final_round_competitors_count: 10,
          nordic?: false,
          european?: false,
      }
  }

  SHOTGUN_CONFIG = BASE_CONFIGS[:SHOOTING].merge(
      {
          qualification_round: [25],
          qualification_round_shot_count: 25,
          qualification_round_max_score: 25,
          final_round: [25],
          final_round_shot_count: 25,
          final_round_max_score: 25,
          best_shot_value: 1,
          shot_count: 50,
          shots_per_extra_round: 1,
      }
  )

  CONFIGS = {
      RUN: OpenStruct.new(BASE_CONFIGS[:SKI_AND_RUN].merge(
          { name: 'Hirvenjuoksu' }
      )),
      SKI: OpenStruct.new(BASE_CONFIGS[:SKI_AND_RUN].merge(
          { name: 'Hirvenhiihto' }
      )),
      ILMAHIRVI: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Ilmahirvi',
              qualification_round: [10],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              shots_per_extra_round: 2,
          }
      )),
      ILMALUODIKKO: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Ilmaluodikko',
              qualification_round: [5, 5],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              best_shot_value: 11,
              shot_count: 20,
              inner_ten?: true,
              shots_per_extra_round: 1,
              default_series: [['S13', ['T13', 'P13']]] + BASE_CONFIGS[:SHOOTING][:default_series],
          }
      )),
      METSASTYSHIRVI: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Metsästyshirvi',
              qualification_round: [4, 6],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              shots_per_extra_round: 2,
          }
      )),
      METSASTYSLUODIKKO: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Metsästysluodikko',
              qualification_round: [5, 5],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              shots_per_extra_round: 1,
          }
      )),
      METSASTYSHAULIKKO: OpenStruct.new(SHOTGUN_CONFIG.merge(
          {
              name: 'Metsästyshaulikko',
          }
      )),
      METSASTYSTRAP: OpenStruct.new(SHOTGUN_CONFIG.merge(
          {
              name: 'Metsästystrap',
          }
      )),
      PIENOISHIRVI: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
        {
          name: 'Pienoishirvi',
          qualification_round: [20],
          qualification_round_shot_count: 20,
          qualification_round_max_score: 200,
          final_round: [10],
          final_round_shot_count: 10,
          shot_count: 30,
          shots_per_extra_round: 2,
        }
      )),
      PIENOISLUODIKKO: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
        {
          name: 'Pienoisluodikko',
          qualification_round: [20],
          qualification_round_shot_count: 20,
          qualification_round_max_score: 200,
          final_round: [10],
          final_round_shot_count: 10,
          shot_count: 30,
          shots_per_extra_round: 2,
        }
      )),
      NORDIC: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Pohjoismainen metsästysammunta',
              nordic?: true,
              default_series: [['S20'], ['M'], ['N'], ['S60']],
              one_batch_list?: true,
          }
      )),
      EUROPEAN: OpenStruct.new(BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Eurooppalainen metsästysammunta',
              european?: true,
              default_series: [['S20'], ['M'], ['N'], ['S55']],
              one_batch_list?: true,
          }
      )),
  }

  def self.by_key(key)
    return nil unless key
    CONFIGS[key.to_sym] or raise("Unknown sport key: #{key}")
  end
end
