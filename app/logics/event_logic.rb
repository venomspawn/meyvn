# frozen_string_literal: true

# Provides business logic of event management
module EventLogic
  # Tries to create new event record and returns {Event} instance with
  # attributes of the record
  # @param [Hash]
  #   associative array of parameters
  # @return [Event]
  #   {Event} instance
  def self.create(params)
    Create.new(params).create
  end

  # Returns array of assocative arrays with information on events
  # @param [Hash]
  #   associative array of parameters
  # @return [Array<Hash>]
  #   resulting array
  def self.index(params)
    Index.new(params).index
  end
end
