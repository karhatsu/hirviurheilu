# encoding: UTF-8
class TimeQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+\,[0-2][0-9][0-5][0-9][0-5][0-9]$/)
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
    @string.split(',')[1][0,2]
  end

  def minutes
    @string.split(',')[1][2,2]
  end

  def seconds
    @string.split(',')[1][4,2]
  end
end
