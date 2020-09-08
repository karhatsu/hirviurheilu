class Official::FinalRoundBatchListsController < Official::BatchListsController
  before_action :assign_race_by_race_id, :check_assigned_race, :check_batch_count, only: :index
  before_action :assign_series_by_series_id, :check_assigned_series, :set_menu, only: [:show, :create]

  def index
    respond_to do |format|
      @batches = @race.final_round_batches.includes(competitors: [:club, :series])
      format.pdf do
        render pdf: "#{@race.name}-loppukilpailu", layout: true,
               margin: pdf_margin, header: pdf_header("#{t :batch_list} - #{@race.name}"),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end

  def show
    find_competitors_without_batch
  end

  def create
    generator = BatchList.new(@series)
    opts = build_opts
    opts[:best_as_last] = params[:best_as_last]
    generator.generate_final_round params[:first_batch_number].to_i, params[:first_track_place].to_i, params[:first_batch_time],
                       params[:minutes_between_batches].to_i, params[:competitors_count].to_i, opts
    if generator.errors.empty?
      flash[:success] = t('.batch_list_generated')
      redirect_to official_series_final_round_batch_list_path(@series)
    else
      flash[:error] = generator.errors.join('. ')
      find_competitors_without_batch
      render :show
    end
  end

  private

  def check_batch_count
    if @race.final_round_batches.empty?
      @error = t 'official.batches.index.no_batches'
      render 'official/shared/pdf_error'
    end
  end

  def find_competitors_without_batch
    @competitors_without_batch = @series.competitors.where('final_round_batch_id IS NULL AND final_round_track_place IS NULL')
  end

  def set_menu
    @final_round_batch_list = true
  end
end
