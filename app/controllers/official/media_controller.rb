class Official::MediaController < Official::OfficialController
  before_filter :assign_race, :check_race_rights, :set_media

  def index
    @show_results = params[:results]
  end

  private
  def assign_race
    @race = Race.find(params[:race_id])
  end

  def check_race_rights
    check_race(@race)
  end

  def set_media
    @is_media = true
  end
end
