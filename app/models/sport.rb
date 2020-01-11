class Sport
  SKI = "SKI"
  RUN = "RUN"
  ILMAHIRVI = "ILMAHIRVI"
  ILMALUODIKKO = "ILMALUODIKKO"

  def self.by_key(key)
    if key == RUN
      OpenStruct.new({
          name: 'Hirvenjuoksu',
          start_list?: true,
          batch_list?: false,
          qualification_round: false,
      })
    elsif key == SKI
      OpenStruct.new({
          name: 'Hirvenhiihto',
          start_list?: true,
          batch_list?: false,
          qualification_round: false,
      })
    elsif key == ILMAHIRVI
      OpenStruct.new({
          name: 'Ilmahirvi',
          start_list?: false,
          batch_list?: true,
          qualification_round: [10],
      })
    elsif key == ILMALUODIKKO
      OpenStruct.new({
           name: 'Ilmaluodikko',
           start_list?: false,
           batch_list?: true,
           qualification_round: [5, 5],
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
