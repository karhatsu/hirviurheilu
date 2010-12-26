class QuickSave
  attr_reader :competitor, :error

  def initialize(race_id, string, valid_pattern)
    @race_id = race_id
    @string = string
    @valid_pattern = valid_pattern
    @competitor = nil
    @error = nil
  end

  def save
    if valid_string?
      if find_competitor
        set_competitor_attrs
        if @competitor.save
          return true
        else
          set_save_error
        end
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
    @string.match(@valid_pattern)
  end

  def number
    @string.split(':')[0]
  end

  def find_competitor
    race = Race.find(@race_id)
    return nil unless race
    @competitor = race.competitors.where(:number => number).first
  end

  def set_competitor_attrs
    raise "Must be implemented in the sub class"
  end

  def set_invalid_format_error
    @error = 'Syöte vääränmuotoinen'
  end

  def set_unknown_competitor_error
    @error = "Numerolla #{number} ei löytynyt kilpailijaa."
  end

  def set_save_error
    @error = @competitor.errors.full_messages.join(". ")
  end
end
