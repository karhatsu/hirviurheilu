source 'https://rubygems.org'
ruby '3.1.0'

gem 'rails', '7.0.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
gem 'sassc-rails'
gem 'authlogic'
gem 'wicked_pdf'
gem 'coffee-rails'
gem 'uglifier'
gem 'haml-rails'
gem 'dalli'
gem 'roman-numerals'
gem 'nokogiri'
gem 'redcarpet'
gem 'jbuilder'
gem 'scrypt'
gem 'jsbundling-rails'

group :development, :production do
  gem 'pg'
  gem 'unicorn'
end

group :production do
  gem 'newrelic_rpm'
  gem 'exception_notification'
  gem 'wkhtmltopdf-heroku'
  gem 'redis'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'puma'
  gem 'minitest'
  gem 'capybara'
  # Remove git when 2.4.1
  gem 'cucumber-rails', '2.4.0', git: 'https://github.com/cucumber/cucumber-rails.git', require: false
  gem 'database_cleaner'
  gem 'email_spec'
  gem "factory_bot_rails", :require => false
  gem 'launchy'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers'
  gem 'fuubar'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'wkhtmltopdf-binary-edge'
end
