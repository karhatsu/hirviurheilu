require 'email_spec/cucumber'
require 'cucumber/rspec/doubles'
require 'factory_bot_rails'
World(FactoryBot::Syntax::Methods)

Capybara.server = :webrick
Capybara.javascript_driver = :selenium_chrome_headless

def setup_database
  Role.ensure_default_roles_exist
  District.find_or_create_by! name: 'Test district', short_name: 'TD'
end

Before do
  setup_database
end
