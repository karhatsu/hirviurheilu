class QuickSave::Estimates < QuickSave::QuickSaveBase
  def initialize(race_id, string)
    super(race_id, string, /^(\+\+|)\d+(\,|#)\d+(\,|#)\d+$/, /^(\+\+|)\d+(\,|#)\d+(\,|#)\d+(\,|#)\d+(\,|#)\d+$/)
  end

  private
  def set_competitor_attrs
    numbers = @string.split(main_separator)
    @competitor.estimate1 = numbers[1]
    @competitor.estimate2 = numbers[2]
    @competitor.estimate3 = numbers[3] # can be nil
    @competitor.estimate4 = numbers[4] # can be nil
  end

  def save_competitor
    estimate_count = @string.split(main_separator).length - 1
    name = "#{@competitor.last_name} #{@competitor.first_name}, #{@competitor.series.name}"
    if @competitor.series.estimates == 4 && estimate_count != 4
      @error = "Tälle kilpailijalle (#{name}) täytyy syöttää neljä ennustetta"
      return false
    elsif @competitor.series.estimates == 2 && estimate_count != 2
      @error = "Tälle kilpailijalle (#{name}) täytyy syöttää kaksi ennustetta"
      return false
    end
    super
  end

  def set_save_error
    return unless @error.blank?
    super
  end

  def competitor_has_attrs?
    !@competitor.estimate1.nil? ||
    !@competitor.estimate2.nil? ||
    !@competitor.estimate3.nil? ||
    !@competitor.estimate4.nil?
  end
end
