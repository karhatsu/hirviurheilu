module CompetitorPosition
  extend ActiveSupport::Concern

  private

  def add_position_for_competitors(competitors, equal_rank_after_medals = false, &block)
    prev_competitor_results = nil
    prev_competitor_position = 0
    medal_score = competitors.length >= 3 ? block.call(competitors[2])[0] : 0
    competitors.each_with_index do |comp, i|
      competitor_results = block.call comp
      if competitor_results == prev_competitor_results
        comp.position = prev_competitor_position
      # competitor_results[0] is the total score
      elsif equal_rank_after_medals && competitor_results[0] < medal_score && prev_competitor_results[0] == competitor_results[0]
        comp.position = prev_competitor_position
      else
        comp.position = i + 1
      end
      prev_competitor_results = competitor_results
      prev_competitor_position = comp.position
    end
    competitors
  end
end
