
require "active_support/core_ext/integer/time"
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => "public, max-age=3600" }
  config.consider_all_requests_local = true
  config.action_dispatch.show_exceptions = :rescuable
  config.log_level = :warn
end
