require 'test_helper'
require 'rails/performance_test_help'

class CompetitorsTest < ActionDispatch::PerformanceTest
  def setup
    race = Factory.create(:race)
    @series = Factory.create(:series, :race => race, :has_start_list => true)
    15.times do |i|
      Factory.create(:competitor, :series => @series, :number => i + 1,
        :start_time => '10:00:00', :arrival_time => "10:30:#{40-i}",
        :shots_total_input => 80 + i,
        :estimate1 => 100 + i, :estimate2 => 150 - i)
    end
    race.correct_estimates << Factory.build(:correct_estimate, :race => race,
      :min_number => 1, :distance1 => 105, :distance2 => 140)
    race.set_correct_estimates_for_competitors
    race.finish!
  end

  def test_competitors
    get "/series/#{@series.id}/competitors"
  end
end
