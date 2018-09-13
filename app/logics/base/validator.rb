# frozen_string_literal: true

require 'json-schema'

module Base
  # Provides methods to check if a data structures correspond to JSON-schemas
  module Validator
    # Checks if the provided data structure corresponds to JSON-schema.
    # Supposes that keys of inner associative arrays are strings.
    # @param [Object] data
    #   data structure
    # @raise [JSON::Schema::ValidationError]
    #   if the data structure doesn't correspond to JSON-schema
    def validate!(data)
      validator.instance_exec do
        @data = data
        validate
      end
    end

    private

    # Returns JSON-schema by extracting value of `PARAMS_SCHEMA` constant of
    # the class
    # @return [Hash]
    #   JSON-schema
    # @raise [NameError]
    #   if there is no `PARAMS_SCHEMA` constant in the class
    def schema
      self::PARAMS_SCHEMA
    end

    # Associative array with JSON-schema validator's options
    VALIDATOR_OPTIONS = { parse_data: false }.freeze

    # Returns JSON-schema validator
    # @return [JSON::Validator]
    #   JSON-schema validator
    def validator
      @validator ||= JSON::Validator.new(schema, nil, VALIDATOR_OPTIONS)
    end
  end
end
