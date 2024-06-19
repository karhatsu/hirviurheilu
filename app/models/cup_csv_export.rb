require 'csv'

class CupCsvExport
  def initialize(cup_series, rifle=false)
    @cup_series = cup_series
    @cup = cup_series.cup
    @rifle = rifle
  end

  def generate_file(file_name)
    CSV.open(file_name, 'wb') do |csv|
      create_csv csv
    end
  end

  def data
    CSV.generate do |csv|
      create_csv csv
    end
  end

  private

  def create_csv(csv)
    csv << create_header_row
    cup_competitors = @rifle ? @cup_series.european_rifle_results : @cup_series.results
    cup_competitors.each {|cc| csv << create_competitor_row(cc)}
  end

  def create_header_row
    row = [I18n.t('activerecord.models.competitor.one')]
    @cup.races.each {|race| row << race.name }
    row << I18n.t(:total_points)
    row
  end

  def create_competitor_row(cup_competitor)
    row = ["#{cup_competitor.last_name} #{cup_competitor.first_name}"]
    @cup.races.each do |race|
      competitor = cup_competitor.competitor_for_race(race)
      if competitor&.no_result_reason
        row << competitor.no_result_reason
      elsif competitor
        row << (@rifle ? competitor.european_rifle_score : competitor.total_score)
      else
        row << ''
      end
    end
    row << (@rifle ? cup_competitor.european_rifle_score : cup_competitor.points!)
  end
end
