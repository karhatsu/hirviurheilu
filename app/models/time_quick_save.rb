class TimeQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+\.[0-2][0-9][0-5][0-9][0-5][0-9]$/)
  end

  private
  def set_competitor_attrs
    numbers = @string.split('.')[1]
    @competitor.arrival_time = "#{numbers[0,2]}:#{numbers[2,2]}:#{numbers[4,2]}"
  end
end
