class ErrorMailer < ApplicationMailer
  def error_mail(subject, exception, request, params, current_user)
    @exception = exception
    @path = request.fullpath
    @request = request
    @params = params
    @user = current_user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "#{subject} (#{Rails.env})"
  end
end
