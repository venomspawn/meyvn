# frozen_string_literal: true

module Users
  module Logics
    class Create
      # JSON-schema of business logic parameters
      PARAMS_SCHEMA = {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: {
                type: :string
              },
              password: {
                type: :string
              },
              password_confirmation: {
                type: :string
              }
            },
            required: %i[
              email
              password
              password_confirmation
            ]
          }
        },
        required: %i[
          user
        ]
      }.freeze
    end
  end
end
