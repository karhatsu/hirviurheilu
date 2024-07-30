class Official::QualificationRoundHeatListsController < Official::HeatListsController
  before_action :assign_race_by_race_id, :check_assigned_race, :check_heat_count, only: :index
  before_action :assign_series_by_series_id, :check_assigned_series, :set_menu, only: [:show, :create]

  def index
    respond_to do |format|
      @heats = @race.qualification_round_heats.includes(competitors: [:club, :series])
      orientation = @race.sport_key == Sport::METSASTYSTRAP || @race.sport_key == Sport::METSASTYSHAULIKKO ? 'Landscape' : 'Portrait'
      format.pdf do
        render pdf: "#{@race.name}-alkukilpailu", layout: true,
               margin: pdf_margin, header: pdf_header("#{t :result_sheet_pdf_title} - #{@race.name} - #{I18n.t("sport_name.#{@race.sport_key}")}"),
               footer: pdf_footer, disable_smart_shrinking: true, orientation: orientation
      end
    end
  end

  def show
    find_competitors_without_heat
  end

  def create
    generator = HeatList.new(@series)
    opts = build_opts
    generator.generate_qualification_round params[:first_heat_number].to_i, params[:first_track_place].to_i, params[:first_heat_time],
                       params[:minutes_between_heats].to_i, opts
    if generator.errors.empty?
      flash[:success] = t('.heat_list_generated')
      redirect_to official_series_qualification_round_heat_list_path(@series)
    else
      flash[:error] = generator.errors.join('. ')
      find_competitors_without_heat
      render :show
    end
  end

  private

  def check_heat_count
    if @race.qualification_round_heats.empty?
      @error = t 'official.heats.index.no_heats'
      render 'official/shared/pdf_error'
    end
  end

  def find_competitors_without_heat
    @competitors_without_heat = @series.competitors.where('qualification_round_heat_id IS NULL AND qualification_round_track_place IS NULL')
  end

  def set_menu
    @qualification_round_heat_list = true
  end
end
