require 'csv'

class CsvExport
  def initialize(race)
    @race = race
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
  
  def create_csv(csv)
    @race.competitors.except(:order).order(:start_time).each do |competitor|
      csv << row(competitor)
    end
  end
  
  def row(competitor)
    [name(competitor), competitor.club.name, series(competitor), competitor.number,
      start_time(competitor), competitor.team_name]
  end
  
  def name(competitor)
    competitor.first_name + ' ' + competitor.last_name
  end
  
  def series(competitor)
    if competitor.age_group
      return "#{competitor.series.name}/#{competitor.age_group.name}"
    end
    competitor.series.name
  end
  
  def start_time(competitor)
    return nil unless competitor.start_time
    competitor.start_time.strftime('%H.%M.%S')
  end
end