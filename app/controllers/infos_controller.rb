class InfosController < ApplicationController
  before_action :set_is_info

  def show
    use_react
    @is_info_main = true
    render layout: true, html: ''
  end

  def answers
    @is_answers = true
  end
end
