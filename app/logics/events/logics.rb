# frozen_string_literal: true

module Events
  # Provides business logic of event management
  module Logics
    # Creates new event record
    # @param [Hash] params
    #   associative array of parameters
    # @raise [ActiveRecord::RecordNotSaved]
    #   if the record can't be created
    def self.create(params)
      Create.new(params).create
    end

    # Returns array of assocative arrays with information on events
    # @param [Hash] params
    #   associative array of parameters
    # @return [Array<Hash>]
    #   resulting array
    def self.index(params)
      Index.new(params).index
    end
  end
end
