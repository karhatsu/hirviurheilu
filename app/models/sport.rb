class Sport
  SKI = "SKI"
  RUN = "RUN"
  AIR = "AIR"

  def self.by_key(key)
    if key == RUN
      OpenStruct.new({
          name: 'Hirvenjuoksu',
          start_list?: true,
          batch_list?: false,
      })
    elsif key == SKI
      OpenStruct.new({
          name: 'Hirvenhiihto',
          start_list?: true,
          batch_list?: false,
      })
    elsif key == AIR
      OpenStruct.new({
          name: 'Ilma-aseet',
          start_list?: false,
          batch_list?: true,
      })
    else
      raise "Unknown sport key: #{key}"
    end
  end

  def self.default_sport_key
    month = Time.new.month
    return RUN if month >= 5 and month <= 10
    SKI
  end
end
