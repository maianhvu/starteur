module APIHelper
  include Rack::Test::Methods
  #include Rack::Request

  def app
    Rails.application
  end

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include APIHelper, :type => :api
end
