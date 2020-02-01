class QuickSave::Time < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+(\,|#)[0-2][0-9][0-5][0-9][0-5][0-9]$/)
  end

  private
  def valid_string?
    return false unless super
    if hours.to_i > 23 or minutes.to_i > 59 or seconds.to_i > 59
      @error = 'Syöte vääränmuotoinen'
      return false
    end
    true
  end

  def set_competitor_attrs
    @competitor.arrival_time = "#{hours}:#{minutes}:#{seconds}"
  end

  def competitor_has_attrs?
    !@competitor.arrival_time.nil?
  end

  def hours
    result_string[0,2]
  end

  def minutes
    result_string[2,2]
  end

  def seconds
    result_string[4,2]
  end
end
