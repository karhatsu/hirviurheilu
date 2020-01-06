class Sport
  SKI = "SKI"
  RUN = "RUN"
  AIR = "AIR"

  def self.by_key(key)
    if key == RUN
      OpenStruct.new({
          name: 'Hirvenjuoksu'
      })
    elsif key == SKI
      OpenStruct.new({
          name: 'Hirvenhiihto'
      })
    elsif key == AIR
      OpenStruct.new({
          name: 'Ilma-aseet'
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
