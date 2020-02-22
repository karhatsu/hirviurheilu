class Official::BatchListGenerationsController < Official::OfficialController
  before_action :assign_series_by_series_id, :check_assigned_series, :set_menu

  def show
    find_competitors_without_batch
  end

  def create
    generator = BatchList.new(@series)
    opts = {}
    opts[:batch_day] = params[:batch_day].to_i unless params[:batch_day].blank?
    opts[:only_track_places] = params[:only_track_places]
    opts[:skip_first_track_place] = params[:skip_first_track_place]
    opts[:skip_last_track_place] = params[:skip_last_track_place]
    opts[:skip_track_places] = params[:skip_track_places].split(',').map(&:strip).map(&:to_i)
    if params[:only_one_batch]
      generator.generate_single_batch params[:first_batch_number].to_i, params[:first_track_place].to_i, params[:first_batch_time], opts
    else
      generator.generate params[:first_batch_number].to_i, params[:first_track_place].to_i, params[:first_batch_time],
                         params[:concurrent_batches].to_i, params[:minutes_between_batches].to_i, opts
    end
    if generator.errors.empty?
      success_key = params[:only_one_batch] ? 'one' : 'many'
      flash[:success] = t(".batch_list_generated.#{success_key}")
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
