class EuropeanSubSport
  CONFIGS = {
      trap: OpenStruct.new(
          {
              best_shot_value: 1,
              shot_count: 25,
          }
      ),
      compak: OpenStruct.new(
          {
              best_shot_value: 1,
              shot_count: 25,
          }
      ),
      rifle1: OpenStruct.new(
          {
              best_shot_value: 10,
              shot_count: 5,
          }
      ),
      rifle2: OpenStruct.new(
          {
              best_shot_value: 10,
              shot_count: 5,
          }
      ),
      rifle3: OpenStruct.new(
          {
              best_shot_value: 10,
              shot_count: 5,
          }
      ),
      rifle4: OpenStruct.new(
          {
              best_shot_value: 10,
              shot_count: 5,
          }
      ),
  }

  def self.by_key(key)
    CONFIGS[key.to_sym] or raise("Unknown sport key: #{key}")
  end
end
