
require "active_support/core_ext/integer/time"
Rails.application.configure do
  config.enable_reloading = true
  config.consider_all_requests_local = true
  config.server_timing = true
  config.cache_classes = false
  config.eager_load = false
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.hosts.clear
end
