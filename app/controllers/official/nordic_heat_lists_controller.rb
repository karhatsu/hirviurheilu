class Official::NordicHeatListsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @time = :time
    render_pdf
  end

  def shotgun
    @sub_sport = :shotgun
    @time = :time2
    render_pdf
  end

  def rifle_moving
    @sub_sport = :rifle_moving
    @time = :time3
    render_pdf
  end

  def rifle_standing
    @sub_sport = :rifle_standing
    @time = :time4
    render_pdf
  end

  private

  def render_pdf
    @heats = @race.heats.includes(competitors: [:club, :series])
    respond_to do |format|
      format.pdf do
        header = "#{t :result_sheet_pdf_title} - #{@race.name} - #{t "sport_name.nordic_sub.#{@sub_sport}"}"
        render pdf: "#{@race.name}-ampumapoytakirja", layout: true, template: 'official/nordic_heat_lists/index',
               margin: pdf_margin, header: pdf_header(header),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
