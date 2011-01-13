class TimeQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+\.\d+\.\d+\.\d+$/)
  end

  private
  def set_competitor_attrs
    numbers = @string.split('.')
    @competitor.arrival_time = "#{numbers[1]}:#{numbers[2]}:#{numbers[3]}"
  end
end
