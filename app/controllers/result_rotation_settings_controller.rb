class ResultRotationSettingsController < ApplicationController
  before_filter :assign_race_by_race_id

  def show
    if cookies['seriescount'].nil?
      cookies['seriescount'] = 3
    else
      cookies.delete 'seriescount'
    end
  end
end
