class Official::RelayQuickSavesController < Official::OfficialController
  before_filter :assign_relay_by_relay_id, :check_assigned_relay, :set_relays

  def index
  end

  def estimate
    @name = 'estimate'
    do_quick_save(RelayEstimateQuickSave.new(@relay.id, params[:string])) do
      @result = "arvio: #{@competitor.estimate}"
    end
  end

  def misses
    @name = 'misses'
    do_quick_save(RelayMissesQuickSave.new(@relay.id, params[:string])) do
      @result = "ohilaukaukset: #{@competitor.misses}"
    end
  end

  private
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
