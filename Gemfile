source 'https://rubygems.org'
ruby '3.3.1'

gem 'rails', '7.1.3.4'
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
gem 'puma'

group :development, :production do
  gem 'pg'
end

group :production do
  gem 'newrelic_rpm'
  gem 'exception_notification'
  gem 'wkhtmltopdf-heroku', '2.12.6.1.pre.jammy'
  gem 'redis'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'minitest'
  gem 'capybara'
  gem 'cucumber-rails', require: false
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
