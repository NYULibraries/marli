require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Marli
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Autoload the lib path
    config.autoload_paths += %W(#{config.root}/lib)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    if ENV['DOCKER']
      config.action_mailer.smtp_settings = {
        address:              ENV['SMTP_HOSTNAME'],
        port:                 ENV['SMTP_PORT'],
        domain:               ENV['SMTP_DOMAIN'],
        user_name:            ENV['SMTP_USERNAME'],
        password:             ENV['SMTP_PASSWORD'],
        authentication:       ENV['SMTP_AUTH_TYPE'],
        enable_starttls_auto: true
      }
    end

  end
end

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
end
