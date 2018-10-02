# frozen_string_literal: true

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
  end
end
