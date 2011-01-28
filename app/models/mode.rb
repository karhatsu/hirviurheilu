class Mode
  def self.offline?
    Thread.main[:offline] = OFFLINE if Thread.main[:offline] == nil
    Thread.main[:offline]
  end

  def self.online?
    not offline?
  end

  def self.switch
    raise "Mode switching allowed only in dev environment" unless Rails.env == 'development'
    Thread.main[:offline] = !Thread.main[:offline]
  end
end
