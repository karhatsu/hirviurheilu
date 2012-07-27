source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'authlogic'
gem 'wicked_pdf'

group :development, :staging, :production do
  gem 'pg'
  gem 'thin'
end

group :production do
  gem 'newrelic_rpm'
end

group :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
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
  gem "rspec-rails"
  gem "autotest"
  gem "autotest-rails"
  gem "factory_girl_rails", :require => false
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'gherkin'
  gem 'cucumber-rails'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'    # So you can do Then show me the page
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'ruby-prof'
  gem 'watchr'
  gem 'mongrel', '~> 1.2.0.pre'
  gem 'therubyracer'
end
