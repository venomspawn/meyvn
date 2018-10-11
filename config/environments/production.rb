# frozen_string_literal: true

Rails.application.configure do
  config.action_controller.perform_caching = true

  config.action_mailer.perform_caching = false

  config.active_record.dump_schema_after_migration = false

  config.active_support.deprecation = :notify

  config.cache_classes = true

  config.consider_all_requests_local = false

  config.eager_load = true

  config.i18n.fallbacks = true

  config.log_level     = :info
  config.log_tags      = %i[request_id]
  config.log_formatter = ::Logger::Formatter.new

  config.require_master_key = true
end
