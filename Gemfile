source 'http://rubygems.org'
ruby '3.0.2'

gem 'rails', '6.1.4'
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
gem 'webpacker', '~> 5.0'

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
  gem 'cucumber-rails', :require => false
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
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
  gem 'wkhtmltopdf-binary-edge'
end
