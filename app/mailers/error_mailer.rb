class ErrorMailer < ActionMailer::Base
  def error_mail(subject, exception, path, current_user)
    @exception = exception
    @path = path
    @user = current_user
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "#{subject} (#{Rails.env})"
  end
end
