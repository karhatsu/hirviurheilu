class FeedbacksController < ApplicationController
  skip_before_filter :set_competitions

  def index
  end

  def new
    @comment, @name, @email, @tel = '', '', '', ''
    if current_user
      @name = "#{current_user.first_name} #{current_user.last_name}"
      @email = "#{current_user.email}"
    end
  end

  def create
    @comment = params[:comment]
    @name = params[:name]
    @email = params[:email]
    @tel = params[:tel]
    unless @comment.blank?
      FeedbackMailer.feedback_mail(@comment, @name, @email, @tel, current_user).deliver
      flash[:notice] = 'Kiitos palautteesta'
      redirect_to feedbacks_path
    else
      flash[:error] = 'Älä unohda kirjoittaa palautetta'
      render :new
    end
  end
end
