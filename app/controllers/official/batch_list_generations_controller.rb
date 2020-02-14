class Official::BatchListGenerationsController < Official::OfficialController
  before_action :assign_series_by_series_id, :set_menu

  def show
    find_competitors_without_batch
  end

  def create
    generator = BatchList::Ilmahirvi.new(@series)
    generator.generate params[:first_batch_number].to_i, params[:first_track_place].to_i, params[:first_batch_time], params[:minutes_between_batches].to_i
    if generator.errors.empty?
      flash[:success] = t('.batch_list_generated')
      redirect_to official_series_batch_list_generation_path(@series)
    else
      flash[:error] = generator.errors.join('. ')
      find_competitors_without_batch
      render :show
    end
  end

  private

  def find_competitors_without_batch
    @competitors_without_batch = @series.competitors.where('batch_id IS NULL AND track_place IS NULL')
  end

  def set_menu
    @is_batch_list_generation = true
  end
end
