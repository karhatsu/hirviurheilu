class InfosController < ApplicationController
  skip_before_filter :set_competitions

  def show
    @is_info = true
  end
end
