class StartListsController < ApplicationController
  def show
    @series = Series.find(params[:series_id])
    @is_start_list = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@series.name}-lahtolista", :layout => true
      end
    end
  end
end
