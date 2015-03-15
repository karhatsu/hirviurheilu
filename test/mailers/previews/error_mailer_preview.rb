class ErrorMailerPreview < ActionMailer::Preview
  def error_mail
    begin
      do_something
    rescue => exception
    end
    params = {}
    params['hello'] = 'error'
    ErrorMailer.error_mail('Test error', exception, TestRequest.new, params, User.last)
  end

  class TestRequest
    def fullpath
      'http://localhost'
    end

    def headers
      { 'header' => 'ok' }
    end
  end
end