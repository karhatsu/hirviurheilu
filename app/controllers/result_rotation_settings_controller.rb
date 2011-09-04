class ResultRotationSettingsController < ApplicationController
  before_filter :assign_race_by_race_id, :set_races

  def index
    if cookies['seriescount'].nil?
      cookies['seriescount'] = 3
    else
      cookies.delete 'seriescount'
    end
  end
end
