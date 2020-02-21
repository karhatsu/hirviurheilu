class Official::BatchesController < Official::OfficialController
  before_action :set_menu_batches, :assign_race_by_race_id

  def index
    @batches = @race.batches.includes(competitors: [:club, :series])
  end

  def new
    @batch = @race.batches.build
    @batch.number = @race.next_batch_number
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
    params.require(:batch).permit(:number, :track, :day, :time)
  end
end
