class CupSeriesController < ApplicationController
  before_action :assign_cup, :assign_cup_series_by_id

  def show
    @is_cup = true
    @is_cup_series = true
    render_show
  end

  private

  def assign_cup
    @id = params[:cup_id]
    @cup = Cup.where(id: @id).includes([:cup_series, races: [series: [competitors: [:age_group, :club, :series]]]]).first
    render 'errors/cup_not_found' unless @cup
  end

  def render_show
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf do
        render :pdf => "#{@cup_series.name}-tulokset", :layout => true, :margin => pdf_margin,
               :header => pdf_header("#{@cup.name} - #{@cup_series.name}\n"), :footer => pdf_footer,
               :orientation => 'Landscape', disable_smart_shrinking: true
      end
    end
  end
end
