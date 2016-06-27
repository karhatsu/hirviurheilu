class CupSeriesController < ApplicationController
  before_action :set_variant
  before_action :assign_cup, :assign_cup_series_by_id

  def show
    @is_cup = true
    @is_cup_series = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@cup_series.name}-tulokset", :layout => true, :margin => pdf_margin,
          :header => pdf_header("#{@cup.name} - #{@cup_series.name}\n"), :footer => pdf_footer,
          :orientation => 'Landscape', disable_smart_shrinking: true
      end
    end
  end

  private
  def assign_cup
    @id = params[:cup_id]
    @cup = Cup.where(:id => @id).
      includes([
        :races => [:series => [:competitors => [:shots, :age_group, :club, :series]]]
      ]).first
    return true if @cup
    render 'errors/cup_not_found'
    false
  end
  
  def assign_cup_series
    @id = params[:id]
    begin
      @cup_series = @cup.cup_series.find(@id)
      return true
    rescue ActiveRecord::RecordNotFound
      render 'errors/cup_series_not_found'
      return false
    end
  end
end