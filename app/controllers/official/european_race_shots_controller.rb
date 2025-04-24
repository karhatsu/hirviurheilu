class Official::EuropeanRaceShotsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @is_trap = true
    use_react true
    render layout: true, html: ''
  end

  def compak
    @sub_sport = :compak
    @is_compak = true
    use_react true
    render layout: true, html: ''
  end

  def rifle
    @sub_sport = :rifle
    @is_rifle = true
    render :index
  end
end
