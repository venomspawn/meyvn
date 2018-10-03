# frozen_string_literal: true

module Users
  module Logics
    class SaveFilter < Logic
      # Module of namespaces of errors which appear during filter saving
      module Errors
        # Namespace of error classes which used to signal errors of user record
        module User
          # Class of errors which signal that user record isn\'t found
          class NotFound < ActiveRecord::RecordNotFound
            MESSAGE = 'User record isn\'t found'

            # Initializes instance
            def initialize
              super(MESSAGE)
            end
          end
        end

        # Namespace of error classes which used to signal errors of filter
        # values
        module FilterValues
          # Class of errors which signal that filter values are invalid
          class Invalid < ActiveRecord::StatementInvalid
            MESSAGE = 'Filter values are invalid'

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
