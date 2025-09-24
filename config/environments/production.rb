
require "active_support/core_ext/integer/time"
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.log_level = :info
  config.log_tags = [:request_id]
  config.force_ssl = false
end
