# frozen_string_literal: true

module Users
  module Logics
    class Auth
      # JSON-schema of business logic parameters
      PARAMS_SCHEMA = {
        type: :object,
        properties: {
          login: {
            type: :object,
            properties: {
              email: {
                type: :string
              },
              password: {
                type: :string
              }
            },
            required: %i[
              email
              password
            ]
          }
        },
        required: %i[
          login
        ]
      }.freeze
    end
  end
end
