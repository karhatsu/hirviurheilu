class TimeQuickSave < QuickSave
  def initialize(race_id, string)
    super(race_id, string, /^\d+:\d+:\d+:\d+$/)
  end

  private
  def save_result
    numbers = @string.split(':')
    @competitor.arrival_time = "#{numbers[1]}:#{numbers[2]}:#{numbers[3]}"
    @competitor.save!
  end
end
