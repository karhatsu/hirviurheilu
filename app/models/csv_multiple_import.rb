class CsvMultipleImport
  include CsvReader

  attr_reader :errors, :existing_users, :new_emails, :race_count

  def initialize(user, file_path)
    @user = user
    @errors = []
    @existing_users = {}
    @new_emails = {}
    data = get_data file_path
    return unless @errors.empty?
    races = validate_races data
    return unless @errors.empty?
    @race_count = races.length
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
    rescue UnknownCsvEncodingException => e
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
      email = row[8]
      user = User.find_by_email email
      race.user = user if user
      race.pending_official_email = email unless user
      if race.valid? && sport_key
        races << race
      else
        errors = race.errors.full_messages
        errors.unshift('Laji on virheellinen') unless sport_key
        errors << 'Toimitsijan sähköposti on pakollinen' if !race.user && race.pending_official_email.blank?
        @errors << { row: index + 1, errors: errors }
      end
    end
    races
  end

  def insert_races(races)
    races.each do |race|
      race.save!
      race.users << @user
      assign_official race
    end
  end

  def assign_official(race)
    if race.user && race.user.id != @user.id
      race.users << race.user
      @existing_users[race.user] ||= []
      @existing_users[race.user] << race
    elsif race.pending_official_email
      @new_emails[race.pending_official_email] ||= []
      @new_emails[race.pending_official_email] << race
    end
  end
end
