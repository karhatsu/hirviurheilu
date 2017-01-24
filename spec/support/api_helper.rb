module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def put_request(path, body)
    put path, body.to_json, { 'CONTENT_TYPE' => 'application/json' }
  end

  def expect_status_code(status_code)
    expect(last_response.status).to eq status_code
  end

  def expect_json(json)
    expect(last_response.body).to include_json(json)
  end

  def api_date(date)
    date.strftime '%Y-%m-%d'
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
  config.include Rails.application.routes.url_helpers, type: :api
end
