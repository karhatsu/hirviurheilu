class EstimatesQuickSave
  attr_reader :competitor, :error

  def initialize(race_id, string)
    @race_id = race_id
    @string = string
    @competitor = nil
    @error = nil
  end

  def save
    if valid_string?
      if find_competitor
        save_result
        return true
      else
        set_unknown_competitor_error
      end
    else
      set_invalid_format_error
    end
    return false
  end

  private
  def valid_string?
    @string.match(/^\d+:\d+:\d+$/)
  end

  def number
    @string.split(':')[0]
  end

  def find_competitor
    race = Race.find(@race_id)
    return nil unless race
    @competitor = race.competitors.where(:number => number).first
  end

  def save_result
    numbers = @string.split(':')
    @competitor.estimate1 = numbers[1]
    @competitor.estimate2 = numbers[2]
    @competitor.save!
  end

  def set_invalid_format_error
    @error = 'Syöte vääränmuotoinen'
  end

  def set_unknown_competitor_error
    @error = "Numerolla #{number} ei löytynyt kilpailijaa."
  end
end
