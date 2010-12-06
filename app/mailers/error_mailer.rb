class ErrorMailer < ActionMailer::Base
  def error_mail(subject, exception)
    @exception = exception
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "#{subject} (#{Rails.env})"
  end
end
