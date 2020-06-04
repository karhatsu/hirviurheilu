class NordicSubSport
  CONFIGS = {
      trap: OpenStruct.new(
          {
              best_shot_value: 1,
              shot_count: 25,
              shots_per_extra_round: 1,
          }
      ),
      shotgun: OpenStruct.new(
          {
              best_shot_value: 1,
              shot_count: 25,
              shots_per_extra_round: 1,
          }
      ),
      rifle_moving: OpenStruct.new(
          {
              best_shot_value: 10,
              shot_count: 10,
              shots_per_extra_round: 2,
          }
      ),
      rifle_standing: OpenStruct.new(
          {
              best_shot_value: 10,
              shot_count: 10,
              shots_per_extra_round: 2,
          }
      )
  }

  def self.by_key(key)
    CONFIGS[key.to_sym] or raise("Unknown sport key: #{key}")
  end
end
