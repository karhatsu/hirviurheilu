require 'csv'

class CsvImport
  FIRST_NAME_COLUMN = 0
  LAST_NAME_COLUMN = 1
  CLUB_COLUMN = 2
  SERIES_COLUMN = 3
  
  def initialize(race, file_path)
    @race = race
    @data = CSV.read(file_path)
    @competitors = []
    @errors = []
    validate_data
  end
  
  def save
    if errors.empty?
      @competitors.each do |comp|
        comp.club = Club.where(:race_id => @race, :name => comp.club_name).first
        comp.club = Club.create!(:race => @race, :name => comp.club_name) unless comp.club
        comp.save!
      end
      true
    else
      false
    end
  end
  
  def errors
    @errors
  end
  
  private
  def validate_data
    @data.each do |row|
      if row.length != 4
        @errors << 'Tiedoston rakenne virheellinen'
        return
      end
      series_name = row[SERIES_COLUMN]
      series = @race.series.find_by_name(series_name)
      unless series
        @errors << "Tuntematon sarja: '#{series_name}'"
        return
      end
      @competitors << Competitor.new(:series => series,
        :first_name => row[FIRST_NAME_COLUMN], :last_name => row[LAST_NAME_COLUMN],
        :club_name => row[CLUB_COLUMN]) 
    end
  end
end