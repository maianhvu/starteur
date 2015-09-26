module APIHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def token_header(token)
    header 'Authorization', ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  def expect_authentication_failed
    expect(last_response.status).to be(401)
    expect(last_response.body).to_not be_empty
    expect((body = json(last_response.body)).length).to eq(1)
    expect(body[:errors]).to include('Bad credentials')
  end
end

RSpec.configure do |config|
  config.include APIHelper, :type => :api
end
