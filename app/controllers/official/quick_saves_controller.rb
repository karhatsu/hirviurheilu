class Official::QuickSavesController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_quick_saves

  def index
  end

  def estimates
    @name = 'estimates'
    do_quick_save(EstimatesQuickSave.new(@race.id, params[:string])) do
      if @competitor.series.estimates == 4
        @result = "arviot: #{@competitor.estimate1}, #{@competitor.estimate2}, " +
          "#{@competitor.estimate3} ja #{@competitor.estimate4}"
      else
        @result = "arviot: #{@competitor.estimate1} ja #{@competitor.estimate2}"
      end
    end
  end

  def shots
    @name = 'shots'
    do_quick_save(ShotsQuickSave.new(@race.id, params[:string])) do
      @result = "ammunta: #{@competitor.shots_sum}"
    end
  end

  def time
    @name = 'time'
    do_quick_save(TimeQuickSave.new(@race.id, params[:string])) do
      @result = "saapumisaika: #{@competitor.arrival_time.strftime('%H:%M:%S')}"
    end
  end

  private
  def set_quick_saves
    @is_quick_saves = true
  end

  def do_quick_save(quick_save, &block)
    if quick_save.save
      @competitor = quick_save.competitor
      block.call
      respond_to do |format|
        format.js { render :success, :layout => false }
      end
    else
      @error = quick_save.error
      respond_to do |format|
        format.js { render :error, :layout => false }
      end
    end
  end
end
