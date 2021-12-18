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
          default_series: ProductionEnvironment.production? ? [
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
          ] : [
            ['S13', ['T13', 'P13', 'T11', 'P11', 'T9', 'P9', 'T7', 'P7']],
            ['S16', ['T16', 'P16']],
            ['S20', ['T20', 'P20']],
            ['Y', ['Y40']],
            ['M50'],
            ['M60', ['M65']],
            ['M70', ['M75']],
            ['M80', ['M85', 'M90']],
            ['N', ['N40']],
            ['N50', ['N55', 'N60']],
            ['N65', ['N70', 'N75', 'N80', 'N85', 'N90']],
          ],
      },
      SHOOTING: {
          start_list?: false,
          batch_list?: true,
          one_batch_list?: false,
          shooting?: true,
          relays?: false,
          default_series: ProductionEnvironment.production? ? [
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
          ] : [
            ['S16', ['T16', 'P16']],
            ['S20', ['T20', 'P20']],
            ['Y'],
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
          qualification_round_max_score: 100,
          final_round_max_score: 100,
          final_round_competitors_count: 10,
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
      RUN: BASE_CONFIGS[:SKI_AND_RUN].merge(
          { name: 'Hirvenjuoksu' }
      ),
      SKI: BASE_CONFIGS[:SKI_AND_RUN].merge(
          { name: 'Hirvenhiihto' }
      ),
      ILMAHIRVI: BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Ilmahirvi',
              qualification_round: [10],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              shots_per_extra_round: 2,
          }
      ),
      ILMALUODIKKO: BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Ilmaluodikko',
              qualification_round: [5, 5],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              best_shot_value: 11,
              shot_count: 20,
              shots_per_extra_round: 1,
              default_series: [['S13', ['T13', 'P13']]] + BASE_CONFIGS[:SHOOTING][:default_series],
          }
      ),
      METSASTYSHIRVI: BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Metsästyshirvi',
              qualification_round: [4, 6],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              shots_per_extra_round: 2,
          }
      ),
      METSASTYSLUODIKKO: BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Metsästysluodikko',
              qualification_round: [5, 5],
              qualification_round_shot_count: 10,
              final_round: [10],
              final_round_shot_count: 10,
              shots_per_extra_round: 1,
              default_series: (ProductionEnvironment.production? ? [] : [['S13', ['T13', 'P13']]]) + BASE_CONFIGS[:SHOOTING][:default_series],
          }
      ),
      METSASTYSHAULIKKO: SHOTGUN_CONFIG.merge(
          {
              name: 'Metsästyshaulikko',
          }
      ),
      METSASTYSTRAP: SHOTGUN_CONFIG.merge(
          {
              name: 'Metsästystrap',
          }
      ),
      PIENOISHIRVI: BASE_CONFIGS[:SHOOTING].merge(
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
      ),
      PIENOISLUODIKKO: BASE_CONFIGS[:SHOOTING].merge(
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
      ),
      NORDIC: BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Pohjoismainen metsästysammunta',
              default_series: ProductionEnvironment.production? ? [['S20'], ['M'], ['N'], ['S60']] : [['S20'], ['M'], ['N'], ['S60'], ['S70']],
              one_batch_list?: true,
          }
      ),
      EUROPEAN: BASE_CONFIGS[:SHOOTING].merge(
          {
              name: 'Eurooppalainen metsästysammunta',
              default_series: [['S20'], ['M'], ['N'], ['S55']],
              one_batch_list?: true,
          }
      ),
  }

  attr_reader :key

  def initialize(key)
    @config = CONFIGS[key.to_sym] or raise("Unknown sport key: #{key}")
    @key = key
  end

  def ==(other)
    other.key == @key
  end

  def to_s
    "Sport <#{@key}>"
  end

  def inspect
    to_s
  end

  def name
    @config[:name]
  end

  def shooting?
    @config[:shooting?]
  end

  def relays?
    @config[:relays?]
  end

  def start_list?
    @config[:start_list?]
  end

  def batch_list?
    @config[:batch_list?]
  end

  def one_batch_list?
    @config[:one_batch_list?]
  end

  def best_shot_value
    @config[:best_shot_value]
  end

  def shot_count
    @config[:shot_count]
  end

  def inner_ten?
    @key == ILMALUODIKKO
  end

  def qualification_round
    @config[:qualification_round]
  end

  def qualification_round_shot_count
    @config[:qualification_round_shot_count]
  end

  def qualification_round_max_score
    @config[:qualification_round_max_score]
  end

  def final_round
    @config[:final_round]
  end

  def final_round_shot_count
    @config[:final_round_shot_count]
  end

  def final_round_max_score
    @config[:final_round_max_score]
  end

  def final_round_competitors_count
    @config[:final_round_competitors_count]
  end

  def shots_per_extra_round
    @config[:shots_per_extra_round]
  end

  def default_series
    @config[:default_series]
  end

  def nordic?
    @key == NORDIC
  end

  def european?
    @key == EUROPEAN
  end

  def self.by_key(key)
    Sport.new key
  end

  def self.key_by_name(name)
    CONFIGS.keys.find {|key| CONFIGS[key][:name] == name}&.to_s
  end
end
