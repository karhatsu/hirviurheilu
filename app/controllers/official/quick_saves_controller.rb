class Official::QuickSavesController < Official::OfficialController
  include QuickSavesHelper, TimeFormatHelper
  before_action :set_variant
  before_action :assign_race_by_race_id, :check_assigned_race, :set_quick_saves

  def index
  end

  def estimates
  end

  def shots
  end

  def times
  end

  def save_estimates
    @name = 'estimates'
    do_quick_save(EstimatesQuickSave.new(@race.id, params[:string])) do
      if @competitor.series.estimates == 4
        @result = t(:estimates) + ": #{@competitor.estimate1}, #{@competitor.estimate2}, " +
          "#{@competitor.estimate3} ja #{@competitor.estimate4}"
      else
        @result = t(:estimates) + ": #{@competitor.estimate1} ja #{@competitor.estimate2}"
      end
    end
  end

  def save_shots
    @name = 'shots'
    do_quick_save(ShotsQuickSave.new(@race.id, params[:string])) do
      @result = t(:shooting) + ": #{@competitor.shots_sum}"
    end
  end

  def save_time
    @name = 'time'
    do_quick_save(TimeQuickSave.new(@race.id, params[:string])) do
      @result = t('attributes.arrival_time') + ": #{@competitor.arrival_time.strftime('%H:%M:%S')}, " +
          "#{t(:result_time)}: #{time_from_seconds(@competitor.time_in_seconds)}"
    end
  end

  def save_no_result
    @name = 'no_result'
    do_quick_save(UnfinishedCompetitorQuickSave.new(@race.id, params[:string])) do
      @result = t('competitor.DNS') if @competitor.no_result_reason == Competitor::DNS
      @result = t('competitor.DNF') if @competitor.no_result_reason == Competitor::DNF
      @result = t('competitor.DQ') if @competitor.no_result_reason == Competitor::DQ
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
