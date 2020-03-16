class Official::BatchesController < Official::OfficialController
  before_action :set_menu_batches, :assign_race_by_race_id, :check_assigned_race

  def index
    @qualification_round_batches = @race.qualification_round_batches.includes(competitors: [:club, :series])
    @final_round_batches = @race.final_round_batches.includes(competitors: [:club, :series])
  end

  def new
    @batch = @race.batches.build
    @batch.type = params[:type]
    @batch.number = @race.next_batch_number
    @batch.time = @race.next_batch_time || '00:00'
  end

  def create
    @batch = @race.batches.build batch_params
    if @batch.save
      flash[:success] = t '.batch_added'
      redirect_to official_race_batches_path(@race)
    else
      render :new
    end
  end

  def edit
    @batch = @race.batches.find params[:id]
  end

  def update
    @batch = @race.batches.find params[:id]
    if @batch.update batch_params
      flash[:success] = t '.batch_updated'
      redirect_to official_race_batches_path(@race)
    else
      render :edit
    end
  end

  def destroy
    @batch = @race.batches.find params[:id]
    @batch.destroy
    flash[:success] = t '.batch_deleted'
    redirect_to official_race_batches_path(@race)
  end

  private

  def set_menu_batches
    @is_batches = true
  end

  def batch_params
    params.require(:batch).permit(:type, :number, :track, :day, :time)
  end
end
