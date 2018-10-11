# frozen_string_literal: true

Rails.application.configure do
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching       = false

  config.active_record.migration_error    = :page_load
  config.active_record.verbose_query_logs = true

  config.active_support.deprecation = :log

  config.cache_classes = true

  config.cache_store = :null_store

  config.consider_all_requests_local = true

  config.eager_load = true
end
