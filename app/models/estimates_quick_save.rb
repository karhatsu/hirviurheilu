class EstimatesQuickSave
  attr_reader :competitor, :error

  def initialize(race_id, string)
    @race_id = race_id
    @string = string
    @competitor = nil
    @error = nil
  end

  def save
    unless @string.match(/^\d+:\d+:\d+$/)
      @error = 'Syöte vääränmuotoinen'
      return false
    end
    numbers = @string.split(':')
    race = Race.find(@race_id)
    @competitor = race.competitors.where(:number => numbers[0]).first
    if @competitor
      @competitor.estimate1 = numbers[1]
      @competitor.estimate2 = numbers[2]
      @competitor.save!
      return true
    else
      @error = "Numerolla #{numbers[0]} ei löytynyt kilpailijaa."
      return false
    end
  end
end
