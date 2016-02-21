class ErrorMailer < ApplicationMailer
  def error_mail(subject, exception, request, params, current_user)
    @exception = exception
    @path = request.fullpath
    @headers = request.headers.select { |key, value| key.match(/^[A-Z_]+$/) && key.match(/^HTTP.*/) }
                   .inject({}) { |hash, (key, value)| hash[key['HTTP_'.length..-1]] = value; hash }
    @env = request.headers.select { |key, value| key.match(/^[A-Z_]+$/) && !key.match(/^HTTP.*/) }
    @params = params
    @user = current_user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "#{subject} (#{ProductionEnvironment.name})"
  end
end
