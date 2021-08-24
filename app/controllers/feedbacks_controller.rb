class FeedbacksController < ApplicationController
  before_action :set_is_info, :set_is_feedback

  def new
    use_react
    render layout: true, html: ''
  end

  private

  def set_is_feedback
    @is_feedback = true
  end
end
