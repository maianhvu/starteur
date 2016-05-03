source 'https://rubygems.org'
ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'roo', '~> 2.1.1'
# Use Puma server
gem 'puma'

# Use AASM
gem 'aasm'

# User authentication and authorization
gem 'sorcery'
gem 'devise'

# View templating
gem 'slim-rails'

# Front-end
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '>= 3.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'

gem 'sendgrid'

# Use postgresql as the database for Active Record
gem 'pg'

# Use redis for caching of test results
gem 'redis-rails'

# Use React for JS component
gem 'react-rails', '~> 1.6.0'
gem 'classnames-rails'

# SSL
gem 'letsencrypt_plugin'

# Stripe Checkout
gem 'stripe'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # tzinfo-data for windows
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
  gem 'quiet_assets'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  # Use faker for testing
  gem 'faker'
  gem 'shoulda-matchers', require: false

  # Use RSpec for testing
  gem 'rspec-rails'
  # With capybara
  gem 'capybara'
  gem 'capybara-email'
  gem 'selenium-webdriver'
  gem 'database_cleaner'

  # Use Factory Girls for fixtures
  gem 'factory_girl_rails', '~> 4.0'

end

group :production do
  gem 'rails_12factor'
end

