# frozen_string_literal: true

module Users
  module Logics
    class Create
      # Module of namespaces of error classes
      module Errors
        # Namespace of error classes which inform about incorrectness of value
        # of `email` property of a user record
        module Email
          # Class of error used to raise when value of `email` property of user
          # has wrong format
          class Invalid < ActiveRecord::RecordNotSaved
            # Error message
            MESSAGE = 'Email has wrong format'

            # Initializes instance
            # @param [User] user
            #   record of the user
            def initialize(user)
              super(user, MESSAGE)
            end
          end

          # Class of error used to raise when value of `email` property of user
          # record repeats
          class AlreadyTaken < ActiveRecord::RecordNotSaved
            # Error message
            MESSAGE = 'Email has already been taken'

            # Initializes instance
            # @param [User] user
            #   record of the user
            def initialize(user)
              super(user, MESSAGE)
            end
          end
        end

        # Namespace of error classes which inform about incorrectness of user
        # record creation parameters
        module CreationParams
          # Class of error used to raise when user record creation parameters
          # have invalid values
          class Invalid < ActiveRecord::RecordNotSaved
            # Error message
            MESSAGE = 'Invalid values of parameters'

            # Initializes instance
            # @param [User] user
            #   record of the user
            def initialize(user)
              super(user, MESSAGE)
            end
          end
        end
      end
    end
  end
end
