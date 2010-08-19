class CompetitorsController < ApplicationController
  def show
    @competitor = Competitor.find(params[:id])
  end
end 