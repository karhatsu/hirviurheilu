source 'http://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.13'
gem 'jquery-rails', '2.1.4'
gem 'jquery-ui-rails', '3.0.0'
gem 'authlogic'
gem 'wicked_pdf', '0.7.9'
gem 'turbolinks'

group :development, :staging, :production do
  gem 'pg'
  gem 'thin'
end

group :production do
  gem 'newrelic_rpm'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'email_spec'
  gem "factory_girl_rails", :require => false
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spork', '~> 0.9.0.rc'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'watchr'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'gherkin'
  gem 'ruby-prof'
  gem 'mongrel', '~> 1.2.0.pre'
  gem 'therubyracer', '0.12.0'
end
