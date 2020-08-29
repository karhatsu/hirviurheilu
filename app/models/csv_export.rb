require 'csv'

class CsvExport
  def initialize(race, all_data = false)
    @race = race
    @shooting_race = race.sport.shooting?
    @all_data = all_data
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
    @race.competitors.includes(:series, :club, :qualification_round_batch).except(:order).order(:start_time).each do |competitor|
      csv << row(competitor)
    end
  end

  def row(competitor)
    columns = [competitor.first_name, competitor.last_name, competitor.club.name, series(competitor)]
    if @all_data
      columns << competitor.number
      columns << competitor.qualification_round_batch&.number
      columns << competitor.qualification_round_track_place
    elsif !@shooting_race
      columns << competitor.number
      columns << start_time(competitor)
    end
    columns
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
