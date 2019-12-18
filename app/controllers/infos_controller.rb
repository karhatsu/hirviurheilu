class InfosController < ApplicationController
  before_action :set_is_info, :set_variant

  def show
    @is_info_main = true
  end

  def answers
    @is_answers = true
  end
end
