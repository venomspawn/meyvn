# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module Meyvn
  class Application < Rails::Application
    config.load_defaults 5.2

    config.action_controller.per_form_csrf_tokens = false
    config.active_record.schema_format = :sql
    config.eager_load_paths << Rails.root.join('app', 'logics')
    config.generators.system_tests = nil
  end
end
