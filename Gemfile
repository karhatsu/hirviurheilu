source 'http://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
gem 'sass'
gem 'authlogic'
gem 'wicked_pdf'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'coffee-rails'
gem 'uglifier'
gem 'activerecord-session_store'
gem 'haml-rails'
gem 'rack-mini-profiler'
gem 'dalli'
gem 'roman-numerals'

group :development, :production do
  gem 'pg'
  gem 'unicorn'
end

group :production do
  gem 'rails_12factor'
end

group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'minitest'
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'email_spec'
  gem "factory_girl_rails", :require => false
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'sqlite3'
  gem 'fuubar'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'gherkin'
  gem 'ruby-prof'
  gem 'mongrel'
  gem 'therubyracer'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
end
