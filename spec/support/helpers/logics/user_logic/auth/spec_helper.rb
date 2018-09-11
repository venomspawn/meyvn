# frozen_string_literal

module UserLogic
  class Auth
    # Provides auxiliary methods to tests of containing class
    module SpecHelper
      # Returns associative array of business logic parameters made from
      # arguments
      # @param [String] email
      #   email
      # @param [String] password
      #   password
      # @return [Hash]
      #   resulting associative array
      def create_params(email, password)
        { login: { email: email, password: password } }.with_indifferent_access
      end
    end
  end
end
