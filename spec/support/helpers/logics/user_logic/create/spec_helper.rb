# frozen_string_literal

module UserLogic
  class Create
    # Provides auxiliary methods to tests of containing class
    module SpecHelper
      # Returns associative array of business logic parameters made from
      # arguments
      # @return [Hash]
      #   resulting associative array
      def create_params(email, password, password_confirmation)
        params = {
          user: {
            email:                 email,
            password:              password,
            password_confirmation: password_confirmation
          }
        }
        params.with_indifferent_access
      end
    end
  end
end
