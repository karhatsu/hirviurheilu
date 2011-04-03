module TimeHelper
  def seconds_for_day(time)
    3600 * time.hour + 60 * time.min + time.sec
  end

  module_function :seconds_for_day
end
