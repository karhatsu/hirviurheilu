class Official::UploadsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :check_offline, :except => :create

  def new
    @servers = []
    @servers << ['Hirviurheilu', PRODUCTION_URL]
    @servers << ['Hirviurheilu (testi)', TEST_URL]
    @servers << ['Same server', ''] if Rails.env == 'test' or Rails.env == 'development'
  end

  def create
    user = User.find_by_email(params[:email]) # TODO: password check
    race = Race.new(params[:race])
    if race.save
      user.races << race
    end
    redirect_to "#{params[:source]}/official/races/#{params[:race_id]}/upload/done"
  end

  #TODO: success vs. error
  def done
  end

  private
  def check_offline
    redirect_to official_race_path(@race) if online?
  end
end
