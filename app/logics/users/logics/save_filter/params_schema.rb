# frozen_string_literal: true

module Users
  module Logics
    class SaveFilter
      # JSON-schema of business logic parameters
      PARAMS_SCHEMA = {
        type: :object,
        properties: {
          filter: {
            type: :object,
            properties: {
              city_id: {
                type: %i[null string]
              },
              topic_id: {
                type: %i[null string]
              },
              start: {
                type: %i[null string]
              }
            }
          },
          user_id: {
            type: :string
          }
        },
        required: %i[
          filter
          user_id
        ]
      }.freeze
    end
  end
end
