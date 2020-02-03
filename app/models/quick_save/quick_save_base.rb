class QuickSave::QuickSaveBase
  attr_reader :competitor, :error

  def initialize(race_id, string, *valid_patterns)
    @race_id = race_id
    @string = string
    @valid_patterns = valid_patterns
    @competitor = nil
    @error = nil
  end

  def save
    if valid_string?
      if find_competitor
        if competitor_has_attrs? && ! overwrite?
          set_stored_already_error
          return false
        else
          set_competitor_attrs
          if save_competitor
            return true
          else
            set_save_error
          end
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
  def main_separator
    @string.index('#') ? '#' : ','
  end

  def valid_string?
    return false unless @string
    @valid_patterns.each do |pattern|
      return true if @string.match(pattern)
    end
    false
  end

  def overwrite?
    @string[0,2] == '++'
  end

  def number
    s = @string.split(main_separator)[0]
    s = s[2..-1] if (s[0,2]) == '++'
    s
  end

  def result_string
    @string.split(main_separator)[1]
  end

  def find_competitor
    race = Race.find(@race_id)
    return nil unless race
    @competitor = race.competitors.where(:number => number).first
  end

  def save_competitor
    @competitor.save
  end

  def set_competitor_attrs
    raise "Must be implemented in the sub class"
  end

  def competitor_has_attrs?
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

  def set_stored_already_error
    @error = "Kilpailijalle (#{@competitor.first_name} #{@competitor.last_name}, #{@competitor.series.name}) on jo talletettu tieto. Voit ylikirjoittaa vanhan tuloksen syöttämällä ++numero,tulos."
  end
end
