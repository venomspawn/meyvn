# frozen_string_literal: true

# Namespace of classes and modules which manage with users
module Users
  # Provides business logic of user management
  module Logics
    # Tries to identify and authentify user. Returns user record if both
    # processes are successful. Returns nil otherwise.
    # @param [Hash] params
    #   associative array of parameters
    # @return [User]
    #   identified and authentified {User} instance
    # @return [NilClass]
    #   if either identification or authentication is failed
    def self.auth(params)
      Auth.new(params).auth
    end

    # Creates new user record
    # @param [Hash] params
    #   associative array of parameters
    # @raise [ActiveRecord::RecordNotSaved]
    #   if the record can't be created
    def self.create(params)
      Create.new(params).create
    end

    # Saves filter of events index to user record
    # @param [Hash] params
    #   associative array of parameters
    # @raise [ActiveRecord::RecordNotFound]
    #   if the user record can't be found
    # @raise [ActiveRecord::StatementInvalid]
    #   if the user record can't be updated
    def self.save_filter(params)
      SaveFilter.new(params).save
    end
  end
end
