source 'http://rubygems.org'
ruby '2.7.1'

gem 'rails', '6.0.3.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
gem 'sassc-rails'
gem 'authlogic'
gem 'wicked_pdf'
gem 'coffee-rails'
gem 'uglifier'
gem 'activerecord-session_store'
gem 'haml-rails'
gem 'dalli'
gem 'roman-numerals'
gem 'nokogiri'
gem 'redcarpet'
gem 'kaminari'
gem 'jbuilder'
gem 'scrypt'

group :development, :production do
  gem 'pg'
  gem 'unicorn'
end

group :production do
  gem 'newrelic_rpm'
  gem 'exception_notification'
  gem 'wkhtmltopdf-heroku'
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
  gem 'therubyracer'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
  gem 'wkhtmltopdf-binary-edge'
end
