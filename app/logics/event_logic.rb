# frozen_string_literal: true

# Provides business logic of event management
module EventLogic
  # Returns array of assocative arrays with information on events
  # @param [Hash]
  #   associative array of parameters
  # @return [Array<Hash>]
  #   resulting array
  def self.index(params)
    Index.new(params).index
  end
end
