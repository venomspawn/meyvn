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

    config.generators.system_tests = nil
  end
end
