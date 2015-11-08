class ProductionEnvironment
  def self.staging?
    Rails.env.production? && TEST_ENV
  end

  def self.production?
    Rails.env.production? && PRODUCTION_ENV
  end
end