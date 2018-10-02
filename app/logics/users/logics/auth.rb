# frozen_string_literal: true

module Users
  module Logics
    # Class of business logic which identifies and authentifes user
    class Auth < Logic
      # Condition for extracting user record
      IDENTIFICATION_CONDITION = 'lower("email") = lower(?)'

      # Tries to identify and authentify user. Returns user record if both
      # processes are successful. Returns nil otherwise.
      # @param [Hash]
      #   associative array of parameters
      # @return [User]
      #   identified and authentified {User} instance
      # @return [NilClass]
      #   if either identification or authentication is failed
      def auth
        user = User.where(IDENTIFICATION_CONDITION, email).take
        user if user&.authenticate(password)
      end

      private

      # Returns a string with email of the user
      # @return [String]
      #   resulting string
      def email
        params[:login][:email]
      end

      # Returns a string with password of the user
      # @return [String]
      #   resulting string
      def password
        params[:login][:password]
      end
    end
  end
end
