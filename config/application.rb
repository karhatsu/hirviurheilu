require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # Require the gems listed in Gemfile, including any gems
  # you've limited to :test, :development, or :production.
  Bundler.require(:default, :assets, Rails.env)
end

ADMIN_EMAIL = ["com", ".", "karhatsu", "@", "henri"].reverse.join('')

TEST_URL = 'https://testi.hirviurheilu.com'
PRODUCTION_URL = 'https://www.hirviurheilu.com'

TEST_ENV = ENV['TEST_ENV'] == 'true'
PRODUCTION_ENV = !TEST_ENV

NATIONAL_RECORD_URL = "https://metsastajaliitto.fi/metsastajalle/kilpailutoiminta/kilpailut-ja-tulokset/sm-ennatykset"

VAT = 24

OSX_PLATFORM = (RUBY_PLATFORM =~ /darwin/)

module Hirviurheilu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths << "#{config.root}/test/mailers/previews"
    config.eager_load_paths << "#{config.root}/test/mailers/previews"

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Helsinki'

    config.active_support.to_time_preserves_timezone = :zone

    config.active_record.time_zone_aware_types = [:datetime]

    config.i18n.enforce_available_locales = true

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:fi, :sv]
    config.i18n.default_locale = :fi

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    config.assets.precompile += %w[pdf.scss legacy.js social.js]

    config.assets.initialize_on_precompile = false

    config.action_controller.per_form_csrf_tokens = true

    config.action_controller.forgery_protection_origin_check = true

    config.generators do |g|
      g.test_framework :rspec
    end

    config.active_support.cache_format_version = 7.0

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }
  end
end
