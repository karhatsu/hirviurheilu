class Api::V2::Public::RecentRacesController < Api::V2::ApiBaseController
  def index
    @races = Race.where('start_date>?', Date.today - 14.days).order('start_date')
  end
end
