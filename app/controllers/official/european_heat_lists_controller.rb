class Official::EuropeanHeatListsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @time = :time
    render_pdf
  end

  def compak
    @sub_sport = :compak
    @time = :time2
    render_pdf
  end

  def rifle
    @sub_sport = :rifle
    @time = :time3
    render_pdf
  end

  private

  def render_pdf
    @heats = @race.heats.includes(competitors: [:club, :series])
    respond_to do |format|
      format.pdf do
        header = "#{t :result_sheet_pdf_title} - #{@race.name} - #{t "sport_name.european_sub.#{@sub_sport}"}"
        orientation = @sub_sport == :rifle ? 'Landscape' : 'Portrait'
        render pdf: "#{@race.name}-ampumapoytakirja", layout: true, template: 'official/european_heat_lists/index',
               orientation: orientation, margin: pdf_margin, header: pdf_header(header),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
