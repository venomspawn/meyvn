# frozen_string_literal: true

module EventLogic
  class Create
    # Module of namespaces of error classes
    module Errors
      # Namespace of error classes which inform about incorrectness of value of
      # `finish` property of an event
      module Finish
        # Class of error used to raise when value of `finish` property of event
        # is less than value of `start` property or equals it
        class Invalid < ActiveRecord::RecordNotSaved
          # Error message
          MESSAGE = 'Finish is less than start or equals it'

          # Initializes instance
          # @param [Event] event
          #   record of the event
          def initialize(event)
            super(event, MESSAGE)
          end
        end
      end

      # Namespace of error classes which inform about incorrectness of event
      # record creation parameters
      module CreationParams
        # Class of error used to raise when event record creation parameters
        # have invalid values
        class Invalid < ActiveRecord::RecordNotSaved
          # Error message
          MESSAGE = 'Invalid values of parameters'

          # Initializes instance
          # @param [Event] event
          #   record of the event
          def initialize(event)
            super(event, MESSAGE)
          end
        end
      end
    end
  end
end
