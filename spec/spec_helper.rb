# frozen_string_literal: true

RSpec.configure do |config|
  config.expose_dsl_globally = false

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

Dir["#{__dir__}/support/**/*.rb"].each(&method(:require))
