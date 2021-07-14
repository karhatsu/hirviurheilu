module CompetitorPosition
  extend ActiveSupport::Concern

  private

  def add_position_for_competitors(competitors, &block)
    prev_competitor_results = nil
    prev_competitor_position = 0
    competitors.each_with_index do |comp, i|
      competitor_results = block.call comp
      comp.position = competitor_results == prev_competitor_results ? prev_competitor_position : i + 1
      prev_competitor_results = competitor_results
      prev_competitor_position = comp.position
    end
    competitors
  end
end
