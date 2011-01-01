class StartListsController < ApplicationController
  before_filter :assign_series_by_series_id

  def show
    @is_start_list = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@series.name}-lahtolista", :layout => true
      end
    end
  end
end
