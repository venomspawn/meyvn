# frozen_string_literal: true

# Provides business logic of user management
module UserLogic
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
