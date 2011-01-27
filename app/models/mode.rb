class Mode
  @@offline = OFFLINE # see application.rb

  def self.offline?
    @@offline
  end

  def self.online?
    not @@offline
  end

  def self.switch
    raise "Mode switching allowed only in dev environment" unless Rails.env == 'development'
    @@offline = !@@offline
  end
end
