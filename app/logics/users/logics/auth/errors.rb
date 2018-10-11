# frozen_string_literal: true

module Users
  module Logics
    class Auth
      # Module of namespaces for user identification and authentication errors
      module Errors
        # Namespace for classes of errors of user identification
        module Identification
          # Class of errors which signal fails of user identification
          class Failed < RuntimeError
            # Message about failed identification
            MESSAGE = 'Wrong email or password'

            # Initializes instance
            def initialize
              super(MESSAGE)
            end
          end
        end

        # Namespace for classes of errors of user authentication
        module Authentication
          # Class of errors which signal fails of user authentication
          class Failed < RuntimeError
            # Message about failed authentication
            MESSAGE = 'Wrong email or password'

            # Initializes instance
            def initialize
              super(MESSAGE)
            end
          end
        end
      end
    end
  end
end
