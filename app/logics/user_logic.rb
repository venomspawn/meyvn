# frozen_string_literal: true

# Provides business logic of user management
module UserLogic
  # Tries to identify and authentify user. Returns user record if both
  # processes are successful. Returns nil otherwise.
  # @param [Hash]
  #   associative array of parameters
  # @return [User]
  #   identified and authentified {User} instance
  # @return [NilClass]
  #   if either identification or authentication is failed
  def self.auth(params)
    Auth.new(params).auth
  end

  # Tries to create new user record and returns {User} instance with attributes
  # of the record
  # @param [Hash]
  #   associative array of parameters
  # @return [User]
  #   {User} instance
  def self.create(params)
    Create.new(params).create
  end
end
