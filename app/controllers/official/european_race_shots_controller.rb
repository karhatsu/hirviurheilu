class Official::EuropeanRaceShotsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @is_trap = true
    render :index
  end

  def compak
    @sub_sport = :compak
    @is_compak = true
    render :index
  end

  def rifle
    @sub_sport = :rifle
    @is_rifle = true
    render :index
  end
end
