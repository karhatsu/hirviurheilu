class InfosController < ApplicationController
  before_action :set_is_info

  def show
    use_react
    @is_info_main = true
    render layout: true, html: ''
  end

  def answers
    use_react
    @is_answers = true
    render layout: true, html: ''
  end

  def sports_info
    use_react
    render layout: true, html: ''
  end
end
