# frozen_string_literal: true

# Namespace of base classes
module Base
  # Base business logic class, which provides check if parameters correspond to
  # JSON-schema
  class Logic
    extend Validator

    # Initializes instance
    # @param [Hash] params
    #   associative array of parameters
    # @raise [JSON::Schema::ValidationError]
    #   if associative array of parameters doesn't correspond to JSON-schema
    def initialize(params)
      self.class.validate!(params)
      @params = params
    end

    private

    # Associative array of action parameters
    # @return [Hash{Symbol => Object}]
    #   associative array of action parameters
    attr_reader :params
  end
end
