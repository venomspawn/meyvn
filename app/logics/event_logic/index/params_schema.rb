# frozen_string_literal: true

module EventLogic
  class Index
    # JSON-schema of business logic parameters
    PARAMS_SCHEMA = {
      type: :object,
      properties: {
        filter: {
          type: %i[null object],
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
          },
          required: %i[
            city_id
            topic_id
            start
          ],
          additionalProperties: false
        }
      }
    }.freeze
  end
end
