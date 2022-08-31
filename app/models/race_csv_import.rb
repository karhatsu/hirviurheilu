class RaceCsvImport
  include CsvReader

  FIRST_NAME_COLUMN = 0
  LAST_NAME_COLUMN = 1
  CLUB_COLUMN = 2
  SERIES_COLUMN = 3
  START_NUMBER_COLUMN = 4
  START_TIME_COLUMN = 5

  COLUMNS_COUNTS_START_ORDER_SERIES = [4]
  COLUMNS_COUNTS_START_ORDER_MIXED = [6]
  COLUMNS_COUNTS_SHOOTING_RACE = [4, 5]

  def initialize(race, file_path, limited_club=nil)
    @race = race
    @competitors = []
    @errors = []
    @data = read_csv_file file_path
    validate_data limited_club
    validate_duplicate_data
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

  def validate_data(limited_club)
    reserved_numbers = @race.competitors.map(&:number) if @race.sport.shooting?
    prev_number = 0
    @data.each_with_index do |row, index|
      return unless row_structure_correct?(row, index + 1)
      unless row_missing_data?(row, index + 1)
        competitor = new_competitor row, prev_number, reserved_numbers
        prev_number = competitor.number
        if limited_club && competitor.club.name != limited_club
          @errors << "Sinulla on oikeus lisätä kilpailijoita vain \"#{limited_club}\"-piiriin"
        elsif competitor.valid?
          @competitors << competitor
        else
          @errors += competitor.errors.full_messages
        end
      end
    end
  end

  def row_structure_correct?(row, number)
    unless expected_column_count.include? row.length
      @errors << "Rivi #{number} on virheellinen: #{original_format(row)}"
      return false
    end
    true
  end

  def expected_column_count
    return COLUMNS_COUNTS_SHOOTING_RACE if @race.sport.shooting?
    return COLUMNS_COUNTS_START_ORDER_MIXED if @race.start_order == Race::START_ORDER_MIXED
    COLUMNS_COUNTS_START_ORDER_SERIES
  end

  def row_missing_data?(row, number)
    row.each do |col|
      if col.nil? or col.strip == ''
        @errors << "Riviltä #{number} puuttuu tietoja: #{original_format(row)}"
        return true
      end
    end
    false
  end

  def original_format(columns)
    columns.join(',')
  end

  def new_competitor(row, prev_number, reserved_numbers)
    competitor = Competitor.new(first_name: row[FIRST_NAME_COLUMN], last_name: row[LAST_NAME_COLUMN])
    competitor.club = find_or_create_club(row[CLUB_COLUMN])
    set_series_or_age_group(competitor, row[SERIES_COLUMN])
    if @race.sport.shooting?
      number = row[START_NUMBER_COLUMN] || find_available_number(prev_number, reserved_numbers)
      competitor.number = number
    elsif @race.start_order == Race::START_ORDER_MIXED
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
      if !series
        @errors << "Tuntematon sarja/ikäryhmä: '#{series_name}'"
      elsif series.competitors_only_to_age_groups? && !series.age_groups.empty?
        @errors << "Kilpailijalle pitää määrittää ikäryhmä: #{competitor.first_name} #{competitor.last_name} (#{series_name})"
      end
      competitor.series = series
    end
  end

  def find_available_number(prev_number, reserved_numbers)
    number = prev_number + 1
    return number unless reserved_numbers.include? number
    find_available_number number, reserved_numbers
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

  def validate_duplicate_data
    if @data.length != @data.uniq.length
      first_duplicate = @data.group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)
      @errors << "Tiedosto sisältää saman kilpailijan kahteen kertaan: #{original_format first_duplicate}"
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
