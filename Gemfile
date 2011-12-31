source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'jquery-rails'

group :development, :staging, :production do
  gem 'pg'
end

group :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group "winoffline-dev", "winoffline-prod" do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem "rspec-rails"
  gem "autotest"
  gem "autotest-rails"
  gem "factory_girl_rails"
  gem 'capybara'
  gem 'database_cleaner'
  gem 'gherkin'
  gem 'cucumber-rails'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'    # So you can do Then show me the page
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'ruby-prof'
  gem 'watchr'
  gem 'mongrel'
end
