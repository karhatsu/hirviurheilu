class StartListsController < ApplicationController
  def show
    @series = Series.find(params[:series_id])
  end
end
