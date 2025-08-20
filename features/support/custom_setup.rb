require 'email_spec/cucumber'
require 'cucumber/rspec/doubles'
require 'factory_bot_rails'
World(FactoryBot::Syntax::Methods)

Capybara.javascript_driver = :selenium_chrome_headless

def setup_database
  Role.ensure_default_roles_exist
  District.find_or_create_by! name: 'Test district', short_name: 'TD'
end

Before do
  setup_database
end

Before('@javascript') do
  # Ensure window is resized before each JS scenario
  page.driver.browser.manage.window.resize_to(1400, 1400)
end

After do |scenario|
  if scenario.failed?
    # save_and_open_screenshot
  end
end
