class Api::V2::Public::FeedbacksController < Api::V2::ApiBaseController
  def create
    read_params
    return render status: 400, json: { errors: [t(:wrong_captcha)] } unless %w[neljä fyra].include?(@captcha&.downcase)
    send_feedback_email
    render status: 201, body: nil
  end

  private

  def read_params
    @comment = params[:comment]
    @name = params[:name]
    @email = params[:email]
    @tel = params[:tel]
    @race_id = params[:race_id]
    @captcha = params[:captcha]&.strip
  end

  def send_feedback_email
    if @race_id.blank?
      FeedbackMailer.feedback_mail(@comment, @name, @email, @tel, current_user).deliver_now
    else
      race = Race.find @race_id
      FeedbackMailer.race_feedback_mail(race, @comment, @name, @email, @tel, current_user).deliver_now
    end
  end
end
