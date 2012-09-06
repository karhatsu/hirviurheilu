class ErrorMailer < ActionMailer::Base
  def error_mail(subject, exception, request, current_user)
    @exception = exception
    @path = request.fullpath
    @request = request
    @user = current_user
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "#{subject} (#{Rails.env})"
  end
end
