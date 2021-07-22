class ResultRotationsController < ApplicationController
  before_action :assign_race_by_race_id

  def show
    use_react
    render layout: true, html: ''
  end
end
