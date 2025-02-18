class CompetitorNumbersSync
  def initialize(event, first_number)
    @event = event
    @current_number = first_number
    @changed_competitors = []
  end

  def synchronize
    collect_competitors
    save_competitors
  end

  private

  def collect_competitors
    numbers = {}
    # order by id ensures that the races are always handled in the same order
    @event.races.order(:id).each do |race|
      race.competitors.includes(:club).except(:order).order(:number).each do |competitor|
        key = "#{competitor.club.name}_#{competitor.last_name}_#{competitor.first_name}"
        if numbers[key]
          number = numbers[key]
        else
          number = @current_number
          numbers[key] = number
          @current_number = @current_number + 1
        end
        if number != competitor.number
          competitor.number = number
          @changed_competitors << competitor
        end
      end
    end
  end

  def save_competitors
    Competitor.transaction do
      @changed_competitors.each do |competitor|
        Competitor.where(id: competitor.id).update_all(number: competitor.number)
        competitor.touch
      end
    end
  end
end
