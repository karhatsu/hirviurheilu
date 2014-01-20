# encoding: UTF-8
class CsvImport
  FIRST_NAME_COLUMN = 0
  LAST_NAME_COLUMN = 1
  CLUB_COLUMN = 2
  SERIES_COLUMN = 3
  START_NUMBER_COLUMN = 4
  START_TIME_COLUMN = 5

  COLUMNS_COUNT_START_ORDER_SERIES = 4
  COLUMNS_COUNT_START_ORDER_MIXED = 6

  def initialize(race, file_path)
    @race = race
    @competitors = []
    @errors = []
    @data = read_file(file_path)
    validate_data
    strip_duplicate_errors
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
  def read_file(file_path)
    ["r:utf-8", "r:windows-1252:utf-8"].each do |read_encoding|
      data = []
      begin
        File.open(file_path, read_encoding).each_line do |line|
          data += [line.gsub(/\r\n?/, '').gsub(/\n?/, '').split(",")]
        end
        return data
      rescue ArgumentError
      end
    end
    raise UnknownCSVEncodingException.new
  end
  
  def validate_data
    @data.each do |row|
      return unless row_structure_correct(row)
      unless row_missing_data?(row)
        competitor = new_competitor(row)
        if competitor.valid?
          @competitors << competitor
        else
          @errors += competitor.errors.full_messages
        end
      end
    end
  end
  
  def row_structure_correct(row)
    if row.length != expected_column_count
      @errors << "Virheellinen rivi tiedostossa: #{original_format(row)}"
      return false
    end
    true
  end

  def expected_column_count
    return COLUMNS_COUNT_START_ORDER_MIXED if @race.start_order == Race::START_ORDER_MIXED
    COLUMNS_COUNT_START_ORDER_SERIES
  end
  
  def row_missing_data?(row)
    row.each do |col|
      if col.nil? or col.strip == ''
        @errors << "Riviltä puuttuu tietoja: #{original_format(row)}"
        return true
      end
    end
    false
  end
  
  def original_format(columns)
    columns.join(',')
  end
  
  def new_competitor(row)
    competitor = Competitor.new(:first_name => row[FIRST_NAME_COLUMN],
      :last_name => row[LAST_NAME_COLUMN])
    competitor.club = find_or_create_club(row[CLUB_COLUMN])
    set_series_or_age_group(competitor, row[SERIES_COLUMN])
    if @race.start_order == Race::START_ORDER_MIXED
      competitor.number = row[START_NUMBER_COLUMN]
      competitor.start_time = row[START_TIME_COLUMN]
    end
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
  
  def strip_duplicate_errors
    unique_errors = []
    @errors.each do |error|
      unique_errors << error unless unique_errors.include?(error)
    end
    @errors = unique_errors
  end
end