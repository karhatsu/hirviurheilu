class Api::V2::ApiBaseController < ApplicationController
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
end
