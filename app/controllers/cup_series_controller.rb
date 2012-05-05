class CupSeriesController < ApplicationController
  def show
    @is_cup = true
    @is_cup_series = true
    @cup = Cup.where(:id => params[:cup_id]).
      includes([
        :races => [:series => [:competitors => [:shots, :age_group, :club, :series]]]
      ]).first
    @cup_series = @cup.cup_series.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@cup_series.name}-tulokset", :layout => true, :margin => pdf_margin,
          :header => pdf_header("#{@cup.name} - #{@cup_series.name}\n"), :footer => pdf_footer
      end
    end
  end
end