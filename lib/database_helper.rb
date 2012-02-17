module DatabaseHelper
  DB_ADAPTER = Rails.configuration.database_configuration[Rails.env]["adapter"]

  def self.postgres?
    DB_ADAPTER == "postgresql"
  end

  def self.sqlite3?
    DB_ADAPTER == "sqlite3"
  end
  
  def self.true_value
    postgres? ? true : "'t'"
  end
end
