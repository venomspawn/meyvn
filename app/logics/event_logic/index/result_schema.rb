# frozen_string_literal: true

module EventLogic
  class Index
    # JSON-schema of business logic result
    RESULT_SCHEMA = {
      type: :array,
      items: {
        type: :object,
        properties: {
          event_title: {
            type: :string
          },
          event_place: {
            type: :string
          },
          event_start: {
            type: :string
          },
          event_finish: {
            type: :string
          },
          city_name: {
            type: :string
          },
          topic_title: {
            type: :string
          }
        },
        required: %i[
          event_title
          event_place
          event_start
          event_finish
          city_name
          topic_title
        ],
        additionalProperties: false
      }
    }.freeze
  end
end
