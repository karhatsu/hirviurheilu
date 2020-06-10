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

  def rifle1
    @sub_sport = :rifle1
    @is_rifle1 = true
    render :index
  end

  def rifle2
    @sub_sport = :rifle2
    @is_rifle2 = true
    render :index
  end

  def rifle3
    @sub_sport = :rifle3
    @is_rifle3 = true
    render :index
  end

  def rifle4
    @sub_sport = :rifle4
    @is_rifle4 = true
    render :index
  end
end
