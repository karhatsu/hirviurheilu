class InfosController < ApplicationController
  before_filter :set_is_info
  
  def show
    @is_info_main = true
  end
  
  def answers
    @is_answers = true
  end
end
