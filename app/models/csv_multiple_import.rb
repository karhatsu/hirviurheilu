class CsvMultipleImport
  include CsvReader

  attr_accessor :errors

  def initialize(user, file_path)
    @user = user
    @errors = []
    data = get_data file_path
    return unless @errors.empty?
    races = validate_races data
    return unless @errors.empty?
    Race.transaction do
      insert_races races
    rescue => e
      puts e.backtrace
      @errors = [{ row: 0, errors: ["Odottamaton virhe kilpailuiden tallentamisessa: #{e.message}"] }]
      raise ActiveRecord::Rollback
    end
  end

  private

  def get_data(file_path)
    begin
      read_csv_file file_path
    rescue UnknownCSVEncodingException => e
      @errors = [{ row: 0, errors: ['Tiedoston merkistökoodausta ei pystytty tunnistamaan, ole hyvä ja lähetä asiasta palautetta'] }]
    rescue
      @errors = [{ row: 0, errors: ['Tiedosto on virheellinen'] }]
    end
  end

  def validate_races(data)
    races = []
    if data[0].length != 9
      @errors << { row: 0, errors: ['Virheellinen määrä sarakkeita'] }
      return
    end
    data.each_with_index do |row, index|
      next if index == 0 # header row
      sport_key = Sport.key_by_name(row[0])
      race = Race.new sport_key: sport_key,
                      name: row[1],
                      start_date: row[2],
                      location: row[3],
                      address: row[4],
                      organizer: row[5],
                      level: row[6],
                      district: District.find_by_short_name(row[7]),
                      start_interval_seconds: 60
      race.email = row[8]
      if race.valid? && sport_key
        races << race
      else
        errors = race.errors.full_messages
        errors.unshift('Laji on virheellinen') unless sport_key
        @errors << { row: index + 1, errors: errors }
      end
    end
    races
  end

  def insert_races(races)
    races.each do |race|
      race.save!
      race.users << @user
      race.users << User.find_by_email(race.email) unless race.email == @user.email
    end
  end
end
