
require_relative "boot"
require "rails/all"

# Only load the parts we need for API; ActionMailer etc. can be left; api_only=true strips middleware.
Bundler.require(*Rails.groups)

module GoodnightApplication
  class Application < Rails::Application
    config.load_defaults 7.1
    config.api_only = true
    # Timezone & default settings
    config.time_zone = "UTC"
  end
end
