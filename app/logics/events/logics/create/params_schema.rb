# frozen_string_literal: true

module Events
  module Logics
    class Create
      # JSON-schema of business logic parameters
      PARAMS_SCHEMA = {
        type: :object,
        properties: {
          event: {
            type: :object,
            properties: {
              title: {
                type: :string
              },
              place: {
                type: :string
              },
              start: {
                type: :string
              },
              finish: {
                type: :string
              },
              city_id: {
                type: :string
              },
              topic_id: {
                type: :string
              }
            },
            required: %i[
              title
              place
              start
              finish
              city_id
              topic_id
            ]
          },
          creator_id: {
            type: :string
          }
        },
        required: %i[
          event
          creator_id
        ]
      }.freeze
    end
  end
end
