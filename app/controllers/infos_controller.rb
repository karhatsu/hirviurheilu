class InfosController < ApplicationController
  before_action :set_is_info

  def show
    use_react
    @is_info_main = true
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.json { render status: 404, body: nil }
    end
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
