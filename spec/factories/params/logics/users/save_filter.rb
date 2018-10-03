# frozen_string_literal: true

FactoryBot.define do
  associative_array = HashWithIndifferentAccess
  factory 'params/logics/users/save_filter', class: associative_array do
    city_id  { nil }
    topic_id { nil }
    start    { nil }
    user_id  { nil }

    skip_create
    initialize_with do
      result = {
        filter: {
          city_id:  city_id,
          topic_id: topic_id,
          start:    start
        },
        user_id: user_id
      }
      result.with_indifferent_access
    end
  end
end
