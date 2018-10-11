# frozen_string_literal: true

FactoryBot.define do
  factory 'params/requests/users/save_filter', class: Hash do
    city_id  { nil }
    topic_id { nil }
    start    { nil }

    skip_create
    initialize_with do
      { filter: { city_id: city_id, topic_id: topic_id, start: start } }
    end
  end
end
