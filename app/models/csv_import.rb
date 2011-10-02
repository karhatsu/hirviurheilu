# encoding: UTF-8
require 'csv'

class CsvImport
  FIRST_NAME_COLUMN = 0
  LAST_NAME_COLUMN = 1
  CLUB_COLUMN = 2
  SERIES_COLUMN = 3
  COLUMNS_COUNT = 4
  
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
        comp.save!
      end
      return true
    end
    false
  end
  
  def errors
    @errors
  end
  
  private
  def validate_data
    @data.each do |row|
      if row.length != COLUMNS_COUNT
        @errors << 'Tiedoston rakenne virheellinen'
        return
      end
      competitor = new_competitor(row)
      if competitor.valid?
        @competitors << competitor
      else
        @errors += competitor.errors.full_messages
      end
    end
  end
  
  def new_competitor(row)
    competitor = Competitor.new(:first_name => row[FIRST_NAME_COLUMN],
      :last_name => row[LAST_NAME_COLUMN])
    competitor.club = find_or_create_club(row[CLUB_COLUMN])
    set_series_or_age_group(competitor, row[SERIES_COLUMN])
    competitor
  end
  
  def set_series_or_age_group(competitor, series_name)
    age_group = @race.age_groups.find_by_name(series_name)
    if age_group
      competitor.age_group = age_group
      competitor.series = age_group.series
    else
      series = @race.series.find_by_name(series_name)
      unless series
        @errors << "Tuntematon sarja/ikäryhmä: '#{series_name}'"
      end
      competitor.series = series
    end
  end
  
  def find_or_create_club(club_name)
    club = Club.where(:race_id => @race, :name => club_name).first
    return club if club
    club = Club.new(:race => @race, :name => club_name)
    if club.valid?
      club.save
      return club
    else
      @errors += club.errors.full_messages
      return nil
    end
  end
end