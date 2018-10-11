require 'coveralls'
Coveralls.wear_merged!('rails')

require 'selenium-webdriver'
require 'pry'

# # Require support classes in spec/support and its subdirectories.
# Dir[Rails.root.join("spec/support/**/*.rb")].each do |helper|
#   require helper
# end

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[Rails.root.join("features/support/helpers/**/*.rb")].each do |helper|
  require helper
  # Only include _helper.rb methods
  if /_helper.rb/ === helper
    helper_name = "RoomsFeatures::#{helper.camelize.demodulize.split('.').first}"
    Cucumber::Rails::World.send(:include, helper_name.constantize)
  end
end

if ENV['IN_BROWSER']
  # On demand: non-headless tests via Selenium/WebDriver
  # To run the scenarios in browser (default: Firefox), use the following command line:
  # IN_BROWSER=true bundle exec cucumber
  # or (to have a pause of 1 second between each step):
  # IN_BROWSER=true PAUSE=1 bundle exec cucumber
  Capybara.register_driver :selenium do |app|
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.timeout = 120
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :http_client => http_client)
  end
  Capybara.default_driver = :selenium
  AfterStep do
    sleep (ENV['PAUSE'] || 0).to_i
  end
else
  # DEFAULT: Headless tests with chrome headless
  Capybara.register_driver :chrome_headless do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        args: %w[ no-sandbox headless disable-gpu window-size=1280,1024]
      }
    )

    Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
  end
  Capybara.default_driver    = :chrome_headless
  Capybara.javascript_driver = :chrome_headless
  # Capybara.default_wait_time = 20
end


require 'database_cleaner'
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation
Before do
  DatabaseCleaner.start
end

After do |scenario|
  DatabaseCleaner.clean
end


ENV['INSTITUTIONS'] = <<YAML
---
NYU:
  ip_addresses:
    - 127.0.0.1
NYUAD:
  ip_addresses:
    - 127.0.0.1
NYUSH:
  ip_addresses:
    - 127.0.0.1
NYSID:
  ip_addresses:
    - 127.0.0.1
HSL:
  ip_addresses:
    - 127.0.0.1
CU:
  ip_addresses:
    - 127.0.0.1
NS:
  ip_addresses:
    - 127.0.0.1
YAML
ENV['ROOMS_ROLES_ADMIN'] = <<YAML
---
- superuser
- ny_admin
- shanghai_admin
YAML
ENV['ROOMS_DEFAULT_ADMINS'] = <<YAML
---
- admin
YAML
ENV['ROOMS_ROLES_AUTHORIZED'] = <<YAML
---
shanghai_undergraduate:
  - '0'
ny_undergraduate:
  - '1'
  - '2'
ny_graduate:
  - '3'
  - '4'
  - '5'
  - '6'
  - '7'
YAML
