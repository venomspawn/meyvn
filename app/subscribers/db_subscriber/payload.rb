# frozen_string_literal: true

class DBSubscriber
  # Provides functions to generate and parse control notification payloads
  module Payload
    # Generates and returns a string with control notification payload
    # @param [Object] action
    #   action of control
    # @param [Object] param
    #   parameter of action
    # @return [String]
    #   payload
    def self.generate(action, param)
      [action, param].to_json
    end

    # Returns array of action of control and parameter of the action recovered
    # from the provided notification payload, or `nil` if recovering fails
    # @return [Array<(Symbol, Object)>]
    #   resulting array
    # @return [NilClass]
    #   if recovering fails
    def self.parse(payload)
      JSON.parse(payload, symbolize_keys: true).tap do |values|
        values[0] = values[0].to_sym
      end
    rescue StandardError
      nil
    end
  end
end
