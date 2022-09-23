class Api::V2::ApiBaseController < ApplicationController
  def process_action(*args)
    super
  rescue ActionDispatch::Http::Parameters::ParseError => exception
    if request.env['CONTENT_TYPE'] == 'application/json'
      render status: 400, json: { errors: ['invalid JSON'] }
    else
      raise exception
    end
  end
end
