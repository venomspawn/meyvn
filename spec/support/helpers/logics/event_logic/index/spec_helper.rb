# frozen_string_literal

module EventLogic
  class Index
    # Provides auxiliary methods to tests of containing class
    module SpecHelper
      # Returns JSON-schema of business logic result
      def schema
        RESULT_SCHEMA
      end
    end
  end
end
