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
end

RSpec.configure do |config|
  config.include APIHelper, :type => :api
end
