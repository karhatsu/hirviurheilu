# encoding: UTF-8
class FeedbacksController < ApplicationController
  include ApplicationHelper

  before_action :set_is_info, :set_is_feedback
  before_action :check_offline
  before_action :set_variant

  def index
  end

  def new
    @comment, @name, @email, @tel = '', '', '', ''
    if current_user
      @name = "#{current_user.first_name} #{current_user.last_name}"
      @email = "#{current_user.email}"
    end
    set_races
  end

  def create
    @comment = params[:comment]
    @name = params[:name]
    @email = params[:email]
    @tel = params[:tel]
    @race_id = params[:race_id]
    unless @comment.blank?
      unless @race_id.blank?
        race = Race.find(@race_id)
        FeedbackMailer.race_feedback_mail(race, @comment, @name, @email, @tel, current_user).deliver_now
      else
        FeedbackMailer.feedback_mail(@comment, @name, @email, @tel, current_user).deliver_now
      end
      redirect_to feedbacks_path
    else
      set_races
      flash[:error] = t('feedbacks.create.feedback_missing')
      render :new
    end
  end

  private
  def set_is_feedback
    @is_feedback = true
  end
  
  def check_offline
    render :offline if offline?
  end

  def set_races
    @races = Race.where('start_date>?', Date.today - 14.days).order('start_date').map { |race| ["#{race.name} (#{race_date_interval(race)}, #{race.location})", race.id] }
  end
end
