class Official::QualificationRoundBatchListsController < Official::BatchListsController
  before_action :assign_series_by_series_id, :check_assigned_series, :set_menu

  def show
    find_competitors_without_batch
  end

  def create
    generator = BatchList.new(@series)
    opts = build_opts
    generator.generate_qualification_round params[:first_batch_number].to_i, params[:first_track_place].to_i, params[:first_batch_time],
                       params[:minutes_between_batches].to_i, opts
    if generator.errors.empty?
      flash[:success] = t('.batch_list_generated')
      redirect_to official_series_qualification_round_batch_list_path(@series)
    else
      flash[:error] = generator.errors.join('. ')
      find_competitors_without_batch
      render :show
    end
  end

  private

  def find_competitors_without_batch
    @competitors_without_batch = @series.competitors.where('qualification_round_batch_id IS NULL AND qualification_round_track_place IS NULL')
  end

  def set_menu
    @qualification_round_batch_list = true
  end
end
