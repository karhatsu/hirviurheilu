class ErrorMailer < ActionMailer::Base
  def error_mail(subject, exception)
    @exception = exception
    mail :to => 'henri@karhatsu.com', :from => '<noreply@hirviurheilu.com>',
      :subject => subject
  end
end
