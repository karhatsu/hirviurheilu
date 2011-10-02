# encoding: UTF-8
class RelayQuickSave
  attr_reader :competitor, :error

  def initialize(relay_id, string, *valid_patterns)
    @relay_id = relay_id
    @string = string
    @valid_patterns = valid_patterns
    @competitor = nil
    @error = nil
  end

  def save
    if valid_string?
      if find_team
        if find_competitor
          set_competitor_attrs
          if save_competitor
            return true
          else
            set_save_error
          end
        else
          set_unknown_competitor_error
        end
      else
        set_unknown_team_error
      end
    else
      set_invalid_format_error
    end
    return false
  end

  private
  def valid_string?
    @valid_patterns.each do |pattern|
      return true if @string.match(pattern)
    end
    false
  end

  def team_number
    @string.split(',')[0]
  end

  def leg_number
    @string.split(',')[1]
  end

  def find_team
    relay = Relay.find(@relay_id)
    return nil unless relay
    @team = relay.relay_teams.where(:number => team_number).first
  end

  def find_competitor
    @competitor = @team.relay_competitors.where(:leg => leg_number).first
  end

  def save_competitor
    @competitor.save
  end

  def set_competitor_attrs
    raise "Must be implemented in the sub class"
  end

  def set_invalid_format_error
    @error = 'Syöte vääränmuotoinen'
  end

  def set_unknown_team_error
    @error = "Numerolla #{team_number} ei löytynyt joukkuetta."
  end

  def set_unknown_competitor_error
    @error = "Osuuden numerolla #{leg_number} ei löytynyt kilpailijaa."
  end

  def set_save_error
    @error = @competitor.errors.full_messages.join(". ")
  end
end
