# frozen_string_literal: true

module Users
  module Logics
    # Class of business logic which identifies and authentifes user
    class Auth < Logic
      # Condition for extracting user record
      IDENTIFICATION_CONDITION = 'lower("email") = lower(?)'

      # Returns record identified and authentified user
      # @return [User]
      #   identified and authentified {User} instance
      # @raise [RuntimeError]
      #   if identification is failed
      # @raise [RuntimeError]
      #   if authentication is failed
      def auth
        User.where(IDENTIFICATION_CONDITION, email).take.tap do |user|
          raise Errors::Identification::Failed if user.nil?
          next if user.authenticate(password)
          raise Errors::Authentication::Failed
        end
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
